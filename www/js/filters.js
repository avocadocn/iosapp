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
    //new Date(input) will invalidDate in safari
    //must user new Date('2014-02-18T15:00:48'.replace(/\s/, 'T'))
    var date = new Date(input.replace(/\s/, 'T'));
    var now = Date.now();
    var intervalMilliForNow = now - date.getTime();
    var xcts = intervalMilliForNow / (24 * 60 * 60 * 1000);
    var result;
    if(Math.floor(xcts)>=1){
      result = Math.floor(xcts)+'天前';
    }
    else if (Math.floor(xcts*24)>=1) {
      result = Math.floor(xcts*24)+'小时前';
    }
    else if (Math.floor(xcts*24*60)>=1) {
      result = Math.floor(xcts*24*60)+'分前';
    }
    else{
      result = '刚刚';
    }
    return result;
  };
})
.filter('circleBeforeNow', function($filter) {
  return function(input) {
    var today = new Date();
    today.setHours(0);
    today.setMinutes(0);
    today.setSeconds(0);
    var date = new Date(input);
    var intervalMilliForDay = today.getTime() - date.getTime();
    var distanceOfDays = Math.floor(intervalMilliForDay / (24 * 60 * 60 * 1000)) + 1; // 相差几天

    var now = Date.now();
    var intervalMilliForNow = now - date.getTime();

    var result;
    if(distanceOfDays > 2){
      result = $filter('date')(input, 'M月d日');
    }
    else if (distanceOfDays === 2) {
      result = '前天';
    }
    else if (distanceOfDays === 1) {
      result = '昨天';
    }
    else if (Math.floor(intervalMilliForNow / (60 * 60 * 1000)) >= 1) {
      result = Math.floor(intervalMilliForNow / (60 * 60 * 1000)) + '小时前';
    }
    else if (Math.floor(intervalMilliForNow / (60 * 1000)) >= 1) {
      result = Math.floor(intervalMilliForNow / (60 * 1000)) + '分前';
    }
    else{
      result = '刚刚';
    }
    return result;
  };
})
.filter("unsafe", ['$sce', function($sce) {
  return function(val) {
    return $sce.trustAsHtml(val);
  };
}])
.filter("competitionMessageStatusFormat", [function() {
  return function(input, statusText, sponsor) {
    var result = '';
    switch(input) {
      case 'sent':
        result = '还有' +statusText+ (sponsor ?'等待对方回应':'可以进行回应');
        break;
      case 'accepted':
        result = '还有' +statusText+ (sponsor ?'发起活动':'等待对方发起活动');
        break;
      case 'rejected':
        result = '被拒绝';
        break;
      case 'competing':
        result = '已生成挑战';
        break;
      case 'deal_timeout':
        result = '挑战因为7天没有进行响应，已经过期';
        break;
      case 'competion_timeout':
        result = '挑战因为应战后7天没有发起活动，已经过期';
        break;
    }
    return result;
  };
}])
.filter("scoreResultFormat", [function() {
  return function(input) {
    var result = '';
    switch(input) {
      case 1:
        result = '胜';
        break;
      case 0:
        result = '平';
        break;
      case -1:
        result = '负';
        break;
    }
    return result;
  };
}])