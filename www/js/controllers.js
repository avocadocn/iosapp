/**
 * Created by Sandeep on 11/09/14.
 */

angular.module('donlerApp.controllers', [])
  .directive('preventDefault', function () {
    return function (scope, element, attrs) {
      angular.element(element).bind('click', function (event) {
        event.preventDefault();
        event.stopPropagation();
      });
    }
  })
  .directive('detectGestures', function($ionicGesture) {
    return {
      restrict :  'A',

      link : function(scope, elem, attrs) {
        var gestureType = attrs.gestureType.split(',');
        var getstureCallback = attrs.getstureCallback.split(',');
        var gesture = [];
        gestureType.forEach(function(_gestureType,_index){
          switch(_gestureType) {
            case "swipe":
              gesture[_index] = $ionicGesture.on('swipe',scope[getstureCallback[_index]], elem);
              break;
            case "swipeleft":
              gesture[_index] = $ionicGesture.on('swipeleft', scope[getstureCallback[_index]], elem);
              break;
            case "swiperight":
              gesture[_index] = $ionicGesture.on('swiperight', scope[getstureCallback[_index]], elem);
              break;
            case "pinch":
              gesture[_index] = $ionicGesture.on('pinch', scope[getstureCallback[_index]], elem);
              break;
             case "drag":
              gesture[_index] = $ionicGesture.on('drag', scope[getstureCallback[_index]], elem);
              break;
            case 'doubletap':
              gesture[_index] = $ionicGesture.on('doubletap', scope[getstureCallback[_index]], elem);
              break;
            // case 'tap':
            //   $ionicGesture.on('tap', scope.reportEvent, elem);
            //   break;
          }
        });
        scope.$on('$destroy', function() {
          // Unbind drag gesture handler
          gestureType.forEach(function(_gestureType,_index){
            switch(_gestureType) {
              case "swipe":
                $ionicGesture.off(gesture[_index], 'swipeleft');
                break;
              case "swipeleft":
                $ionicGesture.off(gesture[_index], 'swipeleft');
                break;
              case "swiperight":
                $ionicGesture.off(gesture[_index], 'swipeleft');
                break;
              case "pinch":
                $ionicGesture.off(gesture[_index], 'pinch');
                break;
              case "drag":
                $ionicGesture.off(gesture[_index], 'drag');
                break;
              case 'doubletap':
                $ionicGesture.off(gesture[_index],'doubletap');
                break;
              // case 'tap':
              //   $ionicGesture.off('tap', scope.reportEvent, elem);
              //   break;
            }
          });
        });
      }
    }
  })
  .directive('match', ['$parse', function ($parse) {
    return {
      require: 'ngModel',
      link: function(scope, elem, attrs, ctrl) {
        scope.$watch(function() {
          return $parse(attrs.match)(scope) === ctrl.$modelValue;
        }, function(currentValue) {
          ctrl.$setValidity('mismatch', currentValue);
        });
      }
    };
  }])
  .controller('AppContoller', ['$scope', function ($scope) {
  }])
  .controller('UserLoginController', ['$scope', '$state', 'UserAuth', function ($scope, $state, UserAuth) {

    $scope.loginData = {
      email: '',
      password: ''
    };

    $scope.login = function () {
      UserAuth.login($scope.loginData.email, $scope.loginData.password, function (msg) {
        if (msg) {
          $scope.msg = msg;
        } else {
          $state.go('app.campaigns');
        }
      });
    };

  }])
  .controller('CompanyLoginController', ['$scope', '$state', 'CompanyAuth', function ($scope, $state, CompanyAuth) {

    $scope.loginData = {
      username: '',
      password: ''
    };

    $scope.login = function () {
      CompanyAuth.login($scope.loginData.username, $scope.loginData.password, function (msg) {
        if (msg) {
          $scope.msg = msg;
        } else {
          $state.go('company_home');
        }
      });
    };

  }])
  .controller('CompanyHomeController', ['$scope', '$state', 'CompanyAuth', function ($scope, $state, CompanyAuth) {

    $scope.logout = function () {
      CompanyAuth.logout(function (err) {
        if (err) {
          // todo
          console.log(err);
          $state.go('login');

        } else {
          $state.go('home');
        }
      });
    };

  }])
  .controller('CampaignController', ['$scope', '$state', '$timeout', '$ionicLoading', '$ionicPopup', 'Campaign', 'INFO', function ($scope, $state, $timeout, $ionicLoading, $ionicPopup, Campaign, INFO) {
    var showLoading = function() {
      $ionicLoading.show({
        template: '正在加载'
      });
    };
    var hideLoading = function(){
      $ionicLoading.hide();
    };
    showLoading();
    $scope.nowType = 'all';
    INFO.campaignBackUrl = '#/app/campaigns';
    if(!localStorage.id){
      return $state.go('login');
    }
    Campaign.getList({
      requestType: 'user',
      requestId: localStorage.id,
      select_type: 0,
      populate: 'photo_album'
    }, function (err, data) {
      if (!err) {
        $scope.unStartCampaigns = data[0];
        $scope.nowCampaigns = data[1];
        $scope.newCampaigns = data[2];
        $scope.provokes = data[3];
      }
      else {
        $ionicPopup.alert({
          title: '错误',
          template: err
        });
      }
      hideLoading();
    });
    $scope.join = function(filter,index, id){
      Campaign.join(id,localStorage.id, function(err, data){
        if(!err){
          $scope[filter][index] = data;
          alert('参加成功');
        }
      });
      return false;
    }
    $scope.dealProvoke = function(filter,index, id, dealType){
      //dealType:1接受，2拒绝，3取消
      Campaign.dealProvoke(id, dealType, function(err, data){
        if(!err){
          //TODO:
          alert('挑战处理成功');
          $scope[filter].splice(index,1);
        }
        else{
          alert(err);
        }
      });
      return false;
    }
    $scope.doRefresh = function(){
      Campaign.getList({
        requestType: 'user',
        requestId: localStorage.id,
        select_type: 0,
        populate: 'photo_album'
      }, function (err, data) {
        if (!err) {
          $scope.unStartCampaigns = data[0];
          $scope.nowCampaigns = data[1];
          $scope.newCampaigns = data[2];
          $scope.provokes = data[3];
        }
        else{
          $ionicPopup.alert({
            title: '错误',
            template: err
          });
        }
        $scope.$broadcast('scroll.refreshComplete');
      });
    }
  }])
  .controller('CampaignDetailController', ['$scope', '$state', '$ionicPopup', 'Campaign', 'Message', 'INFO', function ($scope, $state, $ionicPopup, Campaign, Message, INFO) {
    $scope.backUrl = INFO.campaignBackUrl;
    INFO.photoAlbumBackUrl = '#/campaign/detail/' + $state.params.id;
    INFO.memberBackUrl = '#/campaign/detail/' + $state.params.id;
    Campaign.get($state.params.id, function(err, data){
      if(!err){
        $scope.campaign = data;
        $scope.campaign.members =[];
        var memberContent = [];
        data.campaign_unit.forEach(function(campaign_unit){
          if(campaign_unit.team){
            memberContent.push({
              name:campaign_unit.team.name,
              members:campaign_unit.member
            });
          }
          else{
              memberContent.push({
              name:campaign_unit.company.name,
              members:campaign_unit.member
            });
          }
        })
        INFO.memberContent = memberContent;
        data.campaign_unit.forEach(function(campaign_unit){
          $scope.campaign.members = $scope.campaign.members.concat(campaign_unit.member);
        });
      }
    });
    Message.getCampaignMessages($state.params.id, function(err, data){
      if(!err){
        $scope.notices = data;
      }
    });
    $scope.join = function(id){
      Campaign.join(id,localStorage.id, function(err, data){
        if(!err){
          $scope.campaign = data;
          $ionicPopup.alert({
            title: '提示',
            template: '参加成功'
          });
        }
      });
      return false;
    }
    $scope.quit = function(id){
      Campaign.quit(id,localStorage.id, function(err, data){
        if(!err){
          $scope.campaign = data;
          $ionicPopup.alert({
            title: '提示',
            template: '退出成功'
          });
        }
      });
      return false;
    }
    $scope.goDiscussDetail = function(campaignId, campaignTheme) {
      INFO.discussName = campaignTheme;
      $state.go('discuss_detail',{campaignId: campaignId});
    }
  }])
  .controller('SponsorController', ['$scope', '$state', '$ionicPopup', 'Campaign', 'Team', 'INFO', function ($scope, $state, $ionicPopup, Campaign, Team, INFO) {
    $scope.campaignData ={};
    Team.getLeadTeam(null, function(err, leadTeams){
      if(!err &&leadTeams.length>0){
        $scope.leadTeams = leadTeams;
        $scope.selectTeam = leadTeams[0];
        $scope.changeTeam();
      }
      else{
        $state.go('app.campaigns');
      }
    });
    $scope.changeTeam = function() {
      Campaign.getMolds('team',$scope.selectTeam._id,function(err, molds){
        if(!err){
          $scope.campaign_molds = molds;
          $scope.selectMold = molds[0];
        }
      })
    }
    $scope.sponsor = function(){
        $scope.campaignData.cid = [$scope.selectTeam.cid];
        $scope.campaignData.tid = [$scope.selectTeam._id];
        $scope.campaignData.campaign_type = 2;
        $scope.campaignData.campaign_mold = $scope.selectMold.name;
      Campaign.create($scope.campaignData,function(err,data){
        if(!err){
          $ionicPopup.alert({
            title: '提示',
            template: '活动发布成功！'
          });
        }
      })
    }
  }])
  .controller('DiscussListController', ['$scope', 'Comment', '$state', 'Socket', 'Tools', 'INFO', function ($scope, Comment, $state, Socket, Tools, INFO) { //标为全部已读???
    Socket.emit('enterRoom', localStorage.id);
    //进来以后先http请求,再监视推送
    Comment.getList('joined').success(function (data) {
      $scope.commentCampaigns = data.commentCampaigns;
      $scope.latestUnjoinedCampaign = data.latestUnjoinedCampaign;
      //判断下把未参加的放哪
      $scope.unjoinedIndex = 20;
      if($scope.latestUnjoinedCampaign) {
        var unjoinedCommentTime = new Date($scope.latestUnjoinedCampaign.latestComment.createDate);
        for(var i=$scope.commentCampaigns.length-1; i>=0; i--){
          var joinedCommentTime = new Date($scope.commentCampaigns[i].latestComment.createDate);
          if(unjoinedCommentTime>joinedCommentTime){
            $scope.unjoinedIndex = i;
          }else{
            $scope.unjoinedIndex = i;
            break;
          }
        }
      }
      $scope.newUnjoined = data.newUnjoinedCampaignComment;
      localStorage.hasNewComment = false;
    });
    Socket.on('newCommentCampaign', function (data) {
      var newCommentCampaign = data;
      var index = Tools.arrayObjectIndexOf($scope.commentCampaigns, newCommentCampaign._id, '_id');
      if(index===-1){
        $scope.commentCampaigns.unshift(newCommentCampaign);
      }else{
        $scope.commentCampaigns[index].unread++;
        $scope.commentCampaigns[index].latestComment = newCommentCampaign.latestComment;
      }
    });
    Socket.on('newUnjoinedCommentCampaign', function (data) {
      $scope.newUnjoined = true;
      $scope.latestUnjoinedCampaign = data;
      $scope.unjoinedIndex = 0;
    });
    //不作数据刷新，给用户玩玩的...
    $scope.refresh = function() {
      $scope.$broadcast('scroll.refreshComplete');
    }
    $scope.goDetail = function(campaignId, campaignTheme) {
      INFO.discussName = campaignTheme;
      $state.go('discuss_detail',{campaignId: campaignId});
    }
  }])
  .controller('UnjoinedDiscussController', ['$scope','$state', 'Comment', 'Socket', 'Tools', function ($scope, $state, Comment, Socket, Tools) { //标为全部已读???
    Socket.emit('enterRoom', localStorage.id);
    //进来以后先http请求,再监视推送
    Comment.getList('unjoined').success(function (data) {
      $scope.commentCampaigns = data.commentCampaigns;
    });
    Socket.on('newUnjoinedCommentCampaign', function (data) {
      var newCommentCampaign = data;
      var index = Tools.arrayObjectIndexOf($scope.commentCampaigns, newCommentCampaign._id, '_id');
      if(index===-1){
        $scope.commentCampaigns.unshift(newCommentCampaign);
      }else{
        $scope.commentCampaigns[index].unread++;
        $scope.commentCampaigns[index].latestComment = newCommentCampaign.latestComment;
      }
    });
    //不作数据刷新，给用户玩玩的...
    $scope.refresh = function() {
      $scope.$broadcast('scroll.refreshComplete');
    };
    $scope.goDetail = function(campaignId, campaignTheme) {
      INFO.discussName = campaignTheme;
      $state.go('discuss_detail',{campaignId: campaignId});
    };
  }])
  .controller('DiscussDetailController', ['$scope', '$stateParams', '$ionicScrollDelegate', 'Comment', 'Socket', 'Message', 'Tools', 'CONFIG', 'INFO', function ($scope, $stateParams, $ionicScrollDelegate, Comment, Socket, Message, Tools, CONFIG, INFO) {
    $scope.campaignTitle =  $stateParams.campaignName;
    Socket.emit('enterRoom', $stateParams.campaignId);
    //无论进入离开，都需归零user的对应campaign的unread数目
    //获取时清空好了

    $scope.photos = [];
    var addPhotos = function (comment) {
      if (comment.photos && comment.photos.length > 0) {
        comment.photos.forEach(function (photo) {
          // todo 获取屏幕尺寸
          $scope.photos.push({
            _id: photo._id,
            src: CONFIG.STATIC_URL + photo.uri + '/resize/' + INFO.screenWidth + '/' + INFO.screenHeight,
            w: INFO.screenWidth,
            h: INFO.screenHeight
          });
        });
      }
    };

    $scope.openPhotoSwipe = function (photoId) {
      var pswpElement = document.querySelectorAll('.pswp')[0];

      var index = Tools.arrayObjectIndexOf($scope.photos, photoId, '_id');

      var options = {
        // history & focus options are disabled on CodePen
        history: false,
        focus: false,
        index: index,
        showAnimationDuration: 0,
        hideAnimationDuration: 0

      };
      var gallery = new PhotoSwipe(pswpElement, PhotoSwipeUI_Default, $scope.photos, options);
      gallery.init();
    };

    var nextStartDate ='';
    Comment.getComments($stateParams.campaignId, 20).success(function(data){
      $scope.comments = data.comments.reverse();//保证最新的在最下面
      $scope.comments.forEach(addPhotos);
      nextStartDate = data.nextStartDate;
      $ionicScrollDelegate.scrollBottom();
    });
    //获取公告
    Message.getCampaignMessages($stateParams.campaignId, function(err, data){
      if(err){
        console.log(err)
      }else{
        if(data.length>0){
          $scope.noticeSender = data[0].sender[0].nickname;
          $scope.notification = data[0].content;
        }
      }
    });
    
    //获取新留言
    Socket.on('newCampaignComment', function (data) {
      data.create_date = data.createDate;
      $scope.comments.push(data);
      addPhotos(data);
      $scope.comments[$scope.comments.length-1].showTime = $scope.needShowTime($scope.comments.length-1);
      $ionicScrollDelegate.scrollBottom();
    });
    /* 是否需要显示时间()
     * @params: index: 第几个comment
     * 判断依据：与上一个评论时间是否在同一分钟||index为0
     * return: 
     *   0 不用显示
     *   1 显示年、月、日
     *   2 显示月、日
     */
    $scope.needShowTime = function (index) {
      if(index===0){
        return 1;
      }else{
        var preTime = new Date($scope.comments[index-1].create_date);
        var nowTime = new Date($scope.comments[index].create_date);
        if(nowTime.getFullYear() != preTime.getFullYear()) {
          return 1;
        }else if(nowTime.getDay() != preTime.getDay()) {
          return 2;
        }else if(nowTime.getHours() != preTime.getHours()) {
          return 2;
        }else if(nowTime.getMinutes() != preTime.getMinutes()){
          return 2;
        }
      };
    };
    $scope.historyCommentList=[];
    //拉取历史讨论记录
    $scope.readHistory = function() {
      if(nextStartDate){//如果还有下一条
        Comment.getComments($stateParams.campaignId, 20, nextStartDate).success(function(data){
          $scope.historyCommentList.unshift(data.comments.reverse());
          // $('#currentComment').scrollIntoView();//need jQuery
          nextStartDate = data.nextStartDate;
          $scope.$broadcast('scroll.refreshComplete');
        });
      }else{//没下一条了~
        $scope.$broadcast('scroll.refreshComplete');
      }
    };
    //发表评论
    $scope.publishComment = function(photo) {
      Comment.publishComment($stateParams.campaignId, $scope.commentContent, photo, function(err){
        if(err){
          console.log(err);
        }else{
          $scope.commentContent = '';
        }
      });
    };
    //获取id给详情链接用
    $scope.campaignId = $stateParams.campaignId;
  }])
  .controller('DiscoverController', ['$scope', '$ionicPopup', 'Team', 'INFO', function ($scope, $ionicPopup, Team, INFO) {
    INFO.teamBackUrl = '#/app/discover/teams';
    Team.getList('company', null, function (err, teams) {
      if (err) {
        // todo
        console.log(err);
      } else {
        $scope.teams = teams;
      }
    });
    $scope.joinTeam = function(tid, index) {
      Team.joinTeam(tid, localStorage.id, function(err, data) {
        if(!err) {
          $ionicPopup.alert({
            title: '提示',
            template: '加入成功'
          });
          $scope.teams[index].hasJoined = true;
        }
        else {
          $ionicPopup.alert({
            title: '错误',
            template: err
          });
        }
      });
    }
    $scope.quitTeam = function(tid, index) {
      Team.quitTeam(tid, localStorage.id, function(err, data) {
        if(!err) {
          $ionicPopup.alert({
            title: '提示',
            template: '退出成功'
          });
          $scope.teams[index].hasJoined = false;
        }
        else {
          $ionicPopup.alert({
            title: '错误',
            template: err
          });
        }
      });
    }
  }])
  .controller('DiscoverCircleController', ['$scope', 'TimeLine', 'INFO', function ($scope, TimeLine, INFO) {
    INFO.campaignBackUrl = '#/app/discover/circle';
    var yearIndex= 0,
    monthIndex = -1;
    $scope.loadFinished = false;
    $scope.timelinesRecord =[];

    var loadData = function(yearIndex, monthIndex){
      TimeLine.getTimelineData('company', '0', $scope.timelinesRecord[yearIndex].year, $scope.timelinesRecord[yearIndex].month[monthIndex].month, function (err, timelineData) {
        if (err) {
          // todo
          console.log(err);
        } else {
          $scope.timelinesRecord[yearIndex].month[monthIndex].campaign = timelineData.campaigns;
          $scope.$broadcast('scroll.infiniteScrollComplete');
        }
      });
    }
    TimeLine.getTimelineRecord('company', '0', function (err, timelines) {
      if (err) {
        // todo
        console.log(err);
      } else {
        $scope.timelinesRecord = timelines;
        $scope.loadMore();
      }
    });

    $scope.loadMore = function(){
      if($scope.timelinesRecord.length<=yearIndex || $scope.timelinesRecord.length==yearIndex+1 && $scope.timelinesRecord[yearIndex].month.length==monthIndex+1){
        $scope.loadFinished = true;
        return;
      }
      else if($scope.timelinesRecord[yearIndex].month.length <= monthIndex + 1){
        yearIndex++;
        monthIndex = 0;
      }
      else {
        monthIndex ++;
      }
      loadData(yearIndex, monthIndex);
    }



  }])
  .controller('PersonalController', ['$scope', '$state', 'User', function ($scope, $state, User) {

    User.getData(localStorage.id, function (err, data) {
      if (err) {
        // todo
        console.log(err);
      } else {
        $scope.user = data;
      }
    });

  }])
  .controller('PersonalTeamListController', ['$scope', 'Team', 'INFO', function ($scope, Team, INFO) {
    INFO.teamBackUrl = '#/app/personal_teams';
    Team.getList('user', localStorage.id, function (err, teams) {
      if (err) {
        // todo
        console.log(err);
      } else {
        $scope.teams = teams;
      }
    });

  }])
  .controller('SettingsController', ['$scope', '$state', 'UserAuth', function ($scope, $state, UserAuth) {

    $scope.logout = function () {
      UserAuth.logout(function (err) {
        if (err) {
          // todo
          console.log(err);
        } else {
          $state.go('home');
        }
      })
    }

  }])
  .controller('TabController', ['$scope','Socket', function ($scope, Socket) {
    //每次进入页面判断是否有新评论没看
    if(localStorage.hasNewComment === true) {
      $scope.hasNewComment = true;
    }
    //socket服务器推送通知
    Socket.on('getNewComment', function() {
      $scope.hasNewComment = true;
      localStorage.hasNewComment = true;
    });
    //点过去就代表看过了

    $scope.readComments = function() {
      $scope.hasNewComment = false;
      localStorage.hasNewComment = false;
    };
  }])
  .controller('CalendarController',['$scope', '$rootScope', '$ionicPopup', '$ionicPopover', '$timeout','Campaign', 'INFO', function($scope, $rootScope, $ionicPopup, $ionicPopover, $timeout, Campaign, INFO) {
    $scope.campaignTypes =[{
      value:'unjoined',view:'未参加'
    },
    {
      value:'joined',view:'已参加'
    },
    {
      value:'all',view:'所有'
    }];
    $scope.nowTypeIndex =2;
    moment.locale('zh-cn');
    INFO.campaignBackUrl = '#/calendar';
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


    if (INFO.lastDate) {
      /**
       * 当前浏览的日期，用于更新视图
       * @type {Date}
       */
      var current = $scope.current_date = INFO.lastDate;
      $scope.view = 'day';
      INFO.lastDate = null;
    } else {
      var current = $scope.current_date = new Date();
    }

    /**
     * 月视图卡片数据
     * @type {Array}
     */
    $scope.month_cards;

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
      var offset = mdate.day();// mdate.day(): Sunday as 0 and Saturday as 6
      var now = new Date();
      $scope.current_year = year;
      $scope.current_date = date;
      var month_data = {
        date: date,
        format_month: month+1,
        days: []
      };
      var month_dates = mdate.daysInMonth();
      //标记周末、今天
      for (var i = 0; i < month_dates; i++) {
        month_data.days[i] = {
          full_date: new Date(year, month, i + 1),
          date: i + 1,
          events: []
        };
        //由本月第一天，计算是星期几，决定位移量
        if(i===0){
          month_data.days[0].first_day = 'offset_' + offset; // mdate.day(): Sunday as 0 and Saturday as 6
          month_data.offset = month_data.days[0].first_day;
        }
        // 是否是周末
        if((i+offset)%7===6||(i+offset)%7===0)
          month_data.days[i].is_weekend = true;

        // 是否是今天
        var now = new Date();
        if (now.getDate() === i + 1 && now.getFullYear() === year && now.getMonth() === month) {
          month_data.days[i].is_today = true;
        }
      }
      var dayOperate = function (i,campaign) {
        if($scope.nowTypeIndex==2 ||$scope.nowTypeIndex==campaign.join_flag) {
          month_data.days[i-1].events.push(campaign);
          // month_data.days[i-1].has_event = true;
          // if (campaign.is_joined) {
          //   month_data.days[i-1].has_joined_event = true;
          // }
        };
      }
      // 将活动及相关标记存入某天
      var month_start = new Date(year,month,1);
      var month_end = new Date(year,month,1);
      month_end.setMonth(month_end.getMonth()+1);
      $scope.campaigns.forEach(function(campaign) {
        var start_time = new Date(campaign.start_time);
        var end_time = new Date(campaign.end_time);
        if(start_time<=month_end&&end_time>=month_start){//如果活动'经过'本月
          var day_start = start_time.getDate();
          var day_end = end_time.getDate();
          var month_day_end = month_end.getDate();
          if(start_time>=month_start){//c>=a
            if(end_time<=month_end){//d<=b 活动日
              for(i=day_start;i<day_end+1;i++)
                dayOperate(i,campaign);
            }else{//d>b 开始日到月尾
              for(i=day_start;i<month_dates+1;i++)
                dayOperate(i,campaign);
            }
          }else{//c<a
            if(end_time<=month_end){//d<=b 月首到结束日
              for(i=1;i<day_end+1;i++)
                dayOperate(i,campaign);
            }else{//d>b 每天
              for(i=1;i<month_dates+1;i++)
                dayOperate(i,campaign);

            }
          }
        }
        campaign.format_start_time = moment(campaign.start_time).calendar();
        campaign.format_end_time = moment(campaign.end_time).calendar();
      });
      $scope.current_month = month_data;
      if(!$scope.$$phase) {
        $scope.$apply();
      }
      // return month_data;
    };

    /**
     * 进入某一天的详情, 会更新current
     * @param  {Date} date
     */
    var updateDay = $scope.updateDay = function(date) {
      var date = new Date(date);
      var now = new Date();
      $scope.view = 'day';
      if (date.getMonth() !== current.getMonth()) {
        updateMonth(date);
      }
      current = date;
      $scope.current_date =date;
      INFO.lastDate = date;
      var events =[];
      $scope.current_month.days[current.getDate() - 1].events.forEach(function(event){
        if($scope.nowTypeIndex==2 ||$scope.nowTypeIndex==event.join_flag) {
          events.push(event);
        }
      })
      var day = {
        date: current,
        past_flag: current<now,
        format_date: moment(current).format('ll'),
        format_day: moment(current).format('dddd'),
        campaigns: events
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
      if(!$scope.$$phase) {
        $scope.$apply();
      }
      // return day;
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
        $scope.month = updateMonth(current);
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
      updateDay(date);
      // $scope.day_cards = day;
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


    $scope.nextMonth = function() {
      var temp = $scope.current_date;
      temp.setMonth(temp.getMonth() + 1);
      current = new Date(temp);
      updateMonth(temp);
      // $scope.month_cards.push(updateMonth(temp));
      // $timeout(function(){
      //   $scope.removeMonth(0);
      // },100);
    };

    $scope.preMonth = function() {
      var temp = $scope.current_date;
      temp.setMonth(temp.getMonth() - 1);
      current = new Date(temp);
      updateMonth(temp);
      // $scope.month_cards.unshift(updateMonth(temp));
      // $timeout(function(){
      //   $scope.removeMonth(-1);
      // },100);
    };

    $scope.nextDay = function() {
      var temp = $scope.current_date;
      temp.setDate(temp.getDate() + 1);
      updateDay(temp);
      // $scope.day_cards = new_day;
    };

    $scope.preDay = function(day) {
      var temp = $scope.current_date;
      temp.setDate(temp.getDate() - 1);
      updateDay(temp);
      // $scope.day_cards = new_day;

    };

    // $scope.removeMonth = function(index) {
    //   $scope.month_cards.splice(index, 1);
    // };

    // $scope.removeDay = function(index) {
    //   $scope.day_cards.splice(index, 1);
    // };
    $ionicPopover.fromTemplateUrl('my-popover.html', {
        scope: $scope,
      }).then(function(popover) {
        $scope.popover = popover;
      });
    $scope.showFilter = function($event){
      $scope.popover.show($event);
    }
    $scope.campaignFilter = function(index){
      $scope.nowTypeIndex = index;
      $scope.popover.hide();
      switch ($scope.view) {
      case 'month':
        updateMonth($scope.current_date);
        break;
      case 'day':
        updateDay($scope.current_date);

        break;
      }
    }
    Campaign.getList({
      requestType: 'user',
      requestId: localStorage.id
    }, function (err, data) {
      if(err){
        $ionicPopup.alert({
          title: '提示',
          template: '网络错误，请检查网络状态'
        });
        return;
      }
      $scope.campaigns = data;
      // var lastMonthDate = nextMonthDate =current;
      // lastMonthDate.setMonth(current.getMonth() - 1);
      // nextMonthDate.setMonth(current.getMonth() + 1);
      // $scope.month_cards = [updateMonth(lastMonthDate),updateMonth(current),updateMonth(nextMonthDate)];
      $scope.month_cards = updateMonth(current);
      if ($scope.view === 'day') {
        updateDay(current);
      }
    });
  }])
  .controller('privacyController', ['$scope', '$ionicNavBarDelegate', function ($scope, $ionicNavBarDelegate) {
    $scope.backHref = '#/app/settings/about';
  }])
  .controller('compRegPrivacyController', ['$scope', '$ionicNavBarDelegate', function ($scope, $ionicNavBarDelegate) {
    $scope.backHref = '#/register/company';
  }])
  .controller('userRegPrivacyController', ['$scope', '$ionicNavBarDelegate', 'INFO', function ($scope, $ionicNavBarDelegate, INFO) {
    $scope.backHref = '#/register/user/post_detail/' + INFO.companyId;
  }])
  .controller('companySignupController' ,['$scope', '$state', 'CompanySignup', 'CONFIG', function ($scope,$state, CompanySignup, CONFIG) {
    //for region
    var region_url = CONFIG.BASE_URL + '/region';
    // var region_url = "http://192.168.2.107:3002/region";
    var selector_elem = document.getElementById('selector');
    selector_elem.dataset.src = region_url;
    $scope.province = '安徽省';
    $scope.city = '安庆市';
    $scope.district = '大观区';
    var selector = new LinkageSelector(selector_elem, function(selectValues) {
      $scope.province = selectValues[0];
      $scope.city = selectValues[1];
      $scope.district = selectValues[2];
    });
    //提交表单数据
    $scope.signup = function() {
      var data = {
        name: $scope.name,
        province: $scope.province,
        city: $scope.city,
        district: $scope.district,
        address: $scope.address,
        contacts: $scope.contacts,
        areacode: $scope.areacode,
        tel: $scope.tel,
        extension: $scope.extension,
        email: $scope.email,
        phone: $scope.phone
      };
      CompanySignup.signup(data, function(err){
        if(err){
          console.log(err);
        }else{
          $state.go('register_company_wait');
        }
      })
    };
    //validate
    var pattern =  /^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$/;
    $scope.reg = true;
    $scope.mailRegCheck = function() {
      $scope.reg = (pattern.test($scope.email));
    };
    $scope.mailCheck = function() {
      if($scope.reg&&$scope.email){
        CompanySignup.validate($scope.email, null, function(msg){
          if(!msg){
            $scope.mail_error = false;
            $scope.mail_msg = '该邮箱可以使用';
          }else{
            $scope.mail_error = true;
            $scope.mail_msg = '该邮箱已存在或您输入的邮箱有误'
          }
          $scope.mail_check = true;
        });
      }
    };
    $scope.nameCheck = function() {
      if($scope.name) {
        CompanySignup.validate(null, $scope.name, function(msg){
          if(msg) {
            $scope.name_repeat = true;
          }else{
            $scope.name_repeat = false;
          }
          $scope.name_check = true;
        });
      }
    }
  }])
  .controller('userSearchCompanyController', ['$scope', '$state', 'UserSignup','INFO', function ($scope, $state, UserSignup, INFO) {
    // UserSignup.searchCompany()
    $scope.keypress = function(keyEvent) {
      if (keyEvent.which === 13) {
        $scope.searchCompany();
      }
    };
    $scope.companyName = {};
    $scope.searchCompany = function() {
      if($scope.companyName.value){
        UserSignup.searchCompany($scope.companyName.value, function(msg, data){
          if(!msg){
            $scope.companies = data;
          }
          $scope.searched = true;
        });
      }
    };
    $scope.goDetail = function(company) {
      INFO.companyId = company._id;
      INFO.companyName = company.name;
      if(company.mail_active){
        $state.go('register_user_postDetail',{cid:company._id});
      }else{
        $state.go('register_user_remind_activate');
      }
    }
  }])
  .controller('userRegisterDetailController', ['$scope', '$state', '$ionicLoading', 'UserSignup', 'INFO', function ($scope, $state, $ionicLoading, UserSignup, INFO) {
    $scope.data = {};
    $scope.data.cid = INFO.companyId;
    $scope.companyName = INFO.companyName;
    $scope.signup = function() {
      $ionicLoading.show({
        template: 'Loading...'
      });
      UserSignup.signup($scope.data, function(msg, data) {
        $ionicLoading.hide();
        if(!msg){
          $state.go('register_user_waitEmail');
        }
      })
    };
    var pattern =  /^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$/;
    $scope.reg = true;
    $scope.mailRegCheck = function() {
      $scope.reg = (pattern.test($scope.data.email));
    };
    $scope.mailCheck = function() {
      if($scope.reg&&$scope.data.email){
        UserSignup.validate($scope.data.email, INFO.companyId, null, function (msg, data) {
          $scope.active=data.active;
          if(msg){
            $scope.mail_msg = '您输入的邮箱有误';
          }else{
            $scope.mail_msg = null;
          }
          $scope.mail_check = true;
        });
      }else{
        $scope.mail_check = false;
        $scope.mail_msg = '您输入的邮箱有误';
      }
    };
    $scope.checkInvitekey = function() {
      if($scope.data.inviteKey && $scope.data.inviteKey.length===8){
        UserSignup.validate(null, INFO.companyId, $scope.data.inviteKey, function (msg, data) {
          if(!msg){
            $scope.invitekeyCheck=data.invitekeyCheck;
          }else{
            $scope.invitekeyCheck=2;
          }
        });
      }else{
        $scope.invitekeyCheck = false;
      }
    }
  }])
  .controller('TeamController', ['$scope', '$stateParams', 'Team', 'Campaign', 'INFO', function ($scope, $stateParams, Team, Campaign, INFO) {
    var teamId = $stateParams.teamId;
    $scope.backUrl = INFO.teamBackUrl;
    INFO.campaignBackUrl = '#/team/' + teamId;
    Team.getData(teamId, function (err, team) {
      if (err) {
        // todo
        console.log(err);
      } else {
        $scope.team = team;
        INFO.memberBackUrl = '#/team/' + teamId;
        INFO.memberContent = [team];
        $scope.homeCourtIndex = 0;
      }
    });
    $scope.joinTeam = function (tid) {
      Team.joinTeam(tid, localStorage.id, function (err, data) {
        if (!err) {
          $ionicPopup.alert({
            title: '提示',
            template: '加入成功'
          });
          $scope.team.hasJoined = true;
        }
        else {
          $ionicPopup.alert({
            title: '错误',
            template: err
          });
        }
      });
    };
    $scope.quitTeam = function (tid) {
      Team.quitTeam(tid, localStorage.id, function (err, data) {
        if (!err) {
          $ionicPopup.alert({
            title: '提示',
            template: '退出成功'
          });
          $scope.team.hasJoined = false;
        }
        else {
          $ionicPopup.alert({
            title: '错误',
            template: err
          });
        }
      });
    };
    $scope.selectHomeCourt = function (index) {
      $scope.homeCourtIndex = index;
    };

    $scope.firstLoad = true;
    $scope.lastCount;
    var pageSize = 20;
    $scope.campaigns = [];

    $scope.getCampaigns = function (options) {
      Campaign.getList(options, function (err, campaigns) {
        if (err) {
          // todo
          console.log(err);
        } else {
          $scope.lastCount = campaigns.length;
          $scope.firstLoad = false;
          $scope.loading = false;
          $scope.campaigns = $scope.campaigns.concat(campaigns);
          $scope.$broadcast('scroll.infiniteScrollComplete');
        }
      });
    };

    $scope.loadMore = function () {
      // ionic bug, loadmore会意外地执行两次，现在并无好的解决方案，故只要开始加载就设置标记阻止再次执行
      if ($scope.loading == true) {
        return;
      }
      if ($scope.firstLoad) {
        $scope.loading = true;
        var options = {
          requestType: 'team',
          requestId: teamId,
          populate: 'photo_album',
          sortBy: '-start_time',
          limit: pageSize
        };
        $scope.getCampaigns(options);
      } else {
        if ($scope.lastCount === pageSize) {
          $scope.loading = true;
          var startTime = new Date($scope.campaigns[$scope.campaigns.length - 1].start_time);
          options = {
            requestType: 'team',
            requestId: teamId,
            populate: 'photo_album',
            sortBy: '-start_time',
            limit: pageSize,
            to: startTime.valueOf()
          };
          $scope.getCampaigns(options);
        }
      }
    };

    $scope.moreDataCanBeLoaded = function () {
      if (!$scope.firstLoad && $scope.lastCount < pageSize) {
        return false;
      } else {
        return true;
      }
    };

    $scope.$on('$stateChangeSuccess', function() {
      $scope.loadMore();
    });

  }])
  .controller('PhotoAlbumListController', ['$scope', '$stateParams', 'PhotoAlbum', 'INFO',
    function ($scope, $stateParams, PhotoAlbum, INFO) {
      $scope.teamId = $stateParams.teamId;
      INFO.photoAlbumBackUrl = '#/photo_album/list/team/' + $stateParams.teamId;

      $scope.firstLoad = true;
      $scope.lastCount;
      var pageSize = 20;
      $scope.photoAlbums = [];

      $scope.getPhotoAlbums = function (options) {
        PhotoAlbum.getList(options, function (err, photoAlbums) {
          if (err) {
            // todo
            console.log(err);
          } else {
            $scope.lastCount = photoAlbums.length;
            $scope.firstLoad = false;
            $scope.loading = false;
            $scope.photoAlbums = $scope.photoAlbums.concat(photoAlbums);
            $scope.$broadcast('scroll.infiniteScrollComplete');
          }
        });
      };

      $scope.loadMore = function () {
        // ionic bug, loadmore会意外地执行两次，现在并无好的解决方案，故只要开始加载就设置标记阻止再次执行
        if ($scope.loading == true) {
          return;
        }
        if ($scope.firstLoad) {
          $scope.loading = true;
          var options = {
            ownerType: 'team',
            ownerId: $scope.teamId
          };
          $scope.getPhotoAlbums(options);
        } else {
          if ($scope.lastCount === pageSize) {
            $scope.loading = true;
            var createDate = $scope.photoAlbums[$scope.photoAlbums.length - 1].createDate;
            options = {
              ownerType: 'team',
              ownerId: $scope.teamId,
              createDate: createDate
            };
            $scope.getPhotoAlbums(options);
          }
        }
      };

      $scope.moreDataCanBeLoaded = function () {
        if (!$scope.firstLoad && $scope.lastCount < pageSize) {
          return false;
        } else {
          return true;
        }
      };

      $scope.$on('$stateChangeSuccess', function() {
        $scope.loadMore();
      });

  }])
  .controller('PhotoAlbumDetailController', ['$scope', '$stateParams', 'PhotoAlbum', 'INFO',
    function ($scope, $stateParams, PhotoAlbum, INFO) {
      $scope.screenWidth = INFO.screenWidth;
      $scope.screenHeight = INFO.screenHeight;

      $scope.photoAlbumBackUrl = INFO.photoAlbumBackUrl;
      PhotoAlbum.getData($stateParams.photoAlbumId, function (err, photoAlbum) {
        if (err) {
          // todo
          console.log(err);
        } else {
          $scope.photoAlbum = photoAlbum;
        }
      });

      PhotoAlbum.getPhotos($stateParams.photoAlbumId, function (err, photos) {
        if (err) {
          // todo
          console.log(err);
        } else {
          $scope.photoGroups = groupByDate(photos);
        }
      });

      /**
       * 判断两个日期是否是同一天
       * @param {Date|String} d1
       * @param {Date|String} d2
       */
      var isTheSameDay = function (d1, d2) {
        if (typeof d1 === 'string') {
          d1 = new Date(d1);
        }
        if (typeof d2 === 'string') {
          d2 = new Date(d2);
        }
        return d1.getFullYear() === d2.getFullYear()
          && d1.getMonth() === d2.getMonth()
          && d1.getDate() === d2.getDate();

      };

      /**
       * 将照片按日期分组，要求照片是按上传日期排序，上传日期距离现在越近，排在最前面
       * @param {Array} photos 照片数组
       */
      var groupByDate = function (photos) {
        var resData = [];
        photos.forEach(function (photo) {
          var lastGroup = resData[resData.length - 1];
          if (lastGroup && isTheSameDay(lastGroup.date, photo.upload_date)) {
            lastGroup.photos.push(photo);
          } else {
            resData.push({
              date: new Date(photo.upload_date),
              photos: [photo]
            });
          }
        });
        return resData;
      };

      var initPhotoSwipeFromDOM = function (gallerySelector) {

        // parse slide data (url, title, size ...) from DOM elements
        // (children of gallerySelector)
        var parseThumbnailElements = function(el) {
          var thumbElements = el.childNodes,
            numNodes = thumbElements.length,
            items = [],
            figureEl,
            linkEl,
            size,
            item;

          for(var i = 0; i < numNodes; i++) {

            figureEl = thumbElements[i]; // <figure> element

            // include only element nodes
            if(figureEl.nodeType !== 1) {
              continue;
            }

            linkEl = figureEl.children[0]; // <a> element

            size = linkEl.getAttribute('data-size').split('x');

            // create slide object
            item = {
              src: linkEl.getAttribute('href'),
              w: parseInt(size[0], 10),
              h: parseInt(size[1], 10)
            };



            if(figureEl.children.length > 1) {
              // <figcaption> content
              item.title = figureEl.children[1].innerHTML;
            }

            if(linkEl.children.length > 0) {
              // <img> thumbnail element, retrieving thumbnail url
              item.msrc = linkEl.children[0].getAttribute('src');
            }

            item.el = figureEl; // save link to element for getThumbBoundsFn
            items.push(item);
          }

          return items;
        };

        // find nearest parent element
        var closest = function closest(el, fn) {
          return el && ( fn(el) ? el : closest(el.parentNode, fn) );
        };

        // triggers when user clicks on thumbnail
        var onThumbnailsClick = function(e) {
          e = e || window.event;
          e.preventDefault ? e.preventDefault() : e.returnValue = false;

          var eTarget = e.target || e.srcElement;

          // find root element of slide
          var clickedListItem = closest(eTarget, function(el) {
            return el.tagName === 'FIGURE';
          });

          if(!clickedListItem) {
            return;
          }

          // find index of clicked item by looping through all child nodes
          // alternatively, you may define index via data- attribute
          var clickedGallery = clickedListItem.parentNode,
            childNodes = clickedListItem.parentNode.childNodes,
            numChildNodes = childNodes.length,
            nodeIndex = 0,
            index;

          for (var i = 0; i < numChildNodes; i++) {
            if(childNodes[i].nodeType !== 1) {
              continue;
            }

            if(childNodes[i] === clickedListItem) {
              index = nodeIndex;
              break;
            }
            nodeIndex++;
          }



          if(index >= 0) {
            // open PhotoSwipe if valid index found
            openPhotoSwipe( index, clickedGallery );
          }
          return false;
        };

        // parse picture index and gallery index from URL (#&pid=1&gid=2)
        var photoswipeParseHash = function() {
          var hash = window.location.hash.substring(1),
            params = {};

          if(hash.length < 5) {
            return params;
          }

          var vars = hash.split('&');
          for (var i = 0; i < vars.length; i++) {
            if(!vars[i]) {
              continue;
            }
            var pair = vars[i].split('=');
            if(pair.length < 2) {
              continue;
            }
            params[pair[0]] = pair[1];
          }

          if(params.gid) {
            params.gid = parseInt(params.gid, 10);
          }

          if(!params.hasOwnProperty('pid')) {
            return params;
          }
          params.pid = parseInt(params.pid, 10);
          return params;
        };

        var openPhotoSwipe = function(index, galleryElement, disableAnimation) {
          var pswpElement = document.querySelectorAll('.pswp')[0],
            gallery,
            options,
            items;

          items = parseThumbnailElements(galleryElement);

          // define options (if needed)
          options = {
            index: index,

            // define gallery index (for URL)
            galleryUID: galleryElement.getAttribute('data-pswp-uid'),

            getThumbBoundsFn: function(index) {
              // See Options -> getThumbBoundsFn section of documentation for more info
              var thumbnail = items[index].el.getElementsByTagName('img')[0], // find thumbnail
                pageYScroll = window.pageYOffset || document.documentElement.scrollTop,
                rect = thumbnail.getBoundingClientRect();

              return {x:rect.left, y:rect.top + pageYScroll, w:rect.width};
            }

          };

          if(disableAnimation) {
            options.showAnimationDuration = 0;
          }

          // Pass data to PhotoSwipe and initialize it
          gallery = new PhotoSwipe( pswpElement, PhotoSwipeUI_Default, items, options);

          gallery.init();
        };

        // loop through all gallery elements and bind events
        var galleryElements = document.querySelectorAll( gallerySelector );
        for(var i = 0, l = galleryElements.length; i < l; i++) {
          galleryElements[i].setAttribute('data-pswp-uid', i+1);
          galleryElements[i].onclick = onThumbnailsClick;
        }

        // Parse URL and open gallery if it contains #&pid=3&gid=1
        var hashData = photoswipeParseHash();
        if(hashData.pid > 0 && hashData.gid > 0) {
          openPhotoSwipe( hashData.pid - 1 ,  galleryElements[ hashData.gid - 1 ], true );
        }
      };

      var initPhotoSwipe = function () {
        // execute above function
        initPhotoSwipeFromDOM('.dl_gallery');
      };

      $scope.$on('onRepeatLast', function (scope, element, attrs) {
        initPhotoSwipe();
      });

  }])
  .controller('MemberController', ['$scope', '$stateParams', 'INFO', 'Team', function($scope, $stateParams, INFO, Team) {
    if($stateParams.memberType=='team') {
      var currentTeam = Team.getCurrentTeam();

      Team.getMembers($stateParams.id, function (err, members) {
        if (err) {
          // todo
          console.log(err);
        } else {
          $scope.memberContents = [{
            name: currentTeam.name,
            members: members
          }];
        }
      });
    }
    else {
      $scope.memberContents = INFO.memberContent;
    }
    $scope.backUrl = INFO.memberBackUrl;
  }])
