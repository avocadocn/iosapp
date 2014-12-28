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

  .directive('campaignCard', ['CONFIG', 'Campaign', 'INFO', 'Tools', function (CONFIG, Campaign, INFO, Tools) {
    return {
      restrict: 'E',
      scope: {
        campaign: '='
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
        }
        var addPhotos = function (photos) {
            photos.forEach(function (photo) {
              var width = photo.width || INFO.screenWidth;
              var height = photo.height || INFO.screenHeight;
              // todo 获取屏幕尺寸
              scope.photos.push({
                _id: photo._id,
                src: CONFIG.STATIC_URL + photo.uri + '/resize/' + width + '/' + height,
                w: width,
                h: height
              });
            });
        };

        scope.openPhotoSwipe = function (photos, photoId) {
          var pswpElement = document.querySelectorAll('.pswp')[0];
          scope.photos = [];
          addPhotos(photos);
          var index = Tools.arrayObjectIndexOf(scope.photos, photoId, '_id');

          var options = {
            // history & focus options are disabled on CodePen
            history: false,
            focus: false,
            index: index,
            showAnimationDuration: 0,
            hideAnimationDuration: 0

          };
          var gallery = new PhotoSwipe(pswpElement, PhotoSwipeUI_Default, scope.photos, options);
          gallery.init();
          return false;
        };
      }
    }
  }])