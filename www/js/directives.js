'use strict';

angular.module('donlerApp.directives', ['donlerApp.services'])
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
            if(scope.photos){//非打开个人头像
              var index = Tools.arrayObjectIndexOf(scope.photos, scope.photo._id, '_id');
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
              index: index? index: 0,
              showAnimationDuration: 0,
              hideAnimationDuration: 0
            };
            var gallery = new PhotoSwipe(pswpElement, PhotoSwipeUI_Default, photos, options);
            $rootScope.hideTabs = true;
            $cordovaStatusbar.hide();
            if (!$rootScope.$$phase) {
              $rootScope.$digest();
            }
            gallery.listen('close', function() {
              $rootScope.hideTabs = false;
              $cordovaStatusbar.show();
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
            $rootScope.hideTabs = false;
            $cordovaStatusbar.show();
            if (!$rootScope.$$phase) {
              $rootScope.$digest();
            }
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
              if(scope.campaignIndex&&scope.campaignFilter){
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
                  if(scope.campaignIndex&&scope.campaignFilter){
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
          var link = 'http://m.amap.com/navi/?dest=' + scope.coordinates[0] + ',' + scope.coordinates[1] + '&destName=' + scope.name+'&hideRouteIcon=1&key=077eff0a89079f77e2893d6735c2f044';
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












