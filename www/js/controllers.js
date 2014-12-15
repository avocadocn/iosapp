/**
 * Created by Sandeep on 11/09/14.
 */

angular.module('donlerApp.controllers', [])
  .directive('preventDefault', function() {
      return function(scope, element, attrs) {
          angular.element(element).bind('click', function(event) {
              event.preventDefault();
              event.stopPropagation();
          });
      }
  })
  .controller('AppContoller', ['$scope', function ($scope) {

  }])
  .controller('UserLoginController', ['$scope', '$state', 'UserAuth', function ($scope, $state, UserAuth) {

    $scope.loginData = {
      email: '',
      password: ''
    };

    $scope.login = function () {
      UserAuth.login($scope.loginData.email, $scope.loginData.password, function (err) {
        if (err) {
          // todo
          console.log(err);
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
      CompanyAuth.login($scope.loginData.username, $scope.loginData.password, function (err) {
        if (err) {
          // todo
          console.log(err);
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
        } else {
          $state.go('home');
        }
      });
    };

  }])
  .controller('CampaignController', ['$scope', '$state', '$timeout', 'Campaign', function ($scope, $state, $timeout, Campaign) {
    $scope.nowType = 'all';
    if(!localStorage.id){
      return $state.go('login');
    }
    Campaign.getAll('user',localStorage.id,function(err,data){
      if(!err){
        $scope.unStartCampaigns = data[0];
        $scope.nowCampaigns = data[1];
        $scope.newCampaigns = data[2];
        $scope.provokes = data[3];
      }
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
  }])
  .controller('CampaignDetailController', ['$scope', '$state', 'Campaign', function ($scope, $state, Campaign) {
    Campaign.get($state.params.id, function(err, data){
      if(!err){
        $scope.campaign = data;
      }
    });
    $scope.join = function(id){
      Campaign.join(id,localStorage.id, function(err, data){
        if(!err){
          $scope.campaign = data;
          alert('参加成功');
        }
      });
      return false;
    }
    $scope.quit = function(id){
      Campaign.quit(id,localStorage.id, function(err, data){
        if(!err){
          $scope.campaign = data;
          alert('退出成功');
        }
      });
      return false;
    }
  }])
  .controller('DiscussListController', ['$scope', 'Comment', 'Socket', 'Tools', function ($scope, Comment, Socket, Tools) { //标为全部已读???
    Socket.emit('enterRoom', localStorage.id);
    //进来以后先http请求,再监视推送
    Comment.getList('joined').success(function (data) {
      $scope.commentCampaigns = data.commentCampaigns;
      $scope.newUnjoined = data.newUnjoinedCampaignComment;
      localStorage.hasNewComment = false;
    });
    Socket.on('newCommentCampaign', function (data) {
      var newCommentCampaign = data;
      var index = Tools.arrayObjectIndexOf($scope.commentCampaigns, newCommentCampaign._id, '_id');
    });
    Socket.on('newUnjoinedCommentCampaign', function (data) {
      $scope.newUnjoined = true;
    });
  }])
  .controller('DiscussDetailController', ['$scope', '$stateParams', '$ionicScrollDelegate', 'Comment', 'Socket', function ($scope, $stateParams, $ionicScrollDelegate, Comment, Socket) {
    Socket.emit('enterRoom', $stateParams.campaignId);
    //无论进入离开，都需归零user的对应campaign的unread数目
    //获取时清空好了
    Comment.getComments($stateParams.campaignId, 20).success(function(data){
      $scope.comments = data.comments.reverse();//保证最新的在最下面
      $scope.nextStartDate = data.nextStartDate;
      $ionicScrollDelegate.scrollBottom();
    });
    //获取公告
    //todo
    
    //获取新留言
    Socket.on('newCampaignComment', function (data) {
      console.log('???');
      $scope.comments.push(data);
      //滚到最下?
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
      }
    };
  }])
  .controller('DiscoverController', ['$scope', function ($scope) {

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
  .controller('PersonalTeamListController', ['$scope', 'Team', function ($scope, Team) {
    $scope.backLink = '#/app/personal';
    $scope.backLinkText = '我的';
    $scope.title = '我的小队';

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
  .controller('CalendarController', ['$scope', function ($scope) {

  }])
  .controller('privacyController', ['$scope', '$ionicNavBarDelegate', function ($scope, $ionicNavBarDelegate) {
    $scope.backHref = '#/personal/settings/about';
  }])
  .controller('compRegPrivacyController', ['$scope', '$ionicNavBarDelegate', function ($scope, $ionicNavBarDelegate) {
    $scope.backHref = '#/register/company';
  }])
  .controller('userRegPrivacyController', ['$scope', '$ionicNavBarDelegate', function ($scope, $ionicNavBarDelegate) {
    $scope.backHref = '#/register/user/post_detail';
  }]);
