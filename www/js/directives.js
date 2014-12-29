'use strict';

angular.module('donlerApp.directives', ['donlerApp.services'])

  .directive('onLastRepeat', function () {
    return {
      link: function(scope, element, attrs, ctrl) {
        if (scope.$last) {
          setTimeout(function () {
            scope.$emit('onRepeatLast', element, attrs);
          }, 1);
        }
      }

    };
  })

  .directive('campaignCard', ['$rootScope', 'CONFIG', 'Campaign', 'INFO', 'Tools', '$location', function ($rootScope, CONFIG, Campaign, INFO, Tools, $location) {
    return {
      restrict: 'E',
      scope: {
        campaign: '=',
        pswpPhotoAlbum: '='
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
            scope.photos.push({
              _id: photo._id,
              src: CONFIG.STATIC_URL + photo.uri + '/resize/' + width + '/' + height,
              w: width,
              h: height,
              title: '上传者: ' + photo.upload_user.name + '  上传时间: ' + moment(photo.upload_date).format('YYYY-MM-DD HH:mm')
            });
          });
        };

        scope.openPhotoSwipe = function (photos, photoId) {
          var pswpElement = document.querySelectorAll('.pswp')[0];
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
            $rootScope.$digest();
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
          return false;
        };
      }
    }
  }])