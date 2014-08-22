angular.module('starter.controllers', [])


.controller('AppCtrl', function($state, $scope, $rootScope, Authorize, Global) {
  if (Authorize.authorize() === true) {
    $state.go('app.campaignList');
  }

  $scope.logout = Authorize.logout;
  $scope.base_url = Global.base_url;
  $scope.user = Global.user;
})



.controller('LoginCtrl', function($scope, $rootScope, $http, $state, Authorize) {

  if (Authorize.authorize() === true) {
    $state.go('app.campaignList');
  }

  $scope.data = {
    username: '',
    password: ''
  };

  $scope.loginMsg = '';

  $scope.login = Authorize.login($scope, $rootScope);
})



.controller('CampaignListCtrl', function($scope, $rootScope, $ionicModal, Campaign, Global, Authorize) {
  Authorize.authorize();

  $scope.base_url = Global.base_url;

  $rootScope.campaignReturnUri = '#/app/campaign_list';

  Campaign.getUserCampaignsForList(function(campaign_list) {
    $scope.campaign_list = campaign_list;
  });


  $scope.join = Campaign.join(Campaign.getCampaign);
  $scope.quit = Campaign.quit(Campaign.getCampaign);
  $ionicModal.fromTemplateUrl('templates/partials/select_team.html', {
    scope: $scope,
    animation: 'slide-in-up'
  }).then(function(modal) {
    $scope.selectModal = modal;
  });
  $scope.openselectModal = function(campaign) {
    $scope.campaign =campaign;
    $scope.selectModal.show();
  };
  $scope.select = function(campaign_id,tid) {
    $scope.join(campaign_id,tid);
    $scope.selectModal.hide();
  };
})


.controller('CampaignDetailCtrl', function($scope, $rootScope, $state, $stateParams, $ionicModal, $ionicSlideBoxDelegate, $timeout, Campaign, PhotoAlbum, Comment, Global, Authorize) {
  Authorize.authorize();

  $scope.base_url = Global.base_url;
  $scope.user_id = Global.user._id;
  Campaign.getCampaignDetail( $stateParams.id,function(campaign) {
    $scope.campaign = campaign;
    $scope.photo_album_id = $scope.campaign.photo_album;
    getPhotoList();
    $scope.deletePhoto = PhotoAlbum.deletePhoto($scope.photo_album_id, getPhotoList);
    $scope.commentPhoto = PhotoAlbum.commentPhoto($scope.photo_album_id, getPhotoList);
  });
  var getPhotoList = function() {
    PhotoAlbum.getPhotoList($scope.photo_album_id, function(photos) {
      $scope.photos = photos;
      $scope.photos_view = [];
      var _length = photos.length;
      for(var i=0;i<_length;i++){
        var index = Math.floor(i/4);
        if(!$scope.photos_view[index]){
          $scope.photos_view[index]=[];
        }
        photos[i].index = i;
        $scope.photos_view[index].push(photos[i]);
      }
      $ionicSlideBoxDelegate.update();
    });
  };
  $scope.comment_content = {
    text:''
  };
  $scope.initUpload = function(){
    $('#upload_form').ajaxForm(function(ee) {
      getPhotoList();
      var file = $('#upload_form').find('.upload_input');
      file.after(file.clone().val(""));
      file.remove();
      alert('图片上传成功！');
    });
  }
  $scope.photos = [];

  Comment.getCampaignComments($stateParams.id, function(comments) {
    $scope.comments = comments;
  });

  var updateCampaign = function(id) {
    Campaign.getCampaign(id, function(campaign) {
      $scope.campaign = campaign;
    });
  }

  $scope.join = Campaign.join(updateCampaign);
  $scope.quit = Campaign.quit(updateCampaign);
  $scope.publishComment =  function(){
    if($scope.comment_content.text==''){
      return alert('评论不能为空');
    }
    Comment.publishCampaignComment($stateParams.id, $scope.comment_content.text, function(msg) {
      if(!msg){
        $scope.comment_content.text = '';
        Comment.getCampaignComments($stateParams.id, function(comments) {
          $scope.comments = comments;
        });
      $scope.viewFormFlag =false;
      }
      else{
        alert(msg);
      }
    });
  };
  $scope.viewFormFlag =false;
  $scope.viewCommentForm =function(){
    $scope.viewFormFlag =true;
  }
  $ionicModal.fromTemplateUrl('templates/partials/photo_detail.html', {
    scope: $scope,
    animation: 'slide-in-up'
  }).then(function(modal) {
    $scope.modal = modal;
  });
  $scope.openModal = function(index) {
    $ionicSlideBoxDelegate.update();
    $ionicSlideBoxDelegate.slide(index);
    $scope.modal.show();
  };
  $scope.closeModal = function() {
    $scope.modal.hide();
  };
  $ionicModal.fromTemplateUrl('templates/partials/select_team.html', {
    scope: $scope,
    animation: 'slide-in-up'
  }).then(function(modal) {
    $scope.selectModal = modal;
  });
  $scope.openselectModal = function() {
    $scope.selectModal.show();
  };
  $scope.select = function(campaign_id,tid) {
    $scope.join(campaign_id,tid);
    $scope.selectModal.hide();
  };
  //Cleanup the modal when we're done with it!
  // $scope.$on('$destroy', function() {
  //   $scope.modal.remove();
  // });
  // Execute action on hide modal
  // $scope.$on('modal.hidden', function() {
  //   // Execute action
  // });
  // // Execute action on remove modal
  // $scope.$on('modal.removed', function() {
  //   // Execute action
  // });
  $timeout( function() {
    $ionicSlideBoxDelegate.update();
  });
})



.controller('ScheduleListCtrl', function($scope, $rootScope, Campaign, Global, Authorize) {
  Authorize.authorize();
  $rootScope.enable_drag = false;
  $rootScope.$on('$stateChangeStart', function() {
    $rootScope.enable_drag = true;
  });
  moment.lang('zh-cn');

  /**
   * 日历视图的状态，有年、月、日三种视图
   * 'year' or 'month' or 'day'
   * @type {String}
   */
  $scope.view = 'month';

  /**
   * 日视图中，当前周的日期数组，从周日开始
   * 每个数组元素为Date对象
   * @type {Array}
   */
  $scope.current_week_date = [];

  $scope.year = '一月 二月 三月 四月 五月 六月 七月 八月 九月 十月 十一月 十二月'.split(' ');


  if (Global.last_date) {
    /**
     * 当前浏览的日期，用于更新视图
     * @type {Date}
     */
    var current = $scope.current_date = Global.last_date;
    $scope.view = 'day';
    Global.last_date = null;
  } else {
    var current = $scope.current_date = new Date();
  }

  /**
   * 月视图卡片数据
   * @type {Array}
   */
  $scope.month_cards = [];

  /**
   * 日视图卡片数据
   * @type {Array}
   */
  $scope.day_cards = [];

  /**
   * 更新日历的月视图, 并返回该存放该月相关数据的对象, 不会更新current对象
   * @param  {Date} date
   * @return {Object}
   */
  var updateMonth = function(date) {
    var date = new Date(date);
    var year = date.getFullYear();
    var month = date.getMonth();
    var mdate = moment(new Date(year, month));
    $scope.current_year = year;
    var month_data = {
      date: date,
      format_month: mdate.format('MMMM'),
      days: []
    };
    for (var i = 0; i < mdate.daysInMonth(); i++) {
      month_data.days[i] = {
        full_date: new Date(year, month, i + 1),
        date: i + 1,
        events: []
      };

      // 如果是本月第一天，计算是星期几，决定位移量
      if (i === 0) {
        month_data.days[i].first_day = 'offset_' + mdate.day(); // mdate.day(): Sunday as 0 and Saturday as 6
        month_data.offset = month_data.days[i].first_day;
      }

      // 是否是周末
      var thisDay = new Date(year, month, i + 1);
      if (thisDay.getDay() === 0 || thisDay.getDay() === 6) {
        month_data.days[i].is_weekend = true;
      }

      // 是否是今天
      var now = new Date();
      if (now.getDate() === i + 1 && now.getFullYear() === year && now.getMonth() === month) {
        month_data.days[i].is_today = true;
      }

      // 将活动及相关标记存入这一天
      $scope.campaigns.forEach(function(campaign) {
        var start = moment(campaign.start_time);
        var end = moment(campaign.end_time);
        var today_end = moment(new Date(year, month, i + 1, 24));
        if (start < today_end && today_end < end
          || start.year() === year && start.month() === month && start.date() === i + 1
          || end.year() === year && end.month() === month && end.date() === i + 1) {
          month_data.days[i].events.push(campaign);
          month_data.days[i].has_event = true;
          if (campaign.is_joined) {
            month_data.days[i].has_joined_event = true;
          }
        }
        campaign.format_start_time = moment(campaign.start_time).calendar();
        campaign.format_end_time = moment(campaign.end_time).calendar();

      });

    }
    $scope.current_month = month_data;
    return month_data;
  };

  /**
   * 进入某一天的详情, 会更新current
   * @param  {Date} date
   */
  var updateDay = $scope.updateDay = function(date) {
    var date = new Date(date);
    $scope.view = 'day';
    if (date.getMonth() !== current.getMonth()) {
      updateMonth(date);
    }
    current = date;

    // ios safari ng-click将ng-href覆盖, 此为临时解决方案
    Global.last_date = current;
    $rootScope.campaignReturnUri = '#/app/schedule_list';

    var day = {
      date: current,
      format_date: moment(current).format('ll'),
      format_day: moment(current).format('dddd'),
      campaigns: $scope.current_month.days[current.getDate() - 1].events
    };

    var temp = new Date(date);
    var first_day_of_week = new Date(temp.setDate(temp.getDate() - temp.getDay()));
    $scope.current_week_date = [];
    for (var i = 0; i < 7; i++) {
      $scope.current_week_date.push(new Date(first_day_of_week.setDate(first_day_of_week.getDate())));
      first_day_of_week.setDate(first_day_of_week.getDate() + 1);
      var week_date = $scope.current_week_date[i];
      var now = new Date();
      if (week_date.getFullYear() === now.getFullYear() && week_date.getMonth() === now.getMonth() && week_date.getDate() === now.getDate()) {
        week_date.is_today = true;
      }
      if (week_date.getFullYear() === current.getFullYear() && week_date.getMonth() === current.getMonth() && week_date.getDate() === current.getDate()) {
        week_date.is_current = true;
      }
    }
    $scope.current_day = day;
    return day;
  };

  $scope.back = function() {
    switch ($scope.view) {
    case 'month':
      $scope.view = 'year';
      break;
    case 'day':
      $scope.view = 'month';
      break;
    }
  };


  /**
   * 回到今天，仅在月、日视图下起作用
   */
  $scope.today = function() {

    switch ($scope.view) {
    case 'month':
      current = new Date();
      var month = updateMonth(current);
      $scope.month_cards = [month];
      break;
    case 'day':
      var temp = new Date();
      var day = updateDay(temp);
      $scope.day_cards = [day];
      break;
    }

  };

  /**
   * 进入某月的视图
   * @param  {Number} month 月份, 0-11
   */
  $scope.monthView = function(month) {
    current.setDate(1);
    current.setMonth(month);
    var new_month = updateMonth(current);
    $scope.month_cards = [new_month];
    $scope.view = 'month';
  };

  /**
   * 进入日视图
   * @param  {Date} date
   */
  $scope.dayView = function(date) {
    var day = updateDay(date);
    $scope.day_cards = [day];
    $scope.view = 'day';
  };

  // ios safari下有问题
  /**
   * 查看活动详情前保存当前时间，以便返回
   */
  // $scope.saveStatus = function() {
  //   Global.last_date = current;
  //   $rootScope.campaignReturnUri = '#/app/schedule_list';
  // };


  $scope.nextMonth = function(month) {
    var temp = new Date(month.date);
    temp.setMonth(temp.getMonth() + 1);
    current = new Date(temp);
    var new_month = updateMonth(temp);
    $scope.month_cards.push(new_month);
  };

  $scope.preMonth = function(month) {
    var temp = new Date(month.date);
    temp.setMonth(temp.getMonth() - 1);
    current = new Date(temp);
    var new_month = updateMonth(temp);
    $scope.month_cards.push(new_month);
  };

  $scope.nextDay = function(day) {
    var temp = new Date(day.date);
    temp.setDate(temp.getDate() + 1);
    var new_day = updateDay(temp);
    $scope.day_cards.push(new_day);
  };

  $scope.preDay = function(day) {
    var temp = new Date(day.date);
    temp.setDate(temp.getDate() - 1);
    var new_day = updateDay(temp);
    $scope.day_cards.push(new_day);
  };

  $scope.removeMonth = function(index) {
    $scope.month_cards.splice(index, 1);
  };

  $scope.removeDay = function(index) {
    $scope.day_cards.splice(index, 1);
  };


  Campaign.getUserCampaignsForCalendar(function(campaigns) {
    $scope.campaigns = campaigns;
    var month = updateMonth(current);
    $scope.month_cards = [month];
    if ($scope.view === 'day') {
      var day = updateDay(current);
      $scope.day_cards = [day];
    }
  });

})


// .controller('DynamicListCtrl', function($scope, Dynamic) {

//   Dynamic.getDynamics(function(dynamic_list) {
//     $scope.dynamic_list = dynamic_list;
//   });


//   $scope.vote = Dynamic.vote($scope.dynamic_list, function(positive, negative) {
//     $scope.dynamic_list[index].positive = positive;
//     $scope.dynamic_list[index].negative = negative;
//   });

// })


// .controller('GroupJoinedListCtrl', function($scope, Group) {

//   $scope.show_list = [];

//   var joined_list = Group.getJoinedGroups();
//   if (joined_list === null) {
//     Group.getGroups(function(joined_groups, unjoin_groups) {
//       $scope.show_list = joined_groups;
//     });
//   } else {
//     $scope.show_list = joined_list;
//   }

// })

// .controller('GroupUnjoinListCtrl', function($scope, Group) {

//   $scope.show_list = [];

//   var unjoin_list = Group.getUnjoinGroups();
//   if (unjoin_list === null) {
//     Group.getGroups(function(joined_groups, unjoin_groups) {
//       $scope.show_list = unjoin_groups;
//     });
//   } else {
//     $scope.show_list = unjoin_list;
//   }

// })

// .controller('GroupInfoCtrl', function($scope, $stateParams, Group) {

//   $scope.template = 'templates/partials/group_info.html';
//   $scope.group = Group.getGroup($stateParams.id);

// })

// .controller('GroupCampaignCtrl', function($scope, $rootScope, $stateParams, Group, Campaign) {

//   $scope.template = 'templates/partials/campaigns.html';
//   $rootScope.campaign_owner = 'group';
//   $rootScope.campaignReturnUri = '#/app/group_detail/' + $stateParams.id;
//   $scope.group = Group.getGroup($stateParams.id);

//   var getGroupCampaigns = function() {
//     Campaign.getGroupCampaigns($stateParams.id, function(campaign_list) {
//       $scope.campaign_list = campaign_list;
//     });
//   };

//   getGroupCampaigns();

//   $scope.join = Campaign.join(getGroupCampaigns);
//   $scope.quit = Campaign.quit(getGroupCampaigns);

// })

// .controller('GroupDynamicCtrl', function($scope, $stateParams, Group, Dynamic) {

//   $scope.template = 'templates/partials/dynamics.html';
//   $scope.group = Group.getGroup($stateParams.id);

//   Dynamic.getGroupDynamics($scope.group._id, function(dynamics) {
//     $scope.dynamic_list = dynamics;
//   })
// })



.controller('TimelineCtrl', function($scope, $rootScope, Timeline, Authorize) {
  Authorize.authorize();
  
  Timeline.getUserTimeline(function(time_lines) {
    $rootScope.time_lines = time_lines;
    $rootScope.campaignReturnUri = '#/app/timeline';
  });

})


// .controller('UserInfoCtrl', function($scope, User, Global) {

//   $scope.base_url = Global.base_url;

//   User.getInfo(Global.user._id, function(user) {
//     $scope.user = user;
//   });

// })


// .controller('OtherUserInfoCtrl', function($scope, $stateParams, User, Global) {

//   $scope.base_url = Global.base_url;

//   User.getInfo($stateParams.uid, function(user) {
//     $scope.user = user;
//   });


// })


.directive('thumbnailPhotoDirective', function() {
  return function(scope, element, attrs) {

    var thumbnail = function(img) {
      if (img.width * 120 > img.height * 128) {
        element[0].style.height = '100%';
      } else {
        element[0].style.width = '100%';
      }
    };

    var img = new Image();
    img.src = attrs.ngSrc;

    if (img.complete) {
      thumbnail(img);
      img = null;
    } else {
      img.onload = function() {
        thumbnail(img);
        img = null;
      };
    }


  };
})

// .directive('mapDirective', function(Map) {
//   return function(scope, element, attrs) {
//     Map.init(attrs.id, attrs.location);
//   };
// })


.directive('uploadDirective', function() {
  return function(scope, element, attrs) {
    scope.initUpload();
  };
})

.directive('noScroll', function() {
  return {
    restrict: 'A',
    link: function(scope, element, attr) {
      element.on('touchmove', function(e) {
        e.preventDefault();
      });
    }
  }
})

.directive('validFile',function(){
  return {
    require: 'ngModel',
    link:function(scope,el,attrs,control){
      el.bind('change',function(){
        scope.$apply(function(){
          $('#upload_form').submit();
        });
      });
    }
  }
});







