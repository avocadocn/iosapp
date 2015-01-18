'use strict';

angular.module('donlerApp.directives', ['donlerApp.services'])

  .directive('campaignCard', ['$rootScope', 'CONFIG', 'Campaign', 'INFO', 'Tools', '$location', function ($rootScope, CONFIG, Campaign, INFO, Tools, $location) {
    return {
      restrict: 'E',
      scope: {
        campaign: '=',
        pswpPhotoAlbum: '=',
        pswpId: '=',
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
              scope.campaign = data;
              scope.campaign.remove = true;
              $rootScope.$broadcast('updateCampaignList', { campaign:data,campaignFilter: scope.campaignFilter,campaignIndex: scope.campaignIndex});
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
                  $rootScope.$broadcast('updateCampaignList', { campaignFilter: scope.campaignFilter,campaignIndex: scope.campaignIndex});
                }
              });
            }
          });
          return false;
        };

        var addPhotos = function (photos) {
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

        scope.openPhotoSwipe = function (photos, photoId) {
          try {
            var pswpElement;
            if (scope.pswpId) {
              pswpElement = document.querySelector('#' + scope.pswpId);
            } else {
              pswpElement = document.querySelectorAll('.pswp')[0];
            }
            scope.photos = [];
            addPhotos(photos);
            var index = Tools.arrayObjectIndexOf(scope.photos, photoId, '_id');

            var options = {
              history: false,
              focus: false,
              index: index,
              showAnimationDuration: 0,
              hideAnimationDuration: 0
            };
            var pswp = new PhotoSwipe(pswpElement, PhotoSwipeUI_Default, scope.photos, options);
            pswp.listen('close', function() {
              $rootScope.hideTabs = false;
              if (!$rootScope.$$phase) {
                $rootScope.$digest();
              }
            });
            $rootScope.hideTabs = true;
            pswp.init();
            if (scope.pswpPhotoAlbum) {
              scope.pswpPhotoAlbum.goToAlbum = function () {
                INFO.photoAlbumBackUrl = '#' + $location.url();
                pswp.close();
                $rootScope.hideTabs = false;
                $location.url('/photo_album/' + scope.campaign.photo_album._id + '/detail');
              };
            }
          } catch (e) {
            console.log(e);
            console.log(e.stack);
            $rootScope.hideTabs = false;
          }
          return false;
        };
      }
    }
  }])

  .directive('errorImg', ['CONFIG', function (CONFIG) {
    return {
      restrict: 'A',
      scope: {
        errorImg: '='
      },
      link: function (scope, ele, attrs, ctrl) {
        var errorImgSrc;
        if (!scope.errorImg) {
          errorImgSrc = CONFIG.STATIC_URL + '/img/not_found.jpg';
        } else {
          errorImgSrc = scope.errorImg;
        }
        ele[0].onerror = function () {
          this.src = errorImgSrc;
        };
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












