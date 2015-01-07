// Ionic Starter App

// angular.module is a global place for creating, registering and retrieving Angular modules
// 'starter' is the name of this angular module example (also set in a <body> attribute in index.html)
// the 2nd parameter is an array of 'requires'

angular.module('donlerApp', ['ionic', 'ngCordova', 'donlerApp.controllers', 'donlerApp.services', 'donlerApp.filters', 'donlerApp.directives', 'dbaq.emoji', 'ngSanitize'])

  .run(function ($ionicPlatform, $state, $cordovaPush, $ionicLoading, $ionicPopup, $http, $rootScope, CommonHeaders, CONFIG) {
    $ionicPlatform.ready(function () {
      // Hide the accessory bar by default (remove this to show the accessory bar above the keyboard
      // for form inputs)
      if (window.cordova && window.cordova.plugins.Keyboard) {
        cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true);
      }
      if (window.StatusBar) {
        StatusBar.styleDefault();
      }

      $rootScope.STATIC_URL = CONFIG.STATIC_URL;

      var iosConfig = {
        "badge": "true",
        "sound": "false",
        "alert": "true"
      };

      if (typeof device !== 'undefined') {
        CommonHeaders.set({
          'x-device-id': device.uuid,
          'x-device-type': device.model,
          'x-platform': device.platform,
          'x-version': device.version
        });

        var config;
        if (device.platform === 'iOS') {
          config = iosConfig;
        }
        $cordovaPush.register(config).then(function(result) {
          CommonHeaders.set({
            'x-device-token': result
          });
        }, function(err) {
          console.log(err);
        });

        $rootScope.$on('pushNotificationReceived', function(event, notification) {
          var confirmPopup = $ionicPopup.confirm({
            title: '提示',
            template: notification.alert,
            okText: '查看详情',
            cancelText: '忽略'
          });
          confirmPopup.then(function (res) {
            if (res) {
              $state.go('campaigns_detail',{ 'id': notification.campaignId });
            }
          });

        });

      }

      if (localStorage.userType) {
        if (localStorage.userType === 'user') {
          $http.defaults.headers.common['x-access-token'] = localStorage.accessToken;
          $state.go('app.campaigns');
        } else if (localStorage.userType === 'company') {
          $http.defaults.headers.common['x-access-token'] = localStorage.accessToken;
          $state.go('company_home');
        }
      } else {
        $state.go('home');
      }

    });
    $rootScope.showLoading = function() {
      $ionicLoading.show({
        template: '<i class="icon ion-looping"></i>正在加载'
      });
    };
    $rootScope.hideLoading = function(){
      $ionicLoading.hide();
    };
  }).config(function ($stateProvider) {
    $stateProvider
      .state('home', {
        url: '/home',
        templateUrl: './views/home.html'
      })
      .state('user_login', {
        url: '/user/login',
        controller: 'UserLoginController',
        templateUrl: './views/user-login.html'
      })
      .state('company_login', {
        url: '/company/login',
        controller: 'CompanyLoginController',
        templateUrl: './views/company-login.html'
      })
      .state('company_home', {
        url: '/company/home',
        controller: 'CompanyHomeController',
        templateUrl: './views/company-home.html'
      })
      .state('company_activeCode', {
        url: '/company/active_code',
        controller: 'CompanyActiveCodeController',
        templateUrl: './views/company-active-code.html'
      })
      .state('company_teamPage', {
        url: '/company/team_page',
        templateUrl: './views/company-team-page.html'
      })
      .state('company_teamList', {
        url: '/company/team_list/:type',
        controller: 'CompanyTeamController',
        templateUrl: './views/company-team-list.html'
      })
      .state('company_forget', {
        url: '/company/forget',
        controller: 'CompanyForgetController',
        templateUrl: './views/company-forget.html'
      })
      .state('user_forget', {
        url: '/user/forget',
        controller: 'UserForgetController',
        templateUrl: './views/user-forget.html'
      })
      .state('register_company', {
        url: '/register/company',
        templateUrl: './views/register-company.html'
      })
      .state('register_company_law', {
        url: '/register/company/law',
        controller: 'compRegPrivacyController',
        templateUrl: './views/privacy.html'
      })
      .state('register_company_wait', {
        url: '/register/company/wait',
        templateUrl: './views/register-company-wait.html'
      })
      .state('register_user_searchCompany', {
        url: '/register/user/search_company',
        controller:'userSearchCompanyController',
        templateUrl: './views/register-user-search-company.html'
      })
      .state('register_user_postDetail', {
        url: '/register/user/post_detail/:cid',
        controller: 'userRegisterDetailController',
        templateUrl: './views/register-user-post-detail.html'
      })
      .state('register_user_remind_activate', {
        url: '/register/user/remind_activate',
        templateUrl: './views/register-user-remind-activate.html'
      })
      .state('register_user_waitEmail', {
        url: '/register/user/wait_email',
        templateUrl: './views/register-user-wait-email.html'
      })
      .state('register_user_activeCode', {
        url: '/register/user/active_code',
        templateUrl: './views/register-user-active-code.html'
      })
      .state('register_user_law', {
        url: '/register/user/law',
        controller: 'userRegPrivacyController',
        templateUrl: './views/privacy.html'
      })
      .state('app', {
        url: '/app',
        abstract: true,
        templateUrl: './views/tab-layout.html',
        controller: 'AppContoller'
      })
      .state('privacy', {
        url: '/settings/about/privacy',
        controller: 'privacyController',
        templateUrl: './views/privacy.html'
      })
      .state('app.campaigns', {
        url: '/campaigns',
        // controller: 'CampaignController',
        templateUrl: './views/campaign.html'
      })
      .state('campaigns_detail', {
        url: '/campaign/detail/:id',
        controller: 'CampaignDetailController',
        templateUrl: './views/campaign-detail.html'
      })
      .state('campaigns_edit', {
        url: '/campaign/edit/:id',
        controller: 'CampaignEditController',
        templateUrl: './views/campaign-edit.html'
      })
      .state('sponsor', {
        url: '/campaign/sponsor',
        controller: 'SponsorController',
        templateUrl: './views/sponsor.html'
      })
      .state('app.discuss_list', {
        url: '/discuss/list',
        // controller: 'DiscussListController',
        templateUrl: './views/discuss-list.html'
      })
      .state('unjoined_discuss_list', {
        url: '/discuss/list/unjoined',
        controller: 'UnjoinedDiscussController',
        templateUrl: './views/unjoined-discuss-list.html'
      })
      .state('discuss_detail', {
        url: '/discuss/detail/:campaignId',
        controller: 'DiscussDetailController',
        templateUrl: './views/discuss-detail.html'
      })
      .state('create_team',{
        url: '/company/create_team',
        controller: 'createTeamController',
        templateUrl: './views/create-team.html'
      })
      .state('app.discover', {
        url: '/discover',
        // controller: 'DiscoverController',
        templateUrl: './views/discover.html'
      })
      .state('discover_circle', {
        url: '/discover/circle',
        controller: 'DiscoverCircleController',
        templateUrl: './views/colleague-circle.html'
      })
      .state('discover_teams', {
        url: '/discover/teams/:type',
        controller: 'DiscoverController',
        templateUrl: './views/team-list.html'
      })
      .state('contacts', {
        url: '/discover/contacts',
        controller: 'ContactsController',
        templateUrl: './views/contacts.html'
      })
      .state('app.personal', {
        url: '/personal',
        // controller: 'PersonalController',
        templateUrl: './views/personal.html'
      })
      .state('personal_edit', {
        url: '/personal/edit',
        controller: 'PersonalEditController',
        templateUrl: './views/personal-edit.html'
      })
      .state('personal_teams', {
        url: '/personal/teams',
        controller: 'PersonalTeamListController',
        templateUrl: './views/personal-team-list.html'
      })
      .state('personal_timeline', {
        url: '/personal/timeline',
        controller: 'TimelineController',
        templateUrl: './views/timeline.html'
      })
      // .state('personal_messages', {
      //   url: '/personal/messages',
      //   controller: 'MessageController',
      //   templateUrl: './views/messages.html'
      // })
      .state('settings', {
        url: '/settings',
        controller: 'SettingsController',
        templateUrl: './views/settings.html'
      })
      .state('settings_account', {
        url: '/settings/account',
        controller: 'AccoutController',
        templateUrl: './views/settings-account.html'
      })
      .state('change_password', {
        url: '/settings/account/change_password',
        controller: 'PasswordController',
        templateUrl: './views/settings-change-password.html'
      })
      .state('settings_feedback', {
        url: '/settings/feedback',
        controller: 'FeedbackController',
        templateUrl: './views/settings-feedback.html'
      })
      .state('settings_about', {
        url: '/settings/about',
        templateUrl: './views/settings-about.html'
      })
      .state('good', {
        url: '/settings/about/good',
        templateUrl: './views/about-good.html'
      })
      .state('intro', {
        url: '/settings/about/intro',
        templateUrl: './views/about-intro.html'
      })
      .state('notice', {
        url: '/settings/about/notice',
        templateUrl: './views/about-notice.html'
      })
      .state('calendar', {
        url: '/calendar',
        controller: 'CalendarController',
        templateUrl: './views/calendar.html'
      })
      .state('team', {
        url: '/team/:teamId',
        controller: 'TeamController',
        templateUrl: './views/team-detail.html'
      })
      .state('team_edit', {
        url: '/team/:teamId/edit',
        controller: 'TeamEditController',
        templateUrl: './views/team-edit.html'
      })
      .state('team_family', {
        url: '/team/:teamId/family',
        controller: 'FamilyPhotoController',
        templateUrl: './views/family-photo.html'
      })
      .state('members', {
        url: '/members/:memberType/:id',
        controller: 'MemberController',
        templateUrl: './views/members.html'
      })

      .state('location', {
        url: '/location/:id',
        controller: 'LocationController',
        templateUrl: './views/location.html'
      })
      .state('photo_album_list', {
        url: '/photo_album/list/team/:teamId',
        controller: 'PhotoAlbumListController',
        templateUrl: './views/photo-album-list.html'
      })
      .state('photo_album_detail', {
        url: '/photo_album/:photoAlbumId/detail',
        controller: 'PhotoAlbumDetailController',
        templateUrl: './views/photo-album-detail.html'
      })
      .state('user_info', {
        url: '/user/:userId',
        controller: 'UserInfoController',
        templateUrl: './views/user-info.html'
      })
      .state('report_form', {
        url: '/report/:userId',
        controller: 'ReportController',
        templateUrl: './views/report.html'
      });
  });