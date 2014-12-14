/**
 * Created by Sandeep on 11/09/14.
 */

angular.module('donlerApp.controllers', [])
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
          $state.go('campaigns');
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
    Campaign.getAll('user',localStorage.id).success(function(data){
      $scope.unStartCampaigns = data[0];
      $scope.nowCampaigns = data[1];
      $scope.newCampaigns = data[2];
      $scope.provokes = data[3];
    })
  }])
  .controller('CampaignDetailController', ['$scope', 'Campaign', function ($scope, Campaign) {
  }])
  .controller('DiscussListController', ['$scope', 'Comment', 'Socket', 'Tools', function ($scope, Comment, Socket, Tools) { //标为全部已读???
    //进来以后先http请求,再监视推送
    Comment.getList('joined').success(function(data){
      console.log(data);
      $scope.commentCampaigns = data.commentCampaigns;
      $scope.newUnjoined = data.newUnjoinedCampaignComment;
      localStorage.hasNewComment = false;
    });
    Socket.on('newCommentCampaign',function(data){
      var newCommentCampaign = data;
      var index = Tools.arrayObjectIndexOf($scope.commentCampaigns, newCommentCampaign._id, '_id');
    });
    Socket.on('newUnjoinedCommentCampaign', function(data){
      $scope.newUnjoined = true;
    })
  }])
  .controller('DiscussDetailController', ['$scope', function ($scope) {
    //无论进入离开，都需归零user的对应campaign的unread数目
    //获取时清空好了
    
  }])
  .controller('DiscoverController', ['$scope', function ($scope) {

  }])
  .controller('PersonalController', ['$scope','$state', 'UserAuth', function ($scope, $state, UserAuth) {

  }])
  .controller('SettingsController', ['$scope','$state', 'UserAuth', function ($scope, $state, UserAuth) {

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
  .controller('TabController', ['$scope','Socket', function($scope, Socket) {
    //每次进入页面判断是否有新评论没看
    if(localStorage.hasNewComment === true){
      $scope.hasNewComment = true;
    }
    //socket服务器推送通知
    Socket.on('getNewComment', function(){
      $scope.hasNewComment = true;
      localStorage.hasNewComment = true;
    });
    //点过去就代表看过了

    $scope.readComments = function(){
      $scope.hasNewComment = false;
      localStorage.hasNewComment = false;
    };
  }])
  .controller('CalendarController', ['$scope', function ($scope) {

  }])
  .controller('privacyController', ['$scope', '$ionicNavBarDelegate', function($scope, $ionicNavBarDelegate) {
    $scope.backHref = '#/personal/settings/about';
  }])
  .controller('compRegPrivacyController', ['$scope', '$ionicNavBarDelegate', function($scope, $ionicNavBarDelegate) {
    $scope.backHref = '#/register/company';
  }])
  .controller('userRegPrivacyController', ['$scope', '$ionicNavBarDelegate', function($scope, $ionicNavBarDelegate) {
    $scope.backHref = '#/register/user/post_detail';
  }]);