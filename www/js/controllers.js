angular.module('starter.controllers', ['ngTouch', 'ionic.contrib.ui.cards'])


.controller('AppCtrl', function($state, $scope, $rootScope, $ionicPopup, Authorize, Global) {
  if (Authorize.authorize() === true) {
    $state.go('app.index');
  }
  $scope.logout = Authorize.logout;
  $scope.base_url = Global.base_url;
  $scope.img_url = Global.img_url;
  $scope.user = Global.user;
  $scope.logoRandom = new Date().getTime();
  $rootScope.$on('updateUser', function() {
    $scope.user = Global.user;
    $scope.logoRandom = new Date().getTime();
  });
  document.addEventListener("resume", function() {
    window.plugins.pushNotification.setApplicationIconBadgeNumber(0);
    Authorize.autologin(false,function(loginStatus,otherStatus,netStatus){
      if(netStatus){
        $ionicPopup.alert({
          title: '提示',
          template: '网络错误，请检查网络状态'
        });
        return;
      }
      if(!loginStatus){
        if(otherStatus){
          var myPopup = $ionicPopup.show({
            template: '您的账号在其他设备上登录，请重新登录!',
            title: '警告',
            scope: $scope,
            buttons: [
              { text: '取消' },
              {
                text: '<b>确定</b>',
                type: 'button-positive',
                onTap: function(e) {
                  return true;
                }
              },
            ]
          });
          myPopup.then(function(res) {
            if(res){
              $state.go('login');
            }
          });
        }
        else{
          $state.go('login');
        }a
      }
    });
  }, false);
  
})

.controller('LoginCtrl', function($scope, $rootScope, $http, $state, Authorize) {
  $scope.checkStatus = false;
  if (Authorize.authorize() === true) {
    $state.go('app.index');
  }
  else {
    Authorize.autologin(true,function(loginStatus){
      if(loginStatus){
        $state.go('app.index');
      }
      else{
        $scope.checkStatus = true;
      }
    });
  }
  $scope.data = {
    username: '',
    password: ''
  };

  $scope.loginMsg = '';

  $scope.login = Authorize.login(function(status){
    if(status){
      if (status === 401) {
        $scope.loginMsg = '用户名或密码错误';
      }
      else{
        $scope.loginMsg = '网络错误，请检查网络状态';
      }
    }else{
      $state.go('app.index');
    }
  });

})

.controller('IndexCtrl', function($scope, $rootScope, $ionicSlideBoxDelegate, $ionicPopup, $timeout, Campaign, Global, Authorize) {
  Authorize.authorize();
  $scope.base_url = Global.base_url;
  $rootScope.campaignReturnUri = '#/app/index';
  $scope.moreData = true;
  $scope.now =0;
  var init = function(callback){
    Campaign.getNowCampaignList(function(now_campaign_status, now_campaign_list) {

      Campaign.getNewCampaignList(function(new_campaign_status, new_campaign_list) {

        Campaign.getNewFinishCampaign(function(newFinishCampaignStatus, newFinishCampaign) {
          if(now_campaign_status || new_campaign_status || newFinishCampaignStatus){
            $ionicPopup.alert({
              title: '提示',
              template: '网络错误，请检查网络状态'
            });
            callback && callback();
            return;
          }
          $scope.nowCampaigns = now_campaign_list;
          $scope.newCampaigns = new_campaign_list;
          if(newFinishCampaign){
            if($scope.newCampaigns.length>3){
              $scope.newCampaigns.splice(3,0,newFinishCampaign);
            }
            else{
              $scope.newCampaigns.push(newFinishCampaign);
            }
          }
          if($scope.nowCampaigns.length==0 && $scope.newCampaigns.length==0 ){
            $scope.moreData = false;
          }
          callback && callback();
        });
      });
    });
  }

  init(function(){
    $ionicSlideBoxDelegate.update();
  });
  var removeCampaign = function(status, id){
    if(status){
      $ionicPopup.alert({
        title: '提示',
        template: '网络错误，请检查网络状态'
      });
      return;
    }
    var _length = $scope.newCampaigns.length;
    for(var i=0;i<_length;i++){
      if($scope.newCampaigns[i]._id==id){
        $scope.newCampaigns[i].is_joined = true;
        break;
      }
    }
  }
  $scope.join = Campaign.join(removeCampaign);
  $scope.openselectModal = function(campaign) {
    $scope.campaign=campaign;
    $scope.selectTid = campaign.myteam[0].id;
    var myPopup = $ionicPopup.show({
      templateUrl: 'templates/partials/select_team.html',
      title: '选择参加活动的小队',
      scope: $scope,
      buttons: [
        { text: '取消' },
        {
          text: '<b>确定</b>',
          type: 'button-positive',
          onTap: function(e) {
            $scope.join($scope.campaign,$scope.selectTid);
          }
        },
      ]
    });
  };
  $scope.select = function(tid) {
    $scope.selectTid = tid;
  };
  $scope.doRefresh = function(){
    init(function(){
      $scope.$broadcast('scroll.refreshComplete');
      $ionicSlideBoxDelegate.update();
    });
  }

})

.controller('CampaignListCtrl', function($scope, $rootScope, $ionicModal, $ionicPopup, Campaign, Global, Authorize) {
  Authorize.authorize();
  var page = -1;
  $scope.moreData =true;
  $scope.remind_text = '没有更多的活动了';
  $scope.base_url = Global.base_url;
  $scope.doRefresh = function(){
    $scope.moreData =true;
    page = -1;
    $scope.campaign_list = undefined;
    $scope.loadMore(function(){
       $scope.$broadcast('scroll.refreshComplete');
    });
  }
  $rootScope.campaignReturnUri = '#/app/campaign_list';
  $scope.loadMoreFinish = function(){
    $scope.$broadcast('scroll.infiniteScrollComplete');
  }
  // Campaign.getUserCampaignsForList(page,function(campaign_list) {
  //   $scope.campaign_list = campaign_list;
  // });

  // var removeCampaign = function(id){
  //   var _length = $scope.campaign_list.length;
  //   for(var i=0;i<_length;i++){
  //     if($scope.campaign_list[i]._id==id){
  //       $scope.campaign_list.splice(i,1);
  //       break;
  //     }
  //   }
  // }
  // $scope.join = Campaign.join(Campaign.getCampaign);
  // $scope.quit = Campaign.quit(removeCampaign);
  // $ionicModal.fromTemplateUrl('templates/partials/select_team.html', {
  //   scope: $scope,
  //   animation: 'slide-in-up'
  // }).then(function(modal) {
  //   $scope.selectModal = modal;
  // });
  // $scope.openselectModal = function(campaign) {
  //   $scope.campaign =campaign;
  //   $scope.selectModal.show();
  // };
  // $scope.select = function(campaign_id,tid) {
  //   $scope.join(campaign_id,tid);
  //   $scope.selectModal.hide();
  // };
  $scope.loadMore = function(callback){
    page++;
    Campaign.getUserJoinedCampaignsForList(page,function(status, campaign_list) {
      if(status){
        $ionicPopup.alert({
          title: '提示',
          template: '网络错误，请检查网络状态'
        });
        return;
      }
      if($scope.campaign_list){
         $scope.campaign_list = $scope.campaign_list.concat(campaign_list);
      }
      else{
        $scope.campaign_list = campaign_list;
      }
      if(campaign_list.length<20){
        $scope.moreData =false;
        if (campaign_list.length === 0) {
          $scope.remind_text = '没有已参加的活动';
        } else {
          $scope.remind_text = '没有更多的活动了';
        }
      }
      callback();
    });
  }
  $scope.loadMore($scope.loadMoreFinish);
})

.controller('CampaignDetailCtrl', function($scope, $rootScope, $state, $sce, $stateParams, $ionicModal, $ionicSlideBoxDelegate, $ionicScrollDelegate, $ionicPopup, $ionicLoading, $ionicTabsDelegate, $timeout, Campaign, PhotoAlbum, Comment, Global, Authorize) {

  Authorize.authorize();
  $scope.base_url = Global.base_url;
  $scope.user_id = Global.user._id;
  $scope.loading = {status:false};
  $scope.publishing = false;
  // $scope.now =0;
  $scope.togglePublishing = function() {
    $scope.publishing = !$scope.publishing;
  };
  Campaign.getCampaignDetail( $stateParams.id,function(status, campaign) {
    if(status){
      $ionicPopup.alert({
        title: '提示',
        template: '网络错误，请检查网络状态'
      });
      return;
    }
    $scope.campaign = campaign;
    $scope.loading.status = true;
    if($stateParams.index){
      $ionicTabsDelegate.select(1,true);
    }
    $scope.photo_album_id = $scope.campaign.photo_album;
    $scope.upload_form_url = $scope.base_url + '/photoAlbum/' + $scope.photo_album_id + '/photo';
    $scope.upload_form_url = $sce.trustAsResourceUrl($scope.upload_form_url);
    getPhotoList();
    $scope.deletePhoto = PhotoAlbum.deletePhoto($scope.photo_album_id, getPhotoList);
    $scope.commentPhoto = PhotoAlbum.commentPhoto($scope.photo_album_id, getPhotoList);
  });
  var getPhotoList = function() {
    PhotoAlbum.getPhotoList($scope.photo_album_id, function(status, photos) {
      if(status){
        $ionicPopup.alert({
          title: '提示',
          template: '网络错误，请检查网络状态'
        });
        return;
      }
      $scope.photos = photos;
      $scope.photos_view = [];
      var _length = photos.length;
      for(var i = 0; i < _length; i++){
        var index = Math.floor(i / 4);
        if(!$scope.photos_view[index]) {
          $scope.photos_view[index] = [];
        }
        photos[i].index = i;
        $scope.photos_view[index].push(photos[i]);
      }
      $ionicSlideBoxDelegate.$getByHandle('photoList').update();
    });
  };
  $scope.comment_content = {
    text:''
  };

  var showLoading = function() {
    $ionicLoading.show({
      template: '上传中...',
      noBackdrop: true,
      duration: 5000
    });
  };

  var hideLoading = function(){
    $ionicLoading.hide();
  };

  var ionicAlert = function(text) {
    $ionicPopup.alert({
      title: '提示',
      template: text
    });
  };

  $scope.photos = [];
  $scope.changePhoto = function (index) {
    var scrollDelegate = $ionicScrollDelegate.$getByHandle('photo_'+index);
    var view = scrollDelegate.getScrollView();
    $scope.nowIndex = index;
    //reset zoom level
    view.__zoomLevel = 1;
    scrollDelegate.scrollTo(0,0);
  }
  Comment.getCampaignComments($stateParams.id, function(status, comments) {
    if(status){
      $ionicPopup.alert({
        title: '提示',
        template: '网络错误，请检查网络状态'
      });
      return;
    }
    $scope.comments = comments;
  });

  var updateCampaign = function(upstatus, id) {
    if(upstatus){
      $ionicPopup.alert({
        title: '提示',
        template: '网络错误，请检查网络状态'
      });
      return;
    }
    Campaign.getCampaignDetail(id, function(status, campaign) {
      if(status){
        $ionicPopup.alert({
          title: '提示',
          template: '网络错误，请检查网络状态'
        });
        return;
      }
      $scope.campaign = campaign;
    });
  };

  $scope.join = Campaign.join(updateCampaign);
  $scope.quit = Campaign.quit(updateCampaign);
  $scope.publishComment =  function(){
    if($scope.comment_content.text==''){
      return ionicAlert('评论不能为空');
    }
    Comment.publishCampaignComment($stateParams.id, $scope.comment_content.text, function(msg) {
      if(!msg){
        $scope.comment_content.text = '';
        Comment.getCampaignComments($stateParams.id, function(status, comments) {
          if(status){
            $ionicPopup.alert({
              title: '提示',
              template: '网络错误，请检查网络状态'
            });
            return;
          }
          $scope.comments = comments;
        });
      //$scope.viewFormFlag =false;
      }
      else{
        $ionicPopup.alert({
          title: '提示',
          template: '网络错误，请检查网络状态'
        });
      }
    });
    $scope.publishing = false;
  };
  $scope.deleteComment = function(id, index){
    Comment.deleteCampaginComment(id,function(msg){
      if(msg){
        $ionicPopup.alert({
          title: '提示',
          template: '删除失败'
        });
      }
      else{
        $scope.comments.splice(index,1);
      }
    });
  }
  //$scope.viewFormFlag =false;
  // $scope.viewCommentForm =function(){
  //   $scope.viewFormFlag =true;
  // }

  var win = function(r) {
    hideLoading();
    ionicAlert('上传成功');
    getPhotoList();
  };

  var fail = function(error) {
    hideLoading();
    ionicAlert('上传失败，请重试。');
  };

  $ionicModal.fromTemplateUrl('templates/partials/upload.html', {
    scope: $scope,
    animation: 'slide-in-up'
  }).then(function(modal) {
    $scope.upload_modal = modal;
  });

  $scope.uploadFormSuccess = function() {
    $scope.upload_modal.hide();
    hideLoading();
    ionicAlert('图片上传成功！');
    getPhotoList();
  };

  $scope.uploadFormFail = function() {
    hideLoading();
    ionicAlert('图片上传失败！');
  };
  $scope.uploadFormError = function(status) {
    hideLoading();
    if(status==413){
      ionicAlert('图片尺寸过大，请重新选择！');
    }
    else{
      ionicAlert('图片上传失败！');
    }
  };

  $scope.upload = function() {
    showLoading();
  };

  $scope.openUploadModal = function() {
    $scope.upload_modal.show();
  };

  $scope.closeUploadModal = function() {
    $scope.upload_modal.hide();
  };

  $scope.getPhoto = function() {

    navigator.camera.getPicture(function(imageURI) {
      var options = new FileUploadOptions();
      options.fileKey = 'photos';
      options.chunkedMode = false;
      options.fileName = imageURI.substr(imageURI.lastIndexOf('/') + 1);
      options.mimeType = "image/jpeg";
      var uri = encodeURI($scope.upload_form_url);
      var ft = new FileTransfer();
      $scope.upload_modal.hide();
      showLoading();
      ft.upload(imageURI, uri, win, fail, options);
    }, function(err) {

    }, {
      quality: 50,
      destinationType: Camera.DestinationType.FILE_URI,
      sourceType: Camera.PictureSourceType.CAMERA,
      encodingType: Camera.EncodingType.JPEG,
      correctOrientation: true,
      saveToPhotoAlbum: true
    });

  };
  $ionicModal.fromTemplateUrl('templates/partials/photo_detail.html', {
    scope: $scope,
    animation: 'slide-in-up'
  }).then(function(modal) {
    $scope.modal = modal;
  });
  $scope.openModal = function(index) {
    $scope.nowIndex = index;
    $scope.showHeader = true;
    $ionicSlideBoxDelegate.$getByHandle('photoDetail').update();
    $ionicSlideBoxDelegate.$getByHandle('photoDetail').slide(index);

    $scope.modal.show();
  };
  $scope.closeModal = function() {
    $scope.modal.hide();
  };
  $scope.openselectModal = function() {
    $scope.selectTid = $scope.campaign.myteam[0].id;
    var myPopup = $ionicPopup.show({
      templateUrl: 'templates/partials/select_team.html',
      title: '选择参加活动的小队',
      scope: $scope,
      buttons: [
        { text: '取消' },
        {
          text: '<b>确定</b>',
          type: 'button-positive',
          onTap: function(e) {
            $scope.join($scope.campaign,$scope.selectTid);
          }
        },
      ]
    });
  };
  $scope.select = function(tid) {
    $scope.selectTid = tid;
  };
  $scope.linkMap = function (location) {
    var link = 'http://mo.amap.com/?q=' + location.coordinates[1] + ',' + location.coordinates[0] + '&name=' + location.name;
    window.open( link, '_system' , 'location=yes');
    return false;
  }
  $scope.swipeTab = function(event)  {
    if($(event.target).parents('#photo_list').length>0){
      return true;
    }
    switch(event.gesture.direction){
      case 'left':
        var nowTab = $ionicTabsDelegate.selectedIndex();
        if(nowTab<3){
          $timeout(function() {
            $ionicTabsDelegate.select(nowTab+1,true);
          });
        }
      break;
      case 'right':
        var nowTab = $ionicTabsDelegate.selectedIndex();
        if(nowTab>0){
          $timeout(function() {
            $ionicTabsDelegate.select(nowTab-1,true);
          });
        }
      break;
      default:
      break;
    }
  }
  $scope.savePhoto = function(){
    $ionicLoading.show({
      template: '保存中...'
    });
    var fileTransfer = new FileTransfer();
    var uri = encodeURI(Global.img_url + $scope.photos[$scope.nowIndex].uri);
    var tempUri = uri.split('/');
    var downloadPhoto = function(fileSystem){
        fileTransfer.download(
          uri,
          fileSystem.root.toURL()+'/donler/'+tempUri[tempUri.length-1],
          function(entry) {
              function success() {
                hideLoading();
                $ionicPopup.alert({
                  title: '提示',
                  template: '图片保存成功！'
                });
              }
            
              function fail(err) {
                hideLoading();
                $ionicPopup.alert({
                  title: '提示',
                  template: '图片保存失败！'
                });
              }
              window.plugins.SaveToPhotoAlbum.saveToPhotoAlbum( success, fail, entry.toURL());
          },
          function(error) {
              console.log(error);
              console.log("download error source " + error.source);
              console.log("download error target " + error.target);
              console.log("upload error code" + error.code);
          }
        );

    }

    window.requestFileSystem(LocalFileSystem.PERSISTENT, 0, downloadPhoto, null);
  }
})

.controller('ScheduleListCtrl', function($scope, $rootScope, $ionicPopup, Campaign, Global, Authorize) {
  Authorize.authorize();
  $rootScope.enable_drag = false;
  $rootScope.$on('$stateChangeStart', function() {
    $rootScope.enable_drag = true;
  });
  moment.lang('zh-cn');

  /**
   * 日历视图的状态，有年、月、日三种视图
   * 'year' or 'month' or 'day'
   * @type {String}
   */
  $scope.view = 'month';

  /**
   * 日视图中，当前周的日期数组，从周日开始
   * 每个数组元素为Date对象
   * @type {Array}
   */
  $scope.current_week_date = [];

  $scope.year = '一月 二月 三月 四月 五月 六月 七月 八月 九月 十月 十一月 十二月'.split(' ');


  if (Global.last_date) {
    /**
     * 当前浏览的日期，用于更新视图
     * @type {Date}
     */
    var current = $scope.current_date = Global.last_date;
    $scope.view = 'day';
    Global.last_date = null;
  } else {
    var current = $scope.current_date = new Date();
  }

  /**
   * 月视图卡片数据
   * @type {Array}
   */
  $scope.month_cards = [];

  /**
   * 日视图卡片数据
   * @type {Array}
   */
  $scope.day_cards = [];

  /**
   * 更新日历的月视图, 并返回该存放该月相关数据的对象, 不会更新current对象
   * @param  {Date} date
   * @return {Object}
   */
  var updateMonth = function(date) {
    var date = new Date(date);
    var year = date.getFullYear();
    var month = date.getMonth();
    var mdate = moment(new Date(year, month));
    var offset = mdate.day();// mdate.day(): Sunday as 0 and Saturday as 6
    var now = new Date();
    $scope.current_year = year;
    var month_data = {
      date: date,
      format_month: mdate.format('MMMM'),
      days: []
    };
    var month_dates = mdate.daysInMonth();
    //标记周末、今天
    for (var i = 0; i < month_dates; i++) {
      month_data.days[i] = {
        full_date: new Date(year, month, i + 1),
        date: i + 1,
        events: []
      };
      //由本月第一天，计算是星期几，决定位移量
      if(i===0){
        month_data.days[0].first_day = 'offset_' + offset; // mdate.day(): Sunday as 0 and Saturday as 6
        month_data.offset = month_data.days[0].first_day;
      }
      // 是否是周末
      if((i+offset)%7===6||(i+offset)%7===0)
        month_data.days[i].is_weekend = true;

      // 是否是今天
      var now = new Date();
      if (now.getDate() === i + 1 && now.getFullYear() === year && now.getMonth() === month) {
        month_data.days[i].is_today = true;
      }
    }
    var dayOperate = function (i,campaign) {
      month_data.days[i-1].events.push(campaign);
      month_data.days[i-1].has_event = true;
      if (campaign.is_joined) {
        month_data.days[i-1].has_joined_event = true;
      }
    };
    // 将活动及相关标记存入某天
    var month_start = new Date(year,month,1);
    var month_end = new Date(year,month,1);
    month_end.setMonth(month_end.getMonth()+1);
    $scope.campaigns.forEach(function(campaign) {
      var start_time = new Date(campaign.start_time);
      var end_time = new Date(campaign.end_time);
      if(start_time<=month_end&&end_time>=month_start){//如果活动'经过'本月
        var day_start = start_time.getDate();
        var day_end = end_time.getDate();
        var month_day_end = month_end.getDate();
        if(start_time>=month_start){//c>=a
          if(end_time<=month_end){//d<=b 活动日
            for(i=day_start;i<day_end+1;i++)
              dayOperate(i,campaign);
          }else{//d>b 开始日到月尾
            for(i=day_start;i<month_dates+1;i++)
              dayOperate(i,campaign);
          }
        }else{//c<a
          if(end_time<=month_end){//d<=b 月首到结束日
            for(i=1;i<day_end+1;i++)
              dayOperate(i,campaign);
          }else{//d>b 每天
            for(i=1;i<month_dates+1;i++)
              dayOperate(i,campaign);

          }
        }
      }
      campaign.format_start_time = moment(campaign.start_time).calendar();
      campaign.format_end_time = moment(campaign.end_time).calendar();
    });
    $scope.current_month = month_data;

    return month_data;
  };

  /**
   * 进入某一天的详情, 会更新current
   * @param  {Date} date
   */
  var updateDay = $scope.updateDay = function(date) {
    var date = new Date(date);
    $scope.view = 'day';
    if (date.getMonth() !== current.getMonth()) {
      updateMonth(date);
    }
    current = date;

    // ios safari ng-click将ng-href覆盖, 此为临时解决方案
    Global.last_date = current;
    $rootScope.campaignReturnUri = '#/app/schedule_list';

    var day = {
      date: current,
      format_date: moment(current).format('ll'),
      format_day: moment(current).format('dddd'),
      campaigns: $scope.current_month.days[current.getDate() - 1].events
    };

    var temp = new Date(date);
    var first_day_of_week = new Date(temp.setDate(temp.getDate() - temp.getDay()));
    $scope.current_week_date = [];
    for (var i = 0; i < 7; i++) {
      $scope.current_week_date.push(new Date(first_day_of_week.setDate(first_day_of_week.getDate())));
      first_day_of_week.setDate(first_day_of_week.getDate() + 1);
      var week_date = $scope.current_week_date[i];
      var now = new Date();
      if (week_date.getFullYear() === now.getFullYear() && week_date.getMonth() === now.getMonth() && week_date.getDate() === now.getDate()) {
        week_date.is_today = true;
      }
      if (week_date.getFullYear() === current.getFullYear() && week_date.getMonth() === current.getMonth() && week_date.getDate() === current.getDate()) {
        week_date.is_current = true;
      }
    }
    $scope.current_day = day;
    return day;
  };

  $scope.back = function() {
    switch ($scope.view) {
    case 'month':
      $scope.view = 'year';
      break;
    case 'day':
      $scope.view = 'month';
      break;
    }
  };


  /**
   * 回到今天，仅在月、日视图下起作用
   */
  $scope.today = function() {

    switch ($scope.view) {
    case 'month':
      current = new Date();
      var month = updateMonth(current);
      $scope.month_cards = [month];
      break;
    case 'day':
      var temp = new Date();
      var day = updateDay(temp);
      $scope.day_cards = [day];
      break;
    }

  };

  /**
   * 进入某月的视图
   * @param  {Number} month 月份, 0-11
   */
  $scope.monthView = function(month) {
    current.setDate(1);
    current.setMonth(month);
    var new_month = updateMonth(current);
    $scope.month_cards = [new_month];
    $scope.view = 'month';
  };

  /**
   * 进入日视图
   * @param  {Date} date
   */
  $scope.dayView = function(date) {
    var day = updateDay(date);
    $scope.day_cards = [day];
    $scope.view = 'day';
  };

  // ios safari下有问题
  /**
   * 查看活动详情前保存当前时间，以便返回
   */
  // $scope.saveStatus = function() {
  //   Global.last_date = current;
  //   $rootScope.campaignReturnUri = '#/app/schedule_list';
  // };


  $scope.nextMonth = function(month) {
    var temp = new Date(month.date);
    temp.setMonth(temp.getMonth() + 1);
    current = new Date(temp);
    var new_month = updateMonth(temp);
    $scope.month_cards.push(new_month);
  };

  $scope.preMonth = function(month) {
    var temp = new Date(month.date);
    temp.setMonth(temp.getMonth() - 1);
    current = new Date(temp);
    var new_month = updateMonth(temp);
    $scope.month_cards.push(new_month);
  };

  $scope.nextDay = function(day) {
    var temp = new Date(day.date);
    temp.setDate(temp.getDate() + 1);
    var new_day = updateDay(temp);
    $scope.day_cards.push(new_day);
  };

  $scope.preDay = function(day) {
    var temp = new Date(day.date);
    temp.setDate(temp.getDate() - 1);
    var new_day = updateDay(temp);
    $scope.day_cards.push(new_day);
  };

  $scope.removeMonth = function(index) {
    $scope.month_cards.splice(index, 1);
  };

  $scope.removeDay = function(index) {
    $scope.day_cards.splice(index, 1);
  };


  Campaign.getUserCampaignsForCalendar(function(status, campaigns) {
    if(status){
      $ionicPopup.alert({
        title: '提示',
        template: '网络错误，请检查网络状态'
      });
      return;
    }
    $scope.campaigns = campaigns;
    var month = updateMonth(current);
    $scope.month_cards = [month];
    if ($scope.view === 'day') {
      var day = updateDay(current);
      $scope.day_cards = [day];
    }
  });

})


// .controller('DynamicListCtrl', function($scope, Dynamic) {

//   Dynamic.getDynamics(function(dynamic_list) {
//     $scope.dynamic_list = dynamic_list;
//   });


//   $scope.vote = Dynamic.vote($scope.dynamic_list, function(positive, negative) {
//     $scope.dynamic_list[index].positive = positive;
//     $scope.dynamic_list[index].negative = negative;
//   });

// })


// .controller('GroupJoinedListCtrl', function($scope, Group) {

//   $scope.show_list = [];

//   var joined_list = Group.getJoinedGroups();
//   if (joined_list === null) {
//     Group.getGroups(function(joined_groups, unjoin_groups) {
//       $scope.show_list = joined_groups;
//     });
//   } else {
//     $scope.show_list = joined_list;
//   }

// })

// .controller('GroupUnjoinListCtrl', function($scope, Group) {

//   $scope.show_list = [];

//   var unjoin_list = Group.getUnjoinGroups();
//   if (unjoin_list === null) {
//     Group.getGroups(function(joined_groups, unjoin_groups) {
//       $scope.show_list = unjoin_groups;
//     });
//   } else {
//     $scope.show_list = unjoin_list;
//   }

// })

// .controller('GroupInfoCtrl', function($scope, $stateParams, Group) {

//   $scope.template = 'templates/partials/group_info.html';
//   $scope.group = Group.getGroup($stateParams.id);

// })

// .controller('GroupCampaignCtrl', function($scope, $rootScope, $stateParams, Group, Campaign) {

//   $scope.template = 'templates/partials/campaigns.html';
//   $rootScope.campaign_owner = 'group';
//   $rootScope.campaignReturnUri = '#/app/group_detail/' + $stateParams.id;
//   $scope.group = Group.getGroup($stateParams.id);

//   var getGroupCampaigns = function() {
//     Campaign.getGroupCampaigns($stateParams.id, function(campaign_list) {
//       $scope.campaign_list = campaign_list;
//     });
//   };

//   getGroupCampaigns();

//   $scope.join = Campaign.join(getGroupCampaigns);
//   $scope.quit = Campaign.quit(getGroupCampaigns);

// })

// .controller('GroupDynamicCtrl', function($scope, $stateParams, Group, Dynamic) {

//   $scope.template = 'templates/partials/dynamics.html';
//   $scope.group = Group.getGroup($stateParams.id);

//   Dynamic.getGroupDynamics($scope.group._id, function(dynamics) {
//     $scope.dynamic_list = dynamics;
//   })
// })

.controller('TimelineCtrl', function($scope, $rootScope, $ionicScrollDelegate, $state, $ionicPopup, Timeline, Authorize) {
  Authorize.authorize();
  $rootScope.campaignReturnUri = '#/app/timeline';
  $scope.moreData =true;
  $scope.time_lines = undefined;
  var page = -1;
  $scope.doRefresh = function(){
    $scope.moreData =true;
    page = -1;
    $scope.time_lines = undefined;
    $scope.loadMore(function(){
       $scope.$broadcast('scroll.refreshComplete');
    });
  }
  $scope.loadMoreFinish = function(){
    $scope.$broadcast('scroll.infiniteScrollComplete');
  }
  $scope.loadMore = function(callback){
    page++;
    Timeline.getUserTimeline(page,function(status, time_lines, nowpage, moreData) {
      if(status){
        $ionicPopup.alert({
          title: '提示',
          template: '网络错误，请检查网络状态'
        });
        callback();
        return;
      }
      $scope.time_lines = time_lines;
      if(Timeline.getCacheTimeline()){
        Timeline.setCacheTimeline(false);
        $ionicScrollDelegate.$getByHandle('timelineScroll').scrollTo(0,Timeline.getTimelinePosition());
      }
      $scope.moreData =moreData;
      callback();
    });
  }
  $scope.loadMore($scope.loadMoreFinish);
  $scope.rememberPosition = function(id){
    Timeline.setTimelinePosition($ionicScrollDelegate.$getByHandle('timelineScroll').getScrollPosition().top);
    Timeline.setCacheTimeline(true);
    $state.go('app.campaignDetail',{'id':id,'index':1});
    return true;
  }
})

.controller('UserInfoCtrl', function($scope,$ionicPopup, $rootScope, User, Global) {

  $scope.base_url = Global.base_url;

  User.getInfo(Global.user._id, false, function(user) {
    $scope.user = user;
  });

  $scope.editInfo = function(editName){
    $scope.backup={};
    $scope.backup.editValue = $scope.user[editName];
    var template = '',
        title = '';
    if(editName === 'nickname'){
      //template = '<input type="String" ng-model="user.nickname">';
      title = '修改昵称';
    }
    else if(editName === 'realname'){
      //template = '<input type="String" ng-model="user.realname">';
      title = '修改真名';
    }
    else if(editName === 'introduce'){
      //template = '<input type="String" ng-model="user.introduce">';
      title = '修改简介';
    }
    else if(editName === 'phone'){
      //template = '<input type="String" ng-model="user.phone">';
      title = '修改电话';
    }
    var myPopup = $ionicPopup.show({
      template: '<input type="String" ng-model="backup.editValue">',
      title: title,
      //subTitle: 'Please use normal things',
      scope: $scope,
      buttons: [
        { text: '取消' },
        {
          text: '<b>确定</b>',
          type: 'button-positive',
          onTap: function(e) {
            return true;
          }
        },
      ]
    });
    myPopup.then(function(res) {
      if(res){
        if(editName === 'nickname' && $scope.backup.editValue===""){
          $ionicPopup.alert({
            title: '提示',
            template: '昵称不能为空'
          });
          return;
        }
        User.setInfo($scope.user._id, editName, $scope.backup.editValue ,function(msg){
          if(msg){
            $ionicPopup.alert({
              title: '提示',
              template: '网络错误，请检查网络状态'
            });
          }
          else{
            $scope.user[editName]= $scope.backup.editValue;
            if(editName === 'nickname'){
              Global.user.nickname = $scope.backup.editValue;
              $rootScope.$broadcast('updateUser', true);
            }
            $ionicPopup.alert({
              title: '提示',
              template: '修改成功!'
            });
          }
        });
      }
    });
  };
})

// .controller('OtherUserInfoCtrl', function($scope, $stateParams, User, Global) {

//   $scope.base_url = Global.base_url;

//   User.getInfo($stateParams.uid, function(user) {
//     $scope.user = user;
//   });


// })
.controller('SettingsCtrl', function($scope, $ionicActionSheet,$timeout, User, Authorize, Global) {
  User.getInfo(Global.user._id, true, function(user) {
    $scope.user.push_toggle = user.push_toggle;
  });

  $scope.openlogoutModal = function() {
    var hideSheet = $ionicActionSheet.show({
      destructiveText: '注销',
      titleText: '您确认要注销吗?',
      cancelText: '取消',
      cancel: function() {
        },
      destructiveButtonClicked: function() {
        Authorize.logout();
        return true;
      }
    });
  };

  $scope.pushToggle = function(){
    $timeout(function(){
      User.setInfo($scope.user._id, 'push_toggle', $scope.user.push_toggle ,function(msg){
        if(msg){
          $ionicPopup.alert({
            title: '提示',
            template: '网络错误，请检查网络状态'
          });
        }
      });
    },10);
  };
})



.controller('UserPhotoCtrl', function($scope, $sce, $state, $ionicPopup, $timeout, $rootScope, Authorize, Global) {

  Authorize.authorize();

  $scope.uid = Global.user._id;
  $scope.edit_form_action = Global.base_url + '/logo/update';
  $scope.edit_form_action = $sce.trustAsResourceUrl($scope.edit_form_action);

  var success = function () {
    $ionicPopup.alert({
      title: '提示',
      template: '修改头像成功'
    });
    $rootScope.$broadcast('updateUser', true);
    $state.go('app.settings');
  };

  var failed = function () {
    $ionicPopup.alert({
      title: '提示',
      template: '修改头像失败'
    });
  };

  /**
   * 获取照片
   * @param  {Number} from 0,1 as Camera.PictureSourceType.PHOTOLIBRARY, Camera.PictureSourceType.CAMERA
   */
  $scope.getPhoto = function(from) {
    navigator.camera.getPicture(function(imageURI) {
      var options = new FileUploadOptions();
      options.fileKey = 'logo';
      options.chunkedMode = false;
      options.fileName = imageURI.substr(imageURI.lastIndexOf('/') + 1);
      options.mimeType = "image/jpeg";
      options.params = {
        userId: $scope.uid,
        target: 'u',
        width: 1,
        height: 1,
        x: 0,
        y: 0
      };
      var uri = encodeURI($scope.edit_form_action);
      var ft = new FileTransfer();
      ft.upload(imageURI, uri, success, failed, options);
    }, function(err) {
      // 取消照相也会触发error.
    }, {
      quality: 50,
      destinationType: Camera.DestinationType.FILE_URI,
      sourceType: from,
      encodingType: Camera.EncodingType.JPEG,
      correctOrientation: true,
      saveToPhotoAlbum: true,
      allowEdit: true,
      targetWidth: 256,
      targetHeight: 256
    });

  };
})

.controller('feedbackCtrl', function($scope, $state, $ionicPopup, Authorize, FeedBack) {
  Authorize.authorize();
  var submiting = false;
  $scope.submitFeedBack = function(){
    if(submiting) {
      return;
    }
    submiting = true;
    FeedBack.submitFeedBack($scope.feedBackContent,function(status){
      submiting = false;
      if(status){
        $ionicPopup.alert({
          title: '提示',
          template: '反馈发送失败，请检查网络状态'
        });
      }
      else{
        $ionicPopup.alert({
          title: '提示',
          template: '反馈发送成功！'
        });
        $state.go('app.settings');
      }
    });
  };
})

.directive('cropPhoto', function () {
  return {
    scope: {
      resource: '=',
      crop: '=',
    },
    link: function (scope, element, attrs) {
      element[0].style.position = 'absolute';
      var parent = $(element).parent();
      parent.css('position', 'relative');
      var thumbnail = function(img) {
        if (img.width > img.height) {
          element[0].style.height = '100%';
          var resize_width = img.width * parent.height() / img.height;
          var left = (resize_width - parent.width()) / 2;
          element[0].style.left = '-' + left + 'px';
          // crop 参数均为100%
          scope.crop = {
            x: left / resize_width,
            y: 0,
            width: parent.width() / resize_width,
            height: 100
          };
        } else {
          element[0].style.width = '100%';
          var resize_height = img.height * parent.width() / img.width;
          var top = (resize_height - parent.height()) / 2;
          element[0].style.top = '-' + top + 'px';
          scope.crop = {
            x: 0,
            y: top / resize_height,
            width: 100,
            height: parent.height() / resize_height
          };
        }
      };

      var setSrc = function (src) {
        if (!src || src === '') {
          return;
        }
        var img = new Image();
        img.src = src;

        if (img.complete) {
          thumbnail(img);
        } else {
          img.onload = function() {
            thumbnail(img);
          };
        }
      };

      setSrc(attrs.ngSrc);
      scope.$watch('resource', function (newVal) {
        setSrc(newVal);
      });
    }

  };
})


// .directive('mapDirective', function(Map) {
//   return function(scope, element, attrs) {
//     Map.init(attrs.id, attrs.location);
//   };
// })


// .directive('uploadDirective', function() {
//   return function(scope, element, attrs) {
//     scope.initUpload();
//   };
// })

.directive('noScroll', function() {
  return {
    restrict: 'A',
    link: function(scope, element, attr) {
      element.on('touchmove', function(e) {
        e.preventDefault();
      });
    }
  }
})

.directive('uploadForm', function() {
  return function(scope, element, attrs) {
    form = $(element);
    scope.form = form;
    form.ajaxForm({
      success:function(data, status) {
        if(data.result){
          scope.uploadFormSuccess();
          var file = form.find('#upload_input');
          file.val("");
        }
        else{
          scope.uploadFormFail();
        }
      },
      error:function(xhr, status, error){
        console.log(xhr,status,error);
        scope.uploadFormError(status);
      }
    });
  };
})

.directive('autoUpload',function() {
  return {
    require: 'ngModel',
    link: function(scope, el, attrs, control) {
      el.bind('change', function() {
        scope.$apply(function() {
          scope.form.submit();
          scope.upload();
        });
      });
    }
  }
})

.directive('hidePager', function() {
  return {
    restrict: 'A',
    scope: {
      length: '='
    },
    link: function(scope, element, attrs) {
      var pager = $(element).parent().parent().find('.slider-pager');
      scope.$watch('length', function(newVal, oldVal) {
        if (newVal === 1) {
          pager.hide();
        } else {
          pager.show();
        }
      });
    }
  };
})

.directive('detectGestures', function($ionicGesture) {
  return {
    restrict :  'A',

    link : function(scope, elem, attrs) {
      var gestureType = attrs.gestureType.split(',');
      var getstureCallback = attrs.getstureCallback.split(',');
      var gesture = [];
      gestureType.forEach(function(_gestureType,_index){
        switch(_gestureType) {
          case "swipe":
            gesture[_index] = $ionicGesture.on('swipe', scope[getstureCallback[_index]], elem);
            break;
          case "pinch":
            gesture[_index] = $ionicGesture.on('pinch', scope[getstureCallback[_index]], elem);
            break;
           case "drag":
            gesture[_index] = $ionicGesture.on('drag', scope[getstureCallback[_index]], elem);
            break;
          case 'doubletap':
            gesture[_index] = $ionicGesture.on('doubletap', scope[getstureCallback[_index]], elem);
            break;
          // case 'tap':
          //   $ionicGesture.on('tap', scope.reportEvent, elem);
          //   break;
        }
      });
      
      scope.$on('$destroy', function() {
        // Unbind drag gesture handler
        gestureType.forEach(function(_gestureType,_index){
          switch(_gestureType) {
            case "swipe":
              $ionicGesture.off(gesture[_index], 'swipe');
              break;
            case "pinch":
              $ionicGesture.off(gesture[_index], 'pinch');
              break;
            case "drag":
              $ionicGesture.off(gesture[_index], 'drag');
              break;
            case 'doubletap':
              $ionicGesture.off(gesture[_index],'doubletap');
              break;
            // case 'tap':
            //   $ionicGesture.off('tap', scope.reportEvent, elem);
            //   break;
          }
        });
      });
    }
  }
})


.directive('autoHeight', function() {
  return {
    restrict: 'A',
    link: function (scope, element, attrs, ctrl) {
      var subHeight = parseInt(attrs.autoHeight);
      var height = window.innerHeight - subHeight - 64;
      $(element)[0].style.height = height + 'px';
      ($(element).find('.scroll'))[0].style.height = height + 'px';
    }
  };

})


