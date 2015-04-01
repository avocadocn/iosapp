angular.module('donlerApp.controllers', [])

  .controller('AppContoller', ['$scope', function ($scope) {
  }])
  .controller('UserLoginController', ['$scope', 'CommonHeaders', '$state', '$ionicHistory', 'UserAuth', function ($scope, CommonHeaders, $state, $ionicHistory, UserAuth) {
    $scope.loginData = {
      email: '',
      password: ''
    };

    $scope.login = function () {
      if(window.analytics){
        window.analytics.trackEvent('Click', 'userLogin');
      }
      UserAuth.login($scope.loginData.email, $scope.loginData.password, function (msg) {
        if (msg) {
          $scope.msg = msg;
        } else {
          $ionicHistory.clearHistory();
          $ionicHistory.clearCache();
          $state.go('app.campaigns');
        }
      });
    };
  }])
  .controller('HrLoginController', ['$scope', 'CommonHeaders', '$state', '$ionicHistory', 'CompanyAuth', function ($scope, CommonHeaders, $state, $ionicHistory, CompanyAuth) {

    $scope.loginData = {
      username: '',
      password: ''
    };

    $scope.login = function () {
      if(window.analytics){
        window.analytics.trackEvent('Click', 'hrLogin');
      }
      CompanyAuth.login($scope.loginData.username, $scope.loginData.password, function (msg) {
        if (msg) {
          $scope.msg = msg;
        } else {
          $ionicHistory.clearHistory();
          $ionicHistory.clearCache();
          $state.go('hr_home');
        }
      });
    };

  }])
  .controller('HrHomeController', ['$scope', '$state', 'CompanyAuth', 'CommonHeaders', function ($scope, $state, CompanyAuth, CommonHeaders) {

    $scope.logout = function () {
      if(window.analytics){
        window.analytics.trackEvent('Click', 'hrLogOut');
      }
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
  .controller('CreateTeamController', ['$scope', '$rootScope', '$state', '$ionicPopup', 'INFO', 'Team', function ($scope, $rootScope, $state, $ionicPopup, INFO, Team) {
    $scope.backUrl = localStorage.userType==='company' ? '#/hr/team_page' : INFO.createTeamBackUrl;
    $scope.isBusy = false;
    $scope.teamName = {};
    Team.getGroups(function(err,data) {
      if(!err) {
        $scope.groups = data;
        $scope.selectType = data[0];
      }
      else {
        $ionicPopup.alert({
          title: '错误',
          template: err
        });
      }
    });
    $scope.changeGroupType = function(selectType) {
      $scope.selectType = selectType;
    };
    $scope.createTeam = function() {
      if(!$scope.isBusy) {
        if(window.analytics){
          window.analytics.trackEvent('Click', 'createTeam');
        }
        $scope.isBusy = true;
        $rootScope.showLoading();
        $scope.isBusy = true;
        var teamData = {
          selectedGroups: [{
            groupType:$scope.selectType.groupType,
            entityType:$scope.selectType.entityType,
            _id:$scope.selectType._id,
            teamName:$scope.teamName.value
          }]
        };
        Team.createTeam(teamData, function(err, data) {
          $rootScope.hideLoading();
          if(!err){
            if(localStorage.userType==='user')
              $state.go('team',{teamId:data.teamId});
            else
              $state.go('hr_teamPage');
          }
          else{
            $ionicPopup.alert({
              title: '错误',
              template: err
            });
          }
        });
      }

    };
  }])
  .controller('HrForgetController', ['$scope', '$ionicLoading', 'Company', function ($scope, $ionicLoading, Company) {
    $scope.msg = '请输入注册所填邮箱，我们会将密码重置邮件发送给您。';
    $scope.forget={};
    $scope.findBack = function(){
      $ionicLoading.show({
        template: '请稍等...'
      });
      if(window.analytics){
        window.analytics.trackEvent('Click', 'hrFindBackPassword');
      }
      Company.findBack($scope.forget.email, function(msg){
        $ionicLoading.hide();
        if(msg){
          $scope.msg = '邮箱填写有误，请重新填写。';
        }else{
          $scope.msg= '密码重置邮件已发送，请登录您的邮箱查收。';
          $scope.sent = true;
        }
      });
    };
  }])
  .controller('UserForgetController', ['$scope', '$ionicLoading', 'User', function ($scope, $ionicLoading, User) {
    $scope.msg = '请输入注册所填邮箱，我们会将密码重置邮件发送给您。';
    $scope.forget={};
    $scope.findBack = function(){
      $ionicLoading.show({
        template: '请稍等...'
      });
      if(window.analytics){
        window.analytics.trackEvent('Click', 'userFindBackPassword');
      }
      User.findBack($scope.forget.email, function(msg){
        $ionicLoading.hide();
        if(msg){
          $scope.msg = '邮箱填写有误，请重新填写。';
        }else{
          $scope.msg= '密码重置邮件已发送，请登录您的邮箱查收。';
          $scope.sent = true;
        }
      });
    };
  }])
  .controller('CampaignController', ['$scope', '$state', '$timeout', '$ionicPopup', '$ionicPopover', '$rootScope', '$ionicScrollDelegate','$ionicHistory', '$filter', 'Campaign', 'INFO',
    function ($scope, $state, $timeout, $ionicPopup, $ionicPopover, $rootScope, $ionicScrollDelegate, $ionicHistory,  $filter, Campaign, INFO) {
    $scope.nowType = 'all';
    $scope.pswpPhotoAlbum = {};
    $scope.pswpId = 'campaigns' + Date.now();
    $scope.showSponsorButton = localStorage.role =='LEADER';
    var getCampaignList = function() {
      $rootScope.showLoading();
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
          // $scope.provokes = data[3];
          if(data[0].length===0&&data[1].length===0&&data[2].length===0){
            $scope.noCampaigns = true;
          }
          else {
            $scope.noCampaigns = false;
          }
        }
        else {
          $ionicPopup.alert({
            title: '错误',
            template: err
          });
        }
        $rootScope.hideLoading();
      });
    };
    // 此处使用rootScope是为了解决切换tab时不能刷新的问题
    $rootScope.getCampaignList = getCampaignList;
    $rootScope.$on( "$ionicView.enter", function( scopes, states ) {
      if(!states.stateName && $state.$current.name === 'app.campaigns'){
        getCampaignList();
      }
    });
    $ionicPopover.fromTemplateUrl('my-popover.html', {
      scope: $scope,
    }).then(function(popover) {
      $scope.popover = popover;
    });
    $scope.showFilter = function($event){
      $scope.popover.show($event);
    };
    var filterMap = {
      'all' : '所有活动',
      'newCampaigns' : '新活动',
      'unStartCampaigns' : '即将开始的活动',
      'nowCampaigns' : '正在进行的活动'
    };
    $scope.typeTitle = '所有活动';
    $scope.filter = function(filterType) {
      $scope.popover.hide();
      $scope.nowType = filterType;
      $scope.typeTitle = filterMap[filterType];
      $timeout(function() {
        $ionicScrollDelegate.scrollTop(true);
      });
    };
    $scope.$on('updateCampaignList', function(event, args) {
      $timeout(function(){
        $scope[args.campaignFilter].splice(args.campaignIndex,1);
        $scope[args.campaignFilter] = $filter('orderBy')($scope[args.campaignFilter], '-create_time');
        if(args.campaign){
          if(args.campaign.start_flag){
            $scope.nowCampaigns.push(args.campaign);
            $scope.nowCampaigns = $filter('orderBy')($scope.nowCampaigns, 'end_time');
          }
          else{
            $scope.unStartCampaigns.push(args.campaign);
            $scope.unStartCampaigns = $filter('orderBy')($scope.unStartCampaigns, 'start_time');
          }
        }
      },300);
    });
    $scope.doRefresh = function(){
      Campaign.getList({
        requestType: 'user',
        requestId: localStorage.id,
        select_type: 0,
        populate: 'photo_album'
      }, function (err, data) {
        if (!err) {
          $scope.unStartCampaigns = $filter('orderBy')(data[0], 'start_time');
          $scope.nowCampaigns = $filter('orderBy')(data[1], 'end_time');
          $scope.newCampaigns = $filter('orderBy')(data[2], '-create_time');
          $scope.provokes = $filter('orderBy')(data[3], '-create_time');
          if(data[0].length===0&&data[1].length===0&&data[2].length===0&&data[3].length===0){
            $scope.noCampaigns = true;
          }
          else {
            $scope.noCampaigns = false;
          }
        }
        else{
          $ionicPopup.alert({
            title: '错误',
            template: err
          });
        }
        $scope.$broadcast('scroll.refreshComplete');
      });
    };
  }])
  .controller('CampaignDetailController', ['$ionicHistory', '$scope', '$state', '$ionicPopup', 'Campaign', 'Message', 'INFO', 'User', 'Circle', 'CONFIG', 'Image', function ($ionicHistory, $scope, $state, $ionicPopup, Campaign, Message, INFO, User, Circle, CONFIG, Image) {
    $scope.goBack = function() {
      if($ionicHistory.backView()){
        $ionicHistory.goBack();
      }
      else {
        $state.go('app.campaigns');
      }
    };
    $scope.chooseUploadImages = function () {
      if (window.imagePicker) {
        window.imagePicker.getPictures(function(results) {
          if (results.length === 0) {
            return;
          }
          Circle.setUploadImages(results);
          $state.go('circle_uploader', { campaignId: $state.params.id });
        }, function (error) {
          console.log('Error: ' + error);
        }, {
          maximumImagesCount: 9,
          quality: 50 // 0~100
        });
      }
    };

    var setMembers = function () {
      $scope.campaign.members =[];
      var memberContent = [];
      $scope.campaign.campaign_unit.forEach(function(campaign_unit){
        if(campaign_unit.team){
          var content = {
            name:campaign_unit.team.name,
            members:campaign_unit.member
          };
          if (campaign_unit.company._id !== localStorage.cid) {
            content.isOtherCompany = true;
          }
          memberContent.push(content);
        }
        else {
          memberContent.push({
            name:campaign_unit.company.name,
            members:campaign_unit.member
          });
        }
      });
      INFO.memberContent = memberContent;
      INFO.locationContent = $scope.campaign.location;
      $scope.campaign.campaign_unit.forEach(function(campaign_unit){
        $scope.campaign.members = $scope.campaign.members.concat(campaign_unit.member);
      });
    };
    $scope.join = function(id){
      if(window.analytics){
        window.analytics.trackEvent('Click', 'joinCampaign');
      }
      Campaign.join($scope.campaign,localStorage.id, function(err, data){
        if(!err){
          $scope.campaign = data;
          setMembers();
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
    };
    $scope.quit = function(id){
      if(window.analytics){
        window.analytics.trackEvent('Click', 'quitCampaign');
      }
      Campaign.quit(id,localStorage.id, function(err, data){
        if(!err){
          $scope.campaign = data;
          setMembers();
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
    };
    $scope.goDiscussDetail = function(campaignId, campaignTheme) {
      INFO.discussName = campaignTheme;
      $state.go('campaigns_discuss',{id: campaignId});
    };
    $scope.goSendCircle = function(campaignId) {
      $state.go('circle_send_content',{campaignId: campaignId});
      // $state.go('circle_company');
    };
    $scope.ionicAlert = function(msg) {
      $ionicPopup.alert({
        title: '提示',
        template: msg
      });
    };
    //CIRCLE
    $scope.loadMore = function() {
      if (!$scope.loadingStatus.hasMore || $scope.loadingStatus.loading || !$scope.loadingStatus.hasInit) {
        return; // 如果没有更多内容或已经正在加载或是还没有获取过一次数据，则返回，防止连续的请求
      }
      $scope.loadingStatus.loading = true;
      var pos = $scope.circleContentList.length - 1;
      var lastContentDate = $scope.circleContentList[pos].content.post_date;
      Circle.getUserCircle($state.params.userId, {last_content_date: lastContentDate})
        .success(function(data) {
          if (data.length) {
            data.forEach(function(circle) {
              Circle.pickAppreciateAndComments(circle);
            });
            $scope.circleContentList = $scope.circleContentList.concat(data);
            $scope.loadingStatus.loading = false;
            copyPhotosToPswp();
          }

          $scope.$broadcast('scroll.infiniteScrollComplete');
        })
        .error(function(data, status) {
          if (status !== 404) {
            $scope.ionicAlert(data.msg || '获取失败');
          } else {
            $scope.loadingStatus.hasMore = false;
          }
          $scope.loadingStatus.loading = false;
          $scope.$broadcast('scroll.infiniteScrollComplete');
        });
    };
    $scope.openCommentBox = function(placeHolderText) {
      $scope.circleCommentBoxCtrl.setPlaceHolderText(placeHolderText);
      $scope.circleCommentBoxCtrl.open();
    };

    $scope.postComment = function(content) {
      $scope.circleCardListCtrl.postComment(content);
    };

    $scope.stopComment = function() {
      $scope.circleCardListCtrl.stopComment();
    };

    $scope.onClickContentImg = function(img) {
      for (var i = 0, imagesLen = $scope.imagesForPswp.length; i < imagesLen; i++) {
        if (img._id === $scope.imagesForPswp[i]._id) {
          $scope.pswpCtrl.open(i);
          break;
        }
      }
    };

    var pageLength = 20; // 一次获取的数据量

    // 复制图片地址到一个数组供预览大图用
    var copyPhotosToPswp = function() {
      $scope.imagesForPswp = [];
      var id = 0;
      for (var i = 0, circlesLen = $scope.circleContentList.length; i < circlesLen; i++) {
        var circle = $scope.circleContentList[i];
        if (circle.content.photos && circle.content.photos.length > 0) {
          var pswpPhotos = [];
          for (var j = 0, photosLen = circle.content.photos.length; j < photosLen; j++) {
            var photo = circle.content.photos[j];
            photo._id = id;
            var size = Image.getFitSize(photo.width, photo.height);
            pswpPhotos.push({
              _id: photo._id,
              w: size.width * 2,
              h: size.height * 2,
              src: CONFIG.STATIC_URL + photo.uri + '/' + size.width * 2 + '/' + size.height * 2
            });
            id++;
          }
          $scope.imagesForPswp = $scope.imagesForPswp.concat(pswpPhotos);
        }
      }
    };
    $scope.$on('$ionicView.enter',function(scopes, states){
      Campaign.get($state.params.id, function(err, data){
        if(!err){
          $scope.campaign = data;
          setMembers();
          data.components && data.components.forEach(function(component, index){
            if(component.name=='ScoreBoard') {
              $scope.scoreBoardId =component._id;
            }
          });
        }
      },true);
      Message.getCampaignMessages($state.params.id, function(err, data){
        if(!err){
          $scope.notices = data;
        }
      });
      Circle.getCampaignCircle($state.params.id)
      .success(function(data, status) {
        if (data.length) {
          data.forEach(function(circle) {
            Circle.pickAppreciateAndComments(circle);
          });
          $scope.circleContentList = (data || []).concat($scope.circleContentList);
        }
        copyPhotosToPswp();
        $scope.$broadcast('scroll.refreshComplete');
      })
      .error(function(data, status) {
        if (status !== 404) {
          $scope.ionicAlert(data.msg || '获取失败');
        }
        $scope.$broadcast('scroll.refreshComplete');
      });
      // 用于保存已经获取到的同事圈内容
      $scope.circleContentList = [];

      User.getData(localStorage.id, function(err, data) {
        if (err) {
          // todo
          console.log(err);
        } else {
          $scope.user = data;
        }
      });
      $scope.loadingStatus = {
        hasInit: false, // 是否已经获取了一次内容
        hasMore: false, // 是否还有更多内容，决定infinite-scroll是否在存在
        loading: false // 是否正在加载更多，如果是，则会保护防止连续请求
      };
      $scope.circleCardListCtrl = {};
      $scope.circleCommentBoxCtrl = {};
      $scope.pswpCtrl = {};


    });

  }])

  .controller('LocationController', ['$ionicHistory', '$scope', '$stateParams', 'INFO', function($ionicHistory, $scope, $stateParams, INFO) {
    $scope.location = INFO.locationContent;
    $scope.goBack = function() {
      if($ionicHistory.backView()){
        $ionicHistory.goBack()
      }
    }
  }])
  .controller('CampaignNoticelController', ['$ionicHistory', '$scope', '$stateParams', '$ionicPopup', 'Campaign', 'Message', function($ionicHistory, $scope, $stateParams, $ionicPopup, Campaign, Message) {
    Campaign.get($stateParams.id, function(err, data){
      if(!err){
        $scope.campaign = data;
      }
    });
    Message.getCampaignMessages($stateParams.id, function(err, data){
      if(!err){
        $scope.notices = data;
      }
    });
    $scope.showPopup = function() {
      $scope.data = {};

      // An elaborate, custom popup
      var myPopup = $ionicPopup.show({
        template: '<input type="text" ng-model="data.message">',
        title: '公告',
        subTitle: '请输入公告内容',
        scope: $scope,
        buttons: [
          { text: '取消' },
          {
            text: '<b>保存</b>',
            type: 'button-positive',
            onTap: function(e) {
              if (!$scope.data.message) {
                //don't allow the user to close unless he enters wifi password
                e.preventDefault();
              } else {
                return $scope.data.message;
              }
            }
          }
        ]
      });
      myPopup.then(function(res) {
        if(res) {
          var messageData = {
            type:'private',
            caption:$scope.campaign.theme,
            content:res,
            specific_type:{
              value: 3,
              child_type: $scope.campaign.campaign_unit.length>1 ? 1 : 0,
            },
            campaignId:$scope.campaign._id
          };
          if(window.analytics){
            window.analytics.trackEvent('Click', 'postCampaignMessage');
          }
          Message.postMessage( messageData, function(err, data){
            if(!err){
              $ionicPopup.alert({
                title: '提示',
                template: '公告发布成功！'
              });
              Message.getCampaignMessages($state.params.id, function(err, data){
                if(!err){
                  $scope.notices = data;
                }
              });
            }
            else{
              $ionicPopup.alert({
                title: '错误',
                template: err
              });
            }
          });
        }
      });
    };
    $scope.goBack = function() {
      if($ionicHistory.backView()){
        $ionicHistory.goBack()
      }
    }
  }])
  .controller('CampaignContentController', ['$ionicHistory', '$scope', '$stateParams', 'Campaign', function($ionicHistory, $scope, $stateParams, Campaign) {
    Campaign.get($stateParams.id, function(err, data){
      if(!err){
        $scope.campaign = data;
      }
    });
    $scope.goBack = function() {
      if($ionicHistory.backView()){
        $ionicHistory.goBack()
      }
    }
  }])
  .controller('SponsorController', ['$ionicHistory', '$scope', '$state', '$ionicPopup', '$ionicModal', '$timeout', 'Campaign', 'INFO', 'Team', function ($ionicHistory, $scope, $state, $ionicPopup, $ionicModal, $timeout, Campaign, INFO, Team) {
    $scope.campaignData ={
      location : {}
    };
    $scope.isBusy = false;
    $scope.showMapFlag ==false;
    $scope.sponsorType = $state.params.type;
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
    if($scope.sponsorType=='competition') {
      $scope.competitionMessage = INFO.competitionMessage;
      $scope.campaignData.messageId = $scope.competitionMessage._id;
      $scope.campaignData.cid = [$scope.competitionMessage.sponsor_cid,$scope.competitionMessage.opposite_cid];
      $scope.campaignData.tid = [$scope.competitionMessage.sponsor_team._id,$scope.competitionMessage.opposite_team._id];
      if($scope.competitionMessage.competition_type==1){
        $scope.campaignData.campaign_mold = $scope.competitionMessage.sponsor_team.group_type;
      }
      else{
        $scope.changeTeam($scope.competitionMessage.sponsor_team);
      }
    }
    else{
      $scope.campaignData.campaign_type = 2;
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
    }
    $ionicHistory.nextViewOptions({
      disableBack: true,
      historyRoot: true
    });
    $scope.goBack = function() {
      if($ionicHistory.backView()){
        $ionicHistory.goBack();
      }
      else {
        if($scope.sponsorType=='competition') {
          $state.go('competition_message_detail',{id:$scope.competitionMessage._id});
        }
        else{
          $state.go('app.'+ $scope.sponsorType);
        }

      }
    }
    var localizeDateStr = function(date_to_convert_str) {
      var date_to_convert = new Date(date_to_convert_str);
      var local_date = new Date();
      date_to_convert.setMinutes(date_to_convert.getMinutes()+local_date.getTimezoneOffset());
      return date_to_convert;
    };
    $scope.sponsor = function(){
      $scope.campaignData.start_time = $scope.campaignData.start_time;
      $scope.campaignData.end_time = $scope.campaignData.end_time;
      var errMsg;
      if($scope.campaignData.start_time < new Date() ) {
        errMsg ='开始时间不能早于现在';
      }
      else if($scope.campaignData.end_time < $scope.campaignData.start_time) {
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
        if(window.analytics){
          window.analytics.trackEvent('Click', 'sponsor');
        }
        $scope.isBusy = true;
        if($scope.sponsorType!=='competition') {
          $scope.campaignData.cid = [$scope.selectTeam.cid];
          $scope.campaignData.tid = [$scope.selectTeam._id];
          $scope.campaignData.campaign_mold = $scope.selectMold.name;
        }
        else if($scope.competitionMessage.competition_type==2){
          $scope.campaignData.campaign_mold = $scope.selectMold.name;
        }
        Campaign.create($scope.campaignData,function(err,data){
          if(!err){
            // $ionicPopup.alert({
            //   title: '提示',
            //   template: '活动发布成功！'
            // });
            $state.go('campaigns_detail',{id:data.campaign_id});
          }
          else{
            $ionicPopup.alert({
              title: '提示',
              template: err
            });
          }
          $scope.isBusy = false;
        });
      }

    };
  }])
  .controller('DiscussListController', ['$scope', '$rootScope', '$ionicHistory', 'Chat', '$state', 'Socket', 'Tools', 'INFO',
    function ($scope, $rootScope, $ionicHistory, Chat, $state, Socket, Tools, INFO) { //标为全部已读???
    Socket.emit('enterRoom', localStorage.id);
    //先在缓存里取
    $rootScope.$on( "$ionicView.enter", function ( scopes, states ) {
      if(!states.stateName){
        //? todo -M 可能需要到缓存里取什么...
        Socket.emit('enterRoom', localStorage.id);
        if(INFO.needUpdateDiscussList) {
          getChatroomsUnread();
        }
      }
    });
    var comeBack = function() {
      if($state.$current.name==='app.discuss_list') {
        Socket.emit('quitRoom');
        Socket.emit('enterRoom', localStorage.id);
        getChatroomsUnread();
      }
    };
    document.addEventListener('resume',comeBack, false);//从后台切回来要刷新及进room

    var getChatroomsUnread = function() {
      Chat.getChatroomUnread(function (err, data) {
        var chatroomsLength = $scope.chatrooms.length;
        if(data.length && $scope.chatrooms) {
          for(var i=0; i<data.length; i++) {
            var index = Tools.arrayObjectIndexOf($scope.chatrooms, data[i]._id, '_id');
            if(index>-1) {
              $scope.chatrooms[index].unread = data[i].unread;
            }
          }
        }
      });
    };
    var getChatrooms = function() {
      Chat.getChatroomList(function (err, data) {
        // console.log(data);
        $scope.chatrooms = data;
        getChatroomsUnread();
      });
    };
    getChatrooms();
    Socket.on('newChatroomChat', function (chat) {
      if($scope.chatrooms) {
        var index = Tools.arrayObjectIndexOf($scope.chatrooms, chat.chatroom_id, '_id');
        if(index>-1) {
          $scope.chatrooms[index].unread ++;
          $scope.chatrooms[index].latestChat = chat;
          //升到第一个
          var temp = $scope.chatrooms[index];
          $scope.chatrooms.splice(index, 1);
          $scope.chatrooms.unshift(temp);
        }
      }
    });

    //以防万一，给个刷新接口。
    $scope.refresh = function() {
      getChatrooms();
      $scope.$broadcast('scroll.refreshComplete');
    };

    //判断是否有新的
    var checkAllRead = function() {
      var hasnotRead = false;
      for (var i = $scope.chatrooms.length - 1; i >= 0; i--) {
        if($scope.chatrooms[i].unread) {
          hasnotRead = true;
        }
      }
      if(hasnotRead === false) {
        $rootScope.hasNewComment = false;
      }
    };

    $scope.goDetail = function(chatroom, index) {
      INFO.chatroomName = chatroom.name;
      $scope.chatrooms[index].unread = 0;
      checkAllRead();
      $state.go('chat',{chatroomId: chatroom._id});
    };
    //离开时缓存
    $scope.$on('$destroy',function() {
      Chat.saveChatroomList($scope.chatrooms);
    });
  }])
  .controller('ChatroomDetailController', ['$scope', '$state', '$stateParams', '$ionicScrollDelegate', 'Chat', 'Socket', 'User', 'Tools', 'CONFIG', 'INFO', '$ionicPopup', 'Upload', '$ionicModal',
    function ($scope, $state, $stateParams, $ionicScrollDelegate, Chat, Socket, User, Tools, CONFIG, INFO, $ionicPopup, Upload, $ionicModal) {
    $scope.chatroomId = $stateParams.chatroomId;
    $scope.chatroomName = INFO.chatroomName;
    $scope.userId = localStorage.id;
    $scope.cid = localStorage.cid;
    Socket.emit('quitRoom');
    Socket.emit('enterRoom', $scope.chatroomId);
    $scope.chatsList = [];
    $scope.topShowTime = [];
    //---获取评论
    //各种获取评论，带nextDate是获取历史，带preDate是获取最新
    var getChats = function(nextDate, nextId, preDate, callback) {
      var params = {chatroom: $scope.chatroomId};
      if(nextDate) {params.nextDate = nextDate;}
      if(nextId) {params.nextId = nextId;}
      if(preDate) {params.preDate = preDate;}
      Chat.getChats(params, function(err, data) {
        if(!err) {
          if(!nextDate) {
            $scope.chatsList.push(data.chats.reverse());
          }
          else {
            $scope.chatsList.unshift(data.chats.reverse());
          }
          data.chats.forEach(addPhotos);
          judgeTopShowTime();
          $scope.nextDate = data.nextDate;
          $scope.nextId = data.nextId;
          callback && callback();
        }
      });
    };
    //刚进来的时候获取第一页评论
    getChats(null,null,null,function() {
      $ionicScrollDelegate.scrollBottom();
    });
    //获取更老的评论
    $scope.readHistory = function() {
      if($scope.nextDate) {
        $scope.topShowTime.push();
        getChats($scope.nextDate, $scope.nextId, null, function() {
          $scope.$broadcast('scroll.refreshComplete');
          $ionicScrollDelegate.scrollTo(0,1350);//此数值仅在发的评论为1行时有效...
          //如果需要精确定位到刚才的地方，需要jquery
          // $('#currentComment').scrollIntoView();//need jQuery
        });
      }else {
        $scope.$broadcast('scroll.refreshComplete');
      }
    };
    //获取比现在的第一条更新的所有讨论
    var refreshChat = function () {
      $scope.startRefresh = true;
      var latestCreateDate = null;
      if($scope.chatsList.length && $scope.chatsList[0][0]) {
        var latestChatIndex = $scope.chatsList[0].length-1;
        latestCreateDate = $scope.chatsList[0][latestChatIndex].create_date;
      }
      getChats(null, null, latestCreateDate);
    };
    //socket来了新评论
    Socket.on('newChat', function(data) {
      // console.log(data);
      //如果是自己发的看看是不是取消loading就行.
      var chatListIndex = $scope.chatsList.length -1;
      if(data.poster._id === currentUser._id && data.randomId) {
        //-找到那条自己发的
        var length = $scope.chatsList[chatListIndex].length;
        for(var i = length-1; i>=0; i--){
          if($scope.chatsList[chatListIndex][i].randomId === data.randomId){
            data.randomId = null;
            addPhotos(data);
            $scope.chatsList[chatListIndex][i] = data;
            break;
          }
        }
      }else{
        var chats_ele = document.getElementsByClassName('comments'); // 获取滚动条
        data.randomId = null;
        var nowHeight =  $ionicScrollDelegate.getScrollPosition().top; //获取总高度
        var scrollHeight = chats_ele.length ? chats_ele[0].scrollHeight - (window.outerHeight-89) : 0; //获取当前所在位置
        var isAtBottom = false;
        if(scrollHeight - nowHeight < 50 ) isAtBottom = true;
        $scope.chatsList[chatListIndex].push(data);
        addPhotos(data);
        if( isAtBottom && !$scope.isWriting) $ionicScrollDelegate.scrollBottom();
      }
    })
    //从后台切回来要刷新及进room
    var comeBackFromBackground = function() {
      if($state.$current.name === 'chat' && $scope.chatroomId === $state.params.chatroomId) {
        Socket.emit('quitRoom');
        Socket.emit('enterRoom', $scope.chatroomId); //以防回来以后接收不到
        //更新刚才一段时间内的新评论
        refreshChat();
      }
    };
    document.addEventListener('resume',comeBackFromBackground, false);

    //---判断时间
    //判断顶部时间是否需要显示
    var judgeTopShowTime = function() {
      $scope.topShowTime.unshift(1);
      if($scope.chatsList.length>1) {
        var preTime = new Date($scope.chatsList[1][0].create_date);//上次的第一个
        var length = $scope.chatsList[0].length;
        var nowTime = new Date($scope.chatsList[0][length-1].create_date);//这次的最后一个
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
    /* 是否需要显示时间()
     * @params: index: 第几个chat
     * 判断依据：与上一个评论时间是否在同一分钟||index为0
     * return:
     *   0 不用显示
     *   1 显示年、月、日
     *   2 显示月、日
     */
    $scope.needShowTime = function (index, chats) {
      if(index===0){
        return 1;
      }else{
        var preTime = new Date(chats[index-1].create_date);
        var nowTime = new Date(chats[index].create_date);
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

    //---发聊天
    $scope.isShowEmotions = false;
    $scope.content = '';
    //获取自己的资料供发的时候用
    var currentUser;
    User.getData($scope.userId, function(err,data){
      currentUser = data;
    });
    //发布文字消息
    $scope.publish = function() {
      // if(window.analytics){
      //   window.analytics.trackEvent('Click', 'publishComment');
      // }
      var randomId = Math.floor(Math.random()*100);
      var newChat = {
        create_date: new Date(),
        poster: {
          '_id': currentUser._id,
          'photo': currentUser.photo,
          'nickname': currentUser.nickname
        },
        content: $scope.content,
        randomId: randomId
        // loading: true
        // 不用loading原因: 用了某个loading旋转以后聊天的外框css会有问题...
      };
      $scope.content = '';
      var chatsListIndex = $scope.chatsList.length-1;
      $scope.chatsList[chatsListIndex].push(newChat);
      $ionicScrollDelegate.scrollBottom();

      Chat.postChat($scope.chatroomId, {content:newChat.content, randomId:randomId}, function(err, chat) {
        if(err) {
          console.log(err);
          var latestIndex = $scope.chatsList[chatsListIndex].length -1;
          $scope.chatsList[chatsListIndex][latestIndex].failed = true;
        }
      });
    };

    $scope.hideEmotions = function() {
      $scope.isShowEmotions = false;
    };

    //---发图片相关
    $ionicModal.fromTemplateUrl('confirm-upload-modal.html', {
      scope: $scope,
      animation: 'slide-in-up'
    }).then(function(modal) {
      $scope.confirmUploadModal = modal;
    });

    $scope.showUploadActionSheet =function() {
      Upload.getPicture(false, function (err, imageURI) {
        if(!err){
          $scope.previewImg = imageURI;
          $scope.confirmUploadModal.show();
        }
      });
    };

    $scope.cancelUpload = function() {
      $scope.confirmUploadModal.hide();
    };

    $scope.confirmUpload = function () {
      // if(window.analytics){
      //   window.analytics.trackEvent('Click', 'uploadImg');
      // }
      //-生成随机id
      var randomId = Math.floor(Math.random()*100);
      //-创建一个新chat
      var newChat = {
        randomId: randomId,
        chatroom_id: $scope.chatroom_id,
        create_date: new Date(),
        poster: {
          '_id': currentUser._id,
          'photo': currentUser.photo,
          'nickname': currentUser.nickname
        },
        photos: [{uri:$scope.previewImg}]
      };
      var chatsListIndex = $scope.chatsList.length -1;
      $scope.chatsList[chatsListIndex].push(newChat);
      $ionicScrollDelegate.scrollBottom();
      //上传
      var data = {randomId: randomId, imageURI:$scope.previewImg};
      var addr = CONFIG.BASE_URL + '/chatrooms/' + $scope.chatroomId + '/chats/';
      Upload.upload('discuss', addr, data, function(err) {
        if(!err) {
          $scope.confirmUploadModal.hide();
        } else {//发送失败
          $scope.confirmUploadModal.hide();
          var length = $scope.chatsList[chatListIndex].length;
          for(var i = length-1; i>=0; i--){
            if($scope.chatsList[chatListIndex][i].randomId === data.randomId){
              $scope.chatsList[chatListIndex][i].failed = true;
              break;
            }
          }
        }
      });
    };

    //for pswp
    $scope.pswpId = 'chat' + Date.now();
    $scope.pswpPhotoAlbum = {};
    $scope.photos = [];
    var addPhotos = function (chat) {
      if (chat.photos && chat.photos.length > 0) {
        chat.photos.forEach(function (photo) {
          var width = photo.width || INFO.screenWidth;
          var height = photo.height || INFO.screenHeight;
          var item = {
            _id: photo._id,
            src: CONFIG.STATIC_URL + photo.uri,
            w: width,
            h: height
          };
          item.title = '上传者: ' + chat.poster.nickname + '  上传时间: ' + moment(chat.create_date).format('YYYY-MM-DD HH:mm');
          $scope.photos.push(item);
        });
      }
    };

    //离开此页时标记读过
    $scope.$on('$destroy',function() {
      Chat.readChat($scope.chatroomId);
      $scope.confirmUploadModal.remove();
    });


  }])
  .controller('DiscussDetailController', ['$ionicHistory', '$scope', '$state', '$stateParams', '$ionicScrollDelegate', '$timeout', 'Comment', 'User', 'INFO',
    function ($ionicHistory, $scope, $state, $stateParams, $ionicScrollDelegate, $timeout, Comment, User, INFO) {
    $scope.campaignId = $stateParams.id;
    $scope.campaignTitle = INFO.discussName;

    $scope.content='';
    $scope.userId = localStorage.id;

    //ionichistory
    $scope.goBack = function() {
      if($ionicHistory.backView()){
        $ionicHistory.goBack();
      }
      else {
        $state.go('app.campaigns');
      }
    };

    $scope.comments = [];
    var nextStartDate = '';
    $scope.loading = false;
    //获取评论
    var getComments = function(queryData) {
      $scope.loading = true;
      Comment.getComments(queryData, function(err, data){
        if(!err) {
          $scope.comments = $scope.comments.concat(data.comments);
          nextStartDate = data.nextStartDate;
          $scope.hasMore = nextStartDate ? true: false;
          $scope.$broadcast('scroll.infiniteScrollComplete');
          $timeout(function() {
            $scope.loading = false;
          }, 1000);
        }
        else{
          console.log(err);
        }
      });
    };
    getComments({
      requestType: 'campaign',
      requestId: $scope.campaignId,
      limit: 20
    });

    $scope.isWriting = false;

    //拉取历史讨论记录
    $scope.readHistory = function() {
      if(nextStartDate){//如果还有下一条
        var queryData = {
          requestType: 'campaign',
          requestId: $scope.campaignId,
          limit: 20,
          createDate: nextStartDate
        };
        getComments(queryData);
      }else{//没下一条了~
        $scope.$broadcast('scroll.infiniteScrollComplete');
      }
    };

    //获取个人信息供发评论使用
    var currentUser;
    User.getData($scope.userId, function(err,data){
      currentUser = data;
    });

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
      }
    };

    //发表评论
    $scope.publish = function() {
      if(window.analytics){
        window.analytics.trackEvent('Click', 'publishComment');
      }
      //-创建一个新comment
      var newComment = {
        create_date: new Date(),
        poster: {
          '_id': currentUser._id,
          'photo': currentUser.photo,
          'nickname': currentUser.nickname
        },
        content: $scope.content
      };
      $scope.comments.push(newComment);
      $ionicScrollDelegate.scrollBottom();
      Comment.publishComment({
        'hostType': 'campaign',
        'hostId': $scope.campaignId,
        'content': $scope.content
      }, function(err){
        if(err){
          console.log(err);
          //发送失败
          var length = $scope.comments.length;
          $scope.comments[length-1].failed = true;
        }else{
          $scope.content = '';
        }
      });
    };

    $scope.hideEmotions = function() {
      $scope.isShowEmotions = false;
    };

  }])
  .controller('CompanyController', ['$scope', '$ionicPopup', '$state', '$ionicHistory', 'Team', 'INFO',
    function ($scope, $ionicPopup, $state, $ionicHistory, Team, INFO) {
    if($state.params.type) {
      $scope.loading = true;
      $scope.teams = INFO.officialTeamList;
      $scope.loading = false;
    }
    else {
      $scope.loading = true;
      Team.getList('company', null, false, function (err, teams) {
        if (err) {
          // todo
          console.log(err);
        } else {
          $scope.teams = teams.sort(function (last,next) {
            return next.hasJoined - last.hasJoined;
          });
          INFO.officialTeamList = $scope.teams;
          $scope.loading = false;
        }
      });
      // Team.getList('company', null, true, function (err, teams) {
      //   if (err) {
      //     // todo
      //     console.log(err);
      //   } else {
      //     $scope.personalTeams = teams;
      //     INFO.personalTeamList = teams;
      //   }
      // });
    }

    $scope.refresh = function() {
      Team.getList('company', null, false, function (err, teams) {
        if (err) {
          // todo
          console.log(err);
        } else {
          $scope.teams = teams;
          INFO.officialTeamList = teams;
        }
        $scope.$broadcast('scroll.refreshComplete');
      });
    };

    $scope.joinTeam = function(tid, index) {
      if(window.analytics){
        window.analytics.trackEvent('Click', 'joinTeamInAllTeam');
      }
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
    };
    $scope.quitTeam = function(tid, index) {
      if(window.analytics){
        window.analytics.trackEvent('Click', 'quitTeamInAllTeam');
      }
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
    };
  }])
  .controller('CompanyCircleController', ['$scope', '$timeout', 'TimeLine', 'INFO', function ($scope, $timeout, TimeLine, INFO) {
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
      }
    };
    $scope.doRefresh = function(){
      $scope.page = 0;
      $scope.loadFinished = false;
      TimeLine.getTimelines('company', '0', $scope.page, function (err, timelineData) {
        if (err) {
          // todo
          console.log(err);
          $scope.loadFinished = true;
        } else {
          if(timelineData.length>0) {
            $scope.timelinesRecord = timelineData;
          }
          else {
            $scope.loadFinished = true;
          }
        }
        $scope.$broadcast('scroll.refreshComplete');
      });
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
            $scope.loadFinished = true;
          } else {
            if(timelineData.length>0) {
              $scope.timelinesRecord = $scope.timelinesRecord.concat(timelineData);
            }
            else {
              $scope.loadFinished = true;
            }
          }
          $timeout(function() {
            $scope.loading = false;
          }, 1000);
          $scope.$broadcast('scroll.infiniteScrollComplete');
        });
      }
    };
  }])
  .controller('ContactsController', ['$scope', 'User', 'INFO', 'Tools', function ($scope, User, INFO, Tools) {
    var contactsBackup = [];
    $scope.keyword = {value:''};
    //获取公司联系人
    User.getCompanyUsers(localStorage.cid,function(msg, data){
      if(!msg) {
        $scope.contacts = data;
        contactsBackup = data;
      }
    });
    $scope.cancelSearch = function () {
      $scope.contacts = contactsBackup;//还原
      $scope.searching = false;
    };
    $scope.search = function (event) {
      if(window.analytics){
        window.analytics.trackEvent('Click', 'searchContacts');
      }
      var keyword = $scope.keyword.value;
      if(keyword && (!event || event.which===13)) {
        $scope.contacts = [];
        var length = contactsBackup.length;
        var find = false;
        for(var i=0; i<length; i++) {//找名字里含关键字的
          if(contactsBackup[i].nickname.indexOf(keyword) > -1) {
            $scope.contacts.push(contactsBackup[i]);
            find = true;
          }
        }
        for(var i=0; i<length; i++) {//找email里含关键字的
          if(contactsBackup[i].email.indexOf(keyword) > -1) {
            if(Tools.arrayObjectIndexOf($scope.contacts,contactsBackup[i]._id,'_id')===-1) {
              $scope.contacts.push(contactsBackup[i]);
              find = true;
            }
          }
        }
        if(find === false) {
          $scope.message = '未查找到相关同事';
        }else{
          $scope.message = '';
        }
        $scope.searching = true;
      }
    };
  }])
  .controller('PersonalController', ['$scope', '$rootScope', '$state', '$ionicHistory', 'User', 'Message', 'Tools', 'CONFIG', 'INFO', function ($scope, $rootScope, $state, $ionicHistory, User, Message, Tools, CONFIG, INFO) {
    $scope.$on('$stateChangeStart',function (event, toState, toParams, fromState, fromParams){
      if(toState.url==='/personal') {
        getUser();
      }
    });
    $rootScope.$on('$ionicView.enter', function (scopes, states) {
      if(!states.stateName){
        getUser();
      }
    });
    var getUser = function() {
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
    };
    getUser();


    $scope.pswpId = 'personal' + Date.now();

    Message.receiveUserMessages(localStorage.id, function (err, messagesCount) {
      if (err) {
        // todo
        console.log(err);
      } else {
        $scope.messagesCount = messagesCount;
      }
    });

  }])
  .controller('PersonalInviteCodeController', ['$scope', 'Company', '$cordovaClipboard', '$ionicPopup', 'CONFIG', function ($scope, Company, $cordovaClipboard, $ionicPopup, CONFIG) {
    Company.getInviteKey(localStorage.cid, function(msg, data){
      if(!msg){
        $scope.inviteKey = data.staffInviteCode;
        var qrcode = new QRCode("inviteKeyQrCode", {
          text: CONFIG.STATIC_URL+"/users/invite?key="+data.staffInviteCode+"&cid="+localStorage.cid
        });
      }
    });

    $scope.copy = function () {
      if(window.analytics){
        window.analytics.trackEvent('Click', 'copyInviteKey');
      }
      $cordovaClipboard
      .copy($scope.inviteKey)
      .then(function () {
        $ionicPopup.alert({
          title: '提示',
          template: '验证码已成功复制到剪贴板'
        });
      }, function () {
        $ionicPopup.alert({
          title: '提示',
          template: '复制验证码到剪贴板失败'
        });
      });
    };

  }])
  .controller('PersonalEditController', ['$scope', '$state', '$ionicPopup', '$ionicHistory', 'User', 'CONFIG', 'Upload',
    function ($scope, $state, $ionicPopup, $ionicHistory, User, CONFIG, Upload) {

    var birthdayInput = document.getElementById('birthday');

    $scope.$on('$ionicView.enter', function (scopes, states) {
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
            birthday: new Date($scope.user.birthday),
            introduce: $scope.user.introduce,
            sex: $scope.user.sex
          };
        }
      });
    });

    $scope.unchanged = true;
    $scope.change = function() {
      $scope.unchanged = false;
    };
    $scope.tagDelete = function(tag, index) {
      $scope.user.tags.splice(index,1);
      User.editData($scope.user._id, {deleteTag:tag}, function(err) {
        if(err) {
          $ionicPopup.alert({
            title: '删除失败',
            template: err
          });
        }
      });
    };

    $scope.edit = function () {
      if(window.analytics){
        window.analytics.trackEvent('Click', 'editUser');
      }
      User.editData($scope.user._id, $scope.formData, function (err) {
        if (err) {
          $ionicPopup.alert({
            title: '编辑失败',
            template: err
          });
        } else {
          //暂时么有tag
          // if($scope.formData.tag) {
          //   $scope.user.tags.push($scope.formData.tag);
          //   $scope.formData.tag = '';
          // }
          $ionicHistory.clearHistory();
          $ionicHistory.clearCache();
          $state.go('app.personal');
        }
      });
    };

    $scope.showUploadActionSheet = function () {
      Upload.getPicture(true, function (err, imageURI) {
        if(!err){
          var addr = CONFIG.BASE_URL + '/users/' + localStorage.id;
          Upload.upload('photo', addr, {imageURI:imageURI}, function(err) {
            if(window.analytics){
              window.analytics.trackEvent('Click', 'editUserPhoto');
            }
            if(!err) {
              //更新现在的头像
              $ionicHistory.clearHistory();
              $ionicHistory.clearCache();
              User.clearCurrentUser();
              var successAlert = $ionicPopup.alert({
                title: '提示',
                template: '修改头像成功'
              });
              successAlert.then(function () {
                $state.go('app.personal');
              });
            }else {
              $ionicPopup.alert({
                title: '提示',
                template: '修改失败，请重试'
              });
            }
          });
        }
      });
    };

    var ta = document.getElementById('ta');

    //获取字符串真实长度，供计算高度用
    var getRealLength = function(str) {
      if(typeof(str) === 'string') {
        var newstr =str.replace(/[\u0391-\uFFE5]/g,"aa");
        return newstr.length;
      }else {
        return 0;
      }
    };
    //重新计算输入框行数
    $scope.resizeTextarea = function() {
      if($scope.formData.introduce) {
        var text = $scope.formData.introduce.split("\n");
        var rows = text.length;
        var originCols = ta.cols;
        for(var i = 0; i<rows; i++) {
          var rowText = i === 0 ? text[i] || text : text[i] || '';
          var realLength = getRealLength(rowText);
          if(realLength >= originCols) {
            if(!text[i])
              rows += Math.ceil(realLength/originCols);
            else
              rows = Math.ceil(realLength/originCols);
          }
        }
        rows = Math.max(rows, 1);
        rows = Math.min(rows, 4);
        if(rows != ta.rows) {
          ta.rows = rows;
        }
      }else {
        ta.rows = 1;
      }
    };

  }])
  .controller('PersonalTeamListController', ['$scope','$state', '$ionicHistory','Team', 'INFO', function ($scope, $state, $ionicHistory, Team, INFO) {
    INFO.createTeamBackUrl = '#/personal/teams';
    $scope.loading = true;
    $scope.goBack = function() {
      if($ionicHistory.backView()){
        $ionicHistory.goBack();
      }
      else {
        $state.go('app.personal');
      }
    };
    $scope.myTeamFlag = !$state.params.userId  || $state.params.userId==localStorage.id;

    var getMyTeams = function() {
      Team.getList('user', $state.params.userId || localStorage.id, null, function (err, teams) {
        if (err) {
          // todo
          console.log(err);
          $scope.loading = false;
        } else {
          var leadTeams = [];
          var memberTeams = [];
          teams.forEach(function(team) {
            if(team.isLeader) {
              leadTeams.push(team);
            }
            else {
              memberTeams.push(team);
            }
          });
          $scope.leadTeams = leadTeams;
          $scope.memberTeams = memberTeams;
          $scope.loading = false;
        }
      });
    };
    getMyTeams();
    $scope.refresh = function() {
      getMyTeams();
      $scope.$broadcast('scroll.refreshComplete');
    };

  }])
  .controller('SettingsController', ['$scope', '$state', '$ionicHistory', 'UserAuth', 'User', 'CommonHeaders', function ($scope, $state, $ionicHistory, UserAuth, User, CommonHeaders) {

    $scope.logout = function () {
      if(window.analytics){
        window.analytics.trackEvent('Click', 'userLogOut');
      }
      User.clearCurrentUser();
      UserAuth.logout(function (err) {
        if (err) {
          // todo
          console.log(err);
        } else {
          $ionicHistory.clearHistory();
          $ionicHistory.clearCache();
          $state.go('home');
        }
      });
    };

  }])
  .controller('AccoutController', ['$scope', 'User', function($scope, User) {
    User.getPushToggle(localStorage.id, function(msg, data){
      if(!msg){
        $scope.user = data;
      }
    });
    $scope.changePushToggle = function() {
      if(window.analytics){
        window.analytics.trackEvent('Click', 'changePushToggle');
      }
      User.editData(localStorage.id, $scope.user, function(msg){});
    };
  }])
  .controller('PasswordController', ['$scope', '$rootScope', '$ionicPopup', 'User', function($scope, $rootScope, $ionicPopup, User) {
    $scope.pswData = {};
    $scope.changePwd = function() {
      $rootScope.showLoading();
      if(window.analytics){
        window.analytics.trackEvent('Click', 'changePwd');
      }
      User.editData(localStorage.id, $scope.pswData, function(msg) {
        $rootScope.hideLoading();
        if(msg){
          $ionicPopup.alert({title:'修改失败',template:msg});
        }else{
          $ionicPopup.alert({title:'修改成功'});
        }
      });
    };
  }])
  .controller('TabController', ['$scope', '$rootScope', '$ionicHistory', 'Socket', 'Circle', function ($scope, $rootScope, $ionicHistory, Socket, Circle) {
    //每次进入页面判断是否有新评论没看
    $rootScope.newCircleComment = 0;

    Circle.getReminds(function(err, data) {
      if(!err) {
        $rootScope.hasNewComment = data.newChat;
        $rootScope.hasNewDiscover = data.newDiscover;
        if(data.newCircleContent) {
          $rootScope.newContent = {photo: data.newCircleContent.post_user_id.photo};
        }
        $rootScope.newCircleComment = data.newCircleComment;
      }
    })

    //socket服务器推送通知
    Socket.on('getNewCircleContent', function(photo) {
      $rootScope.newContent = {photo: photo};
    });
    Socket.on('getNewCircleComment', function() {
      $rootScope.newCircleComment++;
    });
    Socket.on('newCompetitionMessage', function() {
      $rootScope.hasNewDiscover = true;
    });
    Socket.on('getNewChat', function() {
      $rootScope.hasNewComment = true;
    });

    $scope.$on('$stateChangeStart',
      function (event, toState, toParams, fromState, fromParams) {
        $ionicHistory.nextViewOptions({
          disableBack: true,
          historyRoot: true
        });
        if (toState.name === 'app.campaigns') {
          if($rootScope.getCampaignList) { $rootScope.getCampaignList(); }
        }
    });
  }])
  .controller('CalendarController',['$scope', '$rootScope', '$state', '$ionicPopup', '$ionicPopover', '$timeout', '$ionicHistory', 'Campaign', 'INFO',
    function($scope, $rootScope, $state, $ionicPopup, $ionicPopover, $timeout, $ionicHistory, Campaign, INFO) {
      $scope.nowTypeIndex =2;
      $scope.campaignTypes =[{
        value:'unjoined',view:'未参加'
      },
      {
        value:'joined',view:'已参加'
      },
      {
        value:'all',view:'所有'
      }];
      $scope.goBack = function() {
        if($ionicHistory.backView()){
          $ionicHistory.goBack();
        }
        else {
          $state.go('app.'+$state.params.type);
        }
      };

      moment.locale('zh-cn');
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
            }
          };
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
          });
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
              });
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
      };
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
      };
      if($scope.view=='month') {
        updateMonth(current);
      }
      else if($scope.view =='day') {
        updateDay(current);
      }

  }])
  .controller('PrivacyController', ['$scope', '$ionicNavBarDelegate', function ($scope, $ionicNavBarDelegate) {
    $scope.backHref = '#/settings/about';
  }])
  .controller('CompRegPrivacyController', ['$scope', '$ionicNavBarDelegate', function ($scope, $ionicNavBarDelegate) {
    $scope.backHref = '#/register/company';
  }])
  .controller('UserRegPrivacyController', ['$scope', '$ionicNavBarDelegate', 'INFO', function ($scope, $ionicNavBarDelegate, INFO) {
    $scope.backHref = '#/register/user/post_detail/' + INFO.companyId;
  }])
  .controller('HrSignupController' ,['$scope', '$state', '$rootScope', '$ionicPopup', 'CompanySignup', 'CONFIG', function ($scope, $state, $rootScope, $ionicPopup, CompanySignup, CONFIG) {
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
      $rootScope.showLoading();
      if(window.analytics){
        window.analytics.trackEvent('Click', 'companySignUp');
      }
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
        $rootScope.hideLoading();
        if(err){
          $ionicPopup.alert({
            title: '验证失败',
            template: err
          });
        }else{
          $state.go('register_company_wait');
        }
      });
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
  .controller('UserSearchCompanyController', ['$scope', '$state', 'UserSignup','INFO', function ($scope, $state, UserSignup, INFO) {
    // $scope.keypress = function(keyEvent) {
    //   if (keyEvent.which === 13) {
    //     $scope.searchCompany();
    //   }
    // };
    $scope.companyEmail = {};
    var mailCheck = function(callback) {
      if($scope.companyEmail.value){
        UserSignup.validate($scope.companyEmail.value, null, null, function (msg, data) {
          $scope.active=data.active;
          if(msg){
            $scope.mail_msg = '您输入的邮箱有误';
            callback(false);
          }else{
            callback($scope.active);
            $scope.mail_msg = null;
          }
          $scope.mail_check = true;
        });
      }else{
        $scope.mail_check = false;
        $scope.mail_msg = '您输入的邮箱有误';
        callback(false);
      }
    };
    $scope.searchCompany = function() {
      if(window.analytics){
        window.analytics.trackEvent('Click', 'searchCompany');
      }
      mailCheck(function(active){
        if(active===1){
          UserSignup.searchCompany($scope.companyEmail.value, function(msg, data){
            if(!msg){
              $scope.companies = data;
            }
            $scope.searched = true;
          });
        }
      });
    };
    $scope.goDetail = function(company) {
      INFO.companyId = company._id;
      INFO.companyName = company.name;
      INFO.email = $scope.companyEmail.value;
      if(company.mail_active){
        $state.go('register_user_postDetail',{cid:company._id});
      }else{
        $state.go('register_user_remind_activate');
      }
    };
  }])
  .controller('UserRegisterDetailController', ['$scope', '$rootScope', '$state', '$ionicPopup', 'UserSignup', 'INFO', function ($scope, $rootScope, $state, $ionicPopup, UserSignup, INFO) {
    $scope.data = {};
    $scope.data.cid = INFO.companyId;
    $scope.data.email = INFO.email;
    $scope.companyName = INFO.companyName;
    $scope.signup = function() {
      $rootScope.showLoading();
      if(window.analytics){
        window.analytics.trackEvent('Click', 'userSignUp');
      }
      UserSignup.signup($scope.data, function(msg, data) {
        $rootScope.hideLoading();
        if(!msg){
          $state.go('register_user_waitEmail');
        }else{
          $ionicPopup.alert({
            title: '失败',
            template: msg
          });
        }
      });
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
    };

  }])
  .controller('HrActiveCodeController', ['$scope', 'Company', '$cordovaClipboard', '$ionicPopup', function ($scope, Company, $cordovaClipboard, $ionicPopup) {
    Company.getInviteKey(localStorage.id, function(msg, data){
      if(!msg){
        $scope.inviteKey = data.staffInviteCode;
        var qrcode = new QRCode("inviteKeyQrCode", {
          text: "http://www.donler.com/users/invite?key="+data.staffInviteCode+"&cid="+localStorage.id
        });
      }
    });

    $scope.copy = function () {
      if(window.analytics){
        window.analytics.trackEvent('Click', 'copyInviteKey');
      }
      $cordovaClipboard
      .copy($scope.inviteKey)
      .then(function () {
        $ionicPopup.alert({
          title: '提示',
          template: '验证码已成功复制到剪贴板'
        });
      }, function () {
        $ionicPopup.alert({
          title: '提示',
          template: '复制验证码到剪贴板失败'
        });
      });
    };

  }])
  .controller('HrTeamController', ['$scope', '$state', '$stateParams', 'INFO', 'Company', function ($scope, $state, $stateParams, INFO, Company) {
    switch ($stateParams.type) {
    case 'all':
      $scope.title = '所有小队';
      break;
    case 'official':
      $scope.title = '官方小队';
      break;
    case 'unofficial':
      $scope.title = '个人小队';
      break;
    }

    Company.getTeams(localStorage.id, 'team', $stateParams.type, function(msg, data) {
      if(!msg){
        $scope.teams = data;
      }
    });

    $scope.editTeam = function (team) {
      INFO.team = team;
      $state.go('hr_editTeam',{teamId:team._id});
    };
  }])
  //-hr编辑小队信息
  .controller('HrEditTeamController', ['$scope', '$ionicPopup', 'INFO', 'Team', 'User', function ($scope, $ionicPopup, INFO, Team, User) {
    $scope.formData = {name: INFO.team.name};
    $scope.memberName = {};
    var teamMembersBackup = [];//切换组员、公司成员用 全部组员备份
    var allMembers = [];//切换组员、公司成员用  全部成员备份
    var originLeader = {};
    var getTeamMembers = function () {//获取小队成员
      Team.getMembers(INFO.team._id, function(err, team){
        originLeader = team.leaders[0];
        $scope.nowLeader = team.leaders[0];

        $scope.members = team.members;//前端
        teamMembersBackup = team.members;
        $scope.isShowTeam = true;
        if($scope.members.length === 0) {
          $scope.showCompanyMember();
        }
      });
    };
    getTeamMembers();

    $scope.cancelEditing = function() {//取消编辑->重置
      $scope.nowLeader = originLeader;
      $scope.formData.name = INFO.team.name;
      $scope.editing = false;
    };
    $scope.edit = function () {//上传队名及队长
      //if nowLeader._id!==originLeader._id -> upload
      if(window.analytics){
        window.analytics.trackEvent('Click', 'hrEditTeam');
      }
      if(!originLeader || $scope.nowLeader._id !== originLeader._id) {
        $scope.formData.leader = $scope.nowLeader;
      }
      //if success getTeamMembers();
      Team.edit(INFO.team._id, $scope.formData, function(err) {
        if(err) {
          $ionicPopup.alert({
            title: '编辑失败',
            template: err
          });
        }else{
          $ionicPopup.alert({
            title: '编辑成功'
          });
          getTeamMembers();
          $scope.editing = false;
        }
      });

    };
    $scope.point = function (person) {//指定某人为队长
      $scope.nowLeader = person;
    };
    $scope.showTeamMember = function () {//显示小队成员
      $scope.isShowTeam = true;
      $scope.members = teamMembersBackup;
    };

    var getAllMembers = false; //标记是否获取过公司成员
    $scope.showCompanyMember = function () {//显示公司成员
      if(!getAllMembers){//没获取过去拉一下
        User.getCompanyUsers(localStorage.id, function (err, data) {
          allMembers = data;
          $scope.members = allMembers;
          getAllMembers = true;
          // membersBackup = allMembers
        });
      }
      //获取过了就去把members置为allMembers
      else{
        $scope.members = allMembers;
        // membersBackup = allMembers;
      }
      $scope.isShowTeam =false;
    };

    $scope.change = function() {
      $scope.editing = true;
    };

    $scope.search = function(keyEvent) {
      if(window.analytics){
        window.analytics.trackEvent('Click', 'hrEditTeamSearchMember');
      }
      if($scope.memberName.value && (!keyEvent || keyEvent.which === 13)) {
        var membersBackup = $scope.isShowTeam ? teamMembersBackup : allMembers ;
        var length = membersBackup.length;
        var find = false;
        $scope.members = [];
        for(var i=0; i<length; i++) {
          if(membersBackup[i].nickname.indexOf($scope.memberName.value) > -1){
            $scope.members.push(membersBackup[i]);
            find = true;
          }
        }
        if(!find){
          $scope.message = "未找到该成员";
        }else{
          $scope.message = '';
        }
        $scope.memberName.value = '';
      }
    };

  }])
  .controller('FeedbackController', ['$scope', '$rootScope', '$ionicPopup', 'User', function ($scope, $rootScope, $ionicPopup, User) {
    $scope.opinion = {};
    $scope.feedback = function () {
      $rootScope.showLoading();
      if(window.analytics){
        window.analytics.trackEvent('Click', 'feedBack');
      }
      User.feedback($scope.opinion.content, function(msg) {
        if(msg){
          $ionicPopup.alert({title:'发送错误',template:'发送错误请重试。'});
        }else{
          $ionicPopup.alert({title:'发送成功',template:'感谢您的反馈。'});
          $scope.opinion.content = '';

        }
        $rootScope.hideLoading();
      });
    };
  }])
  .controller('TeamController', ['$ionicHistory', '$rootScope', '$scope', '$state', '$stateParams', '$ionicPopup', '$window', 'Team', 'Campaign', 'Tools', 'INFO', '$ionicSlideBoxDelegate', 'User', function ($ionicHistory, $rootScope, $scope, $state, $stateParams, $ionicPopup, $window, Team, Campaign, Tools, INFO, $ionicSlideBoxDelegate, User) {
    var teamId = $stateParams.teamId;
    $scope.goBack = function() {
      if($ionicHistory.backView()){
        $ionicHistory.goBack();
      }
    };
    $scope.pswpId = 'team' + Date.now();
    $scope.pswpPhotoAlbum = {};

    $scope.familyMinHeight = {
      height: (INFO.screenWidth * 190 / 320) + 'px'
    };

    // 已登录的用户获取自己的信息不是异步过程
    User.getData(localStorage.id, function (err, user) {
      $scope.user = user;
    });

    $scope.$on('$ionicView.enter', function(scopes, states) {
      // 为true或undefined时获取小队数据
      if (INFO.hasModifiedTeam !== false) {
        Team.getData(teamId, function (err, team) {
          INFO.hasModifiedTeam = true;
          if (err) {
            // todo
            console.log(err);
          } else {
            $scope.team = team;
            if ($scope.team.cid !== $scope.user.company._id) {
              $scope.team.isOtherCompanyTeam = true;
            }
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
      }
    });

    $scope.updatePersonalTeam = function (tid) {
      Team.updatePersonalTeam(tid, function (err, data) {
        if (!err) {
          $ionicPopup.alert({
            title: '提示',
            template: data.msg
          });
          $scope.team.level = data.level;
        }
        else {
          $ionicPopup.alert({
            title: '错误',
            template: err
          });
        }
      });
    };
    $scope.joinTeam = function (tid) {
      if(window.analytics){
        window.analytics.trackEvent('Click', 'joinTeamInTeamDetail');
      }
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
      if(window.analytics){
        window.analytics.trackEvent('Click', 'quitTeamInTeamDetail');
      }
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
          sortBy: '-start_time -_id',
          limit: pageSize + 1
        };
        $scope.getCampaigns(options);
      } else {
        if ($scope.lastCount >= pageSize) {
          $scope.loading = true;
          var startTime = new Date(nextCampaign.start_time);
          var nextPageStartId = nextCampaign._id;
          options = {
            requestType: 'team',
            requestId: teamId,
            populate: 'photo_album',
            sortBy: '-start_time -_id',
            limit: pageSize + 1,
            to: startTime.valueOf(),
            nextPageStartId: nextPageStartId
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
  .controller('TeamEditController', ['$scope', '$ionicModal', '$ionicPopup', '$ionicHistory', '$stateParams', 'Team', 'CONFIG', 'INFO', 'Upload',
    function ($scope, $ionicModal, $ionicPopup, $ionicHistory, $stateParams, Team, CONFIG, INFO, Upload) {
    $scope.STATIC_URL = CONFIG.STATIC_URL;
    $scope.team = Team.getCurrentTeam();

    $scope.formData = {
      name: $scope.team.name,
      brief: $scope.team.brief || ''
    };
    var copyLoc = function (loc) {
      var resLoc = {};
      if (loc) {
        resLoc.coordinates = [
          loc.coordinates[0],
          loc.coordinates[1]
        ];
        resLoc.type = 'Point';
      }
      return resLoc;
    };
    var setFormDataHomeCourts = function () {
      if (!$scope.team.homeCourts || $scope.team.homeCourts.length === 0) {
        $scope.formData.homeCourts = [
          {
            name: ''
          },
          {
            name: ''
          }
        ];
      } else if ($scope.team.homeCourts.length === 1) {
        $scope.formData.homeCourts = [
          {
            name: $scope.team.homeCourts[0]? $scope.team.homeCourts[0].name: '',
            loc: copyLoc($scope.team.homeCourts[0]? $scope.team.homeCourts[0].loc: null)
          },
          {
            name: ''
          }
        ];
      } else if ($scope.team.homeCourts.length >= 2) {
        $scope.formData.homeCourts = [
          {
            name: $scope.team.homeCourts[0] ? $scope.team.homeCourts[0].name: '',
            loc: copyLoc($scope.team.homeCourts[0]? $scope.team.homeCourts[0].loc: null)
          },
          {
            name: $scope.team.homeCourts[1] ? $scope.team.homeCourts[1].name: '',
            loc: copyLoc($scope.team.homeCourts[1]? $scope.team.homeCourts[1].loc: null)
          }
        ];
      }
    };
    setFormDataHomeCourts();

    var updateFormData = function () {
      $scope.formData = {
        name: $scope.team.name,
        brief: $scope.team.brief || ''
      };
      setFormDataHomeCourts();
    };

    var refreshTeamData = function (callback) {
      Team.getData($scope.team._id, function (err, team) {
        if (err) {
          console.log(err);
        } else {
          $scope.team = team;
          callback && callback(team);
        }
      });
    };

    $scope.editing = false;

    $scope.toEditing = function () {
      if ($scope.editing === false) {
        updateFormData();
        $scope.editing = true;
      }
    };

    $scope.cancelEditing = function () {
      if ($scope.editing === true) {
        updateFormData();
        $scope.editing = false;
      }
    };

    $scope.changed = false;
    $scope.change = function() {
      $scope.changed = true;
    };

    $scope.edit = function () {
      if (!$scope.changed) {
        $scope.editing = false;
        return;
      }
      if(window.analytics){
        window.analytics.trackEvent('Click', 'leaderEditTeam');
      }
      $scope.editingLock = true;
      Team.edit($scope.team._id, $scope.formData, function (err) {
        if (err) {
          $ionicPopup.alert({
            title: '编辑失败',
            template: err
          });
        } else {
          INFO.hasModifiedTeam = true;
          refreshTeamData(function (team) {
            updateFormData();
            $scope.editingLock = false;
          });
          $scope.editing = false;
        }
      });
    };

    //上传
    $scope.showUploadActionSheet = function () {
      Upload.getPicture(true, function (err, imageURI) {//取图
        if(!err) {
          var addr = CONFIG.BASE_URL + '/teams/' + $scope.team._id;
          Upload.upload('logo', addr, {imageURI:imageURI}, function(err) {//上传
            if(window.analytics){
              window.analytics.trackEvent('Click', 'leaderEditTeamLogo');
            }
            if(!err){
              var successAlert = $ionicPopup.alert({
                title: '提示',
                template: '修改logo成功'
              });
              refreshTeamData();
            } else {
              $ionicPopup.alert({
                title: '提示',
                template: '修改失败，请重试'
              });
            }
          });
        }
      });
    };
  }])

  .controller('PhotoAlbumListController', ['$scope', '$stateParams', 'PhotoAlbum', 'Team', 'INFO',
    function ($scope, $stateParams, PhotoAlbum, Team, INFO) {
      $scope.teamId = $stateParams.teamId;
      var getFamily = function() {
        Team.getFamilyPhotos($scope.teamId, function (err, photos) {
          if (err) {
            // todo
            console.log(err);
          } else {
            $scope.familyPhotoLength = photos.length;
            $scope.familyPhotos = photos.reverse().slice(0, 8);
          }
        });
      };
      getFamily();

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
            $scope.photoAlbums=[];
            $scope.lastCount = photoAlbums.length;
            $scope.firstLoad = false;
            $scope.loading = false;
            $scope.photoAlbums = $scope.photoAlbums.concat(photoAlbums);
            $scope.$broadcast('scroll.infiniteScrollComplete');
          }
        });
      };

      $scope.refresh = function () {
        $scope.loading = true;
        var options = {
          ownerType: 'team',
          ownerId: $scope.teamId
        };
        $scope.getPhotoAlbums(options);
        getFamily();
        $scope.$broadcast('scroll.refreshComplete');
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

  }])
  .controller('PhotoAlbumDetailController', ['$ionicHistory', '$scope', '$state', '$stateParams', '$ionicPopup', '$ionicModal', '$ionicLoading', 'PhotoAlbum', 'Tools', 'INFO', 'CONFIG', 'Upload',
    function ($ionicHistory, $scope, $state, $stateParams, $ionicPopup, $ionicModal, $ionicLoading, PhotoAlbum, Tools, INFO, CONFIG, Upload) {
      $scope.screenWidth = INFO.screenWidth;
      $scope.screenHeight = INFO.screenHeight;

      var isCampaignPhotoAlbum = false;
      $scope.goBack = function() {
        if($ionicHistory.backView()) {
          $ionicHistory.goBack();
        }
        else{
          $state.go('app.campaigns');
        }
      }
      PhotoAlbum.getData($stateParams.photoAlbumId, function (err, photoAlbum) {
        if (err) {
          // todo
          console.log(err);
        } else {
          $scope.photoAlbum = photoAlbum;
          if (photoAlbum.owner && photoAlbum.owner.model.type === 'Campaign') {
            isCampaignPhotoAlbum = true;
          }
        }
      });

      var pushToScopePhotos = function (photo) {
        var resPhoto = {
          _id: photo._id,
          src: CONFIG.STATIC_URL + photo.uri,
          w: photo.width || $scope.screenWidth,
          h: photo.height || $scope.screenHeight
        };
        if (photo.uploadUser && photo.uploadDate) {
          resPhoto.title = '上传者: ' + photo.uploadUser.name + '  上传时间: ' + moment(photo.uploadDate).format('YYYY-MM-DD HH:mm');
        }
        $scope.photos.push(resPhoto);
      }

      /**
       * 将照片按日期分组，要求照片是按上传日期排序，上传日期距离现在越近，排在最前面
       * @param {Array} photos 照片数组
       */
      var groupByDate = function (photos) {
        var resData = [];
        photos.forEach(function (photo) {
          var lastGroup = resData[resData.length - 1];
          if (lastGroup && Tools.isTheSameDay(lastGroup.date, photo.uploadDate)) {
            lastGroup.photos.push(photo);
          } else {
            resData.push({
              date: new Date(photo.uploadDate),
              photos: [photo]
            });
          }
        });
        return resData;
      };

      var getPhotos = function () {
        PhotoAlbum.getPhotos($stateParams.photoAlbumId, function (err, photos) {
          if (err) {
            // todo
            console.log(err);
          } else {
            $scope.photos = [];
            photos.forEach(pushToScopePhotos);
            $scope.photoGroups = groupByDate(photos);
          }
        });
      };
      getPhotos();

      $scope.pswpId = 'photoAlbum' + Date.now();

      // 上传照片
      $scope.showUploadActionSheet = function () {
        Upload.getPicture(false, function(err, imageURI) {//取图
          if(!err) {
            $scope.previewImg = imageURI;
            $scope.confirmUploadModal.show();
          }
        })
      };

      $ionicModal.fromTemplateUrl('confirm-upload-modal.html', {
        scope: $scope,
        animation: 'slide-in-up'
      }).then(function(modal) {
        $scope.confirmUploadModal = modal;
      });
      $scope.cancelUpload = function() {
        $scope.confirmUploadModal.hide();
      };

      $scope.$on('$destroy',function() {
        $scope.confirmUploadModal.remove();
      });

      $scope.confirmUpload = function () {
        if(window.analytics){
          window.analytics.trackEvent('Click', 'uploadPictureInPhotoAlbumDetail');
        }
        var addr = CONFIG.BASE_URL + '/photo_albums/' + $scope.photoAlbum._id + '/photos'
        var randomId = Math.floor(Math.random()*100);
        var data = {randomId: randomId, imageURI:$scope.previewImg};
        Upload.upload('photoAlbum', addr, data, function(err) {
          if(!err) {
            var successAlert = $ionicPopup.alert({
              title: '提示',
              template: '上传照片成功'
            });
            successAlert.then(function () {
              $scope.confirmUploadModal.hide();
              getPhotos();
            });
          } else {
            $ionicPopup.alert({
              title: '提示',
              template: '上传失败，请重试'
            });
          }
        });
      };
  }])
  .controller('FamilyPhotoController', ['$ionicHistory', '$rootScope', '$scope', '$stateParams', '$ionicPopup', '$ionicModal', '$ionicLoading', 'INFO', 'Team', 'CONFIG', 'Tools', 'Upload',
    function ($ionicHistory, $rootScope, $scope, $stateParams, $ionicPopup, $ionicModal, $ionicLoading, INFO, Team, CONFIG, Tools, Upload) {
      $scope.screenWidth = INFO.screenWidth;
      $scope.screenHeight = INFO.screenHeight;
      $scope.team = Team.getCurrentTeam();
      var getFamilyPhotos = function () {
        Team.getFamilyPhotos($scope.team._id, function (err, photos) {
          if (err) {
            // todo
            console.log(err);
          } else {
            $scope.familyPhotos = photos;
            //photo
            $scope.photos = [];
            photos.forEach(function (photo) {
              $scope.photos.push({
                _id: photo._id,
                src: CONFIG.STATIC_URL + photo.uri + '/320/190',
                w: 320,
                h: 190
              });
            });
          }
        });
      };
      getFamilyPhotos();
      $scope.goBack = function() {
        if($ionicHistory.backView()){
          $ionicHistory.goBack();
        }
      };
      //for pswp
      $scope.pswpId = 'fa' + Date.now();
      $scope.pswpPhotoAlbum = {};

      $scope.toggleSelect = function (index) {
        if (!$scope.team.isLeader) {
          return;
        }

        var deleteConfirm = $ionicPopup.confirm({
          title: '提示',
          template: '确定要从封面中移除这张照片吗？',
          okText: '确定',
          cancelText: '取消'
        });
        deleteConfirm.then(function (res) {
          if (res) {
            if(window.analytics){
              window.analytics.trackEvent('Click', 'toggleSelectFamilyPhoto');
            }
            var familyPhoto = $scope.familyPhotos[index];
            Team.toggleSelectFamilyPhoto($scope.team._id, familyPhoto._id, function (err) {
              if (err) {
                // todo
                console.log(err);
              } else {
                $scope.familyPhotos.splice(index, 1);
              }
            });
          }
        });
      };

      $scope.editing = false;
      $scope.toggleEdit = function () {
        $scope.editing = !$scope.editing;
      };

      // 上传全家福
      $scope.showUploadActionSheet = function () {
        Upload.getPicture(false, function (err, imageURI) {
          if(!err){
            $scope.previewImg = imageURI;
            $scope.confirmUploadModal.show();
          }
        })
      };

      $ionicModal.fromTemplateUrl('confirm-upload-modal.html', {
        scope: $scope,
        animation: 'slide-in-up'
      }).then(function(modal) {
        $scope.confirmUploadModal = modal;
      });
      $scope.cancelUpload = function() {
        $scope.confirmUploadModal.hide();
      };

      $scope.$on('$destroy',function() {
        $scope.confirmUploadModal.remove();
      });

      $scope.confirmUpload = function () {
        if(window.analytics){
          window.analytics.trackEvent('Click', 'uploadFamilyPhoto');
        }
        var addr = CONFIG.BASE_URL + '/teams/' + $scope.team._id + '/family_photos';
        Upload.upload('family', addr, {imageURI:$scope.previewImg}, function(err) {
          if(!err) {
            var successAlert = $ionicPopup.alert({
              title: '提示',
              template: '上传照片成功'
            });
            successAlert.then(function () {
              $scope.confirmUploadModal.hide();
              getFamilyPhotos();
            });
          }else {
            $scope.confirmUploadModal.hide();
            $ionicPopup.alert({
              title: '提示',
              template: '上传失败，请重试'
            });
          }
        });
      };

  }])
  .controller('MemberController', ['$ionicHistory', '$scope', '$stateParams', 'INFO', 'Team', function($ionicHistory, $scope, $stateParams, INFO, Team) {
    if($stateParams.memberType=='team') {
      var currentTeam = Team.getCurrentTeam();

      Team.getMembers($stateParams.id, function (err, data) {
        if (err) {
          // todo
          console.log(err);
        } else {
          var leaders = data.leaders;
          var members = data.members;
          members.forEach(function (member) {
            for (var i = 0; i < leaders.length; i++) {
              if (member._id === leaders[i]._id) {
                member.isLeader = true;
                break;
              }
            }
          });
          members.sort(function (a, b) {
            if (a.isLeader && !b.isLeader) {
              return false;
            } else {
              return true;
            }
          });
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
    $scope.goBack = function() {
      if($ionicHistory.backView()){
        $ionicHistory.goBack()
      }
    }
  }])
  .controller('TimelineController', ['$scope', '$stateParams', '$timeout', 'TimeLine', 'User', function ($scope, $stateParams, $timeout, TimeLine, User) {
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
    $scope.doRefresh = function(){
      $scope.page = 0;
      $scope.loadFinished = false;
      TimeLine.getTimelines('user', '0', $scope.page, function (err, timelineData) {
        if (err) {
          // todo
          console.log(err);
          $scope.loadFinished = true;
        } else {
          if(timelineData.length>0) {
            $scope.timelinesRecord = timelineData;
          }
          else {
            $scope.loadFinished = true;
          }
        }
        $scope.$broadcast('scroll.refreshComplete');
      });
    }
    $scope.loadMore = function() {
      if($scope.loading){
        $scope.$broadcast('scroll.infiniteScrollComplete');
      }
      else{
        $scope.page++;
        $scope.loading = true;
        TimeLine.getTimelines('user', '0', $scope.page, function (err, timelineData) {
          if (err) {
            // todo
            console.log(err);
            $scope.loadFinished = true;
          } else {
            if(timelineData.length>0) {
              $scope.timelinesRecord = $scope.timelinesRecord.concat(timelineData);
            }
            else {
              $scope.loadFinished = true;
            }
          }
          $timeout(function() {
            $scope.loading = false;
          },1000);
          $scope.$broadcast('scroll.infiniteScrollComplete');
        });
      }
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
  .controller('UserInfoController', ['$ionicHistory', '$scope', '$rootScope', '$state', '$stateParams', '$ionicPopover', 'Tools', 'User', 'CONFIG', 'INFO', function ($ionicHistory, $scope, $rootScope, $state, $stateParams, $ionicPopover, Tools, User, CONFIG, INFO) {

    $ionicPopover.fromTemplateUrl('more-popover.html', {
        scope: $scope,
      }).then(function(popover) {
        $scope.popover = popover;
      });
    $scope.goBack = function() {
      if($ionicHistory.backView()){
        $ionicHistory.goBack()
      }
    }
    $scope.showPopover = function($event){
      $scope.popover.show($event);
    }
    $scope.showReportForm = function() {
      $state.go('report_form',{userId: $scope.user._id});
      $scope.popover.hide();
    }

    User.getData($stateParams.userId, function (err, data) {
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

    $scope.pswpId = 'personal' + Date.now();

  }])
  .controller('UserInfoTimelineController', ['$ionicHistory', '$scope', '$stateParams', '$timeout','User', 'TimeLine', function ($ionicHistory, $scope, $stateParams, $timeout, User, TimeLine) {
    $scope.loadFinished = false;
    $scope.loading = false;
    $scope.timelinesRecord =[];
    $scope.page = 0;

    User.getData($stateParams.userId, function (err, data) {
      if (err) {
        // todo
        console.log(err);
      } else {
        $scope.user = data;
      }
    });
    $scope.goBack = function() {
      if($ionicHistory.backView()){
        $ionicHistory.goBack()
      }
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
    $scope.doRefresh = function(){
      $scope.page = 0;
      $scope.loadFinished = false;
      TimeLine.getTimelines('user', $stateParams.userId, $scope.page, function (err, timelineData) {
        if (err) {
          // todo
          console.log(err);
          $scope.loadFinished = true;
        } else {
          if(timelineData.length>0) {
            $scope.timelinesRecord = timelineData;
          }
          else {
            $scope.loadFinished = true;
          }
        }
        $scope.$broadcast('scroll.refreshComplete');
      });
    }
    $scope.loadMore = function() {
      if($scope.loading){
        $scope.$broadcast('scroll.infiniteScrollComplete');
      }
      else{
        $scope.page++;
        $scope.loading = true;
        TimeLine.getTimelines('user', $stateParams.userId, $scope.page, function (err, timelineData) {
          if (err) {
            // todo
            console.log(err);
            $scope.loadFinished = true;
          } else {
            if(timelineData.length>0) {
              $scope.timelinesRecord = $scope.timelinesRecord.concat(timelineData);
            }
            else {
              $scope.loadFinished = true;
            }
          }
          $timeout(function(){
            $scope.loading = false;
          },1000);
          $scope.$broadcast('scroll.infiniteScrollComplete');
        });
      }
    };
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
  .controller('ReportController', ['$ionicHistory', '$scope', '$stateParams', '$ionicPopup', 'Report', function ($ionicHistory, $scope, $stateParams, $ionicPopup, Report) {
    $scope.goBack = function() {
      if($ionicHistory.backView()){
        $ionicHistory.goBack()
      }
    }
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
        if(window.analytics){
          window.analytics.trackEvent('Click', 'report');
        }
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
  .controller('CampaignEditController', ['$ionicHistory', '$scope', '$state', '$ionicPopup', 'Campaign', function ($ionicHistory, $scope, $state, $ionicPopup, Campaign) {
    $scope.isBusy = false;
    $scope.campaignData ={};
    var deadLineInput = document.getElementById('deadline');
    var localizeDateStr = function(date_to_convert_str) {
      var date_to_convert = new Date(date_to_convert_str);
      var local_date = new Date();
      date_to_convert.setMinutes(date_to_convert.getMinutes()+local_date.getTimezoneOffset());
      return date_to_convert;
    }
    Campaign.get($state.params.id, function(err, data){
      if(!err){
        if(data.deadline){
          $scope.campaignData.deadline = new Date(data.deadline);
          $scope.campaignData.end_time = new Date(data.end_time);
        }
        if(data.content){
          $scope.campaignData.content = data.content;
        }
        if(data.member_min){
          $scope.campaignData.member_min = data.member_min;
        }
        if(data.member_max){
          $scope.campaignData.member_max = data.member_max;
        }
      }
    });
    $scope.goBack = function() {
      if($ionicHistory.backView()){
        $ionicHistory.goBack()
      }
      else {
        $state.go('campaigns_detail',{id:$state.params.id});
      }
    }
    $scope.editCampaign = function() {
      if($scope.isBusy) {

      }
      else {
        if(window.analytics){
          window.analytics.trackEvent('Click', 'editCampaign');
        }
        $scope.campaignData.deadline = $scope.campaignData.deadline;
        if($scope.campaignData.member_min > $scope.campaignData.member_max) {
          $ionicPopup.alert({
            title: '错误',
            template: '人数下限不能大于上限，请重新填写'
          });
        }
        else if($scope.campaignData.deadline > $scope.campaignData.end_time ) {
          $ionicPopup.alert({
            title: '错误',
            template: '报名截止时间不能晚于结束时间'+$scope.campaignData.end_time
          });
        }
        else if($scope.campaignData.deadline < new Date()) {
          $ionicPopup.alert({
            title: '错误',
            template: '报名截止时间不能比现在更早'
          });
        }
        else {
          $scope.isBusy = true;
          Campaign.edit($state.params.id, $scope.campaignData, function (err, data) {
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
                template:'修改成功'
              });
              $state.go('campaigns_detail',{id:$state.params.id});
            }
            $scope.isBusy = false;
          });
        }
      }
    }
    $scope.closeCampaign = function() {
      var confirmPopup = $ionicPopup.confirm({
        title: '确认',
        template: '关闭后将无法再次打开，您确认要关闭该活动吗?',
        cancelText: '取消',
        okText: '确认'
      });
      confirmPopup.then(function(res) {
        if(res) {
          if(window.analytics){
            window.analytics.trackEvent('Click', 'closeCampaign');
          }
          Campaign.close($state.params.id,function(err,data) {
            if(!err){
              $ionicPopup.alert({
                title: '提示',
                template: '关闭成功'
              });
              $state.go('campaigns_detail',{id:$state.params.id});
            }
            else {
              $ionicPopup.alert({
                title: '错误',
                template: err
              });
            }
          });
        }
      });
    }
  }])
  .controller('DiscoverController', ['$scope', '$state', '$ionicSlideBoxDelegate', 'Team', 'Rank', 'INFO',function ($scope, $state, $ionicSlideBoxDelegate, Team, Rank, INFO) {
    $scope.getMyTeams = function(refreshFlag) {
      Team.getList('user', localStorage.id, null, function (err, teams) {
        if (err) {
          // todo
          console.log(err);
        } else {
          $scope.teams = teams;
          $scope.nowTeamIndex =0;
          INFO.myTeams = teams;
          $ionicSlideBoxDelegate.update();
          refreshFlag && $scope.$broadcast('scroll.refreshComplete');
        }
      });
    };
    var getTeamRank = function () {
      if($scope.selectTeam.rankTeams) return;
      Rank.getTeamRank($scope.selectTeam._id,function (err,rankTeams) {
        if (err) {
          // todo
          console.log(err);
        } else {
          $scope.selectTeam.rankTeams = rankTeams;
        }
      });
    }
    $scope.$watch('nowTeamIndex',function (newVal) {
      if(newVal!=undefined && $scope.teams.length>newVal) {
        $scope.selectTeam = $scope.teams[newVal];
        getTeamRank();
      }
    })
    $scope.changeSelectTeam = function (flag) {
      $scope.nowTeamIndex = $scope.nowTeamIndex +flag;
    }
    $scope.getMyTeams();
  }])
  .controller('RankSelectController', ['$scope', '$state', 'Team', 'Rank', function ($scope, $state, Team, Rank) {
    var getTeamType = function () {
      Team.getGroups(function (err,groups) {
        if (err) {
          // todo
          console.log(err);
        } else {
          $scope.groups = groups;
        }
      });
    }
    getTeamType();
  }])
  .controller('RankDetailController', ['$scope', '$state', 'Rank', function ($scope, $state, Rank) {
    $scope.getRank = function (refreshFlag) {
      var data = {
        gid: $state.params.gid,
        province: localStorage.province || '上海市',
        city: localStorage.city || '上海市'
      }
      Rank.getRank(data,function (err,data) {
        if (err) {
          // todo
          console.log(err);
        } else {
          $scope.rank = data.rank;
          $scope.noRankTeams = [];
          if(data.team) {
            data.team.forEach(function(_team, index){

              if(_team.rank>10 || _team.rank==0) {
                $scope.noRankTeams.push(_team);
              }
              else{
                $scope.rank.team[_team.rank-1].belong=true;
              }

            });
          }
        }
        refreshFlag && $scope.$broadcast('scroll.refreshComplete');
      });
    }
    $scope.getRank();
  }])
  .controller('CircleSendController', ['$ionicHistory', '$scope', '$state', '$stateParams', '$ionicPopup', 'Circle', function($ionicHistory, $scope, $state, $stateParams, $ionicPopup, Circle) {
    $scope.circle = {
      content: ''
    };
    $scope.campaignId = $stateParams.campaignId;
    $scope.unshow = true;
    $scope.goBack = function() {
      if ($ionicHistory.backView()) {
        $ionicHistory.goBack()
      } else {
        $state.go('app.campaigns');
      }
    }
    $scope.change = function() {
      if (!$scope.circle.content) {
        $scope.unshow = true;
      } else {
        $scope.unshow = false;
      }
      var element = document.getElementById('circle_content');
      element.style.height = 'auto';
      element.style.height = element.scrollHeight + "px";
    }
    $scope.circle_send_content = function() {
      Circle.postCircleContent($scope.campaignId, $scope.circle.content, function(err, data) {
        if (!err) {
          console.log(data);
          $state.go('circle_company');
        } else {
          console.log('error');
        }
      })
    }
  }])
  .controller('CircleCompanyController', [
    '$ionicHistory',
    '$scope',
    '$rootScope',
    '$state',
    '$stateParams',
    '$ionicPopup',
    '$timeout',
    'Circle',
    'User',
    'INFO',
    'Tools',
    'CONFIG',
    'Image',
    function($ionicHistory, $scope, $rootScope, $state, $stateParams, $ionicPopup, $timeout, Circle, User, INFO, Tools, CONFIG, Image) {
      User.getData(localStorage.id, function(err, data) {
        if (err) {
          // todo
          console.log(err);
        } else {
          $scope.user = data;
        }
      });

      $scope.ionicAlert = function(msg) {
        $ionicPopup.alert({
          title: '提示',
          template: msg
        });
      };

      // 初始化提醒列表
      if (!$rootScope.remindList) {
        $rootScope.remindList = [];
      }

      var hasInit = false;

      // 用于保存已经获取到的同事圈内容
      $scope.circleContentList = [];

      $scope.$on("$ionicView.enter", function(scopes, states) {
        var clearRedSpot = function() {
          $rootScope.newContent = null;
        };

        $scope.goToRemindsPage = function() {
          $state.go('circle_reminds');
        };

        $scope.goBack = function() {
          if ($ionicHistory.backView()) {
            $ionicHistory.goBack();
          } else {
            $state.go('app.company');
          }
        };

        $scope.getData = function(callback) {
          // 先获取一次
          Circle.getCompanyCircle()
            .success(function(data) {
              localStorage.lastGetCircleTime = new Date();
              data.forEach(function(circle) {
                Circle.pickAppreciateAndComments(circle);
              });
              $scope.circleContentList = data;
              $scope.loadingStatus.hasInit = true;
              if (data.length >= pageLength) {
                $scope.loadingStatus.hasMore = true;
              } else {
                $scope.loadingStatus.hasMore = false;
              }
              copyPhotosToPswp();
              if (callback) {
                callback();
              }
            })
            .error(function(data, status) {
              if (status !== 404) {
                $scope.ionicAlert(data.msg || '获取失败');
              }
            });
        };

        if (!hasInit) {
          $scope.getData(function() {
            hasInit = true;
          });
        } else {
          if ($rootScope.newCircleComment > 0 || $rootScope.newContent === true) {
            $scope.getData();
          }
        }
        clearRedSpot();

        $scope.loadingStatus = {
          hasInit: false, // 是否已经获取了一次内容
          hasMore: false, // 是否还有更多内容，决定infinite-scroll是否在存在
          loading: false // 是否正在加载更多，如果是，则会保护防止连续请求
        };

        var pageLength = 20; // 一次获取的数据量

        // 复制图片地址到一个数组供预览大图用
        var copyPhotosToPswp = function() {
          $scope.imagesForPswp = [];
          var id = 0;
          for (var i = 0, circlesLen = $scope.circleContentList.length; i < circlesLen; i++) {
            var circle = $scope.circleContentList[i];
            if (circle.content.photos && circle.content.photos.length > 0) {
              var pswpPhotos = [];
              for (var j = 0, photosLen = circle.content.photos.length; j < photosLen; j++) {
                var photo = circle.content.photos[j];
                photo._id = id;
                var size = Image.getFitSize(photo.width, photo.height);
                pswpPhotos.push({
                  _id: photo._id,
                  w: size.width * 2,
                  h: size.height * 2,
                  src: CONFIG.STATIC_URL + photo.uri + '/' + size.width * 2 + '/' + size.height * 2
                });
                id++;
              }
              $scope.imagesForPswp = $scope.imagesForPswp.concat(pswpPhotos);
            }
          }
        };


        $scope.refresh = function() {
          var latestContentDate = $scope.circleContentList[0].content.post_date;
          Circle.getCompanyCircle(latestContentDate, null)
            .success(function(data, status) {
              localStorage.lastGetCircleTime = new Date();
              if (data.length) {
                data.forEach(function(circle) {
                  Circle.pickAppreciateAndComments(circle);
                });
                $scope.circleContentList = (data || []).concat($scope.circleContentList);
              }
              copyPhotosToPswp();
              $scope.$broadcast('scroll.refreshComplete');
            })
            .error(function(data, status) {
              if (status !== 404) {
                $scope.ionicAlert(data.msg || '获取失败');
              }
              $scope.$broadcast('scroll.refreshComplete');
            });
        };

        $scope.loadMore = function() {
          if (!$scope.loadingStatus.hasMore || $scope.loadingStatus.loading || !$scope.loadingStatus.hasInit) {
            return; // 如果没有更多内容或已经正在加载或是还没有获取过一次数据，则返回，防止连续的请求
          }
          $scope.loadingStatus.loading = true;
          var pos = $scope.circleContentList.length - 1;
          var lastContentDate = $scope.circleContentList[pos].content.post_date;
          Circle.getCompanyCircle(null, lastContentDate)
            .success(function(data) {
              if (data.length) {
                data.forEach(function(circle) {
                  Circle.pickAppreciateAndComments(circle);
                });
                $scope.circleContentList = $scope.circleContentList.concat(data);
                $scope.loadingStatus.loading = false;
                copyPhotosToPswp();
              }

              $scope.$broadcast('scroll.infiniteScrollComplete');
            })
            .error(function(data, status) {
              if (status !== 404) {
                $scope.ionicAlert(data.msg || '获取失败');
              } else {
                $scope.loadingStatus.hasMore = false;
              }
              $scope.loadingStatus.loading = false;
              $scope.$broadcast('scroll.infiniteScrollComplete');
            });
        };


        $scope.circleCardListCtrl = {};
        $scope.circleCommentBoxCtrl = {};
        $scope.pswpCtrl = {};

        $scope.openCommentBox = function(placeHolderText) {
          $scope.circleCommentBoxCtrl.setPlaceHolderText(placeHolderText);
          $scope.circleCommentBoxCtrl.open();
        };

        $scope.postComment = function(content) {
          $scope.circleCardListCtrl.postComment(content);
        };

        $scope.stopComment = function() {
          $scope.circleCardListCtrl.stopComment();
        };

        $scope.onClickContentImg = function(img) {
          for (var i = 0, imagesLen = $scope.imagesForPswp.length; i < imagesLen; i++) {
            if (img._id === $scope.imagesForPswp[i]._id) {
              $scope.pswpCtrl.open(i);
              break;
            }
          }
        };

      });


    }
  ])
  .controller('CircleUserController', [
    '$ionicHistory',
    '$scope',
    '$rootScope',
    '$state',
    '$stateParams',
    '$ionicPopup',
    '$timeout',
    'Circle',
    'User',
    'INFO',
    'Tools',
    'CONFIG',
    'Image',
    function($ionicHistory, $scope, $rootScope, $state, $stateParams, $ionicPopup, $timeout, Circle, User, INFO, Tools, CONFIG, Image) {
      $scope.goBack = function() {
        if ($ionicHistory.backView()) {
          $ionicHistory.goBack();
        } else {
          $state.go('app.personal');
        }
      };

      $scope.ionicAlert = function(msg) {
        $ionicPopup.alert({
          title: '提示',
          template: msg
        });
      };


      $scope.$on("$ionicView.enter", function(scopes, states) {
        // 用于保存已经获取到的同事圈内容
        $scope.circleContentList = [];

        User.getData($state.params.userId, function(err, data) {
          if (err) {
            // todo
            console.log(err);
          } else {
            $scope.user = data;
          }
        });

        Circle.getUserCircle($state.params.userId)
          .success(function(data) {
            localStorage.lastGetCircleTime = new Date();
            data.forEach(function(circle) {
              Circle.pickAppreciateAndComments(circle);
            });
            $scope.circleContentList = data;
            $scope.loadingStatus.hasInit = true;
            if (data.length >= pageLength) {
              $scope.loadingStatus.hasMore = true;
            } else {
              $scope.loadingStatus.hasMore = false;
            }
            copyPhotosToPswp();
          })
          .error(function(data, status) {
            if (status !== 404) {
              $scope.ionicAlert(data.msg || '获取失败');
            }
          });

        $scope.loadingStatus = {
          hasInit: false, // 是否已经获取了一次内容
          hasMore: false, // 是否还有更多内容，决定infinite-scroll是否在存在
          loading: false // 是否正在加载更多，如果是，则会保护防止连续请求
        };

        var pageLength = 20; // 一次获取的数据量

        // 复制图片地址到一个数组供预览大图用
        var copyPhotosToPswp = function() {
          $scope.imagesForPswp = [];
          var id = 0;
          for (var i = 0, circlesLen = $scope.circleContentList.length; i < circlesLen; i++) {
            var circle = $scope.circleContentList[i];
            if (circle.content.photos && circle.content.photos.length > 0) {
              var pswpPhotos = [];
              for (var j = 0, photosLen = circle.content.photos.length; j < photosLen; j++) {
                var photo = circle.content.photos[j];
                photo._id = id;
                var size = Image.getFitSize(photo.width, photo.height);
                pswpPhotos.push({
                  _id: photo._id,
                  w: size.width * 2,
                  h: size.height * 2,
                  src: CONFIG.STATIC_URL + photo.uri + '/' + size.width * 2 + '/' + size.height * 2
                });
                id++;
              }
              $scope.imagesForPswp = $scope.imagesForPswp.concat(pswpPhotos);
            }
          }
        };

        $scope.loadMore = function() {
          if (!$scope.loadingStatus.hasMore || $scope.loadingStatus.loading || !$scope.loadingStatus.hasInit) {
            return; // 如果没有更多内容或已经正在加载或是还没有获取过一次数据，则返回，防止连续的请求
          }
          $scope.loadingStatus.loading = true;
          var pos = $scope.circleContentList.length - 1;
          var lastContentDate = $scope.circleContentList[pos].content.post_date;
          Circle.getUserCircle($state.params.userId, {last_content_date: lastContentDate})
            .success(function(data) {
              if (data.length) {
                data.forEach(function(circle) {
                  Circle.pickAppreciateAndComments(circle);
                });
                $scope.circleContentList = $scope.circleContentList.concat(data);
                $scope.loadingStatus.loading = false;
                copyPhotosToPswp();
              }

              $scope.$broadcast('scroll.infiniteScrollComplete');
            })
            .error(function(data, status) {
              if (status !== 404) {
                $scope.ionicAlert(data.msg || '获取失败');
              } else {
                $scope.loadingStatus.hasMore = false;
              }
              $scope.loadingStatus.loading = false;
              $scope.$broadcast('scroll.infiniteScrollComplete');
            });
        };


        $scope.circleCardListCtrl = {};
        $scope.circleCommentBoxCtrl = {};
        $scope.pswpCtrl = {};

        $scope.openCommentBox = function(placeHolderText) {
          $scope.circleCommentBoxCtrl.setPlaceHolderText(placeHolderText);
          $scope.circleCommentBoxCtrl.open();
        };

        $scope.postComment = function(content) {
          $scope.circleCardListCtrl.postComment(content);
        };

        $scope.stopComment = function() {
          $scope.circleCardListCtrl.stopComment();
        };

        $scope.onClickContentImg = function(img) {
          for (var i = 0, imagesLen = $scope.imagesForPswp.length; i < imagesLen; i++) {
            if (img._id === $scope.imagesForPswp[i]._id) {
              $scope.pswpCtrl.open(i);
              break;
            }
          }
        };

      });


    }
  ])
  .controller('CircleContentDetailController', [
    '$scope',
    '$ionicHistory',
    '$state',
    '$ionicPopup',
    'Circle',
    'CONFIG',
    'User',
    'Image',
    function($scope, $ionicHistory, $state, $ionicPopup, Circle, CONFIG, User, Image) {
      $scope.goBack = function() {
        if ($ionicHistory.backView()) {
          $ionicHistory.goBack();
        } else {
          $state.go('circle_reminds');
        }
      };

      User.getData(localStorage.id, function(err, data) {
        if (err) {
          // todo
          console.log(err);
        } else {
          $scope.user = data;
        }
      });

      $scope.ionicAlert = function(msg) {
        $ionicPopup.alert({
          title: '提示',
          template: msg
        });
      };

      $scope.circleContentPswpId = 'circle_content_pswp_' + Date.now();

      $scope.$on("$ionicView.enter", function(scopes, states) {
        Circle.getCircleContent($state.params.circleContentId).success(function(data) {
          $scope.circle = data.circle;
          Circle.pickAppreciateAndComments($scope.circle);
          $scope.imagesForPswp = [];
          var id = 0;
          var circle = $scope.circle;
          if (circle.content.photos && circle.content.photos.length > 0) {
            var pswpPhotos = [];
            for (var i = 0, photosLen = circle.content.photos.length; i < photosLen; i++) {
              var photo = circle.content.photos[i];
              photo._id = id;
              var size = Image.getFitSize(photo.width, photo.height);
              pswpPhotos.push({
                _id: photo._id,
                w: size.width * 2,
                h: size.height * 2,
                src: CONFIG.STATIC_URL + photo.uri + '/' + size.width * 2 + '/' + size.height * 2
              });
              id++;
            }
            $scope.imagesForPswp = $scope.imagesForPswp.concat(pswpPhotos);
          }
        }).error(function(data) {
          $scope.ionicAlert(data.msg || '获取失败'); // TODO 还需要考虑妥善处理，很可能会出现这条内容被删除了
        });

        $scope.circleCardCtrl = {};
        $scope.circleCommentBoxCtrl = {};
        $scope.pswpCtrl = {};

        $scope.openCommentBox = function(placeHolderText) {
          $scope.circleCommentBoxCtrl.setPlaceHolderText(placeHolderText);
          $scope.circleCommentBoxCtrl.open();
        };

        $scope.postComment = function(content) {
          $scope.circleCardCtrl.postComment(content);
        };

        $scope.onDelete = function() {
          $state.go('circle_company');
        };

        $scope.onClickContentImg = function(img) {
          for (var i = 0, imagesLen = $scope.imagesForPswp.length; i < imagesLen; i++) {
            if (img._id === $scope.imagesForPswp[i]._id) {
              $scope.pswpCtrl.open(i);
              break;
            }
          }
        };

      });

    }
  ])
  .controller('CircleRemindsController', [
    '$scope',
    '$rootScope',
    '$ionicHistory',
    '$state',
    'Circle',
    function($scope, $rootScope, $ionicHistory, $state, Circle) {
      //每次进来以后获取新的reminds
      $scope.$on("$ionicView.enter", function(scopes, states) {
        $rootScope.newCircleComment = 0;
        getRemind();
      });

      var getRemind = function() {
        Circle.getRemindComments({
          last_comment_date: localStorage.lastGetCompanyCircleRemindTime
        }).success(function(data) {
          var newRemindList = data.slice();
          var removeIndexes = [];
          for (var i = 0, newRemindListLen = newRemindList.length; i < newRemindListLen; i++) {
            for (var j = 0, remindListLen = $scope.remindList.length; j < remindListLen; j++) {
              if (newRemindList[i].kind === 'appreciate' && newRemindList[i].poster._id === $scope.remindList[j].poster._id) {
                removeIndexes.push(i);
                break;
              }
            }
          }
          for(var i= removeIndexes.length-1; i>=0; i--) {
            newRemindList.splice(i,1);
          }

          $scope.remindList = newRemindList.concat($scope.remindList);
          localStorage.lastGetCompanyCircleRemindTime = Date.now();
        })
        .error(function(data) {
          console.log(data.msg || '获取提醒失败');
          // TODO: 这里即使失败了也不必提醒用户
        });
      };
    }
  ])
  .controller('CircleRemindsController', [
    '$scope',
    '$rootScope',
    '$ionicHistory',
    function($scope, $rootScope, $ionicHistory) {
      $scope.goBack = function() {
        if ($ionicHistory.backView()) {
          $ionicHistory.goBack();
        } else {
          $state.go('circle_company');
        }
      };

    }
  ])
  .controller('CircleUploaderController', [
    '$scope',
    '$ionicHistory',
    '$state',
    '$q',
    'Circle',
    '$cordovaFile',
    'CONFIG',
    'CommonHeaders',
    '$ionicLoading',
    '$ionicPopup',
    function ($scope, $ionicHistory, $state, $q, Circle, $cordovaFile, CONFIG, CommonHeaders, $ionicLoading, $ionicPopup) {
      $scope.goBack = function() {
        if($ionicHistory.backView()){
          $ionicHistory.goBack();
        }
        else {
          // 这里是不正常的返回，正常情况下都应该从history中返回，不会进入到这里。
          $state.go('app.campaigns');
        }
      };

      $scope.circleData = {
        content: ''
      };

      $scope.formCtrl = {
        unOverMax: true
      };

      $scope.uploadFileURIs = Circle.getUploadImages();

      $scope.change = function() {
        var element = document.getElementById('circle_content');
        element.style.height = 'auto';
        element.style.height = element.scrollHeight + "px";
      };

      /**
       * 上传一张图片
       * @params {String} uri 文件uri
       * @params {String} circleContentId 对应的circleContent的id
       * @returns {Promise}
       */
      var upload = function (uri, circleContentId) {
        var addr = CONFIG.BASE_URL + '/files';
        var headers = CommonHeaders.get();
        headers['x-access-token'] = localStorage.accessToken;
        var options = {
          fileKey: 'files',
          headers: headers,

          // 此处有坑！！！这里只允许简单的键值对，允许字符串或数字类型，不可以是对象
          // 估计是因为这里是使用上传插件，底层调用Object-C方法，为了逻辑简单不接受复杂的参数
          params: {
            owner_kind: 'CircleContent',
            owner_id: circleContentId
          }
        };
        return $cordovaFile.uploadFile(addr, uri, options);
      };

      $scope.publish = function () {
        var circleContentId;
        Circle.preCreate($state.params.campaignId, $scope.circleData.content)
        .then(function (response) {
          circleContentId = response.data.id;
          var uploadPromises = $scope.uploadFileURIs.map(function (uri) {
            return upload(uri, circleContentId);
          });
          $ionicLoading.show({
            template: '上传中...',
            duration: 5000
          });
          return $q.all(uploadPromises);
        })
        .then(function (results) {
          return Circle.active(circleContentId);
        })
        .then(function (response) {
          $ionicLoading.hide();
          $ionicPopup.alert({
            title: '提示',
            template: '发表成功'
          });
          $scope.goBack();
        })
        .then(null, function (response) {
          if (response instanceof Error) {
            console.log(response.stack);
            $ionicPopup.alert({
              title: '提示',
              template: response.message || '发表失败'
            });
          }
          else {
            var msg;
            if (response && response.data && response.data.msg) {
              msg = response.data.msg;
            }
            else {
              msg = '发表失败';
            }
            $ionicPopup.alert({
              title: '提示',
              template: msg
            });
          }
        });
      };

    }
  ])
  .controller('CompetitionMessageListController', ['$scope', '$rootScope','$state', 'CompetitionMessage', function ($scope, $rootScope, $state, CompetitionMessage) {
    $scope.messageType ='receive';
    $scope.page = 1;
    $scope.getCompetitionLog = function (refreshFlag) {
      if(refreshFlag) {
        $scope.page =1;
        $scope.competitionMessages =[]
      }
      var data = {
        messageType: $scope.messageType,
        page: $scope.page
      }
      CompetitionMessage.getCompetitionMessages(data,function (err,data) {
        if (err) {
          // todo
          console.log(err);
        } else {
          $scope.competitionMessages = $scope.page>1 ? $scope.competitionMessages.concat(data.messages): data.messages;
          $scope.page++;
          $scope.maxPage = data.maxPage;
          $rootScope.hasNewDiscover = data.unReadStatus;
        }
        refreshFlag && $scope.$broadcast('scroll.refreshComplete');
      });
    }
    $scope.typeFilter = function (messageType) {
      $scope.messageType = messageType;
      $scope.page = 1;
      $scope.competitionMessages =[];
      $scope.getCompetitionLog();
    }
    $scope.moreCompetition = function (argument) {
      $scope.getCompetitionLog();
    }
    $scope.$on('$ionicView.enter',function(scopes, states){
      $scope.getCompetitionLog(true);
    });
  }])
  .controller('CompetitionMessageDetailController', ['$scope', '$state', '$ionicModal', '$ionicScrollDelegate', '$ionicPopup', '$timeout', '$ionicHistory', 'CompetitionMessage', 'Comment', 'Vote', 'User', 'Upload', 'INFO',
   function ($scope, $state, $ionicModal, $ionicScrollDelegate, $ionicPopup, $timeout, $ionicHistory, CompetitionMessage, Comment, Vote, User, Upload, INFO) {
    $scope.goBack = function() {
      if($ionicHistory.backView()){
        $ionicHistory.goBack();
      }
      else {
        $state.go('competition_message_list');
      }
    };
    //评论获取
    $scope.commentList = [];
    $scope.topShowTime = [];
    $scope.data ={};
    $scope.cid = localStorage.cid;
    var formatVote = function (vote) {
      var totalVote = vote.units[0].positive +vote.units[1].positive;
      vote.units.forEach(function(unit, index){
        if(unit.positive==0 || unit.positive_member.indexOf(localStorage.id)==-1) {
          unit.canVote = true;
        }
        unit.percent=totalVote ? unit.positive *100/totalVote :50;
      });
      return vote;
    }
    var getCompetitionMessage = function () {
      CompetitionMessage.getCompetitionMessage($state.params.id,function (err,data) {
        if (err) {
          // todo
          console.log(err);
        } else {
          $scope.competitionMessage = data.message;
          $scope.competitionMessage.content = $scope.competitionMessage.content.replace(/(\r)?\n/g,"<br>");
          $scope.oppositeLeader = data.oppositeLeader;
          $scope.sponsorLeader = data.sponsorLeader;
          $scope.competitionMessage.vote = formatVote($scope.competitionMessage.vote);
          // var ta = document.getElementById('ta');
        }
      });
    }
    $scope.getCompetitionComments = function (index) {
      var queryData = {
        requestType: 'competition_message',
        requestId: $state.params.id,
        limit: -1
        }
      Comment.getComments(queryData,function (err,data) {
        if (err) {
          // todo
          console.log(err);
        } else {
          $scope.commentList = data.comments;
          $scope.commentList.unshift({
            content:$scope.competitionMessage.content,
            create_date:$scope.competitionMessage.create_date,
            poster_team: $scope.competitionMessage.sponsor_team
          });
        }
      });
    }
    $scope.showPopup = function() {
      $scope.data = {};
      var myPopup = $ionicPopup.show({
        template: '<textarea rows=4 placeholder="请输入评论内容" type="text" ng-model="data.content">',
        title: '评论',
        scope: $scope,
        buttons: [
          { text: '取消' },
          {
            text: '<b>保存</b>',
            type: 'button-positive',
            onTap: function(e) {
              if (!$scope.data.content) {
                //don't allow the user to close unless he enters wifi password
                e.preventDefault();
              } else {
                return $scope.data.content;
              }
            }
          }
        ]
      });
      myPopup.then(function(res) {
        if(res) {
          $scope.publishComment();
        }
      });
    };
    $scope.voteCompetition = function (index) {
      var vote = $scope.competitionMessage.vote;
      var unit = vote.units[index];
      // if(unit.canVote) {
        Vote.vote(vote._id,unit.tid,function (err, vote) {
          if(err) {
            $ionicPopup.alert({
              title: '错误',
              template: err
            });
          }
          else{
            $scope.competitionMessage.vote = formatVote(vote);
            $ionicPopup.alert({
              title: '提示',
              template: '投票成功!'
            });
          }
        })
      // }
      // else{
      //   Vote.cancelVote(vote._id,unit.tid,function (err, vote) {
      //     if(err) {
      //       console.log(err);
      //     }
      //     else{
      //       $scope.competitionMessage.vote = formatVote(vote);
      //     }
      //   })
      // }
    }
    $scope.dealCompetition = function (action) {
      CompetitionMessage.dealCompetition($state.params.id, action, function (err,data) {
        if (err) {
          // todo
          console.log(err);
        } else {
          alert('挑战处理成功!');
          $scope.competitionMessage.status =action+'ed';
        }
      });
    }
    $scope.sponsorCompetition = function () {
      INFO.competitionMessage = $scope.competitionMessage;
      $state.go('sponsor',{type:'competition'});
    }
    //发表评论
    $scope.publishComment = function() {
      if(window.analytics){
        window.analytics.trackEvent('Click', 'publishComment');
      }
      var commentData = {
        hostType: 'competition_message',
        hostId: $state.params.id,
        content: $scope.data.content
      }
      Comment.publishComment(commentData, function(err,data){
        if(err){
          console.log(err);
        }else{
          $scope.data.content = '';
          $scope.commentList.push(data.comment);
        }
      });
    };
    $scope.doRefresh = function (refreshFlag) {
      getCompetitionMessage();
      $scope.getCompetitionComments();
      $scope.data.content='';
      refreshFlag && $scope.$broadcast('scroll.refreshComplete');
    }
    $scope.doRefresh();
  }])
  .controller('SearchOpponentController', ['$scope', '$rootScope', '$state', 'CompetitionMessage', 'Team', 'INFO', function ($scope, $rootScope, $state, CompetitionMessage, Team, INFO) {
    $scope.hasSelected = false;
    $scope.keywords ='';
    var getMyTeams = function(callback) {
      Team.getList('user', localStorage.id, null, function (err, teams) {
        if (err) {
          // todo
          console.log(err);
          $scope.myTeams =[];
        } else {

          $scope.myTeams = teams.sort(function (last,next) {
            return next.isLeader - last.isLeader;
          });
          INFO.myTeams = $scope.myTeams;
          callback && callback();
        }
      });
    };
    if(INFO.myTeams) {
      $scope.myTeams = INFO.myTeams.sort(function (last,next) {
        return next.isLeader - last.isLeader;
      });
    }
    else{
      getMyTeams();
    }
    var getSearchTeam = function (type,addFlag) {
      var queryData = {
        type: type,
        tid: $scope.myTeam._id,
        page: $scope.page,
      }
      if(type == 'nearbyTeam') {
        if($scope.coordinates.length==0) {
          $scope.teams = [];
          return;
        }
        queryData.latitude = $scope.coordinates[1];
        queryData.longitude = $scope.coordinates[0];
      }
      else if(type == 'search'){
        queryData.key = $scope.keywords;
      }
      $rootScope.showLoading();
      Team.getSearchTeam(queryData,function (err, data) {
        if(err) {
          console.log(err);
          $scope.teams = [];
        }
        else{
          if(addFlag) {
            $scope.teams = $scope.teams.concat(data.teams);
          }
          else{
            $scope.teams = data.teams;
          }
          $scope.maxPage = data.maxPage;
        }
        $rootScope.hideLoading();
      });
    }
    $scope.doRefresh = function (argument) {
      if($scope.hasSelected) {
        $scope.page =1;
        getSearchTeam($scope.nowTab);
      }
      else{
        getMyTeams();
      }
      $scope.$broadcast('scroll.refreshComplete');
    }
    $scope.$watch('nowTab',function (newVal, oldVal) {
      if(newVal &&newVal!='search' && newVal!=oldVal) {
        $scope.page =1;
        getSearchTeam(newVal);
      }
    });
    $scope.selectTeam = function (index) {
      $scope.hasSelected = true;
      $scope.myTeam = $scope.myTeams[index];
      $scope.nowTab = 'sameCity';
      $scope.coordinates =[];
      $scope.myTeam.homeCourts.forEach(function(homeCourt, index){
        if(homeCourt.loc.coordinates && homeCourt.loc.coordinates.length==2) {
          $scope.coordinates = homeCourt.loc.coordinates;
        }
      });
      //获取坐标
      if($scope.coordinates.length==0) {
        var onSuccess = function(position) {
          $scope.coordinates = [position.coords.longitude,position.coords.latitude];
        };
        function onError(error) {
           console.log('code: '    + error.code    + '\n' +
                  'message: ' + error.message + '\n');
        }

        if(navigator.geolocation) {
          navigator.geolocation.getCurrentPosition(onSuccess, onError);
        }
      }
    }
    $scope.changeTeam = function () {
      $scope.hasSelected = false;
      $scope.myTeam = null;
      $scope.nowTab = null;
    }
    $scope.changeFilter = function (filter) {
      $scope.nowTab = filter;
    }
    $scope.search = function () {
      $scope.page =1;
      getSearchTeam('search');
    }
    $scope.changeRecommendTeam = function (filter) {
      $scope.page++;
      getSearchTeam(filter);
    }
    $scope.moreTeam = function (filter) {
      $scope.page++;
      getSearchTeam(filter,true);
    }
    $scope.gotTeamDetail = function (teamId) {
      $state.go('competition_team',{
        targetTeamId: teamId
      })
    }
  }])
  .controller('CompetitionTeamController', ['$scope', '$state', '$ionicHistory', '$ionicPopup', 'Team', 'INFO', 'Campaign', 'Chat', function ($scope, $state, $ionicHistory, $ionicPopup, Team, INFO, Campaign, Chat) {
    var targetTeamId = $state.params.targetTeamId;
    $scope.page = 1;
    $scope.goBack = function() {
      if ($ionicHistory.backView()) {
        $ionicHistory.goBack()
      } else {
        $state.go('app.discover');
      }
    }
    var filterSameTeam = function (myTeams, groupType) {
      $scope.sameTeams = myTeams.filter(function (team) {
        return team._id!=targetTeamId &&groupType ===team.groupType;
      });
      $scope.leadTeams = [];
      $scope.memberTeams = [];
      $scope.sameTeams.forEach(function(team, index){
        if(team.isLeader) {
          $scope.leadTeams.push(team);
        }
        else{
          $scope.memberTeams.push(team);
        }
      });
    }
    var getSameTeam = function (groupType) {
      if(INFO.myTeams) {
        filterSameTeam(INFO.myTeams,groupType);
      }
      else{
        Team.getList('user', localStorage.id, null, function (err, teams) {
          if (err) {
            // todo
            console.log(err);
          } else {
            INFO.myTeams = teams;
            filterSameTeam(teams,groupType);
          }
        });
      }
    }

    Team.getData(targetTeamId, function (err, team) {
      if (err) {
        // todo
        console.log(err);
      } else {
        $scope.targetTeam = team;
        getSameTeam(team.groupType);
        $scope.isCompanyTeam = team.isCompanyTeam;
        if(!team.isCompanyTeam) {
          $scope.getCompetitionOfTeams();
        }
      }
    },{resultType:'simple'});
    $scope.getCompetitionOfTeams = function () {
      Campaign.getCompetitionOfTeams({targetTeamId: targetTeamId,page: $scope.page}, function (err, data) {
        if (err) {
          // todo
          console.log(err);
        } else {
          if($scope.competitions) {
            $scope.competitions = $scope.competitions.concat(data.competitions);
          }
          else{
            $scope.competitions = data.competitions;
          }
          $scope.maxPage = data.maxPage;
          $scope.page++;
        }
      })
    }
    $scope.showPopup = function(index) {
      var showText = [{text:'发挑战',teamText:'leadTeams',funText:'createMessage'},{text:'推荐',teamText:'memberTeams',funText:'recommend'}];
      // $scope.selectTeam = $scope[showText[index].teamText][0];
      $scope.selectTeam ={id:$scope[showText[index].teamText][0]._id};
      var templatString = "<ion-radio ng-repeat='team in "+ showText[index].teamText+ "' ng-model='selectTeam.id' ng-value='team._id'>{{team.name}}</ion-radio>";
      // An elaborate, custom popup
      var myPopup = $ionicPopup.show({
        template: templatString,
        title: ' 选择要'+showText[index].text+'的小队',
        // subTitle: '请输入公告内容',
        scope: $scope,
        buttons: [
          { text: '取消' },
          {
            text: '<b>确定</b>',
            type: 'button-positive',
            onTap: function(e) {
              if (!$scope.selectTeam.id) {
                e.preventDefault();
              } else {
                return $scope.selectTeam.id;
              }
            }
          }
        ]
      });
      myPopup.then(function(res) {
        if(res) {
          $scope[showText[index].funText](res);
        }
      });
    };
    $scope.createMessage = function (teamId) {
      INFO.competitionMessageData = {
        fromTeamId: teamId,
        targetTeam: $scope.targetTeam
      }
      $state.go('competition_send');
    }
    $scope.recommend = function (teamId) {
      var postData = {
        content: $scope.targetTeam.name,
        chatType: 2,
        recommendTeamId: targetTeamId
      }
      Chat.postChat(teamId, postData, function(err, data) {
        if(err) {
          console.log(err);
        }
        else{
          $ionicPopup.alert({
            title: '提示',
            template: '推荐成功！'
          });
        }
      })
    }
  }])
  .controller('CompetitonSendController', ['$scope', '$state', '$ionicHistory', '$ionicPopup', 'CompetitionMessage', 'Team', 'INFO', 'Campaign', function ($scope, $state, $ionicHistory, $ionicPopup, CompetitionMessage, Team, INFO, Campaign) {
    $scope.isPublish=false;
    if(INFO.competitionMessageData) {
      var competitionMessageData = INFO.competitionMessageData;
      $scope.fromTeamId = competitionMessageData.fromTeamId;
      $scope.targetTeam = competitionMessageData.targetTeam;
      $scope.messageData = {
        sponsor: $scope.fromTeamId,
        opposite: $scope.targetTeam._id,
        type:1,
        content: "活动地点:\n活动时间:\n挑战词:\n"
      }
    }
    else{
      $ionicPopup.alert({
        title: '错误',
        template: '数据发送错误！'
      });
    }
    $scope.goBack = function() {
      if($ionicHistory.backView()){
        $ionicHistory.goBack()
      }
      else {
        $state.go('competition_team',{
          fromTeamId: $scope.fromTeamId,
          targetTeamId: $scope.targetTeam._id
        });
      }
    }
    $scope.publishMessage = function () {
      if($scope.isPublish)
        return;
      $scope.isPublish =true;
      CompetitionMessage.createCompetitionMessage($scope.messageData, function (err, data) {
        if(!err) {
          $ionicPopup.alert({
            title: '提示',
            template: data.msg
          });
          $scope.goBack();
        }
        else{
          $ionicPopup.alert({
            title: '错误',
            template: data.msg
          });
        }
        $scope.isPublish =false;
      })
    }
  }])
