angular.module('donlerApp.controllers', [])

  .controller('AppContoller', ['$scope', function ($scope) {
  }])
  .controller('UserLoginController', ['$scope', '$rootScope', 'CommonHeaders', '$state', '$ionicHistory', 'UserAuth', function ($scope, $rootScope, CommonHeaders, $state, $ionicHistory, UserAuth) {
    $scope.loginData = {
      email: '',
      password: ''
    };

    $scope.login = function () {
      $rootScope.showLoginLoading();
      if(window.analytics){
        window.analytics.trackEvent('Click', 'userLogin');
      }
      UserAuth.login($scope.loginData.email, $scope.loginData.password, function (msg) {
        $rootScope.hideLoading();
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
  .controller('HrHomeController', ['$scope', '$state', '$rootScope', '$ionicScrollDelegate', 'CompanyAuth', 'CommonHeaders', 'Company', 'INFO', 
    function ($scope, $state, $rootScope, $ionicScrollDelegate, CompanyAuth, CommonHeaders, Company, INFO) {

    $scope.logout = function () {
      if(window.analytics){
        window.analytics.trackEvent('Click', 'hrLogOut');
      }
      $rootScope.showAction({
        type: 1,
        titleText: '你确定退出吗?',
        fun: function() {
          CompanyAuth.logout(function (err) {
            if (err) {
              // todo
              console.log(err);
              $state.go('hr_login');
            } else {
              $state.go('home');
            }
          });
        }
      })

    };
    $scope.toggleGuide = function() {
      $scope.hiding = !$scope.hiding;
      $ionicScrollDelegate.$getByHandle("mainScroll").resize();
    };
    $scope.hidenGuide = function () {
      $scope.company.guide_step = 1;
      Company.edit(localStorage.id,{guide_step:1},function (err) {
        if(err){
          console.log('err');
        }
      });
    }
    $scope.$on('$ionicView.enter', function(scopes, states) {
      // 为true或undefined时获取公司数据
      if (INFO.hasModifiedCompany !== false || INFO.updateHrHome !== false) {
        INFO.hasModifiedCompany = false;
        INFO.updateHrHome = false;
        Company.getData(localStorage.id)
          .success(function(data) {
            $scope.company = data;
          })
          .error(function(data,status) {
            if(status!==401) $rootScope.showAction({titleText:data ? data.msg: '获取公司数据失败'});
          });
      }
    });
  }])
  .controller('CreateTeamController', ['$scope', '$rootScope', '$state', 'INFO', 'Team',
   function ($scope, $rootScope, $state, INFO, Team) {
    $scope.backUrl = localStorage.userType==='company' ? '#/hr/team_page' : INFO.createTeamBackUrl;
    $scope.isBusy = false;
    $scope.teamName = {};
    Team.getGroups(function(err,data) {
      if(!err) {
        $scope.groups = data;
        $scope.selectType = data[0];
      }
      else {
        $rootScope.showAction({titleText:err});
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
            else {
              INFO.hasModifiedTeam = true;
              INFO.updateHrHome = true;
              $state.go('hr_teamPage');
            }
          }
          else{
            $rootScope.showAction({titleText:err});
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
  .controller('CampaignController', ['$scope', '$state', '$timeout', '$rootScope', '$ionicPopover', '$rootScope', '$ionicScrollDelegate','$ionicHistory', '$filter', 'Campaign', 'INFO','UserAuth',
    function ($scope, $state, $timeout, $ionicActionSheet, $ionicPopover, $rootScope, $ionicScrollDelegate, $ionicHistory,  $filter, Campaign, INFO, UserAuth) {
    $scope.nowType = 'all';
    $scope.pswpPhotoAlbum = {};
    $scope.pswpId = 'campaigns' + Date.now();
    $scope.showSponsorButton = localStorage.role =='LEADER';
    $scope.showhrGuide = localStorage.guide_step ==0;
    $scope.hidenGuide = function () {
      UserAuth.logout(function (err) {
        if(!err){
          localStorage.guide_step = 1;
          $state.go('hr_login')
        }
        else{
          console.log(err);
        }
      })
    }
    var getCampaignList = function(loading, callBack) {
      loading && $rootScope.showLoading();
      Campaign.getList({
        requestType: 'user',
        requestId: localStorage.id,
        select_type: 0,
        sqlite: 1
      }, function (err, data) {
        if (!err) {
          $scope.unStartCampaigns = data[0];
          $scope.nowCampaigns = data[1];
          $scope.newCampaigns = data[2];
          // $scope.provokes = data[3];
          $scope.finishedCampaigns = data[3];
          if(data[0].length===0&&data[1].length===0&&data[2].length===0&&data[3].length===0){
            $scope.noCampaigns = true;
          }
          else {
            $scope.noCampaigns = false;
          }
        }
        // callBack &&callBack();
      }, function(err, data) {
        loading && $rootScope.hideLoading();

        if (!err) {
          $scope.unStartCampaigns = data[0];
          $scope.nowCampaigns = data[1];
          $scope.newCampaigns = data[2];
          // $scope.provokes = data[3];
          $scope.finishedCampaigns = data[3];
          if(data[0].length===0&&data[1].length===0&&data[2].length===0&&data[3].length===0){
            $scope.noCampaigns = true;
          }
          else {
            $scope.noCampaigns = false;
          }
        }
        callBack &&callBack();
      });
    };
    // 此处使用rootScope是为了解决切换tab时不能刷新的问题
    $rootScope.getCampaignList = getCampaignList;
    // getCampaignList(true);
    $rootScope.$on( "$ionicView.enter", function( scopes, states ) {
      if(!states.stateName && $state.$current.name === 'app.campaigns' && !INFO.backFromCampaignDetail){
        getCampaignList(true);
        INFO.backFromCampaignDetail = false;
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
      'nowCampaigns' : '正在进行的活动',
      'finishedCampaigns' : '刚结束的活动'
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
      getCampaignList(false, function () {
        $scope.$broadcast('scroll.refreshComplete');
      })
    };
  }])
  .controller('CampaignDetailController', ['$ionicHistory', '$rootScope', '$scope', '$state', '$q', 'Campaign', 'Message', 'INFO', 'User', 'Circle', 'CONFIG',
   function ($ionicHistory, $rootScope, $scope, $state, $q, Campaign, Message, INFO, User, Circle, CONFIG) {
    $scope.goBack = function() {
      if($ionicHistory.backView()){
        $ionicHistory.goBack();
      }
      else {
        $state.go('app.campaigns');
      }
    };
    $scope.doRefresh= function () {
      var promises = [];
      getCampaigData(promises);
      getMessageData(promises);
      getCircleData(promises);
      getUserData(promises);
      $q.all(promises).then(function(res) {
        $scope.$broadcast('scroll.refreshComplete');
        if(res[0] === 'error' || res[1] === 'error' || res[2] === 'error' || res[3] === 'error') {
          $rootScope.showAction({titleText:'获取失败'});
        }
      });

      $scope.reloadFlag= !!$scope.scoreBoardId;
    }
    $scope.cid = localStorage.cid;
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
          INFO.backFromCampaignDetail = false;
          $scope.campaign = data;
          setMembers();
          $rootScope.showAction({titleText:'参加成功'})
        }
        else {
          $rootScope.showAction({titleText:err})
        }
      });
      return false;
    };
    $scope.quit = function(id){
      $rootScope.showAction({type:2,titleText:'确定退出活动吗？',fun:function () {
        if(window.analytics){
          window.analytics.trackEvent('Click', 'quitCampaign');
        }
        Campaign.quit(id,localStorage.id, function(err, data){
          if(!err){
            INFO.backFromCampaignDetail = false;
            $scope.campaign = data;
            setMembers();
            $rootScope.showAction({titleText:'退出成功'})
          }
          else {
            $rootScope.showAction({titleText:err})
          }
        });
      }});
    };
    $scope.goDiscussDetail = function(campaignId, campaignTheme) {
      INFO.discussName = campaignTheme;
      $state.go('campaigns_discuss',{id: campaignId});
    };
    $scope.goSendCircle = function(campaignId) {
      $state.go('circle_send_content',{campaignId: campaignId});
      // $state.go('circle_company');
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
          }

          $scope.$broadcast('scroll.infiniteScrollComplete');
        })
        .error(function(data, status) {
          if (status !== 404) {
            $rootScope.showAction({titleText:'获取失败'})
          } else {
            $scope.loadingStatus.hasMore = false;
          }
          $scope.loadingStatus.loading = false;
          $scope.$broadcast('scroll.infiniteScrollComplete');
        });
    };
    

    var pageLength = 20; // 一次获取的数据量

    var getCampaigData = function(promises) {
      var deferred = $q.defer();
      Campaign.get($state.params.id, function(err, data){
        if(!err){
          $scope.campaign = data;
          setMembers();
          data.components && data.components.forEach(function(component, index){
            if(component.name=='ScoreBoard') {
              $scope.scoreBoardId =component._id;
              $scope.reloadFlag= false;
            }
          });
          deferred.resolve();
        } else {
          deferred.resolve('error');
        }
      },true);
      promises.push(deferred.promise);
    };

    var getMessageData = function(promises) {
      var deferred = $q.defer();
      Message.getCampaignMessages($state.params.id, function(err, data){
        if(!err){
          $scope.notices = data;
          deferred.resolve();
        } else {
          deferred.resolve('error');
        }
      });
      promises.push(deferred.promise);
    };

    var getCircleData = function(promises) {
      var deferred = $q.defer();
      Circle.getCampaignCircle($state.params.id)
      .success(function(data, status) {
        if (data.length) {
          data.forEach(function(circle) {
            Circle.pickAppreciateAndComments(circle);
          });
          $scope.circleContentList = data || []; //(data || []).concat($scope.circleContentList);
        }
        deferred.resolve();
      })
      .error(function(data, status) {
        if (status !== 404) {
          deferred.resolve('error');
        }
        deferred.resolve();
      });
      promises.push(deferred.promise);
    };

    var getUserData = function(promises) {
      var deferred = $q.defer();
      User.getData(localStorage.id, function(err, data) {
        if (err) {
          // todo
          console.log(err);
          deferred.resolve('error');
        } else {
          $scope.user = data;
          deferred.resolve();
        }
      });
      promises.push(deferred.promise);
    };

    $scope.$on('$ionicView.enter',function(scopes, states){
      $rootScope.showLoading();
      INFO.backFromCampaignDetail = true;
      // 用于保存已经获取到的同事圈内容
      $scope.circleContentList = [];
      $scope.loadingStatus = {
        hasInit: false, // 是否已经获取了一次内容
        hasMore: false, // 是否还有更多内容，决定infinite-scroll是否在存在
        loading: false // 是否正在加载更多，如果是，则会保护防止连续请求
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

      $scope.clickBlank = function() {
        $scope.circleCommentBoxCtrl.stopComment();
      };

      $scope.onClickContentImg = function(images, img) {
        $scope.pswpCtrl.init(images, img);
      };

      var promises = [];
      getCampaigData(promises);
      getMessageData(promises);
      getCircleData(promises);
      getUserData(promises);
      $q.all(promises).then(function(res) {
        $rootScope.hideLoading();
        if(res[0] === 'error' || res[1] === 'error' || res[2] === 'error' || res[3] === 'error') {
          $rootScope.showAction({titleText:'获取失败'});
        }
      });
      // Campaign.get($state.params.id, function(err, data){
      //   if(!err){
      //     $scope.campaign = data;
      //     setMembers();
      //     data.components && data.components.forEach(function(component, index){
      //       if(component.name=='ScoreBoard') {
      //         $scope.scoreBoardId =component._id;
      //         $scope.reloadFlag= false;
      //       }
      //     });
      //   }
      // },true);
      // Message.getCampaignMessages($state.params.id, function(err, data){
      //   if(!err){
      //     $scope.notices = data;
      //   }
      // });
      // Circle.getCampaignCircle($state.params.id)
      // .success(function(data, status) {
      //   if (data.length) {
      //     data.forEach(function(circle) {
      //       Circle.pickAppreciateAndComments(circle);
      //     });
      //     $scope.circleContentList = (data || []).concat($scope.circleContentList);
      //   }
      //   $scope.$broadcast('scroll.refreshComplete');
      // })
      // .error(function(data, status) {
      //   if (status !== 404) {
      //     $rootScope.showAction({titleText:data.msg ?data.msg: '获取失败'})
      //   }
      //   $scope.$broadcast('scroll.refreshComplete');
      // });

      // User.getData(localStorage.id, function(err, data) {
      //   if (err) {
      //     // todo
      //     console.log(err);
      //   } else {
      //     $scope.user = data;
      //   }
      // });
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
  .controller('CampaignNoticelController', ['$ionicHistory', '$scope', '$stateParams', '$ionicModal', '$rootScope', 'Campaign', 'Message',
   function($ionicHistory, $scope, $stateParams, $ionicModal, $rootScope, Campaign, Message) {
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
    $ionicModal.fromTemplateUrl('publish-notice.html', {
      scope: $scope,
      animation: 'slide-in-up'
    }).then(function(modal) {
      $scope.publishModal = modal;
    });
    $scope.showPublishSheet = function() {
      $scope.publishModal.show();
    };
    $scope.cancelPublish = function() {
      $scope.publishModal.hide();
    };
    $scope.data = {message:''};
    $scope.publishNotice = function() {
      var messageData = {
        type:'private',
        caption:$scope.campaign.theme,
        content:$scope.data.message,
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
          $rootScope.showAction({titleText:'公告发布成功！'})
          Message.getCampaignMessages($stateParams.id, function(err, data){
            if(!err){
              $scope.notices = data;
            }
            $scope.publishModal.hide();
          });
        }
        else{
           $rootScope.showAction({titleText:err})
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
    var setMembers = function () {
      $scope.campaign.members =[];
      $scope.memberContents = [];
      $scope.campaign.campaign_unit.forEach(function(campaign_unit){
        if(campaign_unit.team){
          var content = {
            name:campaign_unit.team.name,
            members:campaign_unit.member
          };
          if (campaign_unit.company._id !== localStorage.cid) {
            content.isOtherCompany = true;
          }
          $scope.memberContents.push(content);
        }
        else {
          $scope.memberContents.push({
            name:campaign_unit.company.name,
            members:campaign_unit.member
          });
        }
      });
    };
    Campaign.get($stateParams.id, function(err, data){
      if(!err){
        $scope.campaign = data;
        setMembers();
      }
    });
    $scope.goBack = function() {
      if($ionicHistory.backView()){
        $ionicHistory.goBack()
      }
    }
  }])
  .controller('SponsorController', ['$ionicHistory', '$scope', '$state', '$rootScope', '$ionicModal', '$timeout', '$ionicScrollDelegate', 'Campaign', 'INFO', 'Team',
   function ($ionicHistory, $scope, $state, $rootScope, $ionicModal, $timeout, $ionicScrollDelegate, Campaign, INFO, Team) {
    $scope.campaignData ={
      location : {name:''}
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
    $scope.toggleShowMore = function () {
      $scope.showMore = !$scope.showMore;
      $ionicScrollDelegate.resize()
    }
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
        $rootScope.showAction({titleText:errMsg})
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
            $state.go('campaigns_detail',{id:data.campaign_id});
          }
          else{
             $rootScope.showAction({titleText:err})
          }
          $scope.isBusy = false;
        });
      }

    };
  }])
  .controller('DiscussListController', ['$scope', '$rootScope', '$ionicHistory', 'Chat', '$state', 'Socket', 'Tools', 'INFO',
    function ($scope, $rootScope, $ionicHistory, Chat, $state, Socket, Tools, INFO) { //标为全部已读???
    //Socket.emit('enterRoom', localStorage.id);
    //先在缓存里取
    $rootScope.$on( "$ionicView.enter", function ( scopes, states ) {
      if(!states.stateName){
        getChatrooms(true);
      }
    });
    function formatChat(chat) {
      if($scope.userList[chat.from]){
        chat.poster = $scope.userList[chat.from];
      }
      else{
        $scope.userList[chat.from]={_id:chat.from};
        Chat.getChatUser(chat.from,function (err,user) {
          if(err)
            console.log(err);
          chat.poster = user;
        });
      }
      
    };
    $scope.$on('ReciveMessage',
      function (event, chat) {
        Chat.updateChatroomList(chat);
    });
    $scope.$on('ReciveOfflineMessages',
      function (event, chats) {
        getChatrooms(true);
    });
    var comeBack = function() {
      if($state.$current.name==='app.discuss_list') {
        getChatrooms(true);
      }
    };
    document.addEventListener('resume', comeBack, false);//从后台切回来要刷新及进room

    //force为true强制刷新 以下几种情况需要强制刷新：
    //1.用户手动刷新
    //2.用户切到过后台
    //3.刚进controller
    var getChatrooms = function(force) {
      Chat.getChatroomList(force, function (err, data){
        $scope.chatrooms = data;
      }, function (err, data) {
        $scope.chatrooms = data;
      });
    };
    getChatrooms(true);

    //刷新接口
    $scope.refresh = function() {
      getChatrooms(true);
      $scope.$broadcast('scroll.refreshComplete');
    };

    //判断是否有新的
    var checkAllRead = function() {
      var hasnotRead = false;
      for (var i = $scope.chatrooms.length - 1; i >= 0; i--) {
        if($scope.chatrooms[i].unreadMessagesCount) {
          hasnotRead = true;
        }
      }
      if(hasnotRead === false) {
        $rootScope.hasNewComment = false;
      }
    };

    $scope.goDetail = function(chatroom, index) {
      INFO.chatroom = {
        'teamId': chatroom.teamId,
        'easemobId': chatroom.easemobId,
        'logo':chatroom.logo,
        'name': chatroom.name,
        'isGroup':chatroom.isGroup
      };
      $scope.chatrooms[index].unreadMessagesCount = 0;
      checkAllRead();
      $state.go('chat',{chatroomId: chatroom.easemobId});
    };
  }])
  .controller('ChatroomDetailController', ['$scope', '$state', '$stateParams', '$ionicScrollDelegate', '$timeout', 'Chat', 'User', 'Tools', 'INFO', 'Upload', '$ionicModal',
    function ($scope, $state, $stateParams, $ionicScrollDelegate, $timeout, Chat, User, Tools, INFO, Upload, $ionicModal) {
    $scope.chatRoom = INFO.chatroom;
    $scope.chatRoom.type = INFO.chatroom.isGroup?'group':'single';
    $scope.userId = localStorage.id;
    $scope.cid = localStorage.cid;
    $scope.chatsList = [];
    $scope.userList = {};
    function dealReceiveMessage (chat) {
      if(chat.to===$scope.chatRoom.easemobId || !chat.isGroup &&chat.from===$scope.chatRoom.easemobId){
        if(chat.from===$scope.userId) {
          var index = Tools.arrayObjectIndexOf($scope.chatsList,chat.msgTime,"msgTime");
          if(index>-1){
            var _chat = $scope.chatsList[index];
            _chat.status= chat.status;
          }
        }
        else{
          formatChat(chat);
          $scope.chatsList.push(chat);
          $timeout(function () {
            $ionicScrollDelegate.scrollBottom();
          },0)
        }
        
      }
    }
    $scope.$on('ReciveMessage',
      function (event, chat) {
        console.log(chat);
        dealReceiveMessage(chat);
        $scope.$digest();
    });
    $scope.$on('ReciveOfflineMessages',
      function (event, chats) {
        chats.forEach(dealReceiveMessage);
        $scope.$digest();
    });
    var addPhoto = function (chat) {
      if (chat.type==='IMAGE') {
        var item = {
          _id: chat.msgId,
          downloadStatus: chat.body.attachmentDownloadStatus,
          title: '上传时间: ' + moment(chat.msgTime).format('YYYY-MM-DD HH:mm')
        };
        if(chat.body.attachmentDownloadStatus>1){
          item.src = chat.body.thumbnailUrl;
          item.w =chat.body.thumbnailWidth;
          item.h =chat.body.thumbnailHeight;
        }
        else{
          item.src = chat.body.localUrl;
          item.w = chat.body.width;
          item.h = chat.body.height;
        }
        $scope.photos.push(item);
      }
    }
    var formatChat = function (chat) {
      addPhoto(chat);
      if($scope.userList[chat.from]){
        chat.poster = $scope.userList[chat.from];
      }
      else{
        $scope.userList[chat.from]={_id:chat.from};
        Chat.getChatUser(chat.from,function (err,user) {
          if(err) {
            console.log(err);
          }
          else {
            chat.poster = user;
            $scope.userList[chat.from].nickname = user.nickname;
            $scope.userList[chat.from].photo = user.photo;
            $scope.userList[chat.from].realname = user.realname;
          }
          
        });
      }
      
    };
    var updateChat = function (chat) {
      formatChat(chat);
      $scope.chatsList.push(chat);
      $timeout(function () {
        $ionicScrollDelegate.scrollBottom();
      },0)
      
    }
    $scope.recordEnd = function () {
      easemob.recordEnd(updateChat,updateChat,[$scope.chatRoom.type, $scope.chatRoom.easemobId])
    }
    //进来也标记一下，否则可能在退出时来不及.
    easemob.resetUnreadMsgCount(null,null,[$scope.chatRoom.type,$scope.chatRoom.easemobId])
    //离开此页时标记读过
    $scope.$on('$destroy',function() {
      easemob.resetUnreadMsgCount(null,null,[$scope.chatRoom.type,$scope.chatRoom.easemobId])
      $scope.confirmUploadModal.remove();
    });

    //记录当前正在播放的chat的body对象
    var isPlayingBody = null;

    function playAudio (chat) {
      var url = chat.body.localUrl ? chat.body.localUrl:body.remoteUrl;
      var params = {
        chatType: $scope.chatRoom.type,
        target:$scope.chatRoom.easemobId, //目标用户的用户名或群的id
        msgId: chat.msgId, //消息的id
        path: url
      };
      easemob.playRecord(null,null,[params]);
      //定时
      $timeout(function() {
        if(chat.body.isPlaying) {
          isPlayingBody = null;
        }
        chat.body.isPlaying = false;
      }, chat.body.duration*1000);
    };

    function stopAudio () {
      easemob.stopPlayRecord();
      isPlayingBody = null;
    }
    $scope.toggleVoice = function (body) {
      if(!body.isPlaying){
        if(isPlayingBody) {//有其它的在播放
          isPlayingBody.isPlaying = false;
          isPlayingBody= null;
        }
        playAudio(body);
        body.isPlaying = true;
        body.isListened = true;
        isPlayingBody = body;
      }
      else{
        stopAudio();
      }
    }
     
    //---获取评论
    //各种获取评论，带nextId是获取历史
    var getChats = function(nextId, callback) {
      var param = [$scope.chatRoom.type,$scope.chatRoom.easemobId];
      if(nextId){
        param.push(nextId);
      }
      easemob.getMessages(function (chats) {
        chats.forEach(formatChat);
        if(nextId) {
          $scope.chatsList.unshift.apply($scope.chatsList, chats );
        }
        else {
          $scope.chatsList=chats;
        }
        if(chats.length>0) {
          $scope.nextId = chats[0].msgId;
        }
        callback &&callback();
      },function (error) {
        alert(error);
        console.log(error);
      },param);
    };
    //刚进来的时候获取第一页评论
    getChats(null,function() {

      $ionicScrollDelegate.scrollBottom();
    });
    //获取更老的评论
    $scope.readHistory = function() {
      if($scope.nextId) {
        getChats($scope.nextId, function() {
          $scope.$broadcast('scroll.refreshComplete');
          $ionicScrollDelegate.scrollTo(0,1350);//此数值仅在发的评论为1行时有效...
          //如果需要精确定位到刚才的地方，需要jquery
          // $('#currentComment').scrollIntoView();//need jQuery
        });
      }else {
        $scope.$broadcast('scroll.refreshComplete');
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
    $scope.needShowTime = function (index) {
      if(index===0){
        return 1;
      }else{
        var preTime = new Date($scope.chatsList[index-1].msgTime);
        var nowTime = new Date($scope.chatsList[index].msgTime);
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
    //发布文字消息
    $scope.publish = function() {
      // if(window.analytics){
      //   window.analytics.trackEvent('Click', 'publishComment');
      // }
      
      easemob.chat(updateChat,updateChat,[{
        chatType:$scope.chatRoom.type,
        target:$scope.chatRoom.easemobId,
        contentType:'TXT',
        content:{'text':$scope.content}
        }]
      )
      $scope.content = '';
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
      if($scope.uploading) return;
      $scope.uploading = true;
      $scope.confirmUploadModal.hide();
      var _updateChat = function (chat) {
        updateChat(chat);
        $scope.uploading = false;
      }
      easemob.chat(_updateChat,_updateChat,[{
        chatType: $scope.chatRoom.type,
        target: $scope.chatRoom.easemobId,
        contentType: 'IMAGE',
        content: {'filePath': $scope.previewImg}
        }]
      );
    };

    //for pswp
    $scope.pswpId = 'chat' + Date.now();
    $scope.photos = [];

  }])
  .controller('DiscussDetailController', ['$ionicHistory', '$scope', '$state', '$stateParams', '$ionicScrollDelegate', '$ionicModal', '$rootScope', 'Comment', 'User', 'INFO',
    function ($ionicHistory, $scope, $state, $stateParams, $ionicScrollDelegate, $ionicModal, $rootScope, Comment, User, INFO) {
    $scope.campaignId = $stateParams.id;
    $scope.campaignTitle = INFO.discussName;
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
          $scope.hasMore = data.nextStartDate ? true: false;
          $scope.loading = false;
        }
        else{
          console.log(err);
          $scope.loading = false;
        }
      });
    };
    getComments({
      requestType: 'campaign',
      requestId: $scope.campaignId,
      limit: 20
    });

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
      }
    };

    //获取个人信息供发评论使用
    var currentUser;
    User.getData($scope.userId, function(err,data){
      currentUser = data;
    });
    $ionicModal.fromTemplateUrl('publish-comment.html', {
      scope: $scope,
      animation: 'slide-in-up'
    }).then(function(modal) {
      $scope.publishModal = modal;
    });
    $scope.showPublishSheet = function() {
      $scope.publishModal.show();
    };
    $scope.cancelPublish = function() {
      $scope.publishModal.hide();
    };

    $scope.data = {content:''};
    //发表评论
    $scope.publish = function() {
      // console.log($scope.content);
      if($scope.data.content) {
        if(window.analytics){
          window.analytics.trackEvent('Click', 'publishComment');
        }
        Comment.publishComment({
          'hostType': 'campaign',
          'hostId': $scope.campaignId,
          'content': $scope.data.content
        }, function(err){
          if(err){
            console.log(err);
            //发送失败
            $rootScope.showAction({titleText:err})
          }else{
            $rootScope.showAction({titleText:'留言发布成功！'})
            //-创建一个新comment
            var newComment = {
              create_date: new Date(),
              poster: {
                '_id': currentUser._id,
                'photo': currentUser.photo,
                'nickname': currentUser.nickname
              },
              content: $scope.data.content
            };
            $scope.comments.push(newComment);
            $ionicScrollDelegate.scrollBottom();
            $scope.data.content = '';
            $scope.publishModal.hide();
          }
        });
      }
    };

  }])
  .controller('CompanyController', ['$scope', '$rootScope', 'Company', 'User', function($scope, $rootScope, Company, User) {
    
    $scope.doRefresh = function (refreshFlag) {
      // 获取公司数据
      Company.getData(localStorage.cid)
        .success(function(data) {
          $scope.company = data;
          if(refreshFlag){
            $scope.$broadcast('scroll.refreshComplete');
          }
        })
        .error(function(data) {
          $rootScope.showAction({titleText:data.msg || '获取公司数据失败'})
          if(refreshFlag){
            $scope.$broadcast('scroll.refreshComplete');
          }
        });

      // 获取公司成员列表
      User.getCompanyUsers(localStorage.cid, function(err, data) {
        if (err) {
          $rootScope.showAction({titleText:err || '获取公司同事数据失败'})
        }
        else {
          $scope.staffList = data.slice(0, 3);
        }
      }, function(err, data) {
        if(err || data.length==0) {
          console.log(err);
        } else {
          $scope.staffList = data.slice(0, 3);
        }
      });
    }
    $scope.doRefresh();

  }])

  .controller('CompanyTeamListController', ['$scope', '$rootScope', '$state', '$ionicHistory', 'Team', 'INFO', function ($scope, $rootScope, $state, $ionicHistory, Team, INFO) {

    $scope.refresh = function(unRefreshFlag) {
      Team.getList('company', null, false, function (err, teams) {
        if (err) {
          // todo
          console.log(err);
        } else {
          var leadTeams = [];
          var memberTeams = [];
          var unJoinTeams = [];
          teams.forEach(function(team) {
            if(team.isLeader) {
              leadTeams.push(team);
            }
            else if(team.hasJoined){
              memberTeams.push(team);
            }
            else {
              unJoinTeams.push(team);
            }
          });
          $scope.leadTeams = leadTeams;
          $scope.memberTeams = memberTeams;
          $scope.unJoinTeams = unJoinTeams;
        }
        // unRefreshFlag ||  $scope.$broadcast('scroll.refreshComplete');
      }, function (err, teams) {
        if (err) {
          // todo
          console.log(err);
        } else {
          var leadTeams = [];
          var memberTeams = [];
          var unJoinTeams = [];
          teams.forEach(function(team) {
            if(team.isLeader) {
              leadTeams.push(team);
            }
            else if(team.hasJoined){
              memberTeams.push(team);
            }
            else {
              unJoinTeams.push(team);
            }
          });
          $scope.leadTeams = leadTeams;
          $scope.memberTeams = memberTeams;
          $scope.unJoinTeams = unJoinTeams;
        }
        unRefreshFlag ||  $scope.$broadcast('scroll.refreshComplete');
      });
    };
    $scope.refresh(true);
    $scope.joinTeam = function(tid, index) {
      if(window.analytics){
        window.analytics.trackEvent('Click', 'joinTeamInAllTeam');
      }
      Team.joinTeam(tid, localStorage.id, function(err, data) {
        if(!err) {
          $rootScope.showAction({titleText:'加入成功'})
          $scope.teams[index].hasJoined = true;
        }
        else {
          $rootScope.showAction({titleText:err})
        }
      });
    };
    $scope.quitTeam = function(tid, index) {
      if(window.analytics){
        window.analytics.trackEvent('Click', 'quitTeamInAllTeam');
      }
      Team.quitTeam(tid, localStorage.id, function(err, data) {
        if(!err) {
          $rootScope.showAction({titleText:'退出成功'})
          $scope.teams[index].hasJoined = false;
        }
        else {
          $rootScope.showAction({titleText:err})
        }
      });
    };
  }])
  .controller('AllCampaignController', ['$scope', '$state', '$timeout', '$ionicHistory', '$ionicScrollDelegate', 'TimeLine', 'INFO',
   function ($scope, $state, $timeout, $ionicHistory, $ionicScrollDelegate, TimeLine, INFO) {
    $scope.loadFinished = false;
    $scope.loading = false;
    $scope.timelinesRecord = [];
    $scope.page = 0;
    switch($state.params.type) {
      case 'company':
        $scope.title='所有活动';
        break;
      case 'team':
        $scope.title='小队所有活动';
        break;
      case 'user':
        $scope.title='个人足迹';
        break;
    }
    $scope.goBack = function() {
      if($ionicHistory.backView()){
        $ionicHistory.goBack();
      }
      else if($state.params.type=='company'){
        $state.go('app.company');
      }
      else{
        $state.go('app.personal');
      }
    };
    // 是否需要显示时间
    $scope.needShowTime = function (index) {
      if(index===0){
        return true;
      }else{
        var preTime = new Date($scope.timelinesRecord[index-1].start_time);
        var nowTime = new Date($scope.timelinesRecord[index].start_time);
        return nowTime.getDate() != preTime.getDate() || nowTime.getMonth() != preTime.getMonth()|| nowTime.getFullYear() != preTime.getFullYear() ;
      }
    };

    $scope.doRefresh = function(){
      $scope.page = 1;
      $scope.loadFinished = false;
      TimeLine.getTimelines($state.params.type, $state.params.id || localStorage.id, $scope.page, function (err, campaignsData) {
        if (err) {
          // todo
          console.log(err);
          $scope.loadFinished = true;
        } else {
          if(campaignsData.length>0) {
            $scope.timelinesRecord = campaignsData;
          }
          else {
            $scope.loadFinished = true;
          }
        }
        $scope.$broadcast('scroll.refreshComplete');
      });
    };
    $scope.loadMore = function() {
      if(!$scope.loading){
        $scope.page++;
        $scope.loading = true;
        TimeLine.getTimelines($state.params.type, $state.params.id || localStorage.id, $scope.page, function (err, campaignsData) {
          if (err) {
            // todo
            console.log(err);
            $scope.loadFinished = true;
          } else {
            if(campaignsData.length>0) {
              $scope.timelinesRecord = $scope.timelinesRecord.concat(campaignsData);
            }
            else {
              $scope.loadFinished = true;
            }
          }
          $scope.loading = false;
          $ionicScrollDelegate.$getByHandle("mainScroll").resize();
        });
      }
    };
    $scope.loadMore();
  }])
  .controller('ContactsController', ['$scope', 'User', 'INFO', 'Tools', function ($scope, User, INFO, Tools) {
    var contactsBackup = [];
    $scope.keyword = {value:''};
    $scope.doRefresh = function (refreshFlag) {
      //获取公司联系人
      User.getCompanyUsers(localStorage.cid,function(msg, data){
        if(!msg) {
          $scope.contacts = data;
          contactsBackup = data;
        }
        // if(refreshFlag){
        //   $scope.$broadcast('scroll.refreshComplete');
        // }
      }, function(msg, data) {
        if(!msg &&data.length>0) {
          $scope.contacts = data;
          contactsBackup = data;
        }
        if(refreshFlag){
          $scope.$broadcast('scroll.refreshComplete');
        }
      });
    }
    $scope.doRefresh();

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
    var getUser = function(refresh) {
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
        if(refresh) {
          $scope.$broadcast('scroll.refreshComplete');
        }
      });
    };

    $scope.doRefresh = function(refresh) {
      getUser(refresh);
    };

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
  .controller('PersonalInviteCodeController', ['$scope', 'Company', '$cordovaClipboard', '$rootScope', 'CONFIG',
   function ($scope, Company, $cordovaClipboard, $rootScope, CONFIG) {
    Company.getInviteKey(localStorage.cid, function(msg, data){
      if(!msg){
        $scope.inviteKey = data.staffInviteCode;
        var qrcode = new QRCode("inviteKeyQrCode", {
          text: CONFIG.STATIC_URL+"/users/inviteQR?key="+data.staffInviteCode+"&cid="+localStorage.cid+"&uid="+localStorage.id
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
        $rootScope.showAction({titleText:'验证码已成功复制到剪贴板'})
      }, function () {
        $rootScope.showAction({titleText:'复制验证码到剪贴板失败'})
      });
    };

  }])
  .controller('PersonalEditController', ['$scope', '$state', '$rootScope', '$ionicHistory', 'User', 'CONFIG', 'Upload',
    function ($scope, $state, $rootScope, $ionicHistory, User, CONFIG, Upload) {

    var birthdayInput = document.getElementById('birthday');

    $scope.$on('$ionicView.enter', function (scopes, states) {
      User.getData(localStorage.id, function (err, data) {
        if (err) {
          $rootScope.showAction({titleText:'获取个人信息失败'})
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
          $rootScope.showAction({titleText:err})
        }
      });
    };

    $scope.edit = function () {
      if(window.analytics){
        window.analytics.trackEvent('Click', 'editUser');
      }
      User.editData($scope.user._id, $scope.formData, function (err) {
        if (err) {
          $rootScope.showAction({titleText:err})
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
              $rootScope.showAction({titleText:'修改头像成功','cancelFun':function () {
                $state.go('app.personal');
              }});
            }else {
              $rootScope.showAction({titleText:'修改失败，请重试'})
            }
          });
        }
        else {
          $rootScope.showAction({titleText:'获取图片失败'})
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
          $scope.loadFinished = true;
        }
      }, function (err, teams) {
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
          $scope.loadFinished = true;
        }
      });
    };
    getMyTeams();
    $scope.refresh = function() {
      getMyTeams();
      $scope.$broadcast('scroll.refreshComplete');
    };

  }])
  .controller('SettingsController', ['$scope', '$state', '$ionicHistory', 'UserAuth', 'User', 'CommonHeaders', 'Chat', function ($scope, $state, $ionicHistory, UserAuth, User, CommonHeaders, Chat) {

    $scope.logout = function () {
      if(window.analytics){
        window.analytics.trackEvent('Click', 'userLogOut');
      }
      User.clearCurrentUser();
      Chat.clearChatroomList();
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
  .controller('PasswordController', ['$scope', '$rootScope', '$rootScope', 'User', function($scope, $rootScope, $rootScope, User) {
    $scope.pswData = {};
    $scope.changePwd = function() {
      $rootScope.showLoading();
      if(window.analytics){
        window.analytics.trackEvent('Click', 'changePwd');
      }
      User.editData(localStorage.id, $scope.pswData, function(msg) {
        $rootScope.hideLoading();
        if(msg){
          $rootScope.showAction({titleText:msg})
        }else{
          $rootScope.showAction({titleText:'修改成功'})
        }
      });
    };
  }])
  .controller('TabController', ['$scope', '$rootScope', '$ionicHistory', 'Socket', 'Circle', 'INFO', 'Chat', function ($scope, $rootScope, $ionicHistory, Socket, Circle, INFO, Chat) {
    //每次进入页面判断是否有新评论没看
    $rootScope.newCircleComment = 0;

    var tabsEle = document.querySelector('.app_tabs .tab-nav');

    var createSvg = function(id) {
      var svgEle = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
      svgEle.classList.add('svg_icon');
      svgEle.classList.add('svg_tab_icon');
      var useEle = document.createElementNS('http://www.w3.org/2000/svg', 'use');
      useEle.setAttributeNS('http://www.w3.org/1999/xlink', 'href', '#' + id);
      svgEle.appendChild(useEle);
      return svgEle;
    };

    var insertSvgToTabItem = function(tabClass, svgId) {
      var tabItemCampaignEle = tabsEle.querySelector('a.' + tabClass);
      tabItemCampaignEle.insertBefore(createSvg(svgId), tabItemCampaignEle.childNodes[0]);
    };

    setTimeout(function() {
      insertSvgToTabItem('tab_item_campaign', 'huodong');
      insertSvgToTabItem('tab_item_discuss', 'discussion');
      insertSvgToTabItem('tab_item_discover', 'discover');
      insertSvgToTabItem('tab_item_company', 'company');
      insertSvgToTabItem('tab_item_personal', 'mine');
    });


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
    $scope.$on('ReciveMessage',
      function (event, chat) {
        $rootScope.hasNewComment++;
    });
    $scope.$on('ReciveOfflineMessages',
      function (event, chats) {
        $rootScope.hasNewComment+=chats.length;
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
  .controller('CalendarController', ['$scope', '$rootScope', '$state', '$rootScope', '$ionicPopover', '$timeout', '$ionicHistory', 'Campaign', 'INFO',
    function($scope, $rootScope, $state, $rootScope, $ionicPopover, $timeout, $ionicHistory, Campaign, INFO) {
      $scope.pageType = $state.params.type;
      $scope.goBack = function() {
        if ($ionicHistory.backView()) {
          $ionicHistory.goBack();
        } else {
          $state.go('app.' + $state.params.type);
        }
      };

      moment.locale('zh-cn');
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
      var updateMonth = function(date, callback) {
        var date = new Date(date);
        var year = date.getFullYear();
        var month = date.getMonth();
        var mdate = moment(new Date(year, month));
        var offset = mdate.day(); // mdate.day(): Sunday as 0 and Saturday as 6
        var lastMonthDays = mdate.day(); //days of last month to show
        var now = new Date();
        $scope.current_year = year;
        $scope.current_date = date;
        var month_data = {
          date: date,
          format_month: month + 1,
          days: []
        };
        var month_dates = mdate.daysInMonth();
        Campaign.getList({
          requestType: 'user',
          requestId: $state.params.type =='userinfo' ? INFO.guestUserId :localStorage.id,
          from: new Date(year, month).getTime(),
          to: new Date(year, month + 1).getTime()
        }, function(err, data) {
          if (err) {
            $rootScope.showAction({titleText:err})
            return;
          }
          $scope.campaigns = data;
          //标记周末、今天
          for (var i = 0; i < month_dates; i++) {
            month_data.days[i] = {
              full_date: new Date(year, month, i + 1),
              date: i + 1,
              is_current_month: true,
              events: [],
              joined_events: [],
              unjoined_events: []
            };
            //由本月第一天，计算是星期几，决定位移量
            // if (i === 0) {
            //   month_data.days[0].first_day = 'offset_' + offset; // mdate.day(): Sunday as 0 and Saturday as 6
            //   month_data.offset = month_data.days[0].first_day;
            // }
            // 是否是周末
            if ((i + offset) % 7 === 6 || (i + offset) % 7 === 0)
              month_data.days[i].is_weekend = true;

            // 是否是今天
            var now = new Date();
            if (now.getDate() === i + 1 && now.getFullYear() === year && now.getMonth() === month) {
              month_data.days[i].is_today = true;
            }
          }
          var dayOperate = function(i, campaign) {
            month_data.days[i - 1].events.push(campaign);
            if (campaign.join_flag == 1) {
              month_data.days[i - 1].joined_events.push(campaign);
            } else if($scope.pageType!=='userinfo'){
              month_data.days[i - 1].unjoined_events.push(campaign);
            }
          };
          // 将活动及相关标记存入某天
          var month_start = new Date(year, month, 1);
          var month_end = new Date(year, month, 1);
          month_end.setMonth(month_end.getMonth() + 1);
          $scope.campaigns.forEach(function(campaign) {
            var start_time = new Date(campaign.start_time);
            var end_time = new Date(campaign.end_time);
            if (start_time <= month_end && end_time >= month_start) { //如果活动'经过'本月
              var day_start = start_time.getDate();
              var day_end = end_time.getDate();
              var month_day_end = month_end.getDate();
              if (start_time >= month_start) { //c>=a
                if (end_time <= month_end) { //d<=b 活动日
                  for (i = day_start; i < day_end + 1; i++)
                    dayOperate(i, campaign);
                } else { //d>b 开始日到月尾
                  for (i = day_start; i < month_dates + 1; i++)
                    dayOperate(i, campaign);
                }
              } else { //c<a
                if (end_time <= month_end) { //d<=b 月首到结束日
                  for (i = 1; i < day_end + 1; i++)
                    dayOperate(i, campaign);
                } else { //d>b 每天
                  for (i = 1; i < month_dates + 1; i++)
                    dayOperate(i, campaign);

                }
              }
            }
            // campaign.format_start_time = moment(campaign.start_time).calendar();
            // campaign.format_end_time = moment(campaign.end_time).calendar();
          });
          
          if(lastMonthDays) {
            var lastMonthDate;
            if(month === 0) {
              lastMonthDate = moment(new Date(year - 1, 11));
            } else {
              lastMonthDate = moment(new Date(year, month - 1));
            }
            var lastMonthDaysLength = lastMonthDate.daysInMonth();
            for(var i = 0; i < lastMonthDays; i++) {
              month_data.days.unshift({
                full_date: null,
                date: lastMonthDaysLength - i,
                is_current_month: false,
                events: [],
                joined_events: [],
                unjoined_events: []
              });
            }
          }

          var currentMonthLastDay = moment(new Date(year, month, mdate.daysInMonth())).day();
          for(var i = 0; i < 6 - currentMonthLastDay; i++) {
            month_data.days.push({
              full_date: null,
              date: i + 1,
              is_current_month: false,
              events: [],
              joined_events: [],
              unjoined_events: []
            });
          }

          $scope.current_month = month_data;

          if (!$scope.$$phase) {
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
        var year = date.getFullYear();
        var month = date.getMonth();
        var mdate = moment(new Date(year, month));
        var lastMonthDays = mdate.day(); //days of last month to show
        $scope.view = 'day';
        if (date.getMonth() !== current.getMonth() || !$scope.campaigns) {
          updateMonth(date, function() {
            updateDay(date);
          });
          return false;
        } else {
          current = date;
          $scope.current_date = date;
          INFO.lastDate = date;
          var events = [];
          var events_joined = [];
          var events_unjoined = [];
          $scope.current_month.days[current.getDate() + lastMonthDays - 1].events.forEach(function(event) {
            events.push(event);
            if (event.join_flag == 1) {
              events_joined.push(event);
            } else if($scope.pageType!=='userinfo') {
              events_unjoined.push(event);
            }
          });
          var day = {
            date: current,
            past_flag: current < now,
            format_date: moment(current).format('ll'),
            format_day: moment(current).format('dddd'),
            campaigns: events,
            campaigins_joined: events_joined,
            campaigins_unjoined: events_unjoined
          };

          var temp = new Date(date);
          var first_day_of_week = new Date(temp.setDate(temp.getDate() - temp.getDay()));
          $scope.current_week_date = [];
          for (var i = 0; i < 7; i++) {
            $scope.current_week_date.push(new Date(first_day_of_week.setDate(first_day_of_week.getDate())));
            first_day_of_week.setDate(first_day_of_week.getDate() + 1);
            var week_date = $scope.current_week_date[i];
            var now = new Date();
            week_date.is_current_month = false;
            if (week_date.getFullYear() === now.getFullYear() && week_date.getMonth() === now.getMonth() && week_date.getDate() === now.getDate()) {
              week_date.is_today = true;
            }
            if (week_date.getFullYear() === current.getFullYear() && week_date.getMonth() === current.getMonth()) {
              week_date.is_current_month = true;
              if (week_date.getDate() === current.getDate()) {
                week_date.is_current = true;
              }
              var events = [];
              var joined_events = [];
              var unjoined_events = [];
              $scope.current_month.days[week_date.getDate() + lastMonthDays - 1].events.forEach(function(event) {
                events.push(event);
                if (event.join_flag == 1) {
                  joined_events.push(event);
                } else if($scope.pageType!=='userinfo') {
                  unjoined_events.push(event);
                }
              });
              week_date.events = events;
              week_date.joined_events = joined_events;
              week_date.unjoined_events = unjoined_events;
            }
          }
          $scope.current_day = day;
          if (!$scope.$$phase) {
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
        var date = new Date(date);
        if(date.getMonth() !== current.getMonth()) {
          return;
        }
        updateDay(date);
        $scope.view = 'day';
      };


      $scope.nextMonth = function() {
        var temp = $scope.current_date;
        temp.setMonth(temp.getMonth() + 1);
        current = new Date(temp);
        updateMonth(temp);
      };

      $scope.preMonth = function() {
        var temp = $scope.current_date;
        temp.setMonth(temp.getMonth() - 1);
        current = new Date(temp);
        updateMonth(temp);
      };

      $scope.nextDay = function() {
        var temp = $scope.current_date;
        temp.setDate(temp.getDate() + 1);
        updateDay(temp);
      };

      $scope.preDay = function(day) {
        var temp = $scope.current_date;
        temp.setDate(temp.getDate() - 1);
        updateDay(temp);

      };

      if ($scope.view == 'month') {
        updateMonth(current);
      } else if ($scope.view == 'day') {
        updateDay(current);
      }

    }
  ])
  .controller('PrivacyController', ['$scope', '$ionicNavBarDelegate', function ($scope, $ionicNavBarDelegate) {
    $scope.backHref = '#/settings/about';
  }])
  .controller('CompRegPrivacyController', ['$scope', '$ionicNavBarDelegate', function ($scope, $ionicNavBarDelegate) {
    $scope.backHref = '#/register/company';
  }])
  .controller('UserRegPrivacyController', ['$scope', '$ionicNavBarDelegate', 'INFO', function ($scope, $ionicNavBarDelegate, INFO) {
    $scope.backHref = '#/register/user/post_detail/' + INFO.companyId;
  }])
  .controller('HrSignupController' ,['$scope', '$state', '$rootScope', 'CompanySignup', 'Region', 'CONFIG', 'INFO', function ($scope, $state, $rootScope, CompanySignup, Region, CONFIG, INFO) {
    $scope.$on('$ionicView.enter', function(scopes, states) {
      $scope.email = INFO.email;
      $scope.recommandCompany = null;
      $scope.name = '';
      $scope.password = '';
      // console.log($scope.email);
    });
    var arrayObjectIndexOf = function (myArray, searchTerm, property) {
      var _property = property.split('.');
      for(var i = 0, len = myArray.length; i < len; i++) {
        var item = myArray[i];
        _property.forEach( function (_pro) {
          item = item[_pro];
        });
        if (item.toString() === searchTerm.toString()) return i;
      }
      return -1;
    }

    
    Region.getRegion(function(status, data) {
      $scope.provinces = data.data;
      $scope.province = $scope.provinces[0];
      changeProvince();
      Region.getCurrentRegion(function(status, data) {
        var detail = data.content.address_detail;
        var province = detail.province;
        var city = detail.city;
        var district = detail.district;
        if (province) {
          var provinceIndex = arrayObjectIndexOf($scope.provinces, province, 'value');
          if (provinceIndex > -1) {
            $scope.province = $scope.provinces[provinceIndex];
            changeProvince();
            if (city) {
              var cityIndex = arrayObjectIndexOf($scope.cities, city, 'value');
              if (cityIndex > -1) {
                $scope.city = $scope.cities[cityIndex];
                changeCity();
                if (district) {
                  var districtIndex = arrayObjectIndexOf($scope.districts, district, 'value');
                  $scope.district = $scope.districts[districtIndex];
                }
              }
            }
          }
        }
      });
    });

    var changeProvince = function() {
      $scope.cities = $scope.province.data;
      $scope.city = $scope.cities[0];
      changeCity();
    }
    var changeCity = function() {
      $scope.districts = $scope.city.data;
      $scope.district = $scope.districts[0];
    }
    $scope.selcetProvince = function(province) {
      $scope.province = province;
      changeProvince();
    };
    $scope.selectCity = function(city) {
      $scope.city = city;
      changeCity();
    };

    //提交表单数据
    $scope.signup = function() {
      $rootScope.showLoading();
      if(window.analytics){
        window.analytics.trackEvent('Click', 'companySignUp');
      }
      var data = {
        name: $scope.name,
        province: $scope.province.value,
        city: $scope.city.value,
        district: $scope.district.value,
        email: $scope.email,
        password: $scope.password
      };
      CompanySignup.quickSignup(data, function(err, data){
        $rootScope.hideLoading();
        if(err){
          $rootScope.showAction({titleText:err})
        }else{
          INFO.uid = data.uid;
          $state.go('register_company_team');
        }
      });
    };
    // //validate
    // var pattern =  /^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$/;
    // $scope.reg = true;
    // $scope.mailRegCheck = function() {
    //   $scope.reg = (pattern.test($scope.email));
    // };
    // $scope.mailCheck = function() {
    //   if($scope.reg&&$scope.email){
    //     CompanySignup.validate($scope.email, null, function(msg){
    //       if(!msg){
    //         $scope.mail_error = false;
    //         $scope.mail_msg = '该邮箱可以使用';
    //       }else{
    //         $scope.mail_error = true;
    //         $scope.mail_msg = '该邮箱已存在或您输入的邮箱有误'
    //       }
    //       $scope.mail_check = true;
    //     });
    //   }
    // };

    $scope.nameCheck = function() {
      if($scope.name) {
        CompanySignup.validate($scope.email, $scope.name, function(msg, data){
          if(data.validate !== undefined && data.validate === 0) {
            $scope.recommandCompany = {
              _id: data.cid,
              name: $scope.name
            };
            $scope.domain = data.domain;
          } else if(data.validate !== undefined && data.validate === 3) {
            $scope.recommandCompany = '';
          }
        });
      }
    };

    $scope.ignoreRecommand = function() {
      $scope.recommandCompany = null;
    };
    $scope.changeEmail = function() {
      $state.go('register_user_searchCompany');
    };

    $scope.select = function(company) {
      INFO.companyId = company._id;
      INFO.companyName = company.name;
      INFO.email = $scope.email;
      $state.go('register_user_postDetail',{cid:company._id});
    };
    $scope.preStep = function() {
      $state.go('register_user_searchCompany');
    }
  }])
  .controller('HrSignupTeamController', ['$scope', '$state', '$rootScope', 'CompanySignup', 'Team', 'CONFIG', 'INFO', function($scope, $state, $rootScope, CompanySignup, Team, CONFIG, INFO) {
    $scope.$on('$ionicView.enter', function(scopes, states) {
      Team.getGroups(function(status, data) {
        $scope.groups = data.splice(0, 16);
      });
      $scope.uid = INFO.uid;
    });
    
    $scope.selectType = function(index) {
      $scope.groups[index].selected = !$scope.groups[index].selected;
    };

    $scope.createTeams = function() {
      $rootScope.showLoading();
      var selectedGroups = $scope.groups.filter(function(group) {
        return group.selected === true;
      });
      CompanySignup.quickSignupTeams({
            groups: selectedGroups,
            uid: $scope.uid
          }, function(err, data) {
            $rootScope.hideLoading();
            if (err) {
              $rootScope.showAction({
                titleText: err
              })
            } else {
              $state.go('register_success');
            }
        });
    }
  }])
  .controller('ResendEamilController', ['$scope', '$state', '$rootScope', 'UserSignup', 'Team', 'CONFIG', 'INFO', function($scope, $state, $rootScope, UserSignup, Team, CONFIG, INFO) {
    $scope.$on('$ionicView.enter', function(scopes, states) {
      // console.log(INFO.emailActive);
      $scope.email = INFO.emailActive;
    });
    
    $scope.resend = function() {
      $rootScope.showLoading();
      UserSignup.resendActiveEmail({email: $scope.email}, function(msg, data) {
        $rootScope.hideLoading();
        if(!msg) {
          $state.go('register_success');
        } else {
          $rootScope.showAction({titleText:msg})
        }
      });
    };
  }])
  .controller('UserSearchCompanyController', ['$scope', '$state', 'UserSignup','INFO', function ($scope, $state, UserSignup, INFO) {
    $scope.$on('$ionicView.enter', function(scopes, states) {
        $scope.companyEmail.value = '';
    });
    $scope.companyEmail = {};
    var pattern = /^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$/;
    $scope.checkMail = function(keyEvent) {
      if ((!keyEvent || keyEvent.which === 13) && $scope.companyEmail.value) {
        var reg = (pattern.test($scope.companyEmail.value))
        if (reg) {
          $scope.loading = true;
          UserSignup.validate($scope.companyEmail.value, null, null, function(msg, data) {
            $scope.loading = false;
            if(data.active == 1) { //未注册过
              INFO.hideInviteKey = data.hideInviteKey;
              INFO.email = $scope.companyEmail.value;
              searchCompany();
            } else if(data.active == 2) { //邮箱注册但未激活
              INFO.emailActive = $scope.companyEmail.value;
              $state.go('register_user_waitEmail');
            } else { // 邮箱已激活、并注册完毕
              $state.go('register_login');
            }

          });
        } else {
          $scope.companyEmail.value = '';
        }
      }
    };

    var searchCompany = function() {
      UserSignup.searchCompany($scope.companyEmail.value, 1, 4, function(msg, data) {
        if (!msg) {
          if(data.companies === undefined || data.companies.length === 0) {
            $state.go('register_company_notfound');
          } else {
            $state.go('register_company_list');
          }
        }
      });
    };
  }])
  .controller('RegisterCompanyListController', ['$scope', '$state', 'UserSignup','INFO', function ($scope, $state, UserSignup, INFO) {
    $scope.$on('$ionicView.enter', function(scopes, states) {
      // console.log(INFO.email);
      $scope.email = INFO.email;
      UserSignup.searchCompany(INFO.email, 1, 4, function(msg, data) {
        if (!msg) {
          if (data.companies === undefined || data.companies.length === 0) {
            $state.go('register_company_notfound');
          } else {
            $scope.page = 1;
            $scope.companies = data.companies;
            if ($scope.page === data.pageCount) {
              $scope.hasNext = false;
            } else {
              $scope.hasNext = true;
            }
            $scope.hasPrevious = false;
          }
        }
      });
    });

    $scope.preStep = function() {
      $state.go('register_user_searchCompany');
    }

    $scope.nextPage = function() {
      if($scope.hasNext) {
        UserSignup.searchCompany($scope.email, $scope.page + 1, 4, function(msg, data) {
          if (!msg) {
            $scope.page ++;
            $scope.companies = data.companies;
            if($scope.page === data.pageCount) {$scope.hasNext = false;}
            $scope.hasPrevious = true;
          }
        });
      }
    };
    $scope.prePage = function() {
      if($scope.hasPrevious) {
        UserSignup.searchCompany($scope.email, $scope.page - 1, 4, function(msg, data) {
          if (!msg) {
            $scope.companies=data.companies;
            $scope.hasNext = true;
            $scope.page--;
            if($scope.page===1) {$scope.hasPrevious = false;}
          }
        });
      }
    };
    $scope.organize = function() {
      $state.go('register_company');
    }
    $scope.goDetail = function(company) {
      INFO.companyId = company._id;
      INFO.companyName = company.name;
      if(company.mail_active){
        $state.go('register_user_postDetail',{cid:company._id});
      }else{
        $state.go('register_user_remind_activate');
      }
    };
  }])
  .controller('UserRegisterDetailController', ['$scope', '$rootScope', '$state', 'UserSignup', 'INFO', function ($scope, $rootScope, $state, UserSignup, INFO) {
    $scope.$on('$ionicView.enter', function(scopes, states) {
      // console.log(INFO.email);
      $scope.data = {};
      $scope.data.cid = INFO.companyId;
      $scope.data.email = INFO.email;
      $scope.companyName = INFO.companyName;
      $scope.hideInviteKey = INFO.hideInviteKey;
      if ($scope.hideInviteKey) {
        $scope.invitekeyCheck = 1;
      }
    });
    $scope.signup = function() {
      $rootScope.showLoading();
      if(window.analytics){
        window.analytics.trackEvent('Click', 'userSignUp');
      }
      UserSignup.signup($scope.data, function(msg, data) {
        $rootScope.hideLoading();
        if(!msg){
          $state.go('register_success');
        }else{
          $rootScope.showAction({titleText:msg})
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
  .controller('HrActiveCodeController', ['$scope', 'Company', '$cordovaClipboard', '$rootScope', function ($scope, Company, $cordovaClipboard, $rootScope) {
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
        $rootScope.showAction({titleText:'验证码已成功复制到剪贴板'})
      }, function () {
        $rootScope.showAction({titleText:'复制验证码到剪贴板失败'})
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

    $scope.$on('$ionicView.enter', function(scopes, states) {
      // 为true或undefined时获取公司数据
      if (INFO.hasModifiedTeam !== false) {
        INFO.hasModifiedTeam = false;
        Company.getTeams(localStorage.id, 'team', $stateParams.type, function(msg, data) {
          if(!msg){
            $scope.teams = data;
          }
        });
      }
    });

    $scope.editTeam = function (team) {
      INFO.team = team;
      $state.go('hr_editTeam',{teamId:team._id});
    };
  }])
  // hr查看同事资料
  .controller('HrColleagueListController', ['$scope', 'INFO', 'User', 'Tools', function ($scope, INFO, User, Tools) {
    var contactsBackup = [];
    $scope.keyword = {value:''};
    //获取公司联系人
    User.getCompanyUsers(localStorage.id,function(msg, data){
      if(!msg) {
        $scope.contacts = data;
        contactsBackup = data;
      }
    }, function(msg, data) {
      if(!msg &&data.length>0) {
        $scope.contacts = data;
        contactsBackup = data;
      }
    });
    $scope.cancelSearch = function () {
      $scope.contacts = contactsBackup;//还原
      $scope.searching = false;
      $scope.keyword.value = '';
      $scope.message = '';
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
  // hr查看公司资料
  .controller('HrCompanyController', ['$scope', '$rootScope', '$state', '$stateParams', 'INFO', 'Company', function ($scope, $rootScope, $state, $stateParams, INFO, Company) {
    // 获取公司数据
    Company.getData(localStorage.id)
      .success(function(data) {
        $scope.company = data;
      })
      .error(function(data) {
        $rootScope.showAction({titleText:data.msg || '获取公司数据失败'})
      });

    $scope.$on('$ionicView.enter', function(scopes, states) {
      // 为true或undefined时获取公司数据
      if (INFO.hasModifiedCompany !== false) {
        INFO.hasModifiedCompany = false;
        Company.getData(localStorage.id)
          .success(function(data) {
            $scope.company = data;
          })
          .error(function(data) {
            $rootScope.showAction({titleText:data.msg || '获取公司数据失败'})
          });
      }
    });
  }])
  // hr编辑公司资料
  .controller('HrCompanyEditController', ['$scope', '$state', '$stateParams', '$rootScope', 'INFO', 'Company', 'Upload', 'CONFIG', function ($scope, $state, $stateParams, $rootScope, INFO, Company, Upload, CONFIG) {
    // 获取公司数据
    Company.getData(localStorage.id)
      .success(function(data) {
        $scope.company = data;
        $scope.formData = {
          intro: $scope.company.intro || '',
          name: $scope.company.shortName || ''
        };
      })
      .error(function(data) {
        $rootScope.showAction({titleText:data.msg || '获取公司数据失败'});
      });

    var introduceTextarea = document.getElementById('edit_company_introduce_textarea');
    var shortNameInput = document.getElementById('edit_company_short_name');
    $scope.editing = false;

    var updateFormData = function () {
      $scope.formData = {
        intro: $scope.company.intro || '',
        name: $scope.company.shortName || ''
      };
    };

    $scope.toEditing = function (item) {
      if ($scope.editing === false) {
        $scope.editing = true;
        // if(item==='shortName'){
        //   shortNameInput.focus();
        // }
        // else{
        //   introduceTextarea.focus();
        // }
        
      }
      //$scope.change();
    };
    $scope.cancelEditing = function () {
      if ($scope.editing === true) {
        updateFormData();
        $scope.editing = false;
      }
    };

    var refreshCompanyData = function (callback) {
      Company.getData(localStorage.id)
      .success(function (data, status) {
        $scope.company = data;
        callback && callback(data);
      })
      .error(function (data, status) {
        callback('error');
      });
    };

    $scope.changed = false;
    $scope.change = function() {
      $scope.changed = true;
      introduceTextarea.style.height = 'auto';
      introduceTextarea.style.height = introduceTextarea.scrollHeight + "px";
    };

    $scope.edit = function () {
      $scope.change();
      if (!$scope.changed) {
        $scope.editing = false;
        return;
      }
      if(window.analytics){
        window.analytics.trackEvent('Click', 'leaderEditTeam');
      }
      $scope.editingLock = true;
      Company.edit(localStorage.id, $scope.formData, function (err) {
        if (err) {
          $rootScope.showAction({titleText:err})
        } else {
          $rootScope.showAction({titleText: '编辑成功'});
          refreshCompanyData(function (data) {
            updateFormData();
            $scope.editingLock = false;
            INFO.hasModifiedCompany = true;
          });
          $scope.editing = false;
        }
      });
    };

    $scope.showUploadActionSheet = function () {
      Upload.getPicture(true, function (err, imageURI) {//取图
        if(!err) {
          var addr = CONFIG.BASE_URL + '/companies/' + localStorage.id;
          Upload.upload('logo', addr, {imageURI:imageURI}, function(err) {//上传
            if(window.analytics){
              window.analytics.trackEvent('Click', 'hrEditCompanyLogo');
            }
            if(!err){
              $rootScope.showAction({titleText:'修改logo成功'})
              INFO.hasModifiedCompany = true;
              refreshCompanyData();
            } else {
              $rootScope.showAction({titleText:'修改失败，请重试'})
            }
          });
        }
      });
    };
    $scope.showUploadActionSheetForCompanyCover = function () {
      Upload.getPicture(true, function (err, imageURI) {//取图
        if(!err) {
          var addr = CONFIG.BASE_URL + '/companies/' + localStorage.id + '/companyCover';
          Upload.upload('cover', addr, {imageURI:imageURI}, function(err) {//上传
            if(window.analytics){
              window.analytics.trackEvent('Click', 'hrEditCompanyCover');
            }
            if(!err){
              $rootScope.showAction({titleText:'修改封面成功'})
              refreshCompanyData();
              INFO.hasModifiedCompany = true;
            } else {
              $rootScope.showAction({titleText:'修改失败，请重试'})
            }
          });
        }
      });
    };
  }])
  //-hr编辑小队信息
  .controller('HrEditTeamController', ['$scope', '$rootScope', '$ionicActionSheet', '$timeout', 'INFO', 'Team', 'User', function ($scope, $rootScope, $ionicActionSheet, $timeout, INFO, Team, User) {
    $scope.formData = {name: INFO.team.name};
    $scope.memberName = {};
    var teamMembersBackup = [];//切换组员、公司成员用 全部组员备份
    var allMembers = [];//切换组员、公司成员用  全部成员备份
    var originLeader = {};
    var getTeamMembers = function () {//获取小队成员
      Team.getMembers(INFO.team._id, function(err, team){
        originLeader = team.leaders[0];
        $scope.nowLeader = team.leaders[0];
        $scope.newLeader = team.leaders[0];
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
          $rootScope.showAction({titleText:err})
        }else{
          $rootScope.showAction({titleText:'编辑成功'})
          getTeamMembers();
          $scope.editing = false;
        }
      });

    };

    $scope.point = function (person) {//指定某人为队长
      $scope.newLeader = person;
      $rootScope.showAction({type:1,titleText:'你确定更换队长吗?',
        cancelFun:function () {
          $scope.newLeader = $scope.nowLeader;
        },
        fun:function () {
          $scope.formData.leader = $scope.newLeader;
          Team.edit(INFO.team._id, $scope.formData, function(err) {
            if (err) {
              $ionicPopup.alert({
                title: '编辑失败',
                template: err
              });
            } else {
              getTeamMembers();
              $scope.nowLeader = person;
              INFO.hasModifiedTeam = true;
            }
          });
        }
      })
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
          // getAllMembers = true;
          // membersBackup = allMembers
        }, function(err, data) {
          if(data.length>0) {
            allMembers = data;
            $scope.members = allMembers;
          }
          getAllMembers = true;
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
  .controller('FeedbackController', ['$scope', '$rootScope', '$rootScope', 'User', function ($scope, $rootScope, $rootScope, User) {
    $scope.opinion = {};
    $scope.feedback = function () {
      $rootScope.showLoading();
      if(window.analytics){
        window.analytics.trackEvent('Click', 'feedBack');
      }
      User.feedback($scope.opinion.content, function(msg) {
        if(msg){
          $rootScope.showAction({titleText:'发送错误请重试。'})
        }else{
          $rootScope.showAction({titleText:'感谢您的反馈。'})
          $scope.opinion.content = '';
        }
        $rootScope.hideLoading();
      });
    };
  }])
  .controller('TeamController', ['$ionicHistory', '$rootScope', '$scope', '$state', '$stateParams', '$rootScope', '$window', 'Team', 'Campaign', 'Tools', 'INFO', '$ionicSlideBoxDelegate', 'User', function ($ionicHistory, $rootScope, $scope, $state, $stateParams, $rootScope, $window, Team, Campaign, Tools, INFO, $ionicSlideBoxDelegate, User) {
    var teamId = $stateParams.teamId;
    
    $scope.goBack = function() {
      if($ionicHistory.backView()){
        $ionicHistory.goBack();
      }
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
          }
        });
      }

      var latestCount = 3;
      var options = {
        requestType: 'team',
        requestId: teamId,
        sortBy: '-start_time -_id',
        limit: latestCount
      };
      Campaign.getList(options, function (err, campaigns) {
        if (err) {
          // todo
          console.log(err);
        } else {
          $scope.latestCampaigns = campaigns;
        }
      });
    });
    $scope.goLocation = function (index) {
      var homecourt = $scope.homeCourts[index]
      if(!homecourt || !homecourt.loc){
        return;
      }
      INFO.locationContent = {name:homecourt.name,coordinates:homecourt.loc.coordinates};
      $state.go('location',{id:homecourt._id})
    }
    $scope.updatePersonalTeam = function (tid) {
      Team.updatePersonalTeam(tid, function (err, data) {
        if (!err) {
          $rootScope.showAction({titleText:data.msg})
          $scope.team.level = data.level;
        }
        else {
          $rootScope.showAction({titleText:err})
        }
      });
    };
    $scope.joinTeam = function (tid) {
      if(window.analytics){
        window.analytics.trackEvent('Click', 'joinTeamInTeamDetail');
      }
      Team.joinTeam(tid, localStorage.id, function (err, data) {
        if (!err) {
          $rootScope.showAction({titleText:'加入成功'})
          $scope.team.hasJoined = true;
        }
        else {
          $rootScope.showAction({titleText:err})
        }
      });
    };
    $scope.quitTeam = function (tid) {
      if(window.analytics){
        window.analytics.trackEvent('Click', 'quitTeamInTeamDetail');
      }
      Team.quitTeam(tid, localStorage.id, function (err, data) {
        if (!err) {
          $rootScope.showAction({titleText:'退出成功'})
          $scope.team.hasJoined = false;
        }
        else {
          $rootScope.showAction({titleText:err})
        }
      });
    };
    $scope.selectHomeCourt = function (index) {
      $scope.homeCourtIndex = index;
    };

  }])
  .controller('TeamEditController', ['$scope', '$ionicModal', '$rootScope', '$ionicHistory', '$stateParams', 'Team', 'CONFIG', 'INFO', 'Upload',
    function ($scope, $ionicModal, $rootScope, $ionicHistory, $stateParams, Team, CONFIG, INFO, Upload) {
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
      // if (!$scope.changed) {
      //   $scope.editing = false;
      //   return;
      // }
      if(window.analytics){
        window.analytics.trackEvent('Click', 'leaderEditTeam');
      }
      $scope.editingLock = true;
      Team.edit($scope.team._id, $scope.formData, function (err) {
        if (err) {
          $rootScope.showAction({titleText:err})
        } else {
          INFO.hasModifiedTeam = true;
          refreshTeamData(function (team) {
            updateFormData();
            $scope.editingLock = false;
          });
          $scope.editing = false;
          $rootScope.showAction({titleText:'编辑成功'})
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
              $rootScope.showAction({titleText:'修改logo成功'})
              refreshTeamData();
            } else {
              $rootScope.showAction({titleText:'修改失败，请重试'})
            }
          });
        }
      });
    };

    // 修改小队封面
    $scope.showUploadFamilyActionSheet = function() {
      Upload.getPicture(false, function(err, imageURI) {
        if (!err) {
          if(window.analytics){
            window.analytics.trackEvent('Click', 'uploadFamilyPhoto');
          }
          var addr = CONFIG.BASE_URL + '/teams/' + $scope.team._id + '/family_photos';
          Upload.upload('family', addr, {imageURI: imageURI}, function(err) {
            if(!err) {
              $rootScope.showAction({titleText:'修改成功'})
              refreshTeamData();
            }
            else {
              $rootScope.showAction({titleText:'修改失败，请重试'})
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
  .controller('PhotoAlbumDetailController', ['$ionicHistory', '$scope', '$state', '$stateParams', '$rootScope', '$ionicModal', '$ionicLoading', 'PhotoAlbum', 'Tools', 'INFO', 'CONFIG', 'Upload',
    function ($ionicHistory, $scope, $state, $stateParams, $rootScope, $ionicModal, $ionicLoading, PhotoAlbum, Tools, INFO, CONFIG, Upload) {
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
            $rootScope.showAction({titleText:'上传照片成功',
              cancelFun:function () {
                $scope.confirmUploadModal.hide();
                getPhotos();
              }
            })
          } else {
            $rootScope.showAction({titleText:'上传失败，请重试'})
          }
        });
      };
  }])
  .controller('FamilyPhotoController', ['$ionicHistory', '$rootScope', '$scope', '$stateParams', '$ionicPopup', '$ionicModal', '$ionicLoading', '$ionicActionSheet', 'INFO', 'Team', 'CONFIG', 'Tools', 'Upload',
    function ($ionicHistory, $rootScope, $scope, $stateParams, $ionicPopup, $ionicModal, $ionicLoading, $ionicActionSheet, INFO, Team, CONFIG, Tools, Upload) {
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
        $rootScope.showAction({type:1,titleText:'确定要从封面中移除这张照片吗？',
          fun:function () {
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
        })
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
            $rootScope.showAction({titleText:'上传照片成功',
              cancelFun:function () {
                $scope.confirmUploadModal.hide();
                getPhotos();
              }
            })
          }else {
            $scope.confirmUploadModal.hide();
            $rootScope.showAction({titleText:'上传失败，请重试'})
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
        return nowTime.getFullYear() != preTime.getFullYear() || nowTime.getMonth() != preTime.getMonth() || nowTime.getDay() != preTime.getDay();
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
  .controller('UserInfoController', ['$ionicHistory', '$scope', '$rootScope', '$state', '$stateParams', '$ionicPopover', 'Tools', 'User', 'CONFIG', 'INFO', 'Team','Circle', 'Campaign', 'Chat',
    function ($ionicHistory, $scope, $rootScope, $state, $stateParams, $ionicPopover, Tools, User, CONFIG, INFO, Team, Circle, Campaign, Chat) {
    $scope.nowTab ='team';
    var getMyTeams = function() {
      Team.getList('user', $state.params.userId || localStorage.id, null, function (err, teams) {
        if (err) {
          // todo
          console.log(err);
          $scope.myTeams =[]
        } else {
          $scope.myTeams = teams;
        }
      }, function (err, teams) {
        if (err || teams.length==0) {
          // todo
          console.log(err);
        } else {
          $scope.myTeams = teams;
        }
      });
    };
    getMyTeams();
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
    $scope.goChat = function () {
      INFO.chatroom = {
        'easemobId': $scope.user._id,
        'logo':$scope.user.photo,
        'name': $scope.user.nickname,
        'isGroup':false
      };
      $state.go('chat',{chatroomId: $scope.user._id});
      
      $scope.popover.hide();
    }
    var pageLength = 20; // 一次获取的数据量

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
          }

          $scope.$broadcast('scroll.infiniteScrollComplete');
        })
        .error(function(data, status) {
          if (status !== 404) {
            $rootScope.showAction({titleText:data.msg || '获取失败'})
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

    $scope.onClickContentImg = function(images, img) {
      $scope.pswpCtrl.init(images, img);
    };
    // 用于保存已经获取到的同事圈内容
    $scope.circleContentList = [];

    $scope.loadingStatus = {
      hasInit: false, // 是否已经获取了一次内容
      hasMore: false, // 是否还有更多内容，决定infinite-scroll是否在存在
      loading: false // 是否正在加载更多，如果是，则会保护防止连续请求
    };
    var getCirecle=function () {
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
        })
        .error(function(data, status) {
          if (status !== 404) {
            $rootScope.showAction({titleText:data.msg || '获取失败'})
          }
          else {
            $scope.loadingStatus.hasInit = true;
          }
        });
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

    /**
     * 更新日历的月视图, 并返回该存放该月相关数据的对象, 不会更新current对象
     * @param  {Date} date
     * @return {Object}
     */
    var updateMonth = function(date, callback) {
      var date = new Date(date);
      var year = date.getFullYear();
      var month = date.getMonth();
      var mdate = moment(new Date(year, month));
      var offset = mdate.day(); // mdate.day(): Sunday as 0 and Saturday as 6
      var lastMonthDays = mdate.day(); //days of last month to show
      var now = new Date();
      $scope.current_year = year;
      $scope.current_date = date;
      var month_data = {
        date: date,
        format_month: month + 1,
        days: []
      };
      
      var month_dates = mdate.daysInMonth();
      Campaign.getList({
        requestType: 'user',
        requestId: $stateParams.userId,
        from: new Date(year, month).getTime(),
        to: new Date(year, month + 1).getTime()
      }, function(err, data) {
        if (err) {
          $rootScope.showAction({titleText:err})
          return;
        }
        $scope.campaigns = data;
        //标记周末、今天
        for (var i = 0; i < month_dates; i++) {
          month_data.days[i] = {
            full_date: new Date(year, month, i + 1),
            date: i + 1,
            is_current_month: true,
            events: [],
            joined_events: [],
            unjoined_events: []
          };
          //由本月第一天，计算是星期几，决定位移量
          // if (i === 0) {
          //   month_data.days[0].first_day = 'offset_' + offset; // mdate.day(): Sunday as 0 and Saturday as 6
          //   month_data.offset = month_data.days[0].first_day;
          // }
          // 是否是周末
          if ((i + offset) % 7 === 6 || (i + offset) % 7 === 0)
            month_data.days[i].is_weekend = true;

          // 是否是今天
          var now = new Date();
          if (now.getDate() === i + 1 && now.getFullYear() === year && now.getMonth() === month) {
            month_data.days[i].is_today = true;
          }
        }
        var dayOperate = function(i, campaign) {
          if (1== campaign.join_flag) {
            month_data.days[i - 1].events.push(campaign);
            if (campaign.join_flag == 1) {
              month_data.days[i - 1].joined_events.push(campaign);
            }
            //  else {
            //   month_data.days[i - 1].unjoined_events.push(campaign);
            // }
          }
        };
        // 将活动及相关标记存入某天
        var month_start = new Date(year, month, 1);
        var month_end = new Date(year, month, 1);
        month_end.setMonth(month_end.getMonth() + 1);
        $scope.campaigns.forEach(function(campaign) {
          var start_time = new Date(campaign.start_time);
          var end_time = new Date(campaign.end_time);
          if (start_time <= month_end && end_time >= month_start) { //如果活动'经过'本月
            var day_start = start_time.getDate();
            var day_end = end_time.getDate();
            var month_day_end = month_end.getDate();
            if (start_time >= month_start) { //c>=a
              if (end_time <= month_end) { //d<=b 活动日
                for (i = day_start; i < day_end + 1; i++)
                  dayOperate(i, campaign);
              } else { //d>b 开始日到月尾
                for (i = day_start; i < month_dates + 1; i++)
                  dayOperate(i, campaign);
              }
            } else { //c<a
              if (end_time <= month_end) { //d<=b 月首到结束日
                for (i = 1; i < day_end + 1; i++)
                  dayOperate(i, campaign);
              } else { //d>b 每天
                for (i = 1; i < month_dates + 1; i++)
                  dayOperate(i, campaign);

              }
            }
          }
          // campaign.format_start_time = moment(campaign.start_time).calendar();
          // campaign.format_end_time = moment(campaign.end_time).calendar();
        });
        
        if(lastMonthDays) {
          var lastMonthDate;
          if(month === 0) {
            lastMonthDate = moment(new Date(year - 1, 11));
          } else {
            lastMonthDate = moment(new Date(year, month - 1));
          }
          var lastMonthDaysLength = lastMonthDate.daysInMonth();
          for(var i = 0; i < lastMonthDays; i++) {
            month_data.days.unshift({
              full_date: null,
              date: lastMonthDaysLength - i,
              is_current_month: false,
              events: [],
              joined_events: [],
              unjoined_events: []
            });
          }
        }

        var currentMonthLastDay = moment(new Date(year, month, mdate.daysInMonth())).day();
        for(var i = 0; i < 6 - currentMonthLastDay; i++) {
          month_data.days.push({
            full_date: null,
            date: i + 1,
            is_current_month: false,
            events: [],
            joined_events: [],
            unjoined_events: []
          });
        }

        $scope.current_month = month_data;

        if (!$scope.$$phase) {
          $scope.$apply();
        }
        callback && callback();
      });


    };


    $scope.nextMonth = function() {
      var temp = $scope.current_date;
      temp.setMonth(temp.getMonth() + 1);
      current = new Date(temp);
      updateMonth(temp);
    };

    $scope.preMonth = function() {
      var temp = $scope.current_date;
      temp.setMonth(temp.getMonth() - 1);
      current = new Date(temp);
      updateMonth(temp);
    };
    /**
     * 进入日历的日视图
     * @param  {Date} date
     */
    $scope.dayView = function(date) {
      var date = new Date(date);
      INFO.lastDate = date;
      INFO.guestUserId = $stateParams.userId
      $state.go('calendar',{type:'userinfo'})
    };
    var loadCalender = function () {
      moment.locale('zh-cn');
      /**
       * 日历视图的状态，有年、月、日三种视图
       * 'year' or 'month' or 'day'
       * @type {String}
       */
      $scope.view = 'month';

      $scope.year = '一月 二月 三月 四月 五月 六月 七月 八月 九月 十月 十一月 十二月'.split(' ');
      /**
       * 月视图卡片数据
       * @type {Array}
       */
      $scope.month_cards;
      var current = $scope.current_date = new Date();
      updateMonth(current);
    }
    $scope.changeFilter = function (type) {
      if(!type||$scope.nowTab==type)
        return;
      $scope.nowTab = type;
      switch(type) {
        case 'team':
          getMyTeams();
          break;
        case 'circle':
          getCirecle();
          break;
        case 'campaign':
          loadCalender();
          
          break;
      }
      
    }
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
  .controller('ReportController', ['$ionicHistory', '$scope', '$stateParams', '$rootScope', 'Report',
   function ($ionicHistory, $scope, $stateParams, $rootScope, Report) {
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
            $rootScope.showAction({titleText:err})
          } else {
            $rootScope.showAction({titleText:'举报成功！'})
          }
          $scope.isBusy = false;
        });
      }
    }

  }])
  .controller('CampaignEditController', ['$ionicHistory', '$scope', '$state', '$rootScope', 'Campaign',
   function ($ionicHistory, $scope, $state, $rootScope, Campaign) {
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
          $rootScope.showAction({titleText:'人数下限不能大于上限，请重新填写'})
        }
        else if($scope.campaignData.deadline > $scope.campaignData.end_time ) {
          $rootScope.showAction({titleText:'报名截止时间不能晚于结束时间'+$scope.campaignData.end_time})
        }
        else if($scope.campaignData.deadline < new Date()) {
          $rootScope.showAction({titleText:'报名截止时间不能比现在更早'})
        }
        else {
          $scope.isBusy = true;
          Campaign.edit($state.params.id, $scope.campaignData, function (err, data) {
            if (err) {
              // todo
              console.log(err);
              $rootScope.showAction({titleText:err})

            } else {
              $rootScope.showAction({titleText:'修改成功'})
              $state.go('campaigns_detail',{id:$state.params.id});
            }
            $scope.isBusy = false;
          });
        }
      }
    }
    $scope.closeCampaign = function() {
      $rootScope.showAction({type:1,titleText:'关闭后将无法再次打开，您确认要关闭该活动吗?',
        fun:function () {
          if(window.analytics){
            window.analytics.trackEvent('Click', 'closeCampaign');
          }
          Campaign.close($state.params.id,function(err,data) {
            if(!err){
              $rootScope.showAction({titleText:'关闭成功'})
              $state.go('campaigns_detail',{id:$state.params.id});
            }
            else {
              $rootScope.showAction({titleText:err})
            }
          });
        }
      })
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
          $scope.nowTeamIndex =teams.length>1 ? 1:0;
          INFO.myTeams = teams;
          // $ionicSlideBoxDelegate.update();
          // refreshFlag && $scope.$broadcast('scroll.refreshComplete');
        }
      }, function (err, teams) {
        if (err || teams.length==0) {
          // todo
          console.log(err);
        } else {
          $scope.teams = teams;
          $scope.nowTeamIndex =teams.length>1 ? 1:0;
          INFO.myTeams = teams;
        }
        $ionicSlideBoxDelegate.update();
        refreshFlag && $scope.$broadcast('scroll.refreshComplete');
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
      };

      $scope.groupType = $state.params.groupType;
      Rank.getRank(data,function (err,data) {
        if (err) {
          // todo
          console.log(err);
        } else {
          $scope.rank = data.rank;
          $scope.noRankTeams = [];
          if(data.team) {
            data.team.forEach(function(_team, index){
              if(_team.rank>10) {
                $scope.noRankTeams.push(_team);
              }
              else if(_team.rank>0) {
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
  .controller('RankRulesController', ['$ionicHistory', '$state', '$scope', function($ionicHistory, $state, $scope) {
    $scope.goBack = function() {
      if ($ionicHistory.backView()) {
        $ionicHistory.goBack();
      } else {
        $state.go('rank_select');
      }
    }
  }])
  .controller('CircleSendController', ['$ionicHistory', '$scope', '$state', '$stateParams', 'Circle',
   function($ionicHistory, $scope, $state, $stateParams, Circle) {
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
    '$rootScope',
    '$timeout',
    'Circle',
    'Tools',
    'Company',
    'User',
    function($ionicHistory, $scope, $rootScope, $state, $stateParams, $rootScope, $timeout, Circle, Tools, Company, User) {

      Company.getData(localStorage.cid).success(function(data) {
        $scope.company = data;
      }).error(function(data) {
        console.log(data.msg || '获取数据失败'); // 这里没必要提示用户
      });

      User.getData(localStorage.id,function(err, data) {
        $scope.user = data;
      });

      // 初始化提醒列表
      if (!$rootScope.remindList) {
        $rootScope.remindList = [];
      }

      var hasInit = false;

      // 用于保存已经获取到的同事圈内容
      $scope.circleContentList = [];

      $scope.loadingStatus = {
        hasInit: false, // 是否已经获取了一次内容
        hasMore: false, // 是否还有更多内容，决定infinite-scroll是否在存在
        loading: false // 是否正在加载更多，如果是，则会保护防止连续请求
      };

      var pageLength = 20; // 一次获取的数据量

      $scope.goToRemindsPage = function() {
        if ($rootScope.newCircleComment > 0 || $rootScope.newContent === true) {
          $scope.getData();
        }
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
            if(data.length > 0) {
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
              if (callback) {
                callback();
              }
            }
          })
          .error(function(data, status) {
            if (status !== 404) {
              $scope.ionicAlert(data.msg || '获取失败');
            }
            else {
              $scope.loadingStatus.hasInit = true;
            }
          });
      };

      $scope.refresh = function() {
        $scope.getData(function() {
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
            if (data.length > 0) {
              data.forEach(function(circle) {
                Circle.pickAppreciateAndComments(circle);
              });
              $scope.circleContentList = $scope.circleContentList.concat(data);
            }
            else {
              $scope.loadingStatus.hasMore = false;
            }
            $scope.loadingStatus.loading = false;
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

      $scope.clickBlank = function() {
        $scope.circleCommentBoxCtrl.stopComment();
      };

      $scope.onClickContentImg = function(images, img) {
        $scope.pswpCtrl.init(images, img);
      };

      $scope.$on("$ionicView.enter", function(scopes, states) {
        var clearRedSpot = function() {
          $rootScope.newContent = null;
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
      });

    }
  ])
  .controller('CircleTeamController', [
    '$ionicHistory',
    '$scope',
    '$rootScope',
    '$state',
    '$stateParams',
    '$timeout',
    'Circle',
    'Tools',
    'Team',
    'User',
    function($ionicHistory, $scope, $rootScope, $state, $stateParams, $timeout, Circle, Tools, Team, User) {
      $scope.goBack = function() {
        if ($ionicHistory.backView()) {
          $ionicHistory.goBack();
        } else {
          $state.go('app.personal');
        }
      };

      Team.getData($state.params.teamId, function(err, team) {
        if (team) {
          $scope.team = team;
        }
      }, {resultType: 'simple'});

      User.getData(localStorage.id, function(err, user) {
        $scope.user = user;
      })

      var pageLength = 20; // 一次获取的数据量

      $scope.loadingStatus = {
        hasInit: false, // 是否已经获取了一次内容
        hasMore: false, // 是否还有更多内容，决定infinite-scroll是否在存在
        loading: false // 是否正在加载更多，如果是，则会保护防止连续请求
      };

      $scope.loadMore = function() {
        if (!$scope.loadingStatus.hasMore || $scope.loadingStatus.loading || !$scope.loadingStatus.hasInit) {
          return; // 如果没有更多内容或已经正在加载或是还没有获取过一次数据，则返回，防止连续的请求
        }
        $scope.loadingStatus.loading = true;
        var pos = $scope.circleContentList.length - 1;
        var lastContentDate = $scope.circleContentList[pos].content.post_date;
        Circle.getTeamCircle($state.params.teamId, {last_content_date: lastContentDate})
          .success(function(data) {
            if (data.length) {
              data.forEach(function(circle) {
                Circle.pickAppreciateAndComments(circle);
              });
              $scope.circleContentList = $scope.circleContentList.concat(data);
              $scope.loadingStatus.loading = false;
            }

            $scope.$broadcast('scroll.infiniteScrollComplete');
          })
          .error(function(data, status) {
            if (status !== 404) {
              $rootScope.showAction({titleText:data.msg || '获取失败'})
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

      $scope.clickBlank = function() {
        $scope.circleCommentBoxCtrl.stopComment();
      };

      $scope.onClickContentImg = function(images, img) {
        $scope.pswpCtrl.init(images, img);
      };

      $scope.$on("$ionicView.enter", function(scopes, states) {
        // 用于保存已经获取到的同事圈内容
        $scope.circleContentList = [];



        Circle.getTeamCircle($state.params.teamId)
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
          })
          .error(function(data, status) {
            if (status !== 404) {
              $rootScope.showAction({titleText:data.msg || '获取失败'})
            }
            else {
              $scope.loadingStatus.hasInit = true;
            }
          });

      });


    }
  ])
  .controller('CircleUserController', [
    '$ionicHistory',
    '$scope',
    '$rootScope',
    '$state',
    '$stateParams',
    '$timeout',
    'Circle',
    'User',
    'Tools',
    function($ionicHistory, $scope, $rootScope, $state, $stateParams, $timeout, Circle, User, Tools) {
      $scope.goBack = function() {
        if ($ionicHistory.backView()) {
          $ionicHistory.goBack();
        } else {
          $state.go('app.personal');
        }
      };

      var pageLength = 20; // 一次获取的数据量

      $scope.loadMore = function() {
        if (!$scope.loadingStatus.hasMore || $scope.loadingStatus.loading || !$scope.loadingStatus.hasInit) {
          return; // 如果没有更多内容或已经正在加载或是还没有获取过一次数据，则返回，防止连续的请求
        }
        $scope.loadingStatus.loading = true;
        var pos = $scope.circleContentList.length - 1;
        var lastContentDate = $scope.circleContentList[pos].content.post_date;
        Circle.getUserCircle($state.params.userId || localStorage.id, {last_content_date: lastContentDate})
          .success(function(data) {
            if (data.length) {
              data.forEach(function(circle) {
                Circle.pickAppreciateAndComments(circle);
              });
              $scope.circleContentList = $scope.circleContentList.concat(data);
              $scope.loadingStatus.loading = false;
            }

            $scope.$broadcast('scroll.infiniteScrollComplete');
          })
          .error(function(data, status) {
            if (status !== 404) {
              $rootScope.showAction({titleText:data.msg || '获取失败'})
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

      $scope.clickBlank = function() {
        $scope.circleCommentBoxCtrl.stopComment();
      };

      $scope.onClickContentImg = function(images, img) {
        $scope.pswpCtrl.init(images, img);
      };


      $scope.$on("$ionicView.enter", function(scopes, states) {
        // 用于保存已经获取到的同事圈内容
        $scope.circleContentList = [];

        $scope.loadingStatus = {
          hasInit: false, // 是否已经获取了一次内容
          hasMore: false, // 是否还有更多内容，决定infinite-scroll是否在存在
          loading: false // 是否正在加载更多，如果是，则会保护防止连续请求
        };

        User.getData($state.params.userId || localStorage.id, function(err, data) {
          if (err) {
            // todo
            console.log(err);
          } else {
            $scope.user = data;
          }
        });

        Circle.getUserCircle($state.params.userId || localStorage.id)
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
          })
          .error(function(data, status) {
            if (status !== 404) {
              $rootScope.showAction({titleText:data.msg || '获取失败'})
            }
            else {
              $scope.loadingStatus.hasInit = true;
            }
          });

      });


    }
  ])
  .controller('CircleContentDetailController', [
    '$scope',
    '$ionicHistory',
    '$state',
    '$rootScope',
    'Circle',
    'User',
    function($scope, $ionicHistory, $state, $rootScope, Circle, User) {
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

      $scope.clickBlank = function() {
        $scope.circleCommentBoxCtrl.stopComment();
      };

      $scope.onClickContentImg = function(images, img) {
        $scope.pswpCtrl.init(images, img);
      };

      $scope.$on("$ionicView.enter", function(scopes, states) {
        Circle.getCircleContent($state.params.circleContentId).success(function(data) {
          $scope.circle = data.circle;
          Circle.pickAppreciateAndComments($scope.circle);
        }).error(function(data) {
          $rootScope.showAction({titleText:data.msg || '获取失败'}) // TODO 还需要考虑妥善处理，很可能会出现这条内容被删除了
        });

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
      $scope.goBack = function() {
        if ($ionicHistory.backView()) {
          $ionicHistory.goBack();
        } else {
          $state.go('circle_company');
        }
      };
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
  .controller('CompetitionMessageListController', ['$scope', '$rootScope','$state', '$ionicScrollDelegate', 'CompetitionMessage','INFO',
   function ($scope, $rootScope, $state, $ionicScrollDelegate, CompetitionMessage,INFO) {
    $scope.messageType ='receive';
    $scope.page = 1;
    $scope.loading = false;
    $scope.getCompetitionLog = function (refreshFlag) {
      if(refreshFlag) {
        $scope.page =1;
        $scope.competitionMessages =[]
      }
      var data = {
        messageType: $scope.messageType,
        page: $scope.page
      }
      $scope.loading = true;
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
        $scope.loading = false;
        refreshFlag && $scope.$broadcast('scroll.refreshComplete');
        $ionicScrollDelegate.$getByHandle("mainScroll").resize();
      });
    }
    $scope.goDetail = function (index) {
      $scope.competitionMessages[index].unread =false;
      $state.go('competition_message_detail',{id:$scope.competitionMessages[index]._id},{reload:true})
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
    $scope.getCompetitionLog();
    $scope.$on( "$ionicView.enter", function( scopes, states ) {
      var hasNewDiscover =false;
      if($scope.competitionMessages && $scope.competitionMessages.length) {
        $scope.competitionMessages.forEach(function(element, index){
          if(INFO.competitionMessageDetail && element._id==INFO.competitionMessageDetail._id){
            element.status = INFO.competitionMessageDetail.status;
          }
          hasNewDiscover = hasNewDiscover || element.unread;
        });
        $rootScope.hasNewDiscover = hasNewDiscover;
      }
    });
  }])
  .controller('CompetitionMessageDetailController', ['$rootScope', '$scope', '$state', '$ionicModal', '$ionicScrollDelegate', '$ionicPopup', '$timeout', '$ionicHistory', 'CompetitionMessage', 'Comment', 'Vote', 'User', 'Upload', 'INFO',
   function ($rootScope, $scope, $state, $ionicModal, $ionicScrollDelegate, $ionicPopup, $timeout, $ionicHistory, CompetitionMessage, Comment, Vote, User, Upload, INFO) {
    INFO.competitionMessageDetail = undefined;
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
          $scope.sponsor = data.sponsor;
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
            $rootScope.showAction({titleText:err})
          }
          else{
            $scope.competitionMessage.vote = formatVote(vote);
            $rootScope.showAction({titleText:'投票成功!'})
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
          $rootScope.showAction({titleText:'挑战处理成功!'})
          $scope.competitionMessage.status =action+'ed';
          INFO.competitionMessageDetail=$scope.competitionMessage;
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
  .controller('SearchOpponentController', ['$scope', '$rootScope', '$state', 'Team', 'INFO', function ($scope, $rootScope, $state, Team, INFO) {
    var getMyTeams = function(callback) {
      Team.getList('user', localStorage.id, null, function (err, teams) {
        if (err) {
          // todo
          console.log(err);
          $scope.leadTeams = [];
          $scope.memberTeams = [];
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
          INFO.myTeams = teams;
          callback && callback();
        }
      }, function (err, teams) {
        if (err || teams.length==0) {
          // todo
          console.log(err);
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
          INFO.myTeams = teams;
          callback && callback();
        }
      });
    };
    if(INFO.myTeams) {
      var leadTeams = [];
      var memberTeams = [];
      INFO.myTeams.forEach(function(team) {
        if(team.isLeader) {
          leadTeams.push(team);
        }
        else {
          memberTeams.push(team);
        }
      });
      $scope.leadTeams = leadTeams;
      $scope.memberTeams = memberTeams;
    }
    else{
      getMyTeams();
    }
    $scope.doRefresh = function () {
      getMyTeams(function () {
        $scope.$broadcast('scroll.refreshComplete');
      });
      
    }
  }])
  .controller('SearchOpponentTeamController', ['$scope', '$rootScope', '$state', '$ionicHistory', 'Team', 'INFO', function ($scope, $rootScope, $state, $ionicHistory, Team, INFO) {
    $scope.keywords ={value:''};
    $scope.coordinates =[];
    $scope.goBack = function() {
      if($ionicHistory.backView()){
        $ionicHistory.goBack();
      }
      else {
        $state.go('search_opponent');
      }
    };
    $scope.$watch('nowTab',function (newVal, oldVal) {
      if(newVal &&newVal!='search' && newVal!=oldVal) {
        $scope.page =1;
        getSearchTeam(newVal);
      }
    });
    Team.getData($state.params.tid,function (err, data) {
      if(err) {
        console.log(err)
      }
      else{
        $scope.myTeam = data;
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
          var onError = function(error) {
             console.log('code: '    + error.code    + '\n' +
                    'message: ' + error.message + '\n');
          }

          if(navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(onSuccess, onError);
          }
        }
        $scope.nowTab = 'sameCity';
      }
    })
    
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
        queryData.key = $scope.keywords.value;
      }
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
      });
    }
    $scope.doRefresh = function (argument) {
      $scope.page =1;
      getSearchTeam($scope.nowTab);
      $scope.$broadcast('scroll.refreshComplete');
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
        targetTeamId: teamId,
        fromTeamId: $state.params.tid
      })
    }
  }])
  .controller('CompetitionTeamController', ['$scope', '$rootScope', '$state', '$ionicHistory', '$ionicPopup', 'Team', 'INFO', 'Campaign', 'Chat',
   function ($scope, $rootScope, $state, $ionicHistory, $ionicPopup, Team, INFO, Campaign, Chat) {
    var targetTeamId = $state.params.targetTeamId;
    var fromTeamId = $state.params.fromTeamId;
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
      if(fromTeamId) {
        $scope.sameTeams = $scope.sameTeams.filter(function (team) {
          return team._id.toString() === fromTeamId;
        });
      }
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
        }, function (err, teams) {
          if (err || teams.length==0) {
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
        var score_rank = team.score_rank;
        var totalCompetions = score_rank.win + score_rank.tie + score_rank.lose;
        if (totalCompetions === 0) {
          team.rate = 0;
        }
        else {
          team.rate = score_rank.win / totalCompetions * 100;
        }
        // var homeCourtText = '';
        // if (team.homeCourts.length === 0) {
        //   homeCourtText = '无';
        // }
        // else {
        //   for (var i = 0; i < team.homeCourts.length; i++) {
        //     if (i !== 0) {
        //       homeCourtText += '、';
        //     }
        //     homeCourtText += team.homeCourts[i].name;
        //   }
        // }
        // team.homeCourtText = homeCourtText;
        getSameTeam(team.groupType);
        $scope.isCompanyTeam = team.isCompanyTeam;
        if (!team.isCompanyTeam) {
          $scope.getCompetitionOfTeams();
        }
      }
    },{resultType:'simple'});
    $scope.getCompetitionOfTeams = function () {
      Campaign.getCompetitionOfTeams({targetTeamId: targetTeamId, fromTeamId:fromTeamId ,page: $scope.page}, function (err, data) {
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
    $scope.needShowTime = function(index) {
      if(index === 0) {
        return true;
      }else {
        var preTime = new Date($scope.competitions[index-1].start_time);
        var nowTime = new Date($scope.competitions[index].start_time);
        // console.log(index,nowTime,preTime);
        if(nowTime.getFullYear() != preTime.getFullYear()) {
          return true;
        }else if(nowTime.getDay() != preTime.getDay()) {
          return true;
        }else {
          return false;
        }
      }
    }
    $scope.showPopup = function(index) {

      var showText = [{text:'发挑战',teamText:'leadTeams',funText:'createMessage'},{text:'推荐',teamText:'memberTeams',funText:'recommend'}];
      $scope.selectTeam = $scope[showText[index].teamText][0];
      if(fromTeamId ||$scope[showText[index].teamText].length==1){
        $scope[showText[index].funText]($scope.selectTeam);
        return;
      }
      var templatString = "<ion-radio ng-repeat='team in "+ showText[index].teamText+ "' ng-model='selectTeam' ng-value='team'>{{team.name}}</ion-radio>";
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
              if (!$scope.selectTeam) {
                e.preventDefault();
              } else {
                return $scope.selectTeam;
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
    $scope.createMessage = function (team) {
      INFO.competitionMessageData = {
        fromTeam: team,
        targetTeam: $scope.targetTeam
      }
      $state.go('competition_send');
    };
    $scope.recommend = function (team) {
      var postData = {
        content: $scope.targetTeam.name,
        chatType: 2,
        recommendTeamId: targetTeamId
      }
      Chat.postChat(team._id, postData, function(err, data) {
        if(err) {
          console.log(err);
          $rootScope.showAction({titleText:'推荐失败!'})
        }
        else{
          $rootScope.showAction({titleText:'推荐成功!'})
        }
      })
    };
  }])
  .controller('CompetitonSendController', ['$scope', '$rootScope', '$state', '$ionicHistory', '$ionicPopup', 'CompetitionMessage', 'Team', 'INFO', 'Campaign',
   function ($scope, $rootScope, $state, $ionicHistory, $ionicPopup, CompetitionMessage, Team, INFO, Campaign) {
    $scope.isPublish=false;
    if(INFO.competitionMessageData) {
      var competitionMessageData = INFO.competitionMessageData;
      $scope.fromTeam = competitionMessageData.fromTeam;
      $scope.targetTeam = competitionMessageData.targetTeam;
      $scope.messageData = {
        sponsor: $scope.fromTeam._id,
        opposite: $scope.targetTeam._id,
        type:1,
        content: ""
      }
    }
    else{
      $rootScope.showAction({titleText:'数据发送错误！!'})
    }
    $scope.goBack = function() {
      if($ionicHistory.backView()){
        $ionicHistory.goBack()
      }
      else {
        $state.go('competition_team',{
          fromTeamId: $scope.fromTeam._id,
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
          $rootScope.showAction({titleText:data.msg,canelFun:function () {
            $scope.goBack();
          }})
          
        }
        else{
          $rootScope.showAction({titleText:err})
        }
        $scope.isPublish =false;
      })
    }
  }])
