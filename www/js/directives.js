'use strict';

angular.module('donlerApp.directives', ['donlerApp.services'])

  .directive('campaignCard', ['$rootScope', 'CONFIG', 'Campaign', 'INFO', 'Tools', '$location', function ($rootScope, CONFIG, Campaign, INFO, Tools, $location) {
    return {
      restrict: 'E',
      scope: {
        campaign: '=',
        pswpPhotoAlbum: '=',
        pswpId: '='
      },
      templateUrl: './views/campaign-card.html',
      link: function (scope, element, attrs, ctrl) {
        scope.STATIC_URL = CONFIG.STATIC_URL;

        scope.joinCampaign = function (campaignId) {
          Campaign.join(campaignId, localStorage.id, function (err, data) {
            if (!err) {
              // todo
              scope.campaign = data;
            }
          });
        };

        scope.dealProvoke = function(campaignId, dealType){
          //dealType:1接受，2拒绝，3取消
          Campaign.dealProvoke(campaignId, dealType, function(err, data){
            if(!err){
              // todo
              scope.campaign = data;
            }
          });
          return false;
        };

        var addPhotos = function (photos) {
          photos.forEach(function (photo) {
            var width = photo.width || INFO.screenWidth;
            var height = photo.height || INFO.screenHeight;
            var item = {
              _id: photo._id,
              src: CONFIG.STATIC_URL + photo.uri,
              w: width,
              h: height
            };
            if (photo.upload_user && photo.upload_date) {
              item.title = '上传者: ' + photo.upload_user.name + '  上传时间: ' + moment(photo.upload_date).format('YYYY-MM-DD HH:mm');
            }
            scope.photos.push(item);
          });
        };

        scope.openPhotoSwipe = function (photos, photoId) {
          try {
            var pswpElement;
            if (scope.pswpId) {
              pswpElement = document.querySelector('#' + scope.pswpId);
            } else {
              pswpElement = document.querySelectorAll('.pswp')[0];
            }
            scope.photos = [];
            addPhotos(photos);
            var index = Tools.arrayObjectIndexOf(scope.photos, photoId, '_id');

            var options = {
              history: false,
              focus: false,
              index: index,
              showAnimationDuration: 0,
              hideAnimationDuration: 0
            };
            var pswp = new PhotoSwipe(pswpElement, PhotoSwipeUI_Default, scope.photos, options);
            pswp.listen('close', function() {
              $rootScope.hideTabs = false;
              if (!$rootScope.$$phase) {
                $rootScope.$digest();
              }
            });
            $rootScope.hideTabs = true;
            pswp.init();
            if (scope.pswpPhotoAlbum) {
              scope.pswpPhotoAlbum.goToAlbum = function () {
                INFO.photoAlbumBackUrl = '#' + $location.url();
                pswp.close();
                $rootScope.hideTabs = false;
                $location.url('/photo_album/' + scope.campaign.photo_album._id + '/detail');
              };
            }
          } catch (e) {
            console.log(e);
            console.log(e.stack);
            $rootScope.hideTabs = false;
          }
          return false;
        };
      }
    }
  }])

  .directive('errorImg', ['CONFIG', function (CONFIG) {
    return {
      restrict: 'A',
      scope: {
        errorImg: '='
      },
      link: function (scope, ele, attrs, ctrl) {
        var errorImgSrc;
        if (!scope.errorImg) {
          errorImgSrc = CONFIG.STATIC_URL + '/img/not_found.jpg';
        } else {
          errorImgSrc = scope.errorImg;
        }
        ele[0].onerror = function () {
          this.src = errorImgSrc;
        };
      }
    };
  }])
