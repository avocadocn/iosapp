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
  .controller('UserLoginController', ['$scope', 'CommonHeaders', '$state', '$ionicHistory', 'UserAuth', function ($scope, CommonHeaders, $state, $ionicHistory, UserAuth) {

    $scope.loginData = {
      email: '',
      password: ''
    };

    $scope.login = function () {
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
  .controller('CompanyLoginController', ['$scope', 'CommonHeaders', '$state', '$ionicHistory', 'CompanyAuth', function ($scope, CommonHeaders, $state, $ionicHistory, CompanyAuth) {

    $scope.loginData = {
      username: '',
      password: ''
    };

    $scope.login = function () {
      CompanyAuth.login($scope.loginData.username, $scope.loginData.password, function (msg) {
        if (msg) {
          $scope.msg = msg;
        } else {
          $ionicHistory.clearHistory();
          $ionicHistory.clearCache();
          $state.go('company_home');
        }
      });
    };

  }])
  .controller('CompanyHomeController', ['$scope', '$state', 'CompanyAuth', 'CommonHeaders', function ($scope, $state, CompanyAuth, CommonHeaders) {

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
  .controller('createTeamController', ['$scope', '$rootScope', '$state', '$ionicPopup', 'INFO', 'Team', function ($scope, $rootScope, $state, $ionicPopup, INFO, Team) {
    $scope.backUrl = localStorage.userType==='company' ? '#/company/team_page' : INFO.createTeamBackUrl;
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
    }
    $scope.createTeam = function() {
      if(!$scope.isBusy) {
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
        }
        Team.createTeam(teamData, function(err, data) {
          $rootScope.hideLoading();
          if(!err){
            if(localStorage.userType==='user')
              $state.go('team',{teamId:data.teamId});
            else
              $state.go('company_teamPage');
          }
          else{
            $ionicPopup.alert({
              title: '错误',
              template: err
            });
          }
        });
      }
      
    }
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
  .controller('CampaignController', ['$scope', '$state', '$timeout', '$ionicPopup', '$rootScope', '$ionicScrollDelegate','$ionicHistory', 'Campaign', 'INFO',
    function ($scope, $state, $timeout, $ionicPopup, $rootScope, $ionicScrollDelegate, $ionicHistory, Campaign, INFO) {
    $rootScope.showLoading();
    $scope.pswpPhotoAlbum = {};
    $scope.nowType = 'all';
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
        if(data[0].length==0&&data[1].length==0&&data[2].length==0&&data[3].length==0){
          $scope.noCampaigns = true;
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
    $scope.filter = function(filterType) {
      $scope.nowType = filterType;
      $timeout(function() {
        $ionicScrollDelegate.scrollTop(true);
      });
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
          if(data[0].length==0&&data[1].length==0&&data[2].length&&data[3].length==0){
            $scope.noCampaigns = true;
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
    }
  }])
  .controller('CampaignDetailController', ['$ionicHistory', '$scope', '$state', '$ionicPopup', 'Campaign', 'Message', 'INFO', function ($ionicHistory, $scope, $state, $ionicPopup, Campaign, Message, INFO) {
    $scope.goBack = function() {
      if($ionicHistory.backView()){
        $ionicHistory.goBack();
      }
      else {
        $state.go('app.campaigns');
      }
    }
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
    $scope.showPopup = function() {
      $scope.data = {}

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
  }])
  .controller('SponsorController', ['$ionicHistory', '$scope', '$state', '$ionicPopup', '$ionicModal', '$timeout', 'Campaign', 'INFO', 'Team', function ($ionicHistory, $scope, $state, $ionicPopup, $ionicModal, $timeout, Campaign, INFO, Team) {
    $scope.campaignData ={};
    $scope.leadTeams = [];
    $scope.selectTeam = {};
    $scope.isBusy = false;
    $scope.showMapFlag ==false;
    $scope.campaignData.location = {};
    var city,marker;
    $ionicModal.fromTemplateUrl('my-modal.html', {
      scope: $scope,
      animation: 'slide-in-up'
    }).then(function(modal) {
      $scope.modal = modal;
    });
    $scope.goBack = function() {
      if($ionicHistory.backView()){
        $ionicHistory.goBack()
      }
      else {
        $state.go('app.'+$state.params.type);
      }
    }
    $scope.closeModal = function() {
      $scope.modal.hide();
    };
    $scope.$on('$destroy',function() {
      $scope.modal.remove();
    });
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
    var placeSearchCallBack = function(data){
      $scope.locationmap.clearMap();
      if(data.poiList.pois.length==0){
        $ionicPopup.alert({
          title: '提示',
          template: '没有符合条件的地点，请重新输入'
        });
        $scope.closeModal();
        return;
      }
      var lngX = data.poiList.pois[0].location.getLng();
      var latY = data.poiList.pois[0].location.getLat();
      $scope.campaignData.location.coordinates=[lngX, latY];
      var nowPoint = new AMap.LngLat(lngX,latY);
      var markerOption = {
        map: $scope.locationmap,
        position: nowPoint,
        raiseOnDrag:true
      };
      marker = new AMap.Marker(markerOption);
      $scope.locationmap.setFitView();
      AMap.event.addListener($scope.locationmap,'click',function(e){
        var lngX = e.lnglat.getLng();
        var latY = e.lnglat.getLat();
        $scope.campaignData.location.coordinates=[lngX,latY];
        $scope.locationmap.clearMap();
        var nowPoint = new AMap.LngLat(lngX,latY);
        var markerOption = {
          map: $scope.locationmap,
          position: nowPoint,
          raiseOnDrag:true
        };
        marker = new AMap.Marker(markerOption);
      });

    };
    $scope.initialize = function(){
      $scope.locationmap =  new AMap.Map("mapDetail");            // 创建Map实例
      $scope.locationmap.plugin(["AMap.ToolBar"],function(){    
        toolBar = new AMap.ToolBar();
        $scope.locationmap.addControl(toolBar);   
      });
      if(city){
        $scope.locationmap.plugin(["AMap.PlaceSearch"], function() {
          $scope.MSearch = new AMap.PlaceSearch({ //构造地点查询类
            pageSize:1,
            pageIndex:1,
            city:city
          });
          AMap.event.addListener($scope.MSearch, "complete", placeSearchCallBack);//返回地点查询结果
        });
      }
      else {
        $scope.locationmap.plugin(["AMap.PlaceSearch"], function() {
          $scope.MSearch = new AMap.PlaceSearch({ //构造地点查询类
            pageSize:1,
            pageIndex:1
          });
          AMap.event.addListener($scope.MSearch, "complete", placeSearchCallBack);//返回地点查询结果

        });
        $scope.locationmap.plugin(["AMap.CitySearch"], function() {
          //实例化城市查询类
          var citysearch = new AMap.CitySearch();
          AMap.event.addListener(citysearch, "complete", function(result){
            if(result && result.city && result.bounds) {
              var citybounds = result.bounds;
              //地图显示当前城市
              $scope.locationmap.setBounds(citybounds);
              city = result.city;
              $scope.locationmap.plugin(["AMap.PlaceSearch"], function() {
                $scope.MSearch = new AMap.PlaceSearch({ //构造地点查询类
                  pageSize:1,
                  pageIndex:1,
                  city: result.city
                });
                AMap.event.addListener($scope.MSearch, "complete", placeSearchCallBack);//返回地点查询结果
                $timeout(function(){
                  $scope.MSearch.search($scope.campaignData.location.name);
                });
              });
            }
          });
          AMap.event.addListener(citysearch, "error", function(result){alert(result.info);});
          //自动获取用户IP，返回当前城市
          citysearch.getLocalCity();

        });
        $timeout(function(){
          $scope.MSearch.search($scope.campaignData.location.name);
        });
      }
      window.map_ready =true;
    }
    $scope.showPopup = function() {
      if($scope.campaignData.location.name==''){
        $ionicPopup.alert({
          title: '提示',
          template: '请输入地点'
        });
        return false;
      }
      else{
        $scope.modal.show();
        //加载地图
        if(!window.map_ready){
          window.campaign_map_initialize = $scope.initialize;
          var script = document.createElement("script");
          script.src = "http://webapi.amap.com/maps?v=1.3&key=077eff0a89079f77e2893d6735c2f044&callback=campaign_map_initialize";
          document.body.appendChild(script);
        }
        else{
          $scope.initialize();
        }
      }
     };
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
    var localizeDateStr = function(date_to_convert_str) {
      var date_to_convert = new Date(date_to_convert_str);
      var local_date = new Date();
      date_to_convert.setMinutes(date_to_convert.getMinutes()+local_date.getTimezoneOffset());
      return date_to_convert;
    }
    $scope.sponsor = function(){
      $scope.campaignData.start_time = localizeDateStr($scope.campaignData.start_time);
      $scope.campaignData.end_time = localizeDateStr($scope.campaignData.end_time);
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
        $scope.isBusy = true;
        $scope.campaignData.cid = [$scope.selectTeam.cid];
        $scope.campaignData.tid = [$scope.selectTeam._id];
        $scope.campaignData.campaign_type = 2;
        $scope.campaignData.campaign_mold = $scope.selectMold.name;
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
        })
      }

    }
  }])
  .controller('DiscussListController', ['$scope', '$ionicHistory', 'Comment', '$state', 'Socket', 'Tools', 'INFO', function ($scope, $ionicHistory, Comment, $state, Socket, Tools, INFO) { //标为全部已读???
    Socket.emit('enterRoom', localStorage.id);
    //先在缓存里取
    // console.log(INFO);
    if(INFO.discussList){
      $scope.commentCampaigns = INFO.discussList.commentCampaigns;
      $scope.latestUnjoinedCampaign = INFO.discussList.latestUnjoinedCampaign;
      $scope.unjoinedIndex = INFO.discussList.unjoinedIndex;
    }
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
    };
    $scope.goDetail = function(campaignId, campaignTheme) {
      INFO.discussName = campaignTheme;
      $state.go('discuss_detail',{campaignId: campaignId});
    };
    //暂且算存个缓存
    $scope.$on('$destroy',function() {
      INFO.discussList.commentCampaigns = $scope.commentCampaigns;
      INFO.discussList.latestUnjoinedCampaign = $scope.latestUnjoinedCampaign;
      INFO.discussList.unjoinedIndex = $scope.unjoinedIndex;
    });
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
  .controller('DiscussDetailController', ['$ionicHistory', '$scope', '$state', '$stateParams', '$ionicScrollDelegate', 'Comment', 'Socket', 'User', 'Message', 'Tools', 'CONFIG', 'INFO', 'CommonHeaders', '$cordovaFile', '$cordovaCamera', '$ionicActionSheet', '$ionicPopup', 'Campaign', '$location', '$ionicModal', '$ionicLoading',
    function ($ionicHistory, $scope, $state, $stateParams, $ionicScrollDelegate, Comment, Socket, User, Message, Tools, CONFIG, INFO, CommonHeaders, $cordovaFile, $cordovaCamera, $ionicActionSheet, $ionicPopup, Campaign, $location, $ionicModal, $ionicLoading) {
    $scope.campaignId = $stateParams.campaignId;
    $scope.campaignTitle = INFO.discussName;
    Socket.emit('enterRoom', $scope.campaignId);
    $scope.commentContent='';

    Campaign.get($scope.campaignId, function (err, data) {
      if (!err) {
        $scope.campaign = data;
        $scope.photoAlbumId = $scope.campaign.photo_album._id; // for photoswipe
      }
    });

    $scope.userId = localStorage.id;
    $scope.photos = [];
    var addPhotos = function (comment) {
      if (comment.photos && comment.photos.length > 0) {
        comment.photos.forEach(function (photo) {
          var width = photo.width || INFO.screenWidth;
          var height = photo.height || INFO.screenHeight;
          var item = {
            _id: photo._id,
            src: CONFIG.STATIC_URL + photo.uri,
            w: width,
            h: height
          };
          if (photo.upload_user && photo.upload_date) {
            item.title = '上传者: ' + photo.upload_user.name + '  上传时间: ' + moment(photo.upload_date).format('YYYY-MM-DD HH:mm');
          }
          $scope.photos.push(item);
        });
      }
    };
    $scope.goBack = function() {
      if($ionicHistory.backView()){
        $ionicHistory.goBack()
      }
      else {
        $state.go('app.discuss_list');
      }
    }
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
      $scope.pswpPhotoAlbum = {
        goToAlbum: function () {
          gallery.close();
          $location.url('/photo_album/' + $scope.photoAlbumId + '/detail');
        }
      };
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

    // //获取本地记录
    // if(localStorage.commentList) {
    //   var index = Tools.arrayObjectIndexOf(localStorage.commentList, $scope.campaignId, '_id');
    //   if(index>-1) $scope.commentList.push(localStorage.commentList[index]);
    // }
      
    //获取最新20条评论

    Comment.getComments($scope.campaignId, 20).success(function(data){
      $scope.commentList = [];
      $scope.commentList.push(data.comments.reverse());//保证最新的在最下面
      data.comments.forEach(addPhotos);
      nextStartDate = data.nextStartDate;
      $ionicScrollDelegate.scrollBottom();
      judgeTopShowTime();
    });
    
    //获取新留言
    Socket.on('newCampaignComment', function (data) {
      //如果是自己发的看看是不是取消loading就行.
      var commentListIndex = $scope.commentList.length -1;
      data.create_date = data.createDate;
      if(data.poster._id === currentUser._id && data.randomId) {
        //-找到那条自己发的
        var length = $scope.commentList[commentListIndex].length;
        for(var i = length-1; i>=0; i--){
          if($scope.commentList[commentListIndex][i].randomId === data.randomId){
            data.randomId = null;
            addPhotos(data);
            $scope.commentList[commentListIndex][i] = data;
            break;
          }
        }
      }else{
        data.randomId = null;
        $scope.commentList[commentListIndex].push(data);
        addPhotos(data);
        $ionicScrollDelegate.scrollBottom();
      }
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
          data.comments.forEach(addPhotos);
          judgeTopShowTime();
        });
      }else{//没下一条了~
        $scope.$broadcast('scroll.refreshComplete');
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
      };
    };
    
    //发表评论
    $scope.publishComment = function() {
      //-创建一个新comment
      var randomId = Math.floor(Math.random()*100);
      var newComment = {
        randomId: randomId,
        create_date: new Date(),
        poster: {
          '_id': currentUser._id,
          'photo': currentUser.photo,
          'nickname': currentUser.nickname
        },
        content: $scope.commentContent,
        loading: true
      };
      var commentListIndex = $scope.commentList.length -1;
      $scope.commentList[commentListIndex].push(newComment);
      $ionicScrollDelegate.scrollBottom();
      Comment.publishComment($scope.campaignId, $scope.commentContent, randomId, function(err){
        if(err){
          console.log(err);
          var length =  $scope.commentList[commentListIndex].length;
          //发送失败
          $scope.commentList[commentListIndex][length-1].failed = true;
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

    var upload = function (imageURI, randomId) {
      var serverAddr = CONFIG.BASE_URL + '/comments/host_type/campaign/host_id/' + $scope.campaignId;
      var headers = CommonHeaders.get();
      headers['x-access-token'] = localStorage.accessToken;
      var options = {
        fileKey: 'photo',
        httpMethod: 'POST',
        headers: headers,
        mimeType: 'image/jpeg',
        params:{randomId: randomId}
      };

      $ionicLoading.show({
        template: '上传中',
        scope: $scope,
        duration: 5000
      });

      $cordovaFile
        .uploadFile(serverAddr, imageURI, options)
        .then(function(result) {
          $ionicLoading.hide();
          $scope.confirmUploadModal.hide();
        }, function(err) {
          $scope.confirmUploadModal.hide();
          //发送失败
          var length =  $scope.commentList[commentListIndex].length;
          $scope.commentList[commentListIndex][length-1].failed = true;
          // $ionicPopup.alert({
          //   title: '发送失败',
          //   template: '请重试'
          // });
        }, function (progress) {
          // constant progress updates
        });
    };

    $scope.confirmUpload = function () {
      upload($scope.previewImg, $scope.randomId);
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
        encodingType: Camera.EncodingType.JPEG,
        popoverOptions: CameraPopoverOptions,
        saveToPhotoAlbum: save,
        correctOrientation: true
      };

      $cordovaCamera.getPicture(options).then(function(imageURI) {
        //-生成随机id
        var randomId = Math.floor(Math.random()*100);
        $scope.previewImg = imageURI;
        $scope.randomId = randomId;
        $scope.confirmUploadModal.show();
        //-创建一个新comment
        var newComment = {
          randomId: randomId.toString(),
          create_date: new Date(),
          poster: {
            '_id': currentUser._id,
            'photo': currentUser.photo,
            'nickname': currentUser.nickname
          },
          photos: [{uri:imageURI}],
          loading: true
        };
        var commentListIndex = $scope.commentList.length -1;
        $scope.commentList[commentListIndex].push(newComment);
        $ionicScrollDelegate.scrollBottom();
      }, function(err) {
        if (err !== 'no image selected') {
          $ionicPopup.alert({
            title: '获取照片失败',
            template: err
          });
        }
      });
    };

    // localStorage不能保存数组
    // //-保存最新的20条评论
    // $scope.$on('$destroy',function( ) {
    //   if(!localStorage.commentList){
    //     localStorage.commentList = [];
    //   }
    //   var index = Tools.arrayObjectIndexOf(localStorage.commentList, $scope.campaignId, '_id');
    //   var comments = $scope.commentList[$scope.commentList.length-1];
    //   comments.length = 20;
    //   if(index>-1){
    //     localStorage.commentList[index] = comments
    //   }else{
    //     localStorage.commentList.push({
    //       _id: $scope.campaignId,
    //       comments: comments
    //     })
    //   }
    // });
    
    $scope.isShowEmotions = false;
    $scope.showEmotions = function() {
      $scope.isShowEmotions = true;
    };
    $scope.hideEmotions = function() {
      $scope.isShowEmotions = false;
    };

    $scope.emojiList=[];

    var emoji = ["bowtie", "smile", "laughing", "blush", "smiley", "relaxed",
      "smirk", "heart_eyes", "kissing_heart", "kissing_closed_eyes", "flushed",
      "relieved", "satisfied", "grin", "wink", "stuck_out_tongue_winking_eye",
      "stuck_out_tongue_closed_eyes", "grinning", "kissing",
      "stuck_out_tongue", "sleeping", "worried",
      "frowning", "anguished", "open_mouth", "grimacing", "confused", "hushed",
      "expressionless", "unamused", "sweat_smile", "sweat",
      "disappointed_relieved", "weary", "pensive", "disappointed", "confounded",
      "fearful", "cold_sweat", "persevere", "cry", "sob", "joy", "astonished",
      "scream", "neckbeard", "tired_face", "angry", "rage", "triumph", "sleepy",
      "yum", "mask", "sunglasses", "dizzy_face", "smiling_imp",
      "neutral_face", "no_mouth", "innocent", "alien", "heart", "broken_heart",
      "heartbeat", "heartpulse", "two_hearts", "revolving_hearts", "cupid",
      "sparkling_heart", "sparkles", "star", "star2", "dizzy", "boom",
      "collision", "anger", "exclamation", "question", "grey_exclamation",
      "grey_question", "zzz", "dash", "sweat_drops", "notes", "musical_note",
      "fire", "hankey", "+1", "-1", 
      "ok_hand", "punch", "fist", "v", "wave", "hand",
      "open_hands", "point_up", "point_down", "point_left", "point_right",
      "raised_hands", "pray", "point_up_2", "clap", "muscle", "metal", "fu",
      "walking", "runner", "running", "couple", "family", "two_men_holding_hands",
      "two_women_holding_hands", "dancer", "dancers", "ok_woman", "no_good",
      "information_desk_person", "raising_hand", "bride_with_veil",
      "person_with_pouting_face", "person_frowning", "bow", "couplekiss",
      "couple_with_heart", "massage", "haircut", "nail_care", "boy", "girl",
      "woman", "man", "baby", "older_woman", "older_man",
      "person_with_blond_hair", "man_with_gua_pi_mao", "man_with_turban",
      "construction_worker", "cop", "angel", "princess", "smiley_cat",
      "smile_cat", "heart_eyes_cat", "kissing_cat", "smirk_cat", "scream_cat",
      "crying_cat_face", "joy_cat", "pouting_cat", "japanese_ogre",
      "japanese_goblin", "see_no_evil", "hear_no_evil", "speak_no_evil",
      "guardsman", "skull", "feet", "lips", "kiss", "droplet", "ear", "eyes",
      "nose", "tongue", "love_letter", "bust_in_silhouette",
      "busts_in_silhouette", "speech_balloon", "thought_balloon", "feelsgood",
      "finnadie", "goberserk", "godmode", "hurtrealbad", "rage1", "rage2",
      "rage3", "rage4", "suspect", "trollface", "sunny", "umbrella", "cloud",
      "snowflake", "snowman", "zap", "cyclone", "foggy", "ocean", "cat", "dog",
      "mouse", "hamster", "rabbit", "wolf", "frog", "tiger", "koala", "bear",
      "pig", "pig_nose", "cow", "boar", "monkey_face", "monkey", "horse",
      "racehorse", "camel", "sheep", "elephant", "panda_face", "snake", "bird",
      "baby_chick", "hatched_chick", "hatching_chick", "chicken", "penguin",
      "turtle", "bug", "honeybee", "ant", "beetle", "snail", "octopus",
      "tropical_fish", "fish", "whale", "whale2", "dolphin", "cow2", "ram", "rat",
      "water_buffalo", "tiger2", "rabbit2", "dragon", "goat"
    ];

    for(var i =0; emoji.length>24 ;i++) {
      $scope.emojiList.push(emoji.splice(24,24));
    }
    $scope.emojiList.unshift(emoji);

    $scope.addEmotion = function(emotion) {
      // console.log(emotion);
      $scope.commentContent += ':'+ emotion +':';
    };
  }])
  .controller('DiscoverController', ['$scope', '$ionicPopup', '$state', '$ionicHistory', 'Team', 'INFO', function ($scope, $ionicPopup, $state, $ionicHistory, Team, INFO) {
    if($state.params.type) {
      // if($state.params.type=='personal') {
      //   $scope.teams = INFO.personalTeamList;
      // }
      // else {
        $scope.teams = INFO.officialTeamList;
      // }
    }
    else {
      Team.getList('company', null, false, function (err, teams) {
        if (err) {
          // todo
          console.log(err);
        } else {
          $scope.officialTeams = teams;
          INFO.officialTeamList = teams;
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
    };
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
  .controller('ContactsController', ['$scope', 'User', 'INFO', function ($scope, User, INFO) {
    //获取公司联系人
    User.getCompanyUsers(localStorage.cid,function(msg, data){
      if(!msg) {
        $scope.contacts = data;
      }
    });
    //设置点入个人资料后返回的地址
    INFO.userInfoBackUrl = '#/discover/contacts';
  }])
  .controller('PersonalController', ['$scope', '$state', '$ionicHistory', 'User', 'Message', 'Tools', function ($scope, $state, $ionicHistory, User, Message, Tools) {
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
          birthday: moment($scope.user.birthday).format('YYYY-MM-DD'),
          introduce: $scope.user.introduce
        };
      }
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
    }

    $scope.edit = function () {
      User.editData($scope.user._id, $scope.formData, function (err) {
        if (err) {
          $ionicPopup.alert({
            title: '编辑失败',
            template: err
          });
        } else {
          if($scope.formData.tag) {
            $scope.user.tags.push($scope.formData.tag);
            $scope.formData.tag = '';
          }
          $state.go('app.personal');
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
            User.clearCurrentUser();
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
    INFO.createTeamBackUrl = '#/personal/teams';
    Team.getList('user', localStorage.id, null, function (err, teams) {
      if (err) {
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
      }
    });

  }])
  .controller('SettingsController', ['$scope', '$state', '$ionicHistory', 'UserAuth', 'User', 'CommonHeaders', function ($scope, $state, $ionicHistory, UserAuth, User, CommonHeaders) {

    $scope.logout = function () {
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
  .controller('TabController', ['$scope', '$ionicHistory', 'Socket', function ($scope, $ionicHistory, Socket) {
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
    $scope.$on('$stateChangeStart',
      function () {
        $ionicHistory.nextViewOptions({
          disableBack: true,
          historyRoot: true
        });
    });
  }])
  .controller('CalendarController',['$scope', '$rootScope', '$state', '$ionicPopup', '$ionicPopover', '$timeout', '$ionicHistory', 'Campaign', 'INFO',
    function($scope, $rootScope, $state, $ionicPopup, $ionicPopover, $timeout, $ionicHistory, Campaign, INFO) {
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
          $ionicHistory.goBack()
        }
        else {
          $state.go('app.'+$state.params.type);
        }
      }
      $scope.nowTypeIndex =2;
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
  .controller('companySignupController' ,['$scope', '$state', '$rootScope', '$ionicPopup', 'CompanySignup', 'CONFIG', function ($scope, $state, $rootScope, $ionicPopup, CompanySignup, CONFIG) {
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
    }
  }])
  .controller('userRegisterDetailController', ['$scope', '$rootScope', '$state', '$ionicPopup', 'UserSignup', 'INFO', function ($scope, $rootScope, $state, $ionicPopup, UserSignup, INFO) {
    $scope.data = {};
    $scope.data.cid = INFO.companyId;
    $scope.data.email = INFO.email;
    $scope.companyName = INFO.companyName;
    $scope.signup = function() {
      $rootScope.showLoading();
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
      })
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
  .controller('CompanyTeamController', ['$scope', '$stateParams', 'Company', function ($scope, $stateParams, Company) {
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
  .controller('TeamController', ['$ionicHistory', '$rootScope', '$scope', '$state', '$stateParams', '$ionicPopup', '$window', 'Team', 'Campaign', 'Tools', 'INFO', '$ionicSlideBoxDelegate', 'User', function ($ionicHistory, $rootScope, $scope, $state, $stateParams, $ionicPopup, $window, Team, Campaign, Tools, INFO, $ionicSlideBoxDelegate, User) {
    var teamId = $stateParams.teamId;
    $scope.goBack = function() {
      if($ionicHistory.backView()){
        $ionicHistory.goBack()
      }
    }
    $scope.pswpPhotoAlbum = {};

    // 已登录的用户获取自己的信息不是异步过程
    User.getData(localStorage.id, function (err, user) {
      $scope.user = user;
    });

    Team.getData(teamId, function (err, team) {
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
      var link = 'http://m.amap.com/navi/?dest=' + homeCourt.loc.coordinates[0] + ',' + homeCourt.loc.coordinates[1] + '&destName=' + homeCourt.name+'&hideRouteIcon=1&key=077eff0a89079f77e2893d6735c2f044';
      window.open( link, '_system' , 'location=yes');
      return false;
    }
    $scope.$on('$stateChangeSuccess', function() {
      $scope.loadMore();
    });

  }])
  .controller('TeamEditController', ['$scope', '$ionicModal', '$ionicPopup', '$stateParams', 'Team', 'CONFIG', 'INFO', '$ionicActionSheet', '$cordovaFile', '$cordovaCamera', 'CommonHeaders', '$timeout', function ($scope, $ionicModal, $ionicPopup, $stateParams, Team, CONFIG, INFO, $ionicActionSheet, $cordovaFile, $cordovaCamera, CommonHeaders, $timeout) {
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
            name: $scope.team.homeCourts[0].name,
            loc: copyLoc($scope.team.homeCourts[0].loc)
          },
          {
            name: ''
          }
        ];
      } else if ($scope.team.homeCourts.length >= 2) {
        $scope.formData.homeCourts = [
          {
            name: $scope.team.homeCourts[0].name,
            loc: copyLoc($scope.team.homeCourts[0].loc)
          },
          {
            name: $scope.team.homeCourts[1].name,
            loc: copyLoc($scope.team.homeCourts[1].loc)
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
      $scope.editingLock = true;
      Team.edit($scope.team._id, $scope.formData, function (err) {
        if (err) {
          $ionicPopup.alert({
            title: '编辑失败',
            template: err
          });
        } else {
          refreshTeamData(function (team) {
            updateFormData();
            $scope.editingLock = false;
          });
          $scope.editing = false;
        }
      });
    };
    var city, marker;
    $ionicModal.fromTemplateUrl('homecourt-modal.html', {
      scope: $scope,
      animation: 'slide-in-up'
    }).then(function(modal) {
      $scope.modal = modal;
    });
    $scope.closeModal = function() {
      $scope.modal.hide();
    };

    $scope.$on('$destroy',function() {
      $scope.modal.remove();
    });

    var placeSearchCallBack = function(homeCourt) {
      return function(data) {
        $scope.locationmap.clearMap();
        if (data.poiList.pois.length == 0) {
          $ionicPopup.alert({
            title: '提示',
            template: '没有符合条件的地点，请重新输入'
          });
          $scope.closeModal();
          return;
        }
        var lngX = data.poiList.pois[0].location.getLng();
        var latY = data.poiList.pois[0].location.getLat();
        homeCourt.loc.coordinates = [lngX, latY];
        var nowPoint = new AMap.LngLat(lngX, latY);
        var markerOption = {
          map: $scope.locationmap,
          position: nowPoint,
          raiseOnDrag: true
        };
        marker = new AMap.Marker(markerOption);
        $scope.locationmap.setFitView();
        AMap.event.addListener($scope.locationmap, 'click', function(e) {
          var lngX = e.lnglat.getLng();
          var latY = e.lnglat.getLat();
          homeCourt.loc.coordinates = [lngX, latY];
          $scope.locationmap.clearMap();
          var nowPoint = new AMap.LngLat(lngX, latY);
          var markerOption = {
            map: $scope.locationmap,
            position: nowPoint,
            raiseOnDrag: true
          };
          marker = new AMap.Marker(markerOption);
        });
      };
    };

    $scope.initialize = function (homeCourt) {
      try {
        $scope.locationmap = new AMap.Map("homeCourtMapDetail"); // 创建Map实例
        $scope.locationmap.plugin(["AMap.ToolBar"], function() {
          toolBar = new AMap.ToolBar();
          $scope.locationmap.addControl(toolBar);
        });
        if (city) {
          $scope.locationmap.plugin(["AMap.PlaceSearch"], function() {
            $scope.MSearch = new AMap.PlaceSearch({ //构造地点查询类
              pageSize: 1,
              pageIndex: 1,
              city: city
            });
            AMap.event.addListener($scope.MSearch, "complete", placeSearchCallBack(homeCourt)); //返回地点查询结果
          });
        } else {
          $scope.locationmap.plugin(["AMap.PlaceSearch"], function() {
            $scope.MSearch = new AMap.PlaceSearch({ //构造地点查询类
              pageSize: 1,
              pageIndex: 1
            });
            AMap.event.addListener($scope.MSearch, "complete", placeSearchCallBack(homeCourt)); //返回地点查询结果
          });
          $timeout(function() {
            $scope.MSearch.search(homeCourt.name);
          });
        }
      } catch (e) {
        console.log(e);
        console.log(e.stack)
      }

      window.team_map_ready = true;
    };

    $scope.showPopup = function(homeCourt) {
      if (!homeCourt || !homeCourt.name || homeCourt.name == '') {
        $ionicPopup.alert({
          title: '提示',
          template: '请输入地点'
        });
        return false;
      } else {
        $scope.modal.show();
        //加载地图
        if (!window.team_map_ready) {
          window.team_map_init = function () {
            $scope.initialize(homeCourt);
          };
          var script = document.createElement("script");
          script.src = "http://webapi.amap.com/maps?v=1.3&key=077eff0a89079f77e2893d6735c2f044&callback=team_map_init";
          document.body.appendChild(script);
        } else {
          $scope.initialize(homeCourt);
        }
      }
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
      var serverAddr = CONFIG.BASE_URL + '/teams/' + $scope.team._id;
      var headers = CommonHeaders.get();
      headers['x-access-token'] = localStorage.accessToken;
      var options = {
        fileKey: 'logo',
        httpMethod: 'PUT',
        headers: headers,
        mimeType: 'image/jpeg'
      };

      $cordovaFile
        .uploadFile(serverAddr, imageURI, options)
        .then(function(result) {
          var successAlert = $ionicPopup.alert({
            title: '提示',
            template: '修改logo成功'
          });
          refreshTeamData();
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
  .controller('PhotoAlbumListController', ['$scope', '$stateParams', 'PhotoAlbum', 'Team', 'INFO',
    function ($scope, $stateParams, PhotoAlbum, Team, INFO) {
      $scope.teamId = $stateParams.teamId;
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
  .controller('PhotoAlbumDetailController', ['$ionicHistory', '$scope', '$stateParams', '$ionicPopup', 'PhotoAlbum', 'Tools', 'INFO', 'CONFIG', 'CommonHeaders', '$cordovaFile', '$cordovaCamera', '$ionicActionSheet', '$ionicModal', '$ionicLoading',
    function ($ionicHistory, $scope, $stateParams, $ionicPopup, PhotoAlbum, Tools, INFO, CONFIG, CommonHeaders, $cordovaFile, $cordovaCamera, $ionicActionSheet, $ionicModal, $ionicLoading) {
      $scope.screenWidth = INFO.screenWidth;
      $scope.screenHeight = INFO.screenHeight;

      var isCampaignPhotoAlbum = false;
      $scope.goBack = function() {
        if($ionicHistory.backView()){
          $ionicHistory.goBack()
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

      $scope.openPhotoSwipe = function (photoId) {
        var pswpElement = document.querySelectorAll('.pswp')[0];

        var index = Tools.arrayObjectIndexOf($scope.photos, photoId, '_id');

        var options = {
          history: false,
          focus: false,
          index: index,
          showAnimationDuration: 0,
          hideAnimationDuration: 0
        };
        var gallery = new PhotoSwipe(pswpElement, PhotoSwipeUI_Default, $scope.photos, options);
        gallery.init();
      };

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

        if (isCampaignPhotoAlbum) {
          serverAddr = CONFIG.BASE_URL + '/comments/host_type/campaign/host_id/' + $scope.photoAlbum.owner.model._id;
          var randomId = Math.floor(Math.random()*100);
          options.params = {
            randomId: randomId
          };
        }

        $ionicLoading.show({
          template: '上传中',
          scope: $scope,
          duration: 5000
        });

        $cordovaFile
          .uploadFile(serverAddr, imageURI, options)
          .then(function(result) {
            $ionicLoading.hide();
            var successAlert = $ionicPopup.alert({
              title: '提示',
              template: '上传照片成功'
            });
            successAlert.then(function () {
              $scope.confirmUploadModal.hide();
              getPhotos();
            });
          }, function(err) {
            $ionicLoading.hide();
            $ionicPopup.alert({
              title: '提示',
              template: '上传失败，请重试'
            });
          }, function (progress) {
          });
      };

      $scope.confirmUpload = function () {
        upload($scope.previewImg);
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
          encodingType: Camera.EncodingType.JPEG,
          popoverOptions: CameraPopoverOptions,
          saveToPhotoAlbum: save,
          correctOrientation: true
        };

        $cordovaCamera.getPicture(options).then(function (imageURI) {
          $scope.previewImg = imageURI;
          $scope.confirmUploadModal.show();
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
  .controller('FamilyPhotoController', ['$ionicHistory', '$scope', '$stateParams', '$ionicPopup', 'INFO', 'Team', 'CONFIG', 'CommonHeaders', '$cordovaFile', '$cordovaCamera', '$ionicActionSheet', 'Tools', '$ionicModal', '$ionicLoading',
    function ($ionicHistory, $scope, $stateParams, $ionicPopup, INFO, Team, CONFIG, CommonHeaders, $cordovaFile, $cordovaCamera, $ionicActionSheet, Tools, $ionicModal, $ionicLoading) {
      $scope.screenWidth = INFO.screenWidth;
      $scope.screenHeight = INFO.screenHeight;

      var isCampaignPhotoAlbum = false;
      $scope.goBack = function() {
        if($ionicHistory.backView()){
          $ionicHistory.goBack()
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

      $scope.openPhotoSwipe = function (photoId) {
        var pswpElement = document.querySelectorAll('.pswp')[0];

        var index = Tools.arrayObjectIndexOf($scope.photos, photoId, '_id');

        var options = {
          history: false,
          focus: false,
          index: index,
          showAnimationDuration: 0,
          hideAnimationDuration: 0
        };
        var gallery = new PhotoSwipe(pswpElement, PhotoSwipeUI_Default, $scope.photos, options);
        gallery.init();
      };

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

        if (isCampaignPhotoAlbum) {
          serverAddr = CONFIG.BASE_URL + '/comments/host_type/campaign/host_id/' + $scope.photoAlbum.owner.model._id;
          var randomId = Math.floor(Math.random()*100);
          options.params = {
            randomId: randomId
          };
        }

        $ionicLoading.show({
          template: '上传中',
          scope: $scope,
          duration: 5000
        });

        $cordovaFile
          .uploadFile(serverAddr, imageURI, options)
          .then(function(result) {
            $ionicLoading.hide();
            var successAlert = $ionicPopup.alert({
              title: '提示',
              template: '上传照片成功'
            });
            successAlert.then(function () {
              $scope.confirmUploadModal.hide();
              getPhotos();
            });
          }, function(err) {
            $ionicLoading.hide();
            $ionicPopup.alert({
              title: '提示',
              template: '上传失败，请重试'
            });
          }, function (progress) {
          });
      };

      $scope.confirmUpload = function () {
        upload($scope.previewImg);
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
          encodingType: Camera.EncodingType.JPEG,
          popoverOptions: CameraPopoverOptions,
          saveToPhotoAlbum: save,
          correctOrientation: true
        };

        $cordovaCamera.getPicture(options).then(function (imageURI) {
          $scope.previewImg = imageURI;
          $scope.confirmUploadModal.show();
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
  .controller('MemberController', ['$ionicHistory', '$scope', '$stateParams', 'INFO', 'Team', function($ionicHistory, $scope, $stateParams, INFO, Team) {
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
    $scope.goBack = function() {
      if($ionicHistory.backView()){
        $ionicHistory.goBack()
      }
    }
  }])
  .controller('LocationController', ['$ionicHistory', '$scope', '$stateParams', 'INFO', function($ionicHistory, $scope, $stateParams, INFO) {
    $scope.location = INFO.locationContent;
    $scope.linkMap = function (location) {
      var link = 'http://m.amap.com/navi/?dest=' + location.coordinates[0] + ',' + location.coordinates[1] + '&destName=' + location.name+'&hideRouteIcon=1&key=077eff0a89079f77e2893d6735c2f044';
      window.open( link, '_system' , 'location=yes');
      return false;
    }
    $scope.goBack = function() {
      if($ionicHistory.backView()){
        $ionicHistory.goBack()
      }
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
    User.getData(localStorage.id, function (err, data) {
      if (err) {
        // todo
        console.log(err);
      } else {
        $scope.user = data;
      }
    });
  }])
  .controller('UserInfoController', ['$ionicHistory', '$scope', '$state', '$stateParams', '$ionicPopover', 'User', function ($ionicHistory, $scope, $state, $stateParams, $ionicPopover, User) {
    
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
      }
    });
  }])
  .controller('UserInfoTimelineController', ['$ionicHistory', '$scope', '$stateParams', 'User', 'TimeLine', function ($ionicHistory, $scope, $stateParams, User, TimeLine) {
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
          $scope.campaignData.deadline = moment(data.deadline).format('YYYY-MM-DDThh:mm');
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
        $scope.campaignData.deadline = localizeDateStr($scope.campaignData.deadline);
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



