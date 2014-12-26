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
  .controller('createTeamController', ['$scope', '$state', 'Team', function ($scope, $state, Team) {
    //todo
  }])
  .controller('CompanyForgetController', ['$scope', '$ionicLoading', 'Company', function ($scope, $ionicLoading, Company) {
    $scope.msg = '请输入注册所填邮箱，我们会将密码重置邮件发送给您。';
    $scope.forget={};
    $scope.findBack = function(){
      $ionicLoading.show({
        template: '请稍等...'
      });
      Company.findBack($scope.forget.email, function(msg){
        $ionicLoading.hide();
        if(msg){
          $scope.msg = '邮箱填写有误，请重新填写。';
        }else{
          $scope.msg= '密码重置邮件已发送，请登录您的邮箱查收。';
          $scope.sent = true;
        }
      })
    }
  }])
  .controller('UserForgetController', ['$scope', '$ionicLoading', 'User', function ($scope, $ionicLoading, User) {
    $scope.msg = '请输入注册所填邮箱，我们会将密码重置邮件发送给您。';
    $scope.forget={};
    $scope.findBack = function(){
      $ionicLoading.show({
        template: '请稍等...'
      });
      User.findBack($scope.forget.email, function(msg){
        $ionicLoading.hide();
        if(msg){
          $scope.msg = '邮箱填写有误，请重新填写。';
        }else{
          $scope.msg= '密码重置邮件已发送，请登录您的邮箱查收。';
          $scope.sent = true;
        }
      })
    }
  }])
  .controller('CampaignController', ['$scope', '$state', '$timeout', '$ionicPopup', '$rootScope', '$ionicScrollDelegate', 'Campaign', 'INFO', function ($scope, $state, $timeout, $ionicPopup, $rootScope, $ionicScrollDelegate, Campaign, INFO) {
    $rootScope.showLoading();
    $scope.nowType = 'all';
    INFO.campaignBackUrl = '#/app/campaigns';
    INFO.calendarBackUrl ='#/app/campaigns';
    INFO.sponsorBackUrl ='#/app/campaigns';
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
      $rootScope.hideLoading();
    });
    $scope.filter = function(filterType) {
      $scope.nowType = filterType;
      $ionicScrollDelegate.scrollTop(true);
    }
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
        INFO.locationContent = data.location;
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
        else {
          $ionicPopup.alert({
            title: '错误',
            template: err
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
        else {
          $ionicPopup.alert({
            title: '错误',
            template: err
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
    $scope.leadTeams = [];
    $scope.selectTeam = {};
    $scope.backUrl = INFO.sponsorBackUrl;
    $scope.isBusy = false;
    Team.getLeadTeam(null, function(err, leadTeams){
      if(!err &&leadTeams.length>0){
        $scope.leadTeams = leadTeams;
        $scope.selectTeam = leadTeams[0];
        $scope.changeTeam($scope.selectTeam);
      }
      else{
        $state.go('app.campaigns');
      }
    });
    $scope.changeTeam = function(selectTeam) {
      $scope.selectTeam =selectTeam;
      Campaign.getMolds('team',selectTeam._id,function(err, molds){
        if(!err){
          $scope.campaign_molds = molds;
          $scope.selectMold = molds[0];
        }
      })
    }
    $scope.changeMold = function(selectMold) {
      $scope.selectMold = selectMold;
    }
    $scope.sponsor = function(){
      var errMsg;
      if($scope.campaignData.start_time<new Date() ) {
        errMsg ='开始时间不能早于现在';
      }
      else if($scope.campaignData.end_time<$scope.campaignData.start_time) {
        errMsg ='结束时间不能早于开始时间';
      }
      if($scope.isBusy){

      }
      else if(errMsg ){
        $ionicPopup.alert({
          title: '提示',
          template: errMsg
        });
      }
      else {
        $scope.isBusy = true;
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
          else{
            $ionicPopup.alert({
              title: '提示',
              template: err
            });
          }
          $scope.isBusy = false;
        })
      }

    }
  }])
  .controller('DiscussListController', ['$scope', 'Comment', '$state', 'Socket', 'Tools', 'INFO', function ($scope, Comment, $state, Socket, Tools, INFO) { //标为全部已读???
    INFO.calendarBackUrl ='#/app/discuss/list';
    INFO.sponsorBackUrl ='#/app/discuss/list';
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
  .controller('UnjoinedDiscussController', ['$scope','$state', 'INFO', 'Comment', 'Socket', 'Tools', function ($scope, $state, INFO, Comment, Socket, Tools) { //标为全部已读???
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
  .controller('DiscussDetailController', ['$scope', '$stateParams', '$ionicScrollDelegate', 'Comment', 'Socket', 'Message', 'Tools', 'CONFIG', 'INFO', 'CommonHeaders', '$cordovaFile', '$cordovaCamera', '$ionicActionSheet', '$ionicPopup', function ($scope, $stateParams, $ionicScrollDelegate, Comment, Socket, Message, Tools, CONFIG, INFO, CommonHeaders, $cordovaFile, $cordovaCamera, $ionicActionSheet, $ionicPopup) {
    $scope.campaignTitle =  $stateParams.campaignName;
    $scope.campaignId = $stateParams.campaignId;
    Socket.emit('enterRoom', $scope.campaignId);
    //无论进入离开，都需归零user的对应campaign的unread数目
    //获取时清空好了
    $scope.userId = localStorage.id;
    //获取id给详情链接用
    
    $scope.photos = [];
    var addPhotos = function (comment) {
      if (comment.photos && comment.photos.length > 0) {
        comment.photos.forEach(function (photo) {
          var width = photo.width || INFO.screenWidth;
          var height = photo.height || INFO.screenHeight;
          // todo 获取屏幕尺寸
          $scope.photos.push({
            _id: photo._id,
            src: CONFIG.STATIC_URL + photo.uri + '/resize/' + width + '/' + height,
            w: width,
            h: height
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
    
    //获取公告
    Message.getCampaignMessages($scope.campaignId, function(err, data){
      if(err){
        console.log(err)
      }else{
        if(data.length>0){
          $scope.noticeSender = data[0].sender[0].nickname;
          $scope.notification = data[0].content;
        }
      }
    });

    //评论获取

    $scope.commentList = [];
    $scope.topShowTime = [];

    var judgeTopShowTime = function() {
      $scope.topShowTime.unshift(1);
      if($scope.commentList.length>1) {
        var preTime = new Date($scope.commentList[1][0].create_date);//上次的第一个
        var length = $scope.commentList[0].length;
        var nowTime = new Date($scope.commentList[0][length-1].create_date);//这次的最后一个
        if(nowTime.getFullYear() != preTime.getFullYear()) {
          $scope.topShowTime[1] = 1;
        }else if(nowTime.getDay() != preTime.getDay()) {
          $scope.topShowTime[1] = 2;
        }else if(nowTime.getHours() != preTime.getHours()) {
          $scope.topShowTime[1] = 2;
        }else if(nowTime.getMinutes() != preTime.getMinutes()){
          $scope.topShowTime[1] = 2;
        }else{
          $scope.topShowTime[1] = 0;
        }
      }
    };

    //获取最新20条评论
    Comment.getComments($scope.campaignId, 20).success(function(data){
      $scope.commentList.push(data.comments.reverse());//保证最新的在最下面
      data.comments.forEach(addPhotos);
      nextStartDate = data.nextStartDate;
      $ionicScrollDelegate.scrollBottom();
      judgeTopShowTime();
    });
    
    //获取新留言
    Socket.on('newCampaignComment', function (data) {
      data.create_date = data.createDate;
      var comentListIndex = $scope.commentList.length -1;
      $scope.commentList[comentListIndex].push(data);
      addPhotos(data);
      $ionicScrollDelegate.scrollBottom();
    });

    //拉取历史讨论记录
    $scope.readHistory = function() {
      if(nextStartDate){//如果还有下一条
        Comment.getComments($scope.campaignId, 20, nextStartDate).success(function(data){
          $scope.commentList.unshift(data.comments.reverse());
          $scope.topShowTime.push();
          // $('#currentComment').scrollIntoView();//need jQuery
          nextStartDate = data.nextStartDate;
          //-addPhoto
          $scope.$broadcast('scroll.refreshComplete');
          judgeTopShowTime();
        });
      }else{//没下一条了~
        $scope.$broadcast('scroll.refreshComplete');
      }
    };
    /* 是否需要显示时间()
     * @params: index: 第几个comment
     * 判断依据：与上一个评论时间是否在同一分钟||index为0
     * return: 
     *   0 不用显示
     *   1 显示年、月、日
     *   2 显示月、日
     */
    
    $scope.needShowTime = function (index, comments) {
      if(index===0){
        return 1;
      }else{
        var preTime = new Date(comments[index-1].create_date);
        var nowTime = new Date(comments[index].create_date);
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
    
    //发表评论
    $scope.publishComment = function(photo) {
      Comment.publishComment($scope.campaignId, $scope.commentContent, photo, function(err){
        if(err){
          console.log(err);
        }else{
          $scope.commentContent = '';
        }
      });
    };

    // 上传图片
    var uploadSheet;
    $scope.showUploadActionSheet = function () {
      uploadSheet = $ionicActionSheet.show({
        buttons: [{
          text: '拍照上传'
        }, {
          text: '本地上传'
        }],
        titleText: '请选择上传方式',
        cancelText: '取消',
        buttonClicked: function (index) {
          if (index === 0) {
            getPhotoFrom('camera');
          } else if (index === 1) {
            getPhotoFrom('file');
          }
          return true;
        }
      });
    };

    var upload = function (imageURI) {
      var serverAddr = CONFIG.BASE_URL + '/comments/host_type/campaign/host_id/' + $scope.campaignId;
      var headers = CommonHeaders.get();
      headers['x-access-token'] = localStorage.accessToken;
      var options = {
        fileKey: 'photo',
        httpMethod: 'POST',
        headers: headers,
        mimeType: 'image/jpeg'
      };

      $cordovaFile
        .uploadFile(serverAddr, imageURI, options)
        .then(function(result) {
        }, function(err) {
          $ionicPopup.alert({
            title: '发送失败',
            template: '请重试'
          });
        }, function (progress) {
          // constant progress updates
        });
    };

    var getPhotoFrom = function (source) {

      var sourceType = Camera.PictureSourceType.PHOTOLIBRARY;
      var save = false;
      if (source === 'camera') {
        sourceType = Camera.PictureSourceType.CAMERA;
        save = true;
      }

      var options = {
        quality: 50,
        destinationType: Camera.DestinationType.FILE_URI,
        sourceType: sourceType,
        allowEdit: true,
        encodingType: Camera.EncodingType.JPEG,
        targetWidth: 256,
        targetHeight: 256,
        popoverOptions: CameraPopoverOptions,
        saveToPhotoAlbum: save,
        correctOrientation: true
      };

      $cordovaCamera.getPicture(options).then(function(imageURI) {
        upload(imageURI);
      }, function(err) {
        if (err !== 'no image selected') {
          $ionicPopup.alert({
            title: '获取照片失败',
            template: err
          });
        }
      });
    };



  }])
  .controller('DiscoverController', ['$scope', '$ionicPopup', 'Team', 'INFO', function ($scope, $ionicPopup, Team, INFO) {
    INFO.teamBackUrl = '#/discover/teams';
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
  .controller('DiscoverCircleController', ['$scope', '$timeout', 'TimeLine', 'INFO', function ($scope, $timeout, TimeLine, INFO) {
    INFO.campaignBackUrl = '#/discover/circle';
    $scope.loadFinished = false;
    $scope.loading = false;
    $scope.timelinesRecord =[];
    $scope.page = 0;
    // 是否需要显示时间
    $scope.needShowTime = function (index) {
      if(index===0){
        return true;
      }else{
        var preTime = new Date($scope.timelinesRecord[index-1].start_time);
        var nowTime = new Date($scope.timelinesRecord[index].start_time);
        return nowTime.getFullYear() != preTime.getFullYear() || nowTime.getMonth() != preTime.getMonth();
      };
    };
    $scope.loadMore = function() {
      if($scope.loading){
        $scope.$broadcast('scroll.infiniteScrollComplete');
      }
      else{
        $scope.page++;
        $scope.loading = true;
        TimeLine.getTimelines('company', '0', $scope.page, function (err, timelineData) {
          if (err) {
            // todo
            console.log(err);
          } else {
            if(timelineData.length>0) {
              $scope.timelinesRecord = $scope.timelinesRecord.concat(timelineData);
            }
            else {
              $scope.loadFinished = true;
            }
          }
          $scope.loading = false;
          $scope.$broadcast('scroll.infiniteScrollComplete');
        });
      }
    }

  }])
  .controller('PersonalController', ['$scope', '$state', 'User', 'Message', 'INFO', 'Tools', function ($scope, $state, User, Message, INFO, Tools) {
    INFO.calendarBackUrl ='#/app/personal';
    User.getData(localStorage.id, function (err, data) {
      if (err) {
        // todo
        console.log(err);
      } else {
        $scope.user = data;
        if ($scope.user.birthday) {
          var birthday = new Date($scope.user.birthday);
          $scope.constellation = Tools.birthdayToConstellation(birthday.getMonth() + 1, birthday.getDate());
        }
      }
    });

    Message.receiveUserMessages(localStorage.id, function (err, messagesCount) {
      if (err) {
        // todo
        console.log(err);
      } else {
        $scope.messagesCount = messagesCount;
      }
    });

  }])
  .controller('PersonalEditController', ['$scope', '$state', '$ionicPopup', 'User', 'CONFIG', 'CommonHeaders', '$cordovaFile', '$cordovaCamera', '$ionicActionSheet', function ($scope, $state, $ionicPopup, User, CONFIG, CommonHeaders, $cordovaFile, $cordovaCamera, $ionicActionSheet) {

    var birthdayInput = document.getElementById('birthday');

    User.getData(localStorage.id, function (err, data) {
      if (err) {
        $ionicPopup.alert({
          title: '获取个人信息失败',
          template: err
        });
      } else {
        $scope.user = data;
        $scope.formData = {
          nickname: $scope.user.nickname,
          realname: $scope.user.realname,
          phone: $scope.user.phone,
          birthday: moment($scope.user.birthday).format('YYYY-MM-DD')
        };
      }
    });

    $scope.edit = function () {
      User.editData($scope.user._id, $scope.formData, function (err) {
        if (err) {
          $ionicPopup.alert({
            title: '编辑失败',
            template: err
          });
        } else {
          $ionicPopup.alert({
            title: '操作成功',
            template: '编辑个人信息成功'
          });
        }
      });
    };

    var uploadSheet;
    $scope.showUploadActionSheet = function () {
      uploadSheet = $ionicActionSheet.show({
        buttons: [{
          text: '拍照上传'
        }, {
          text: '本地上传'
        }],
        titleText: '请选择上传方式',
        cancelText: '取消',
        buttonClicked: function (index) {
          if (index === 0) {
            getPhotoFrom('camera');
          } else if (index === 1) {
            getPhotoFrom('file');
          }
          return true;
        }
      });
    };

    var upload = function (imageURI) {
      var serverAddr = CONFIG.BASE_URL + '/users/' + localStorage.id;
      var headers = CommonHeaders.get();
      headers['x-access-token'] = localStorage.accessToken;
      var options = {
        fileKey: 'photo',
        httpMethod: 'PUT',
        headers: headers,
        mimeType: 'image/jpeg'
      };

      $cordovaFile
        .uploadFile(serverAddr, imageURI, options)
        .then(function(result) {
          var successAlert = $ionicPopup.alert({
            title: '提示',
            template: '修改头像成功'
          });
          successAlert.then(function () {
            $state.go('app.personal');
          });
        }, function(err) {
          $ionicPopup.alert({
            title: '提示',
            template: '修改失败，请重试'
          });
        }, function (progress) {
          // constant progress updates
        });
    };

    var getPhotoFrom = function (source) {

      var sourceType = Camera.PictureSourceType.PHOTOLIBRARY;
      var save = false;
      if (source === 'camera') {
        sourceType = Camera.PictureSourceType.CAMERA;
        save = true;
      }

      var options = {
        quality: 50,
        destinationType: Camera.DestinationType.FILE_URI,
        sourceType: sourceType,
        allowEdit: true,
        encodingType: Camera.EncodingType.JPEG,
        targetWidth: 256,
        targetHeight: 256,
        popoverOptions: CameraPopoverOptions,
        saveToPhotoAlbum: save,
        correctOrientation: true
      };

      $cordovaCamera.getPicture(options).then(function(imageURI) {
        upload(imageURI);
      }, function(err) {
        if (err !== 'no image selected') {
          $ionicPopup.alert({
            title: '获取照片失败',
            template: err
          });
        }
      });
    };


  }])
  .controller('PersonalTeamListController', ['$scope', 'Team', 'INFO', function ($scope, Team, INFO) {
    INFO.teamBackUrl = '#/personal/teams';
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
  .controller('AccoutController', ['$scope', 'User', function($scope, User) {
    User.getPushToggle(localStorage.id, function(msg, data){
      if(!msg){
        $scope.user = data;
      }
    });
    $scope.changePushToggle = function() {
      User.editData(localStorage.id, $scope.user, function(msg){});
    }
  }])
  .controller('PasswordController', ['$scope', '$rootScope', '$ionicPopup', 'User', function($scope, $rootScope, $ionicPopup, User) {
    $scope.pswData = {};
    $scope.changePwd = function() {
      $rootScope.showLoading();
      User.editData(localStorage.id, $scope.pswData, function(msg) {
        $rootScope.hideLoading();
        if(msg){
          $ionicPopup.alert({title:'修改失败',template:msg});
        }else{
          $ionicPopup.alert({title:'修改成功'});
        }
      });
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
    $scope.calendarBackUrl = INFO.calendarBackUrl;
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
    var updateMonth = function(date,callback) {
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
      Campaign.getList({
        requestType: 'user',
        requestId: localStorage.id,
        from:new Date(year, month).getTime(),
        to:new Date(year, month+1).getTime()
      }, function (err, data) {
        if(err){
          $ionicPopup.alert({
            title: '提示',
            template: err
          });
          return;
        }
        $scope.campaigns = data;
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
          if($scope.nowTypeIndex==2 ||$scope.nowTypeIndex==campaign.join_flag ||$scope.nowTypeIndex==0&&campaign.join_flag==-1) {
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
          // campaign.format_start_time = moment(campaign.start_time).calendar();
          // campaign.format_end_time = moment(campaign.end_time).calendar();
        });
        $scope.current_month = month_data;
        if(!$scope.$$phase) {
          $scope.$apply();
        }
        callback && callback();
        // return month_data;
      });

      
    };

    /**
     * 进入某一天的详情, 会更新current
     * @param  {Date} date
     */
    var updateDay = $scope.updateDay = function(date) {
      var date = new Date(date);
      var now = new Date();
      $scope.view = 'day';
      if (date.getMonth() !== current.getMonth() || !$scope.campaigns) {
        updateMonth(date,function(){
          updateDay(date);
        });
        return false;
      }
      else {
        current = date;
        $scope.current_date =date;
        INFO.lastDate = date;
        var events =[];
        $scope.current_month.days[current.getDate() - 1].events.forEach(function(event){
          if($scope.nowTypeIndex==2 ||$scope.nowTypeIndex==event.join_flag ||$scope.nowTypeIndex==0&&event.join_flag==-1) {
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
          if (week_date.getFullYear() === current.getFullYear() && week_date.getMonth() === current.getMonth()) {
            week_date.is_current_month = true;
            if (week_date.getDate() === current.getDate()) {
              week_date.is_current = true;
            }
            var events =[];
            $scope.current_month.days[week_date.getDate() - 1].events.forEach(function(event){
              if($scope.nowTypeIndex==2 ||$scope.nowTypeIndex==event.join_flag) {
                events.push(event);
              }
            })
            week_date.events = events;
          }
        }
        $scope.current_day = day;
        if(!$scope.$$phase) {
          $scope.$apply();
        }
        // return day;
      }
      
    };

    $scope.back = function() {
      switch ($scope.view) {
      case 'month':
        $scope.view = 'year';
        break;
      case 'day':
        $scope.view = 'month';
        INFO.lastDate = null;
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
    if($scope.view=='month') {
      updateMonth(current)
    }
    else if($scope.view =='day') {
      updateDay(current)
    }
    
  }])
  .controller('privacyController', ['$scope', '$ionicNavBarDelegate', function ($scope, $ionicNavBarDelegate) {
    $scope.backHref = '#/settings/about';
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
        template: '请稍等...'
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
  .controller('CompanyActiveCodeController', ['$scope', 'Company', function ($scope, Company) {
    Company.getInviteKey(localStorage.id, function(msg, data){
      if(!msg){
        $scope.inviteKey = data.staffInviteCode;
      }
    })
  }])
  .controller('CompanyTeamController', ['$scope', 'Company', function ($scope, Company) {
    Company.getTeams(localStorage.id, 'team', 'all', function(msg, data) {
      if(!msg){
        $scope.teams = data;
      }
    });
  }])
  .controller('FeedbackController', ['$scope', '$rootScope', '$ionicPopup', 'User', function ($scope, $rootScope, $ionicPopup, User) {
    $scope.opinion = {};
    $scope.feedback = function () {
      $rootScope.showLoading();
      User.feedback($scope.opinion.content, function(msg) {
        if(msg){
          $ionicPopup.alert({title:'发送错误',template:'发送错误请重试。'});
        }else{
          $ionicPopup.alert({title:'发送成功',template:'感谢您的反馈。'});
          $scope.opinion.content = '';

        }
        $rootScope.hideLoading();
      });
    }
  }])
  .controller('TeamController', ['$scope', '$stateParams', 'Team', 'Campaign', 'Tools', 'INFO', '$ionicSlideBoxDelegate', function ($scope, $stateParams, Team, Campaign, Tools, INFO, $ionicSlideBoxDelegate) {
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
        $scope.homeCourts = team.homeCourts;
        while ($scope.homeCourts.length < 2) {
          $scope.homeCourts.push({
            empty: true
          });
        }
        $ionicSlideBoxDelegate.update();
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
    var nextCampaign;

    /**
     * 按日期分组后的活动
     * [{
     *   date: Date,
     *   campaigns: [Object]
     * }]
     * @type {Array}
     */
    $scope.campaignGroups = [];

    /**
     * 获取该日期的分组，如果不存在，则新建一个
     * @param  {Date} date 日期
     * @return {Object}
     */
    var getGroup = function (date) {
      for (var i = 0; i < $scope.campaignGroups.length; i++) {
        var group = $scope.campaignGroups[i];
        if (Tools.isTheSameMonth(group.date, date)) {
          return group;
        }
      }
      var group = {
        date: date,
        campaigns: []
      };
      $scope.campaignGroups.push(group);
      $scope.campaignGroups.sort(function (a, b) {
        return b.date > a.date;
      });
      return group;
    };

    // 将活动按开始时间分组
    var addCampaignsToGroup = function (campaigns) {
      var group;
      for (var i = 0; i < campaigns.length; i++) {
        var campaign = campaigns[i];
        if (!group) {
          group = getGroup(campaign.start_time);
        } else {
          if (!Tools.isTheSameMonth(group.date, campaign.start_time)) {
            group.campaigns.sort(function (a, b) {
              return b.start_time > a.start_time;
            });
            group = getGroup(campaign.start_time);
          }
        }
        group.campaigns.push(campaign);
      }
    };

    $scope.getCampaigns = function (options) {
      Campaign.getList(options, function (err, campaigns) {
        if (err) {
          // todo
          console.log(err);
        } else {
          $scope.lastCount = campaigns.length;
          $scope.firstLoad = false;
          $scope.loading = false;
          var sliceLength = campaigns.length === pageSize + 1 ? pageSize : campaigns.length;
          nextCampaign = campaigns[campaigns.length - 1];
          addCampaignsToGroup(campaigns.slice(0, sliceLength));
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
          limit: pageSize + 1
        };
        $scope.getCampaigns(options);
      } else {
        if ($scope.lastCount >= pageSize) {
          $scope.loading = true;
          var startTime = new Date(nextCampaign.start_time);
          options = {
            requestType: 'team',
            requestId: teamId,
            populate: 'photo_album',
            sortBy: '-start_time',
            limit: pageSize + 1,
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
    $scope.linkMap = function (homeCourt) {
      var link = 'http://mo.amap.com/?q=' + homeCourt.loc.coordinates[1] + ',' + homeCourt.loc.coordinates[0] + '&name=' + homeCourt.name;
      window.open( link, '_system' , 'location=yes');
      return false;
    }
    $scope.$on('$stateChangeSuccess', function() {
      $scope.loadMore();
    });

  }])
  .controller('PhotoAlbumListController', ['$scope', '$stateParams', 'PhotoAlbum', 'Team', 'INFO',
    function ($scope, $stateParams, PhotoAlbum, Team, INFO) {
      $scope.teamId = $stateParams.teamId;
      INFO.photoAlbumBackUrl = '#/photo_album/list/team/' + $stateParams.teamId;
      Team.getFamilyPhotos($scope.teamId, function (err, photos) {
        if (err) {
          // todo
          console.log(err);
        } else {
          $scope.familyPhotoLength = photos.length;
          $scope.familyPhotos = photos.reverse().slice(0, 8);
        }
      });

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
  .controller('PhotoAlbumDetailController', ['$scope', '$stateParams', '$ionicPopup', 'PhotoAlbum', 'Tools', 'INFO', 'CONFIG', 'CommonHeaders', '$cordovaFile', '$cordovaCamera', '$ionicActionSheet',
    function ($scope, $stateParams, $ionicPopup, PhotoAlbum, Tools, INFO, CONFIG, CommonHeaders, $cordovaFile, $cordovaCamera, $ionicActionSheet) {
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

      var setPhotoSize = function (photo) {
        if (photo.width < INFO.screenWidth && photo.height < INFO.screenHeight) {
          photo.viewWidth = photo.width;
          photo.viewHeight = photo.height;
        } else {
          // o: photo, d: device, 比较 ow/oh 与 dw/dh, 即ow/oh-dw/dh >= 0?
          var compareResult = photo.width * INFO.screenHeight - photo.height * INFO.screenWidth;
          if (compareResult >= 0) {
            // 将图片的宽度调整至屏幕宽度，高度自适应（必定会比屏幕高度小）
            photo.viewWidth = INFO.screenWidth;
            photo.viewHeight = Math.floor(photo.height * INFO.screenWidth / photo.width);
          } else {
            // 将图片的高度调整至屏幕高度，宽度自适应（必定会比屏幕宽度小）
            photo.viewHeight = INFO.screenHeight;
            photo.viewWidth = Math.floor(photo.width * INFO.screenHeight / photo.height);
          }
        }
      };

      var getPhotos = function () {
        PhotoAlbum.getPhotos($stateParams.photoAlbumId, function (err, photos) {
          if (err) {
            // todo
            console.log(err);
          } else {
            photos.forEach(setPhotoSize);
            $scope.photoGroups = groupByDate(photos);
          }
        });
      };
      getPhotos();

      /**
       * 将照片按日期分组，要求照片是按上传日期排序，上传日期距离现在越近，排在最前面
       * @param {Array} photos 照片数组
       */
      var groupByDate = function (photos) {
        var resData = [];
        photos.forEach(function (photo) {
          var lastGroup = resData[resData.length - 1];
          if (lastGroup && Tools.isTheSameDay(lastGroup.date, photo.upload_date)) {
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


      // 上传照片
      var uploadSheet;
      $scope.showUploadActionSheet = function () {
        uploadSheet = $ionicActionSheet.show({
          buttons: [{
            text: '拍照上传'
          }, {
            text: '本地上传'
          }],
          titleText: '请选择上传方式',
          cancelText: '取消',
          buttonClicked: function (index) {
            if (index === 0) {
              getPhotoFrom('camera');
            } else if (index === 1) {
              getPhotoFrom('file');
            }
            return true;
          }
        });
      };

      var upload = function (imageURI) {
        var serverAddr = CONFIG.BASE_URL + '/photo_albums/' + $scope.photoAlbum._id + '/photos';
        var headers = CommonHeaders.get();
        headers['x-access-token'] = localStorage.accessToken;
        var options = {
          fileKey: 'photo',
          httpMethod: 'POST',
          headers: headers,
          mimeType: 'image/jpeg'
        };

        $cordovaFile
          .uploadFile(serverAddr, imageURI, options)
          .then(function(result) {
            var successAlert = $ionicPopup.alert({
              title: '提示',
              template: '上传照片成功'
            });
            successAlert.then(function () {
              getPhotos();
            });
          }, function(err) {
            $ionicPopup.alert({
              title: '提示',
              template: '上传失败，请重试'
            });
          }, function (progress) {
            // constant progress updates
          });
      };

      var getPhotoFrom = function (source) {

        var sourceType = Camera.PictureSourceType.PHOTOLIBRARY;
        var save = false;
        if (source === 'camera') {
          sourceType = Camera.PictureSourceType.CAMERA;
          save = true;
        }

        var options = {
          quality: 50,
          destinationType: Camera.DestinationType.FILE_URI,
          sourceType: sourceType,
          allowEdit: true,
          encodingType: Camera.EncodingType.JPEG,
          targetWidth: 256,
          targetHeight: 256,
          popoverOptions: CameraPopoverOptions,
          saveToPhotoAlbum: save,
          correctOrientation: true
        };

        $cordovaCamera.getPicture(options).then(function(imageURI) {
          upload(imageURI);
        }, function(err) {
          if (err !== 'no image selected') {
            $ionicPopup.alert({
              title: '获取照片失败',
              template: err
            });
          }
        });
      };


  }])
  .controller('FamilyPhotoController', ['$scope', '$stateParams', 'INFO', 'Team', function ($scope, $stateParams, INFO, Team) {
    $scope.screenWidth = INFO.screenWidth;
    $scope.screenHeight = INFO.screenHeight;
    $scope.team = Team.getCurrentTeam();
    Team.getFamilyPhotos($scope.team._id, function (err, photos) {
      if (err) {
        // todo
        console.log(err);
      } else {
        $scope.familyPhotos = photos;
      }
    });

    $scope.toggleSelect = function (familyPhoto) {
      Team.toggleSelectFamilyPhoto($scope.team._id, familyPhoto._id, function (err) {
        if (err) {
          // todo
          console.log(err);
        } else {
          familyPhoto.select = !familyPhoto.select;
        }
      });
    };

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
      INFO.userInfoBackUrl = '#/members/team/' + $stateParams.id;
    }
    else {
      $scope.memberContents = INFO.memberContent;
      INFO.userInfoBackUrl = '#/members/campaign/' + $stateParams.id;
    }
    $scope.backUrl = INFO.memberBackUrl;
  }])
  .controller('LocationController', ['$scope', '$stateParams', 'INFO', function($scope, $stateParams, INFO) {
    $scope.location = INFO.locationContent;
    $scope.backUrl='#/campaign/detail/'+$stateParams.id;
    $scope.linkMap = function (location) {
      var link = 'http://mo.amap.com/?q=' + location.coordinates[1] + ',' + location.coordinates[0] + '&name=' + location.name;
      window.open( link, '_system' , 'location=yes');
      return false;
    }
  }])
  .controller('TimelineController', ['$scope', '$stateParams', 'TimeLine', 'User', function ($scope, $stateParams, TimeLine, User) {
    $scope.loadFinished = false;
    $scope.loading = false;
    $scope.timelinesRecord =[];
    $scope.page = 0;
    // 是否需要显示时间
    $scope.needShowTime = function (index) {
      if(index===0){
        return true;
      }else{
        var preTime = new Date($scope.timelinesRecord[index-1].start_time);
        var nowTime = new Date($scope.timelinesRecord[index].start_time);
        return nowTime.getFullYear() != preTime.getFullYear() || nowTime.getMonth() != preTime.getMonth();
      };
    };
    $scope.loadMore = function() {
      $scope.page++;
      $scope.loading = true;
      TimeLine.getTimelines('user', '0', $scope.page, function (err, timelineData) {
        if (err) {
          // todo
          console.log(err);
        } else {
          if(timelineData.length>0) {
            $scope.timelinesRecord = $scope.timelinesRecord.concat(timelineData);
          }
          else {
            $scope.loadFinished = true;
          }
        }
        $scope.loading = false;
        $scope.$broadcast('scroll.infiniteScrollComplete');
      });
    }
    User.getData(localStorage.id, function (err, data) {
      if (err) {
        // todo
        console.log(err);
      } else {
        $scope.user = data;
      }
    });
  }])
  .controller('UserInfoController', ['$scope', '$state', '$stateParams', '$ionicPopover', 'TimeLine', 'User', 'INFO', function ($scope, $state, $stateParams, $ionicPopover, TimeLine, User, INFO) {
    $scope.backUrl = INFO.userInfoBackUrl;
    INFO.reportBackUrl ='#/user/' + $stateParams.userId;
    $scope.loadFinished = false;
    $scope.loading = false;
    $scope.timelinesRecord =[];
    $scope.page = 0;
    $ionicPopover.fromTemplateUrl('more-popover.html', {
        scope: $scope,
      }).then(function(popover) {
        $scope.popover = popover;
      });
    $scope.showPopover = function($event){
      $scope.popover.show($event);
    }
    $scope.showReportForm = function() {
      $state.go('report_form',{userId: $scope.user._id});
      $scope.popover.hide();
    }
    // 是否需要显示时间
    $scope.needShowTime = function (index) {
      if(index===0){
        return true;
      }else{
        var preTime = new Date($scope.timelinesRecord[index-1].start_time);
        var nowTime = new Date($scope.timelinesRecord[index].start_time);
        return nowTime.getFullYear() != preTime.getFullYear() || nowTime.getMonth() != preTime.getMonth();
      };
    };
    $scope.loadMore = function() {
      $scope.page++;
      $scope.loading = true;
      TimeLine.getTimelines('user', $stateParams.userId, $scope.page, function (err, timelineData) {
        if (err) {
          // todo
          console.log(err);
        } else {
          if(timelineData.length>0) {
            $scope.timelinesRecord = $scope.timelinesRecord.concat(timelineData);
          }
          else {
            $scope.loadFinished = true;
          }
        }
        $scope.loading = false;
        $scope.$broadcast('scroll.infiniteScrollComplete');
      });
    }
    User.getData($stateParams.userId, function (err, data) {
      if (err) {
        // todo
        console.log(err);
      } else {
        $scope.user = data;
      }
    });
  }])
  .controller('MessageController', ['$scope', 'Message', function ($scope, Message) {

    Message.getUserMessages(localStorage.id, function (err, data) {
      if (err) {
        // todo
        console.log(err);
      } else {
        $scope.messages = data;
      }
    });

  }])
  .controller('ReportController', ['$scope', '$stateParams', '$ionicPopup', 'INFO', 'Report', function ($scope, $stateParams, $ionicPopup, INFO, Report) {
    $scope.backUrl = INFO.reportBackUrl;
    $scope.isBusy = false;
    $scope.reportTypes = [
    {
      value: 0,
      view: '淫秽色情'
    },
    {
      value: 1,
      view: '敏感信息'
    },
    {
      value: 2,
      view: '垃圾营销'
    },
    {
      value: 3,
      view: '诈骗'
    },
    {
      value: 4,
      view: '人身攻击'
    },
    {
      value: 5,
      view: '泄露我的隐私'
    },
    {
      value: 6,
      view: '虚假资料'
    }];
    $scope.reportData ={
      hostType:'user',
      hostId :$stateParams.userId
    }
    $scope.pushReport = function() {
      if($scope.isBusy) {

      }
      else {
        $scope.isBusy = true;
        Report.pushReport($scope.reportData, function (err, data) {
          if (err) {
            // todo
            console.log(err);
            $ionicPopup.alert({
              title: '错误',
              template: err
            });

          } else {
            $ionicPopup.alert({
              title: '提示',
              template:'举报成功！'
            });
          }
          $scope.isBusy = false;
        });
      }
      
    }

  }])




