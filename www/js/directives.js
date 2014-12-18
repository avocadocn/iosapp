'use strict';

angular.module('donlerApp.directives', [])

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