// Ionic Starter App

// angular.module is a global place for creating, registering and retrieving Angular modules
// 'starter' is the name of this angular module example (also set in a <body> attribute in index.html)
// the 2nd parameter is an array of 'requires'
angular.module('donlerApp', ['ionic', 'donlerApp.controllers', 'donlerApp.services','donlerApp.filters'])

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
      $rootScope.STATIC_URL ='http://192.168.2.107:3000';
      $http.defaults.headers.common['x-app-id'] = '';
      $http.defaults.headers.common['x-api-key'] = '';
      $http.defaults.headers.common['x-device-id'] = '';
      $http.defaults.headers.common['x-device-type'] = '';
      $http.defaults.headers.common['x-platform'] = '';
      $http.defaults.headers.common['x-version'] = '';
      if (localStorage.userType) {
        if (localStorage.userType === 'user') {
          $http.defaults.headers.common['x-access-token'] = localStorage.accessToken;
          $state.go('app.campaigns');
        } else if (localStorage.userType === 'company') {
          $http.defaults.headers.common['x-access-token'] = localStorage.accessToken;
          // todo 企业登录后页面未知
          $state.go('company_home');
        }
      } else {
        $state.go('home');
      }
    });
  }).config(function ($stateProvider) {
    $stateProvider.state('home', {
      url: '/home',
      templateUrl: 'views/home.html'
    })
    .state('user_login', {
      url: '/user/login',
      controller: 'UserLoginController',
      templateUrl: 'views/user-login.html'
    })
    .state('company_login', {
      url: '/company/login',
      controller: 'CompanyLoginController',
      templateUrl: 'views/company-login.html'
    })
    .state('company_home', {
      url: '/company/home',
      controller: 'CompanyHomeController',
      templateUrl: 'views/company-home.html'
    })
    .state('company_activeCode', {
      url: '/company/active_code',
      templateUrl: 'views/company-active-code.html'
    })
    .state('company_teamList', {
      url: '/company/team_list',
      templateUrl: 'views/company-team-list.html'
    })
    .state('register_company', {
      url: '/register/company',
      templateUrl: 'views/register-company.html'
    })
    .state('register_company_law', {
      url: '/register/company/law',
      controller: 'compRegPrivacyController',
      templateUrl: 'views/privacy.html'
    })
    .state('register_user_searchCompany', {
      url: '/register/user/search_company',
      templateUrl: 'views/register-user-search-company.html'
    })
    .state('register_user_postDetail', {
      url: '/register/user/post_detail',
      templateUrl: 'views/register-user-post-detail.html'
    })
    .state('register_user_waitEmail', {
      url: '/register/user/wait_email',
      templateUrl: 'views/register-user-wait-email.html'
    })
    .state('register_user_activeCode', {
      url: '/register/user/active_code',
      templateUrl: 'views/register-user-active-code.html'
    })
    .state('register_user_law', {
      url: '/register/user/law',
      controller: 'userRegPrivacyController',
      templateUrl: 'views/privacy.html'
    })
    .state('app.privacy', {
      url: '/settings/about/privacy',
      views: {
        'tab-campaign': {
          controller: 'privacyController',
          templateUrl: 'views/privacy.html'
        }
      }
    })
    .state('app', {
      url: '/app',
      abstract: true,
      templateUrl: 'views/tab-layout.html',
      controller: 'AppContoller'
    })
    .state('app.campaigns', {
      url: '/campaigns',
      views: {
        'tab-campaign': {
          controller: 'CampaignController',
          templateUrl: 'views/campaign.html'
        }
      }
    })
    .state('campaigns_detail', {
      url: '/campaign/detail/:id',
      controller: 'CampaignDetailController',
      templateUrl: 'views/campaign-detail.html'
    })

    .state('app.discuss_list', {
      url: '/discuss/list',
      views: {
        'tab-discuss-list': {
          controller: 'DiscussListController',
          templateUrl: 'views/discuss-list.html'
        }
      }
    })
    .state('unjoined_discuss_list', {
      url: '/discuss/list/unjoined',
      controller: 'UnjoinedDiscussController',
      templateUrl: 'views/unjoined-discuss-list.html'
    })
    .state('discuss_detail', {
      url: '/discuss/detail/:campaignId/:campaignName',
      controller: 'DiscussDetailController',
      templateUrl: 'views/discuss-detail.html'
    })

    .state('app.discover', {
      url: '/discover',
      views: {
        'tab-discover': {
          controller: 'DiscoverController',
          templateUrl: 'views/discover.html'
        }
      }
    })
    .state('app.discover_circle', {
      url: '/discover/circle',
      views: {
        'tab-discover': {
          controller: 'DiscoverCircleController',
          templateUrl: 'views/colleague-circle.html'
        }
      }
    })
    .state('app.discover_teams', {
      url: '/discover/teams',
      views: {
        'tab-discover': {
          controller: 'DiscoverController',
          templateUrl: 'views/team-list.html'
        }
      }
    })
    .state('app.personal', {
      url: '/personal',
      views: {
        'tab-personal': {
          controller: 'PersonalController',
          templateUrl: 'views/personal.html'
        }
      }
    })
    .state('app.personal_teams', {
      url: '/personal_teams',
      views: {
        'tab-personal': {
          controller: 'PersonalTeamListController',
          templateUrl: 'views/personal-team-list.html'
        }
      }
    })
    .state('personal_timeline', {
      url: '/personal/timeline',
      templateUrl: 'views/timeline.html'
    })
    .state('personal_messages', {
      url: '/personal/messages',
      templateUrl: 'views/messages.html'
    })
    .state('app.settings', {
      url: '/settings',
      views: {
        'tab-personal': {
          controller: 'SettingsController',
          templateUrl: 'views/settings.html'
        }
      }
    })
    .state('app.settings_account', {
      url: '/settings/account',
      views: {
        'tab-personal': {
          templateUrl: 'views/settings-account.html'
        }
      }
    })
    .state('app.settings_feedback', {
      url: '/settings/feedback',
      views: {
        'tab-personal': {
          templateUrl: 'views/settings-feedback.html'
        }
      }
    })
    .state('app.settings_about', {
      url: '/settings/about',
      views: {
        'tab-personal': {
          templateUrl: 'views/settings-about.html'
        }
      }
    })
    .state('calendar', {
      url: '/calendar',
      controller: 'CalendarController',
      templateUrl: 'views/calendar.html'
    })
    .state('team', {
      url: '/team/:teamId',
      controller: 'TeamController',
      templateUrl: 'views/team-detail.html'
    })
    .state('members', {
      url: '/team/:teamId/members',
      controller: 'MemberController',
      templateUrl: 'views/members.html'
    })
    .state('photo_album_list', {
      url: '/photo_album/list/team/:teamId',
      controller: 'PhotoAlbumListController',
      templateUrl: 'views/photo-album-list.html'
    })
    .state('photo_album_detail', {
      url: '/photo_album/:photoAlbumId/detail',
      controller: 'PhotoAlbumDetailController',
      templateUrl: 'views/photo-album-detail.html'
    })
    .state('photo_detail', {
      url: '/photo_album/:photoAlbumId/photo/:photoId',
      templateUrl: 'views/photo-detail.html'
    });
  });