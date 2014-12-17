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
  .controller('CampaignController', ['$scope', '$state', '$timeout', 'Campaign', 'INFO', function ($scope, $state, $timeout, Campaign, INFO) {
    $scope.nowType = 'all';
    INFO.campaignBackUrl = '#/app/campaigns';
    if(!localStorage.id){
      return $state.go('login');
    }
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
  .controller('CampaignDetailController', ['$scope', '$state', 'Campaign', 'Message', 'INFO', function ($scope, $state, Campaign, Message, INFO) {
    $scope.backUrl = INFO.campaignBackUrl;
    INFO.photoAlbumBackUrl = '#/campaign/detail/' + $state.params.id;
    INFO.memberBackUrl = '#/campaign/detail/' + $state.params.id;
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
    }
  }])
  .controller('UnjoinedDiscussController', ['$scope', 'Comment', 'Socket', 'Tools', function ($scope, Comment, Socket, Tools) { //标为全部已读???
    Socket.emit('enterRoom', localStorage.id);
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
    }
  }])
  .controller('DiscussDetailController', ['$scope', '$stateParams', '$ionicScrollDelegate', 'Comment', 'Socket', 'Message', function ($scope, $stateParams, $ionicScrollDelegate, Comment, Socket, Message) {
    $scope.campaignTitle =  $stateParams.campaignName;
    Socket.emit('enterRoom', $stateParams.campaignId);
    //无论进入离开，都需归零user的对应campaign的unread数目
    //获取时清空好了
    var nextStartDate ='';
    Comment.getComments($stateParams.campaignId, 20).success(function(data){
      $scope.comments = data.comments.reverse();//保证最新的在最下面
      nextStartDate = data.nextStartDate;
      $ionicScrollDelegate.scrollBottom();
    });
    //获取公告
    Message.getCampaignMessages($stateParams.campaignId, function(err, data){
      if(err){
        console.log(err)
      }else{
        if(data.length>0){
          $scope.noticeSender = data[0].sender[0].nickname;
          $scope.notification = data[0].content;
        }
      }
    })
    
    //获取新留言
    Socket.on('newCampaignComment', function (data) {
      data.create_date = data.createDate;
      $scope.comments.push(data);
      $scope.comments[$scope.comments.length-1].showTime = $scope.needShowTime($scope.comments.length-1);
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
      };
    };
    $scope.historyCommentList=[];
    //拉取历史讨论记录
    $scope.readHistory = function() {
      Comment.getComments($stateParams.campaignId, 20, nextStartDate).success(function(data){
        $scope.historyCommentList.unshift(data.comments.reverse());
        // $('#currentComment').scrollIntoView();//need jQuery
        nextStartDate = data.nextStartDate;
        $scope.$broadcast('scroll.refreshComplete');
      });
    };
    //发表评论
    $scope.publishComment = function(photo) {
      Comment.publishComment($stateParams.campaignId, $scope.commentContent, photo, function(err){
        if(err){
          console.log(err);
        }else{
          $scope.commentContent = '';
        }
      });
    };
  }])
  .controller('DiscoverController', ['$scope', 'Team', 'INFO', function ($scope, Team, INFO) {
    INFO.teamBackUrl = '#/app/discover/teams';
    Team.getList('company', null, function (err, teams) {
      if (err) {
        // todo
        console.log(err);
      } else {
        $scope.teams = teams;
      }
    });
    $scope.joinTeam = function(tid, index) {
      Team.joinTeam(tid, localStorage.id, function(err, data) {
        if(!err) {
          alert('加入成功');
          $scope.teams[index].hasJoined = true;
        }
        else {
          alert(err);
        }
      });
    }
    $scope.quitTeam = function(tid, index) {
      Team.quitTeam(tid, localStorage.id, function(err, data) {
        if(!err) {
          alert('退出成功');
          $scope.teams[index].hasJoined = false;
        }
        else {
          alert(err);
        }
      });
    }
  }])
  .controller('DiscoverCircleController', ['$scope', 'TimeLine', 'INFO', function ($scope, TimeLine, INFO) {
    INFO.campaignBackUrl = '#/app/discover/circle';
    var yearIndex= 0,
    monthIndex = -1;
    $scope.loadFinished = false;
    $scope.timelinesRecord =[];
    var loadData = function(yearIndex, monthIndex){
      TimeLine.getTimelineData('company', '0', $scope.timelinesRecord[yearIndex].year, $scope.timelinesRecord[yearIndex].month[monthIndex].month, function (err, timelineData) {
        if (err) {
          // todo
          console.log(err);
        } else {
          $scope.timelinesRecord[yearIndex].month[monthIndex].campaign = timelineData.campaigns;
          $scope.$broadcast('scroll.infiniteScrollComplete');
        }
      });
    }
    TimeLine.getTimelineRecord('company', '0', function (err, timelines) {
      if (err) {
        // todo
        console.log(err);
      } else {
        $scope.timelinesRecord = timelines;
        $scope.loadMore();
      }
    });

    $scope.loadMore = function(){
      if($scope.timelinesRecord.length<=yearIndex || $scope.timelinesRecord.length==yearIndex+1 && $scope.timelinesRecord[yearIndex].month.length==monthIndex+1){
        $scope.loadFinished = true;
        return;
      }
      else if($scope.timelinesRecord[yearIndex].month.length <= monthIndex + 1){
        yearIndex++;
        monthIndex = 0;
      }
      else {
        monthIndex ++;
      }
      loadData(yearIndex, monthIndex);
    }
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
  .controller('PersonalTeamListController', ['$scope', 'Team', 'INFO', function ($scope, Team, INFO) {
    INFO.teamBackUrl = '#/app/personal_teams';
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
  }])
  .controller('TeamController', ['$scope', '$stateParams', 'Team', 'Campaign', 'INFO', function ($scope, $stateParams, Team, Campaign, INFO) {
    var teamId = $stateParams.teamId;
    $scope.backUrl = INFO.teamBackUrl;
    Team.getData(teamId, function (err, team) {
      if (err) {
        // todo
        console.log(err);
      } else {
        $scope.team = team;
        INFO.memberBackUrl = '#/team/' + teamId;
        INFO.memberContent = [team];
        $scope.homeCourtIndex = 0;
      }
    });
    $scope.joinTeam = function (tid) {
      Team.joinTeam(tid, localStorage.id, function (err, data) {
        if (!err) {
          alert('加入成功');
          $scope.team.hasJoined = true;
        }
        else {
          alert(err);
        }
      });
    };
    $scope.quitTeam = function (tid) {
      Team.quitTeam(tid, localStorage.id, function (err, data) {
        if (!err) {
          alert('退出成功');
          $scope.team.hasJoined = false;
        }
        else {
          alert(err);
        }
      });
    };
    $scope.selectHomeCourt = function (index) {
      $scope.homeCourtIndex = index;
    };

    Campaign.getList({
      requestType: 'team',
      requestId: teamId,
      populate: 'photo_album'
    }, function (err, campaigns) {
      if (err) {
        // todo
        console.log(err);
      } else {
        $scope.campaigns = campaigns;
      }
    });

  }])
  .controller('PhotoAlbumListController', ['$scope', '$stateParams', 'PhotoAlbum', 'INFO',
    function ($scope, $stateParams, PhotoAlbum, INFO) {
      $scope.teamId = $stateParams.teamId;
      INFO.photoAlbumBackUrl = '#/photo_album/list/team/' + $stateParams.teamId;
      PhotoAlbum.getList($stateParams.teamId, function (err, photoAlbums) {
        if (err) {
          // todo
          console.log(err);
        } else {
          $scope.photoAlbums = photoAlbums;
        }
      });

  }])
  .controller('PhotoAlbumDetailController', ['$scope', '$stateParams', 'PhotoAlbum', 'INFO',
    function ($scope, $stateParams, PhotoAlbum, INFO) {
      $scope.photoAlbumBackUrl = INFO.photoAlbumBackUrl;
      PhotoAlbum.getData($stateParams.photoAlbumId, function (err, photoAlbum) {
        if (err) {
          // todo
          console.log(err);
        } else {
          $scope.photoAlbum = photoAlbum;
        }
      });

      PhotoAlbum.getPhotos($stateParams.photoAlbumId, function (err, photos) {
        if (err) {
          // todo
          console.log(err);
        } else {
          $scope.photoGroups = groupByDate(photos);
        }
      });

      /**
       * 判断两个日期是否是同一天
       * @param {Date|String} d1
       * @param {Date|String} d2
       */
      var isTheSameDay = function (d1, d2) {
        if (typeof d1 === 'string') {
          d1 = new Date(d1);
        }
        if (typeof d2 === 'string') {
          d2 = new Date(d2);
        }
        return d1.getFullYear() === d2.getFullYear()
          && d1.getMonth() === d2.getMonth()
          && d1.getDate() === d2.getDate();

      };

      /**
       * 将照片按日期分组，要求照片是按上传日期排序，上传日期距离现在越近，排在最前面
       * @param {Array} photos 照片数组
       */
      var groupByDate = function (photos) {
        var resData = [];
        photos.forEach(function (photo) {
          var lastGroup = resData[resData.length - 1];
          if (lastGroup && isTheSameDay(lastGroup.date, photo.upload_date)) {
            lastGroup.photos.push(photo);
          } else {
            resData.push({
              date: new Date(photo.upload_date),
              photos: [photo]
            });
          }
        });
        return resData;
      };
  }])
  .controller('MemberController', ['$scope', '$stateParams', 'INFO', 'Team', function($scope, $stateParams, INFO, Team) {
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
    $scope.backUrl = INFO.memberBackUrl;
  }])