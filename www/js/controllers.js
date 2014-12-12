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
  .controller('CampaignController', ['$scope', '$timeout', 'Campaign', function ($scope, $timeout, Campaign) {
    $scope.nowType = 'all';
    Campaign.getAll('user','53aa7a0c6b2836fd41ba41d7').success(function(data){
      $scope.unStartCampaigns = data[0];
      $scope.nowCampaigns = data[1];
      $scope.newCampaigns = data[2];
      $scope.provokes = data[3];
      $timeout(function(){
        $scope.$broadcast('scroll.resize');
      });
    })
  }])
  .controller('CampaignDetailController', ['$scope', 'Campaign', function ($scope, Campaign) {
  }])
  .controller('DiscussListController', ['$scope','Comment', function ($scope, Comment) {
    //进来以后先http请求,再监视推送
    Comment.getList().success(function(data){
      $scope.commentCampaignList = data;
    });
  }])
  .controller('DiscussDetailController', ['$scope', function ($scope) {

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
    }
  }])
  .controller('CalendarController', ['$scope', function ($scope) {

  }]);
