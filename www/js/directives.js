'use strict';

angular.module('donlerApp.directives', ['donlerApp.services'])

  .directive('scrollParent', function ($ionicScrollDelegate,$ionicGesture) {
    return {
        restrict: 'A',
        link: function (scope, element, attrs) {
          var sc,deltaY,deltaX,geth = $ionicScrollDelegate.$getByHandle(attrs.scrollParent);
          function applydrag(drag) {
            // console.log(drag);
            if(attrs.parentDirection == "y"){
              deltaY = drag.gesture.deltaY - deltaY;
              $ionicScrollDelegate.scrollBy(0,-deltaY, false);
              deltaY = drag.gesture.deltaY;
            }
            else if(attrs.parentDirection == "x"){
              deltaX = drag.gesture.deltaX - deltaX;
              $ionicScrollDelegate.scrollBy(-deltaX, 0, false);
              deltaX = drag.gesture.deltaX;
            }
          }
          var dragUpGesture = $ionicGesture.on('drag', applydrag, element);
          var dragStartGesture = $ionicGesture.on('dragstart',  function (event) {
            deltaY= 0,deltaX =0;
          }, element);
        }
    };
  })
  .directive('openPhoto',['$location', '$ionicModal', '$rootScope', '$cordovaStatusbar', 'Tools', 'CONFIG', 'INFO', function($location, $ionicModal, $rootScope, $cordovaStatusbar, Tools, CONFIG, INFO) {
    return {
      restrict: 'A',
      scope: {
        pswpId: '=',
        photo: '=',
        photos: '=',
        pswpPhotoAlbum: '=',
        photoAlbumId: '='
      },
      link: function (scope, element, attrs, ctrl) {
        element[0].onclick = function() {
          try {
            var pswpElement ; //页面元素
            if (scope.pswpId) {//有的时候设置了pswpId,directive里会拿不到，所以用搜索.pswp类的方法
              pswpElement = document.querySelector('#' + scope.pswpId);
            } else {
              pswpElement = document.querySelectorAll('.pswp')[0];
            }
            var photos = []; //pswp所需的全部photos对象
            var index = 0;
            if(scope.photos){//非打开个人头像
              index = Tools.arrayObjectIndexOf(scope.photos, scope.photo._id, '_id');
              if (index === -1) { // 没找到则不打开大图
                return;
              }
              photos = scope.photos;
            }else{//打开个人头像
              var width = Math.min(INFO.screenWidth, INFO.screenHeight);
              photos.push({
                src: CONFIG.STATIC_URL + scope.photo + '/' + width + '/' + width,
                w: width,
                h: width
              });
            }
            //初始化gallery
            var options = {
              history: false,
              focus: false,
              index: index,
              showAnimationDuration: 0,
              hideAnimationDuration: 0
            };
            var gallery = new PhotoSwipe(pswpElement, PhotoSwipeUI_Default, photos, options);
            $rootScope.hideTabs = true;
            if (window.StatusBar) {
              $cordovaStatusbar.hide();
            }

            if (!$rootScope.$$phase) {
              $rootScope.$digest();
            }
            gallery.listen('close', function() {
              $rootScope.hideTabs = false;
              if (window.StatusBar) {
                $cordovaStatusbar.show();
              }
              if (!$rootScope.$$phase) {
                $rootScope.$digest();
              }
            });

            gallery.init();
            //有些地方需要进入相册,则增加此方法
            if(scope.pswpPhotoAlbum){
              scope.pswpPhotoAlbum.goToAlbum = function () {
                gallery.close();
                $location.url('/photo_album/' + scope.photoAlbumId + '/detail');
              };
            }
          } catch (e) {
            console.log(e.stack);
            gallery.close();
            $rootScope.hideTabs = false;
            if (window.StatusBar) {
              $cordovaStatusbar.show();
            }
            if (!$rootScope.$$phase) {
              $rootScope.$digest();
            }
          }

        };
      }
    }
  }])
  .directive('publishBox', ['CONFIG', function(CONFIG) {
    return {
      restrict: 'E',
      scope: {
        isShowEmotions: '=',
        content: '=',
        isWriting: '=',
        publish: '&',
        showUploadActionSheet: '&'
      },
      templateUrl: './views/publish-box.html',
      link: function (scope, element, attrs, ctrl) {

        // console.log(scope.publish);
        //表情
        scope.isShowEmotions = false;
        scope.showEmotions = function() {
          scope.isShowEmotions = true;
        };

        scope.hideEmotions = function() {
          scope.isShowEmotions = false;
        };

        scope.emojiList=[];

        var emoji = ["laugh", "smile", "happy", "snag", "snaky", "heart_eyes", "kiss", "blush", "howl", "angry",
        "blink", "tongue", "tired", "logy", "asquint", "embarassed", "cry", "laugh_cry", "sigh", "sweat",
        "good", "yeah", "pray", "finger", "clap", "muscle", "bro", "ladybro", "flash", "sun",
        "cat", "dog", "hog_nose", "horse", "plumpkin", "ghost", "present", "trollface", "diamond", "mahjong",
        "hamburger", "fries", "ramen", "bread", "lollipop", "cherry", "cake", "icecream"];

        var dict = {"laugh":"大笑","smile":"微笑","happy":"高兴","snag":"龇牙","snaky":"阴险","heart_eyes":"心心眼","kiss":"啵一个","blush":"脸红","howl":"鬼嚎","angry":"怒",
        "blink":"眨眼","tongue":"吐舌","tired":"困","logy":"呆","asquint":"斜眼","embarassed":"尴尬","cry":"面条泪","laugh_cry":"笑cry","sigh":"叹气","sweat":"汗",
        "good":"棒","yeah":"耶","pray":"祈祷","finger":"楼上","clap":"鼓掌","muscle":"肌肉","bro":"基友","ladybro":"闺蜜","flash":"闪电","sun":"太阳",
        "cat":"猫咪","dog":"狗狗","hog_nose":"猪鼻","horse":"马","plumpkin":"南瓜","ghost":"鬼","present":"礼物","trollface":"贱笑","diamond":"钻石","mahjong":"红中",
        "hamburger":"汉堡","fries":"薯条","ramen":"拉面","bread":"面包","lollipop":"棒棒糖","cherry":"樱桃","cake":"蛋糕","icecream":"冰激凌"};

        for(var i =0; emoji.length>24 ;i++) {
          scope.emojiList.push(emoji.splice(24,24));
        }
        scope.emojiList.unshift(emoji);

        scope.addEmotion = function(emotion) {
          scope.content += '['+ dict[emotion] +']';
          scope.resizeTextarea();
        };

        var ta = document.getElementById('ta');

        //获取字符串真实长度，供计算高度用
        var getRealLength = function(str) {
          if(typeof(str) === 'string') {
            var newstr =str.replace(/[\u0391-\uFFE5]/g,"aa");
            return newstr.length;
          }else {
            return 0;
          }
        };

        //重新计算输入框行数
        scope.resizeTextarea = function(row) {
          if(row) {
            ta.rows = 1;
          }
          else if(scope.content) {
            var text = scope.content.split("\n");
            var rows = text.length;
            var originCols = ta.cols;
            for(var i = 0; i<rows; i++) {
              var rowText = i === 0 ? text[i] || text : text[i] || '';
              var realLength = getRealLength(rowText);
              if(realLength >= originCols) {
                if(!text[i])
                  rows += Math.ceil(realLength/originCols);
                else
                  rows = Math.ceil(realLength/originCols);
              }
            }
            rows = Math.max(rows, 1);
            rows = Math.min(rows, 3);
            if(rows != ta.rows) {
              ta.rows = rows;
            }
          }else {
            ta.rows = 1;
          }
        };
      }
    }
  }])

  .directive('campaignCard', ['$rootScope', 'CONFIG', 'Campaign', 'INFO', 'Tools', '$location', function ($rootScope, CONFIG, Campaign, INFO, Tools, $location) {
    return {
      restrict: 'E',
      scope: {
        campaign: '=',
        campaignIndex:'=',
        campaignFilter:'@'
      },
      templateUrl: './views/campaign-card.html',
      link: function (scope, element, attrs, ctrl) {
        scope.STATIC_URL = CONFIG.STATIC_URL;
        scope.joinCampaign = function (campaign) {
          Campaign.join(campaign, localStorage.id, function (err, data) {
            if (!err) {
              // todo
              scope.campaign.remove = true;
              if(scope.campaignFilter){
                $rootScope.$broadcast('updateCampaignList', { campaign:data,campaignFilter: scope.campaignFilter,campaignIndex: scope.campaignIndex});
              }
              else {
                scope.campaign = data;
              }
            }
          });
        };
        scope.dealProvoke = function(campaignId, dealType){
          //dealType:1接受，2拒绝，3取消
          var dealTypeString = ['接受','拒绝','取消'];
          var confirmPopup = $ionicPopup.confirm({
            title: '确认',
            template: '您确认要'+dealTypeString[dealType-1]+'该挑战吗?',
            cancelText: '取消',
            okText: '确认'
          });
          confirmPopup.then(function(res) {
            if(res) {
              Campaign.dealProvoke(campaignId, dealType, function(err, data){
                if(!err){
                  scope.campaign.remove = true;
                  if(scope.campaignFilter){
                    $rootScope.$broadcast('updateCampaignList', { campaignFilter: scope.campaignFilter,campaignIndex: scope.campaignIndex});
                  }
                  else {
                    scope.campaign = data;
                  }
                }
              });
            }
          });
          return false;
        };

        scope.addPhotos = function (photos) {
          scope.photos = [];
          photos.forEach(function (photo) {
            var width = photo.width || INFO.screenWidth;
            var height = photo.height || INFO.screenHeight;
            var item = {
              _id: photo._id,
              src: CONFIG.STATIC_URL + photo.uri,
              w: width,
              h: height
            };
            if (photo.upload_user && photo.upload_date) {
              item.title = '上传者: ' + photo.upload_user.name + '  上传时间: ' + moment(photo.upload_date).format('YYYY-MM-DD HH:mm');
            }
            scope.photos.push(item);
          });
        };
      }
    }
  }])

  .directive('errorImg', ['CONFIG', function (CONFIG) {
    return {
      restrict: 'A',
      attrs: {
        errorImg: '='
      },
      link: function (scope, ele, attrs, ctrl) {
        var errorImgSrc;
        if (!attrs.errorImg || attrs.errorImg === '' || attrs.errorImg === 'error-img') {
          errorImgSrc = CONFIG.STATIC_URL + '/img/not_found.jpg';
        } else {
          errorImgSrc = attrs.errorImg;
        }
        var errCount = 0;
        ele[0].onerror = function () {
          if (errCount > 1) {
            this.onerror = null;
            return;
          }
          this.src = errorImgSrc;
          errCount++;
        };

      }
    };
  }])
  .directive('preventDefault', function () {
    return function (scope, element, attrs) {
      angular.element(element).bind('click', function (event) {
        event.preventDefault();
        event.stopPropagation();
      });
    }
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
              gesture[_index] = $ionicGesture.on('swipe',scope[getstureCallback[_index]], elem);
              break;
            case "swipeleft":
              gesture[_index] = $ionicGesture.on('swipeleft', scope[getstureCallback[_index]], elem);
              break;
            case "swiperight":
              gesture[_index] = $ionicGesture.on('swiperight', scope[getstureCallback[_index]], elem);
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
                $ionicGesture.off(gesture[_index], 'swipeleft');
                break;
              case "swipeleft":
                $ionicGesture.off(gesture[_index], 'swipeleft');
                break;
              case "swiperight":
                $ionicGesture.off(gesture[_index], 'swipeleft');
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
  .directive('match', ['$parse', function ($parse) {
    return {
      require: 'ngModel',
      link: function(scope, elem, attrs, ctrl) {
        scope.$watch(function() {
          return $parse(attrs.match)(scope) === ctrl.$modelValue;
        }, function(currentValue) {
          ctrl.$setValidity('mismatch', currentValue);
        });
      }
    };
  }])

.directive('staticMap',function(){
  return {
    restrict: 'E',
    scope: {
      name: '@',
      coordinates: '='
    },
    template: '<a ng-if="coordinates.length==2" href="#" ng-click="linkMap()" class="map_wrap"><img ng-src="http://restapi.amap.com/v3/staticmap?location={{coordinates[0]}},{{coordinates[1]}}&amp;zoom=15&amp;size=300*260&amp;markers=mid,,A:{{coordinates[0]}},{{coordinates[1]}}&amp;labels={{name}},2,0,12,0xffffff,0x3498db:{{coordinates[0]}},{{coordinates[1]}}&amp;key=077eff0a89079f77e2893d6735c2f044" class="map_img"/></a>',
    link: function (scope, element, attrs, ctrl) {
      scope.linkMap = function () {
        if(scope.coordinates &&scope.coordinates.length==2) {
          var link = 'http://mo.amap.com/?q=' + scope.coordinates[1] + ',' + scope.coordinates[0] + '&name=' + scope.name+'&dev=0';
          window.open( link, '_system' , 'location=yes');
        }
        return false;
      }
    }
  }
})

.directive('editMap',['$ionicModal', '$ionicPopup', function($ionicModal, $ionicPopup){
  return {
    restrict: 'AE',
    scope: {
      mapName: '@',
      locationName:'=',
      location: '='
    },
    link: function (scope, element, attrs, ctrl) {
      var city, marker, toolBar;
      var modalController = $ionicModal.fromTemplate('<ion-modal-view><ion-header-bar><h1 class="title">地址选择</h1></ion-header-bar><ion-content><div id="{{mapName}}" class="map_container"></div><button ng-click="closeModal()" class="button button-full button-positive">确定</button></ion-content></ion-modal-view>', {
        scope: scope,
        animation: 'slide-in-up'
      });
      scope.$on('$destroy',function() {
        modalController.remove();
      });

      var placeSearchCallBack = function(data){

        scope.locationmap.clearMap();
        if(data.poiList.pois.length==0){
          $ionicPopup.alert({
            title: '提示',
            template: '没有符合条件的地点，请重新输入'
          });
          scope.closeModal();
          return;
        }
        var lngX = data.poiList.pois[0].location.getLng();
        var latY = data.poiList.pois[0].location.getLat();
        scope.location.coordinates=[lngX, latY];
        var nowPoint = new AMap.LngLat(lngX,latY);
        var markerOption = {
          map: scope.locationmap,
          position: nowPoint,
          raiseOnDrag:true
        };
        marker = new AMap.Marker(markerOption);
        scope.locationmap.setFitView();
        AMap.event.addListener(scope.locationmap,'click',function(e){
          var lngX = e.lnglat.getLng();
          var latY = e.lnglat.getLat();
          scope.location.coordinates=[lngX,latY];
          scope.locationmap.clearMap();
          var nowPoint = new AMap.LngLat(lngX,latY);
          var markerOption = {
            map: scope.locationmap,
            position: nowPoint,
            raiseOnDrag: true
          };
          marker = new AMap.Marker(markerOption);
        });
      };
      scope.initialize = function(){
        try {
          scope.locationmap =  new AMap.Map(scope.mapName);            // 创建Map实例
          scope.locationmap.plugin(["AMap.ToolBar"],function(){
            toolBar = new AMap.ToolBar();
            scope.locationmap.addControl(toolBar);
          });
          if(city){
            scope.locationmap.plugin(["AMap.PlaceSearch"], function() {
              scope.MSearch = new AMap.PlaceSearch({ //构造地点查询类
                pageSize:1,
                pageIndex:1,
                city:city
              });
              AMap.event.addListener(scope.MSearch, "complete", placeSearchCallBack);//返回地点查询结果
              scope.MSearch.search(scope.locationName);
            });
          }
          else {
            scope.locationmap.plugin(["AMap.CitySearch"], function() {
              //实例化城市查询类
              var citysearch = new AMap.CitySearch();
              AMap.event.addListener(citysearch, "complete", function(result){
                if(result && result.city && result.bounds) {
                  var citybounds = result.bounds;
                  //地图显示当前城市
                  scope.locationmap.setBounds(citybounds);
                  city = result.city;
                  scope.locationmap.plugin(["AMap.PlaceSearch"], function() {
                    scope.MSearch = new AMap.PlaceSearch({ //构造地点查询类
                      pageSize:1,
                      pageIndex:1,
                      city: city
                    });
                    AMap.event.addListener(scope.MSearch, "complete", placeSearchCallBack);//返回地点查询结果
                    scope.MSearch.search(scope.locationName);
                  });
                }
              });
              AMap.event.addListener(citysearch, "error", function (result) {
                scope.locationmap.plugin(["AMap.PlaceSearch"], function() {
                  scope.MSearch = new AMap.PlaceSearch({ //构造地点查询类
                    pageSize:1,
                    pageIndex:1
                  });
                  AMap.event.addListener(scope.MSearch, "complete", placeSearchCallBack);//返回地点查询结果
                  scope.MSearch.search(scope.locationName);
                });
              });
              //自动获取用户IP，返回当前城市
              citysearch.getLocalCity();

            });
          }
        }
        catch (e){
          console.log(e)
        }
        window.map_ready =true;
      }
      scope.showPopup = function() {
        if(scope.locationName==''){
          $ionicPopup.alert({
            title: '提示',
            template: '请输入地点'
          });
          return false;
        }
        else{
          modalController.show();
          //加载地图
          if(!window.map_ready){
            window.map_initialize = scope.initialize;
            var script = document.createElement("script");
            script.src = "http://webapi.amap.com/maps?v=1.3&key=077eff0a89079f77e2893d6735c2f044&callback=map_initialize";
            document.body.appendChild(script);
          }
          else{
            scope.initialize();
          }
        }
      }
      scope.closeModal = function() {
        modalController.hide();
      };
      element.bind('click', function() {
        scope.showPopup();
      });
    }
  }
}])

.directive('square', function () {
  return {
    restrict: 'A',
    link: function (scope, ele, attrs, ctrl) {
      var domEle = ele[0];
      domEle.style.height = domEle.clientWidth + 'px';
    }
  };
})
