// Ionic Starter App

// angular.module is a global place for creating, registering and retrieving Angular modules
// 'starter' is the name of this angular module example (also set in a <body> attribute in index.html)
// the 2nd parameter is an array of 'requires'
angular.module('donlerApp', ['ionic', 'donlerApp.controllers', 'donlerApp.services'])

  .run(function ($ionicPlatform, $state, $http) {
    $ionicPlatform.ready(function () {
      // Hide the accessory bar by default (remove this to show the accessory bar above the keyboard
      // for form inputs)
      if (window.cordova && window.cordova.plugins.Keyboard) {
        cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true);
      }
      if (window.StatusBar) {
        StatusBar.styleDefault();
      }
      $state.go('campaigns');
    });
  }).config(function ($stateProvider) {
    $stateProvider.state('home', {
      url: '/home',
      templateUrl: 'views/home.html'
    }).state('user_login', {
      url: '/user_login',
      controller: 'UserLoginController',
      templateUrl: 'views/user_login.html'
    }).state('register', {
      url: '/register',
      templateUrl: 'views/register.html'
    }).state('campaigns', {
      url: '/campaigns',
      controller: 'CampaignController',
      templateUrl: 'views/campaign.html'
    }).state('discuss', {
      url: '/discuss',
      controller: 'DiscussController',
      templateUrl: 'views/discuss.html'
    }).state('discover', {
      url: '/discover',
      controller: 'DiscoverController',
      templateUrl: 'views/discover.html'
    }).state('personal', {
      url: '/personal',
      controller: 'PersonalController',
      templateUrl: 'views/personal.html'
    });
  });