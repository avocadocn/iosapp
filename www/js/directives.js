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

  .directive('campaignCard', ['CONFIG', 'Campaign', function (CONFIG, Campaign) {
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

      }
    }
  }])