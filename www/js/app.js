// Ionic Starter App

// angular.module is a global place for creating, registering and retrieving Angular modules
// 'starter' is the name of this angular module example (also set in a <body> attribute in index.html)
// the 2nd parameter is an array of 'requires'
angular.module('donlerApp', ['ionic', 'donlerApp.controllers', 'donlerApp.services'])

  .run(function ($ionicPlatform, $state, $http,$rootScope) {
    $ionicPlatform.ready(function () {
      // Hide the accessory bar by default (remove this to show the accessory bar above the keyboard
      // for form inputs)
      if (window.cordova && window.cordova.plugins.Keyboard) {
        cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true);
      }
      if (window.StatusBar) {
        StatusBar.styleDefault();
      }
      $rootScope.STATIC_URL ='http://localhost:3000';
      $http.defaults.headers.common['x-app-id'] = '';
      $http.defaults.headers.common['x-api-key'] = '';
      $http.defaults.headers.common['x-device-id'] = '';
      $http.defaults.headers.common['x-device-type'] = '';
      $http.defaults.headers.common['x-platform'] = '';
      $http.defaults.headers.common['x-version'] = '';
      if (localStorage.userType) {
        if (localStorage.userType === 'user') {
          $http.defaults.headers.common['x-access-token'] = localStorage.accessToken;
          $state.go('campaigns');
        } else if (localStorage.userType === 'company') {
          $http.defaults.headers.common['x-access-token'] = localStorage.accessToken;
          // todo 企业登录后页面未知
          $state.go('campaigns');
        }
      } else {
        $state.go('home');
      }
    });
  }).config(function ($stateProvider) {
    $stateProvider.state('home', {
      url: '/home',
      templateUrl: 'views/home.html'
    }).state('user_login', {
      url: '/user/login',
      controller: 'UserLoginController',
      templateUrl: 'views/user-login.html'
    }).state('company_login', {
      url: '/company/login',
      controller: 'CompanyLoginController',
      templateUrl: 'views/company-login.html'
    }).state('register', {
      url: '/register',
      templateUrl: 'views/register.html'
    }).state('campaigns', {
      url: '/campaigns',
      controller: 'CampaignController',
      templateUrl: 'views/campaign.html'
    }).state('campaigns_detail', {
      url: '/campaign/detail',
      controller: 'CampaignDetailController',
      templateUrl: 'views/campaign-detail.html'
    }).state('discuss_list', {
      url: '/discuss/list',
      controller: 'DiscussListController',
      templateUrl: 'views/discuss-list.html'
    }).state('discuss_detail', {
      url: '/discuss/detail',
      controller: 'DiscussDetailController',
      templateUrl: 'views/discuss-detail.html'
    }).state('discover', {
      url: '/discover',
      controller: 'DiscoverController',
      templateUrl: 'views/discover.html'
    }).state('discover_circle', {
      url: '/discover/circle',
      templateUrl: 'views/colleague-circle.html'
    }).state('discover_teams', {
      url: '/discover/teams',
      templateUrl: 'views/team-list.html'
    }).state('personal', {
      url: '/personal',
      controller: 'PersonalController',
      templateUrl: 'views/personal.html'
    }).state('personal_teams', {
      url: '/personal/teams',
      templateUrl: 'views/team-list.html'
    }).state('personal_timeline', {
      url: '/personal/timeline',
      templateUrl: 'views/timeline.html'
    }).state('personal_messages', {
      url: '/personal/messages',
      templateUrl: 'views/messages.html'
    }).state('settings', {
      url: '/personal/settings',
      controller: 'SettingsController',
      templateUrl: 'views/settings.html'
    }).state('settings_account', {
      url: '/personal/settings/account',
      templateUrl: 'views/settings-account.html'
    }).state('settings_feedback', {
      url: '/personal/settings/feedback',
      templateUrl: 'views/settings-feedback.html'
    }).state('settings_about', {
      url: '/personal/settings/about',
      templateUrl: 'views/settings-about.html'
    }).state('calendar', {
      url: '/calendar',
      controller: 'CalendarController',
      templateUrl: 'views/calendar.html'
    }).state('team', {
      url: '/team',
      templateUrl: 'views/team-detail.html'
    }).state('members', {
      url: '/members',
      templateUrl: 'views/members.html'
    }).state('photo_album_list', {
      url: '/photo_album/list',
      templateUrl: 'views/photo-album-list.html'
    }).state('photo_album_detail', {
      url: '/photo_album/detail',
      templateUrl: 'views/photo-album-detail.html'
    }).state('photo_detail', {
      url: '/photo_album/photo',
      templateUrl: 'views/photo-detail.html'
    });
  });