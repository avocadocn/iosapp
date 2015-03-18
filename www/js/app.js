// Ionic Starter App

// angular.module is a global place for creating, registering and retrieving Angular modules
// 'starter' is the name of this angular module example (also set in a <body> attribute in index.html)
// the 2nd parameter is an array of 'requires'

angular.module('donlerApp', ['ionic', 'ngCordova', 'donlerApp.controllers', 'donlerApp.services', 'donlerApp.filters', 'donlerApp.directives', 'maggie.emoji', 'ngSanitize'])

  .run(function ($ionicPlatform, $state, $cordovaPush, $ionicLoading, $ionicPopup, $http, $rootScope, CommonHeaders, CONFIG, INFO, UserAuth, CompanyAuth) {
    $ionicPlatform.ready(function () {
      // Hide the accessory bar by default (remove this to show the accessory bar above the keyboard
      // for form inputs)
      if(window.analytics) {
        window.analytics.startTrackerWithId('UA-52353216-2');
        if(localStorage.id){
          window.analytics.setUserId(localStorage.id);
        }
      }
      $rootScope.$on('$stateChangeSuccess',
        function (event, toState, toParams, fromState, fromParams) {
          var nowHash = window.location.hash;
          if(window.analytics &&nowHash!='') {
            window.analytics.trackView(window.location.hash);
          }
      });
      if (window.StatusBar) {
        StatusBar.styleDefault();
      }
      $rootScope.STATIC_URL = CONFIG.STATIC_URL;
      //@:ios
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
        //@:ios_start
        var config;
        if (device.platform === 'iOS') {
          config = iosConfig;
        }
        $cordovaPush.register(config).then(function(result) {
          INFO.pushInfo = {
            ios_token: result
          };
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
        //@:ios_end
      }
      if (localStorage.userType) {
        if (localStorage.userType === 'user') {
          $http.defaults.headers.common['x-access-token'] = localStorage.accessToken;
          UserAuth.refreshToken(function (err) {
             if (err) {
               console.log(err); // 这里没有必要去处理错误，输出供调试即可。失败了仅仅是不能更新token，且没有应对办法，没必要提示用户。
             }
             $state.go('app.campaigns');
          });
        } else if (localStorage.userType === 'company') {
          $http.defaults.headers.common['x-access-token'] = localStorage.accessToken;
          CompanyAuth.refreshToken(function (err) {
            if (err) {
              console.log(err); // 这里没有必要去处理错误，输出供调试即可。失败了仅仅是不能更新token，且没有应对办法，没必要提示用户。
            }
            $state.go('hr_home');
          });
        }
      } else {
        $state.go('home');
      }

      INFO.screenWidth = window.innerWidth;
      INFO.screenHeight = window.innerHeight;

    });

    $ionicPlatform.on('resume', function () {
       if (localStorage.userType) {
         if (localStorage.userType === 'user') {
           UserAuth.refreshToken(function (err) {
             if (err) {
               console.log(err); // 这里没有必要去处理错误，输出供调试即可。失败了仅仅是不能更新token，且没有应对办法，没必要提示用户。
             }
           });
         }
         else if (localStorage.userType === 'company') {
           CompanyAuth.refreshToken(function (err) {
             if (err) {
               console.log(err); // 这里没有必要去处理错误，输出供调试即可。失败了仅仅是不能更新token，且没有应对办法，没必要提示用户。
             }
           });
         }
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
  }).config(function ($stateProvider) {//@:ios
    $stateProvider
      .state('home', {
        url: '/home',
        templateUrl: './views/home.html'
      })
      .state('user_login', {
        cache: false,
        url: '/user/login',
        controller: 'UserLoginController',
        templateUrl: './views/user-login.html'
      })
      .state('hr_login', {
        cache: false,
        url: '/hr/login',
        controller: 'HrLoginController',
        templateUrl: './views/hr-login.html'
      })
      .state('hr_home', {
        url: '/hr/home',
        controller: 'HrHomeController',
        templateUrl: './views/hr-home.html'
      })
      .state('hr_activeCode', {
        url: '/hr/active_code',
        controller: 'HrActiveCodeController',
        templateUrl: './views/hr-active-code.html'
      })
      .state('hr_teamPage', {
        url: '/hr/team_page',
        templateUrl: './views/hr-team-page.html'
      })
      .state('hr_teamList', {
        url: '/hr/team_list/:type',
        controller: 'HrTeamController',
        templateUrl: './views/hr-team-list.html'
      })
      .state('hr_editTeam', {
        url: '/hr/edit_team/:teamId',
        controller: 'HrEditTeamController',
        templateUrl: './views/hr-edit-team.html'
      })
      .state('hr_forget', {
        url: '/hr/forget',
        controller: 'HrForgetController',
        templateUrl: './views/hr-forget.html'
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
        controller: 'CompRegPrivacyController',
        templateUrl: './views/privacy.html'
      })
      .state('register_company_wait', {
        url: '/register/company/wait',
        templateUrl: './views/register-company-wait.html'
      })
      .state('register_user_searchCompany', {
        url: '/register/user/search_company',
        controller:'UserSearchCompanyController',
        templateUrl: './views/register-user-search-company.html'
      })
      .state('register_user_postDetail', {
        url: '/register/user/post_detail/:cid',
        controller: 'UserRegisterDetailController',
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
        controller: 'UserRegPrivacyController',
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
        controller: 'PrivacyController',
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
      .state('campaigns_discuss', {
        url: '/campaign/discuss/:id',
        controller: 'DiscussDetailController',
        templateUrl: './views/campaign-discuss.html'
      })
      .state('sponsor', {
        cache: false,
        url: '/campaign/sponsor/:type',
        controller: 'SponsorController',
        templateUrl: './views/sponsor.html'
      })
      .state('app.discuss_list', {
        url: '/discuss/list',
        controller: 'DiscussListController',
        templateUrl: './views/discuss-list.html'
      })
      .state('chat', {
        url: '/chat/:chatroomId',
        controller: 'ChatroomDetailController',
        templateUrl: './views/discuss-detail.html'
      })
      .state('create_team',{
        url: '/hr/create_team',
        controller: 'CreateTeamController',
        templateUrl: './views/create-team.html'
      })
      .state('app.company', {
        url: '/company',
        // controller: 'CompanyController',
        templateUrl: './views/company.html'
      })
      .state('company_circle', {
        url: '/company/circle',
        controller: 'CompanyCircleController',
        templateUrl: './views/colleague-circle.html'
      })
      .state('company_teams', {
        url: '/company/teams/:type',
        controller: 'CompanyController',
        templateUrl: './views/team-list.html'
      })
      .state('contacts', {
        url: '/company/contacts',
        controller: 'ContactsController',
        templateUrl: './views/contacts.html'
      })
      .state('app.personal', {
        url: '/personal',
        // controller: 'PersonalController',
        templateUrl: './views/personal.html'
      })
      .state('inviteCode', {
        url: '/personal/invitecode',
        controller: 'PersonalInviteCodeController',
        templateUrl: './views/personal-invite-code.html'
      })
      .state('personal_edit', {
        url: '/personal/edit',
        controller: 'PersonalEditController',
        templateUrl: './views/personal-edit.html'
      })
      .state('personal_teams', {
        url: '/personal/teams/:userId',
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
        url: '/calendar/:type',
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
      .state('user_info_timeline', {
        url: '/user/:userId/timeline',
        controller: 'UserInfoTimelineController',
        templateUrl: './views/user-info-timeline.html'
      })
      .state('report_form', {
        url: '/report/:userId',
        controller: 'ReportController',
        templateUrl: './views/report.html'
      })
      .state('app.discover', {
        url: '/discover',
        // controller: 'DiscoverController',
        templateUrl: './views/discover.html'
      })
      .state('search_opponent', {
        url: '/discover/search_opponent',
        controller: 'SearchOpponentController',
        templateUrl: './views/search_opponent.html'
      })
      .state('competition_team', {
        url: '/competition/team/:tid',
        // controller: 'DiscoverController',
        templateUrl: './views/competition_team.html'
      })
      .state('competition_send', {
        url: '/competition/send',
        // controller: 'DiscoverController',
        templateUrl: './views/competition_send.html'
      })
      .state('rank_select', {
        url: '/rank/select',
        controller: 'RankSelectController',
        templateUrl: './views/rank_select.html'
      })
      .state('rank_detail', {
        url: '/rank/detail/:gid',
        controller: 'RankDetailController',
        templateUrl: './views/rank_detail.html'
      })
      .state('competition_message_list', {
        url: '/competition_message/list',
        controller: 'CompetitionMessageListController',
        templateUrl: './views/competition_message_list.html'
      })
      .state('competition_log_detail', {
        url: '/competition/log_detail/:id/:type',
        // controller: 'DiscoverController',
        templateUrl: './views/competition_log_detail.html'
      })
      .state('circle_uploader', {
        url: '/circle/uploader',
        templateUrl: './views/circle_uploader.html',
        controller: 'CircleUploaderController'
      })
      .state('competition_message_detail', {
        url: '/competition_message/detail/:id',
        controller: 'CompetitionMessageDetailController',
        templateUrl: './views/competition_message_detail.html'
      });
  });