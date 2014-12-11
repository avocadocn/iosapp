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
          $state.go('campaigns');
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
  .controller('DiscussListController', ['$scope', function ($scope) {

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
  .controller('CalendarController', ['$scope', function ($scope) {

  }]);
