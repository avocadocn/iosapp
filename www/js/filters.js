'use strict';



angular.module('donlerApp.filters', [])

.filter('day', function() {
  return function(input) {
    var today = new Date();
    today.setHours(0);
    today.setMinutes(0);
    today.setSeconds(0);
    //new Date(input) will invalidDate in safri
    //must user new Date('2014-02-18T15:00:48'.replace(/\s/, 'T'))
    var date = new Date(input.replace(/\s/, 'T'));
    var intervalMilli = date.getTime() - today.getTime();
    var xcts = Math.floor(intervalMilli / (24 * 60 * 60 * 1000));
    // -2:前天 -1：昨天 0：今天 1：明天 2：后天， out：显示日期
    switch(xcts){
      // case -2:
      //   return '前天';
      case -1:
        return '昨天';
      case 0:
        return '今天';
      case 1:
        return '明天';
      // case 2:
      //   return '后天';
      default:
        return (date.getMonth() + 1) + '-' + date.getDate();
    }
  }
})
.filter('beforeNow', function() {
  return function(input) {
    var today = new Date();
    today.setHours(0);
    today.setMinutes(0);
    today.setSeconds(0);
    //new Date(input) will invalidDate in safri
    //must user new Date('2014-02-18T15:00:48'.replace(/\s/, 'T'))
    var date = new Date(input.replace(/\s/, 'T'));
    var intervalMilli = today.getTime() - date.getTime();
    var xcts = Math.floor(intervalMilli / (24 * 60 * 60 * 1000));
    var result;
    if(xcts>1){
      result = xcts+'天前';
    }
    else if (Math.floor(intervalMilli / (60 * 60 * 1000))>1) {
      result = Math.floor(intervalMilli / (60 * 60 * 1000))+'小时前';
    }
    else if (Math.floor(intervalMilli / (60 * 1000))>1) {
      result = Math.floor(intervalMilli / (60 * 1000))+'分前';
    }
    else{
      result = '刚刚';
    }
    return result;
  }
})
.filter("unsafe", ['$sce', function($sce) {
  return function(val) {
    return $sce.trustAsHtml(val);
  };
}]);
