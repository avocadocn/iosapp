'use strict';

angular.module('donlerApp.directives', ['donlerApp.services'])
.directive('contenteditable',function() {
  return {
    restrict: 'A',
    require: 'ngModel',
    link: function(scope, element, attr, ngModel) {
      var read;
      if (!ngModel) {
        return;
      }
      ngModel.$render = function() {
        return element.html(ngModel.$viewValue);
      };
      var changeBind = function(e){
        var htmlContent = element.html();
        if (ngModel.$viewValue !== htmlContent ) {
          if(htmlContent.replace(/<\/?[^>]*>/g, '').replace(/[\u4e00-\u9fa5]/g, '**').length>attr.mixMaxlength){
            ngModel.$setValidity('mixlength', false);
          }
          else{
            ngModel.$setValidity('mixlength', true);
          }
          return scope.$apply(read);
        }
      }
      var clearStyle = function(e){
        var before = e.currentTarget.innerHTML;
        setTimeout(function(){
            // get content after paste by a 100ms delay
            var after = e.currentTarget.innerHTML;
            // find the start and end position where the two differ
            var pos1 = -1;
            var pos2 = -1;
            for (var i=0; i<after.length; i++) {
                if (pos1 == -1 && before.substr(i, 1) != after.substr(i, 1)) pos1 = i;
                if (pos2 == -1 && before.substr(before.length-i-1, 1) != after.substr(after.length-i-1, 1)) pos2 = i;
            }
            // the difference = pasted string with HTML:
            var pasted = after.substr(pos1, after.length-pos2-pos1);
            // strip the tags:
            var replace = pasted.replace(/style\s*=(['\"\s]?)[^'\"]*?\1/gi,'').replace(/class\s*=(['\"\s]?)[^'\"]*?\1/gi,'');
            // build clean content:
            var replaced = after.substr(0, pos1)+replace+after.substr(pos1+pasted.length);
            // replace the HTML mess with the plain content
            //console.log(replaced);
            e.currentTarget.innerHTML = replaced;
            changeBind(e);
        }, 100);
      }
      element.bind('focus', function() {
        element.bind('input',changeBind);
        element.bind('keydown',changeBind);
        element.bind('paste', clearStyle);
      });
      element.bind('blur', function(e) {
        element.unbind('input',changeBind);
        element.unbind('keydown',changeBind);
        element.unbind('paste', clearStyle);
        changeBind(e);
      });
      return read = function() {
        return ngModel.$setViewValue(element.html());
      };
    }
  };
})
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
          if (scope.photos) {//非打开个人头像
            index = Tools.arrayObjectIndexOf(scope.photos, scope.photo._id, '_id');
            if (index === -1) { // 没找到则不打开大图
              return;
            }
            photos = scope.photos;
          }
          else {//打开个人头像
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
          if (scope.pswpPhotoAlbum) {
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
.directive('publishBox', ['CONFIG', 'Emoji', function(CONFIG, Emoji) {
  return {
    restrict: 'E',
    scope: {
      isShowImg: '@',
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
      scope.status ={}
      scope.isShowEmotions = false;
      scope.status.isShowImg = (scope.isShowImg == 'false') ? false : true;
      scope.showEmotions = function() {
        scope.isShowEmotions = true;
      };

      scope.hideEmotions = function() {
        scope.isShowEmotions = false;
      };

      scope.emojiList=[];

      var emoji = Emoji.getEmojiList();

      var dict = Emoji.getEmojiDict();

      for(var i =0; emoji.length>24 ;i++) {
        scope.emojiList.push(emoji.splice(24,24));
      }
      scope.emojiList.unshift(emoji);

      scope.addEmotion = function(emotion) {
        scope.content += '['+ dict[emotion] +']';
      };

      var textAreaEle = document.getElementById('ta');
      scope.change = function() {
        textAreaEle.style.height = 'auto';
        textAreaEle.style.height = textAreaEle.scrollHeight + 'px';
      };

      scope.clear = function() {
        textAreaEle.style.height = 'auto';
      };

      // var ta = document.getElementById('ta');

      //获取字符串真实长度，供计算高度用
      // var getRealLength = function(str) {
      //   if(typeof(str) === 'string') {
      //     var newstr =str.replace(/[\u0391-\uFFE5]/g,"aa");
      //     return newstr.length;
      //   }else {
      //     return 0;
      //   }
      // };

      //重新计算输入框行数
      // scope.resizeTextarea = function(row) {
      //   if(row) {
      //     ta.rows = 1;
      //   }
      //   else if(scope.content) {
      //     var text = scope.content.split("\n");
      //     var rows = text.length;
      //     var originCols = ta.cols;
      //     for(var i = 0; i<rows; i++) {
      //       var rowText = i === 0 ? text[i] || text : text[i] || '';
      //       var realLength = getRealLength(rowText);
      //       if(realLength >= originCols) {
      //         if(!text[i])
      //           rows += Math.ceil(realLength/originCols);
      //         else
      //           rows = Math.ceil(realLength/originCols);
      //       }
      //     }
      //     rows = Math.max(rows, 1);
      //     rows = Math.min(rows, 3);
      //     if(rows != ta.rows) {
      //       ta.rows = rows;
      //     }
      //   }else {
      //     ta.rows = 1;
      //   }
      // };
    }
  }
}])

//以下两个directive共用的controller
.controller( 'campaignCardController', ['$scope', '$rootScope', '$ionicActionSheet', 'CONFIG', 'Campaign', 'INFO',
 function (scope, $rootScope, $ionicActionSheet, CONFIG, Campaign, INFO) {
  scope.pswpPhotoAlbumId = scope.campaign.photo_album._id;
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
    var hideSheet = $ionicActionSheet.show({
      buttons: [
       { text: '确认' }
      ],
      titleText: '您确认要'+dealTypeString[dealType-1]+'该挑战吗?',
      cancelText: '取消',
      cancel: function() {
        hideSheet();
      },
      buttonClicked: function(index) {
        hideSheet();
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
}])

.directive('newCampaignCard', [function() {
  return {
    restrict: 'E',
    scope: {
      campaign: '=',
      campaignIndex:'=',
      campaignFilter:'@',
      isLast: '='
    },
    templateUrl: './views/new-campaign-card.html',
    controller: 'campaignCardController'
  }
}])

.directive('campaignCard', [function () {
  return {
    restrict: 'E',
    scope: {
      campaign: '=',
      campaignIndex:'=',
      campaignFilter:'@',
      pswpId: '=',
      pswpPhotoAlbum: '='
    },
    templateUrl: './views/campaign-card.html',
    controller: 'campaignCardController'
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

.directive('staticMap',['INFO', function(INFO){
  return {
    restrict: 'E',
    scope: {
      name: '@',
      coordinates: '='
    },
    template: '<a ng-if="coordinates.length==2" href="#" ng-click="linkMap()" class="map_wrap"><img ng-src="http://restapi.amap.com/v3/staticmap?location={{coordinates[0]}},{{coordinates[1]}}&amp;zoom=15&amp;size={{width}}*{{height}}&amp;markers=mid,,A:{{coordinates[0]}},{{coordinates[1]}}&amp;labels={{name}},2,0,12,0xffffff,0x3498db:{{coordinates[0]}},{{coordinates[1]}}&amp;key=077eff0a89079f77e2893d6735c2f044" class="map_img"/></a><img class="no_map" ng-if="coordinates.length==0" ng-src="../img/nomap.jpg"/>',
    link: function (scope, element, attrs, ctrl) {
      scope.width = INFO.screenWidth;
      scope.height = INFO.screenHeight -40;
      scope.linkMap = function () {
        if(scope.coordinates &&scope.coordinates.length==2) {
          var link = 'http://mo.amap.com/?q=' + scope.coordinates[1] + ',' + scope.coordinates[0] + '&name=' + scope.name+'&dev=0';
          window.open( link, '_system' , 'location=yes');
        }
        return false;
      }
    }
  }
}])

.directive('editMap',['$ionicModal', '$ionicActionSheet', function($ionicModal, $ionicActionSheet){
  return {
    restrict: 'AE',
    scope: {
      mapName: '@',
      // locationName:'=',
      location: '=',
      changed: '='
    },
    link: function (scope, element, attrs, ctrl) {
      var city, marker, toolBar;
      var modalController;
      $ionicModal.fromTemplateUrl('./views/map-select.html', {
        scope: scope,
        animation: 'slide-in-up'
      }).then(function(modal) {
        modalController = modal;
      });
      
      scope.$on('$destroy',function() {
        modalController.remove();
      });

      scope.change = function() {
        scope.changed = true;
      };

      scope.search = function (event) {
        if(scope.location.name && ( !event || event.which ===13)) {
          scope.MSearch.search(scope.location.name);
        }else if(!event) {
          var hideSheet = $ionicActionSheet.show({
            titleText: '请输入搜索地址',
            buttons: [
             { text: '确定' }
            ],
            buttonClicked: function() {
              hideSheet();
            }
          });
        }
      };

      var placeSearchCallBack = function(data){

        scope.locationmap.clearMap();
        if(data.poiList.pois.length==0){
          var hideSheet = $ionicActionSheet.show({
            titleText: '没有符合条件的地点，请重新输入',
            buttons: [
             { text: '确定' }
            ],
            buttonClicked: function() {
              hideSheet();
            }
          });
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
          scope.changed = true;
        });
      };
      scope.initialize = function(){
        try {
          scope.locationmap =  new AMap.Map(scope.mapName);            // 创建Map实例
          scope.locationmap.plugin(["AMap.ToolBar"],function(){
            toolBar = new AMap.ToolBar();
            scope.locationmap.addControl(toolBar);
          });
          if(scope.location.loc && scope.location.loc.coordinates) {
            var nowPoint = new AMap.LngLat(scope.location.loc.coordinates[0],scope.location.loc.coordinates[1]);
            scope.locationmap.setZoomAndCenter(14, nowPoint);
            var markerOption = {
              map: scope.locationmap,
              position: nowPoint,
              raiseOnDrag: true
            };
            marker = new AMap.Marker(markerOption);
            scope.locationmap.setFitView(marker);
          }

          if(city){
            scope.locationmap.plugin(["AMap.PlaceSearch"], function() {
              scope.MSearch = new AMap.PlaceSearch({ //构造地点查询类
                pageSize:1,
                pageIndex:1,
                city:city
              });
              AMap.event.addListener(scope.MSearch, "complete", placeSearchCallBack);//返回地点查询结果
              // scope.MSearch.search(scope.locationName);
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
                    // scope.MSearch.search(scope.locationName);
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
                  // scope.MSearch.search(scope.locationName);
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

.directive('fontSizeRange', function() {
  return {
    restrict: 'A',
    link: function (scope, ele, attrs, ctrl) {
      var domEle = ele[0];
      domEle.style.lineHeight = domEle.clientWidth + 'px';
      domEle.style.fontSize = domEle.clientWidth * Number(attrs.fontSizeRange) / 100 + 'px';
      console.log(domEle.clientWidth, domEle.style);
    }
  };
})

.directive('whenFocus', ['$timeout', function ($timeout) {
  return {
    restrict: 'A',
    link: function (scope, ele, attrs, ctrl) {
      scope.$watch(attrs.whenFocus, function (newVal) {
        if (newVal) {
          $timeout(function () {
            ele[0].focus();
          });
        }
      });
    }
  };
}])

.directive('scoreBoard', ['$rootScope', '$ionicActionSheet', '$ionicModal', 'CONFIG', 'ScoreBoard', function ($rootScope, $ionicActionSheet, $ionicModal, CONFIG, ScoreBoard) {
    return {
      restrict: 'E',
      scope: {
        componentId: '=',
        campaign:'=',
        reloadFlag:'='
      },
      templateUrl: './views/score-board.html',
      link: function (scope, element, attrs, ctrl) {
        scope.showAction = function (option) {
          if(option.type){
            var hideSheet = $ionicActionSheet.show({
              buttons: [
               { text: '确定' }
              ],
              titleText: option.titleText||'',
              cancelText: option.cancelText||'取消',
              cancel: function() {
                option.cancelFun && option.cancelFun();
                hideSheet();
              },
              buttonClicked: function(index) {
                hideSheet();
                option.fun && option.fun();
                
              }
            });
          }
          else{
            var hideSheet = $ionicActionSheet.show({
              titleText: option.titleText||'',
              buttons: [
               { text: '确定' }
              ],
              buttonClicked: function() {
                hideSheet();
                option.cancelFun && option.cancelFun();
              }
            });
          }
        }
            /**
         * 对于有编辑权限的用户的状态，可以是以下的值
         * 'init' 初始状态，双发都没有设置比分
         * 'waitConfirm' 等待对方确认
         * 'toConfirm' 对方已设置比分，需要我方确认
         * 'confirm' 双方已确认
         * @type {String}
         */
        scope.STATIC_URL = CONFIG.STATIC_URL;
        scope.leaderStatus = 'init';

        /**
         * 是否可以编辑比分板，确认后将无法编辑
         * @type {Boolean}
         */
        scope.allowEdit = false;
        scope.editing = false;
        /**
         * 是否可以查看日志
         * @type {Boolean}
         */
        scope.allowManage = false;
        scope.nowTab ='score';
        scope.changeFilter = function (nowTab) {
          if(scope.editing)
            scope.nowTab=nowTab;
        }
        scope.checkScore = function () {
          switch(scope.nowTab) {
            case 'score':
              return scope.scores[0]==undefined || scope.scores[1]==undefined;
              break;
            case 'result':
              return scope.results[0]==undefined || scope.results[1]==undefined;
              break;
          }
        }
        scope.doRefresh = function() {
          scope.editing = false;
          scope.allowEdit = false;
          scope.allowManage = false;
          scope.componentId && getScoreBoardData(true);
          scope.$broadcast('scroll.refreshComplete');
        }
        var getScoreBoardData = function (refreshFlag) {
          ScoreBoard.getScore(scope.componentId, function (err, scoreBoardData) {
            if (err) {
              scope.showAction({titleText:err})
            } else {
              scope.scoreBoard = scoreBoardData;
              scope.scores = [];
              scope.results = [];
              scope.allow
              for (var i = 0; i < scope.scoreBoard.playingTeams.length; i++) {
                var playingTeam = scope.scoreBoard.playingTeams[i];
                scope.scores.push(playingTeam.score);
                scope.results.push(playingTeam.result);
                if(playingTeam.result!=undefined){
                   scope.nowTab ='result';
                }
                if (scope.scoreBoard.status === 1) {
                  if (playingTeam.allowManage) {
                    scope.allowEdit = true;
                    if (playingTeam.confirm) {
                      scope.leaderStatus = 'waitConfirm';
                    } else {
                      scope.leaderStatus = 'toConfirm';
                    }
                  }
                } else if (scope.scoreBoard.status === 0) {
                  if (playingTeam.allowManage) {
                    scope.allowEdit = true;
                    scope.editing = true;
                  }
                }

                if (playingTeam.allowManage) {
                  scope.allowManage = true;
                }
              }
              if(scope.allowEdit && !refreshFlag) {
                $ionicModal.fromTemplateUrl('./views/score-board-edit.html', {
                  scope: scope,
                  animation: 'slide-in-up'
                }).then(function(modal) {
                  scope.editModal = modal;
                });
                scope.closeModal = function() {
                  scope.editModal.hide();
                };

                scope.$on('$destroy',function() {
                  scope.editModal.remove();
                });
                scope.showEdit = function() {
                  scope.editModal.show();
                }
              }
            }
          });
        };
        scope.componentId && getScoreBoardData();
        scope.$watch('reloadFlag',function (newVal) {
          if(newVal){
            scope.editing = false;
            scope.allowEdit = false;
            scope.allowManage = false;
            // if(scope.editModal){
            //   scope.editModal.remove();
            // }
            scope.componentId && getScoreBoardData();
          }
        })
        /**
         * 设置胜负结果
         * @param {Number} result -1, 0, 1
         * @param {Number} index  0或1, $scope.results的索引
         */
        scope.setResult = function (result, index) {
          if (index === 0) {
            // 两队胜负值的和为0
            scope.results[0] = result;
            scope.results[1] = 0 - result;
          } else if (index === 1) {
            scope.results[0] = 0 - result;
            scope.results[1] = result;
          }
        };

        scope.toggleEdit = function () {
          scope.editing = !scope.editing;
        };

        var finishEdit = function () {
          scope.editing = false;
          scope.scoreBoard.status = 1;
          scope.leaderStatus = 'waitConfirm';
          for (var i = 0; i < scope.scoreBoard.playingTeams.length; i++) {
            var playingTeam = scope.scoreBoard.playingTeams[i];
            playingTeam.score = scope.scores[i];
            playingTeam.result = scope.results[i];
          }
        };

        scope.initScore = function () {
          var data = {};
          if(scope.nowTab==='score') {
            data.scores = scope.scores;
          }
          else {
            data.results = scope.results;
          }
          ScoreBoard.setScore(scope.componentId, {
            data: data,
            isInit: scope.scoreBoard.status==0
          }, function (err) {
            if (err) {
              scope.showAction({titleText:err})
            } else {
              finishEdit();
            }
          })
        };

        scope.confirmScore = function () {
          var remindMsg = '提示：同意后将无法修改，确定要同意吗？';
          scope.showAction({type:1,titleText:remindMsg,
            fun:function () {
              ScoreBoard.confirmScore(scope.componentId, function (err) {
                if (err) {
                  scope.showAction({titleText:err})
                } else {
                  scope.scoreBoard.allConfirm = true;
                  scope.leaderStatus = 'confirm';
                  scope.scoreBoard.status = 2;
                }
              });
            }
          })
        };

        scope.showLogs = false;
        scope.toggleLogs = function () {
          if (!scope.showLogs) {
            ScoreBoard.getLogs(scope.componentId, function (err, logs) {
              if (err) {
                scope.showAction({titleText:err})
              } else {
                scope.logs = logs;
                scope.showLogs = true;
              }
            });
          } else {
            scope.showLogs = false;
          }
        };
      }
    }
  }])
.directive('mixMaxLength', function() {
  return {
    restrict: 'A',
    scope: {
      mixMaxLengthValid: '=',
      model: '=ngModel'
    },
    require: '?ngModel', // TODO: ngModel还是必要的，这里是为了解决一个奇怪的报错问题，先临时设置为可选的
    link: function(scope, ele, attrs, ngModel) {
      scope.$watch('model', function(newVal, oldVal) {
        if (newVal) {
          var resText = newVal.replace(/[\u4e00-\u9fa5]/g, '**');
          if (resText.length > attrs.mixMaxLength) {
            if (scope.mixMaxLengthValid !== undefined) {
              scope.mixMaxLengthValid = false;
            }
            ngModel.$setValidity('mixlength', false);
          }
          else {
            if (scope.mixMaxLengthValid !== undefined) {
              scope.mixMaxLengthValid = true;
            }
            ngModel.$setValidity('mixlength', true);
          }
        }
      });
    }
  };
})

// 精彩瞬间卡片列表组件
.directive('circleCardList', ['Circle', function(Circle) {
  return {
    restrict: 'E',
    transclude: true,
    scope: {
      circleList: '=', // 数据数组
      user: '=', // 用户数据
      ctrl: '=', // 提供给外部的控制器
      onClickCommentButton: '=', // 点击评论按钮或快速回复的事件
      onClickContentImg: '=', // 点击图片的事件
      onClickBlank: '=', // 点击空白区域的事件
      staticUrl: '=', // 静态资源的baseUrl
      kind: '@' // 卡片类型，默认为company,允许的值有company, user
    },
    link: function(scope, ele, attrs, ctrl) {
      if (!scope.kind) {
        scope.kind = 'company';
      }

      scope.lastCardIndex = null;
      scope.currentCardIndex = null;
      scope.onClickCardCommentButton = function(placeHolderText, circle) {
        for (var i = 0, listLen = scope.circleList.length; i < listLen; i++) {
          if (scope.circleList[i].content._id === circle.content._id) {
            if (i !== scope.currentCardIndex) {
              scope.lastCardIndex = scope.currentCardIndex;
              scope.currentCardIndex = i;
              if (scope.lastCardIndex !== null) {
                scope.ctrls[scope.lastCardIndex].stopComment();
              }
            }
            if (scope.onClickCommentButton) {
              scope.onClickCommentButton(placeHolderText);
            }
            return;
          }
        }
      };

      scope.removeFromList = function(id) {
        for (var i = 0, listLen = scope.circleList.length; i < listLen; i++) {
          if (scope.circleList[i].content._id === id) {
            scope.circleList.splice(i, 1);
            return;
          }
        }
      };

      scope.$watch('circleList', function(circleList) {
        if (circleList) {
          scope.ctrls = new Array(circleList.length);
          for (var i = 0, ctrlsLen = scope.ctrls.length; i < ctrlsLen; i++) {
            scope.ctrls[i] = {};
          }
        }
      });

      scope.$watch('ctrl', function(ctrl) {
        if (ctrl) {
          ctrl.postComment = function(content) {
            scope.ctrls[scope.currentCardIndex].postComment(content);
          };
        }
      });

    },
    templateUrl: './views/circle-card-list.html'
  };
}])

.directive('circleCard', ['Circle', '$ionicLoading', '$ionicActionSheet', '$state', '$timeout', function(Circle, $ionicLoading, $ionicActionSheet, $state, $timeout) {
  return {
    restrict: 'E',
    transclude: true,
    scope: {
      ctrl: '=', // 提供给外部的控制器
      circle: '=', // circleContent数据
      user: '=', // 用户数据
      onClickCommentButton: '=', // 点击评论按钮或快速回复的事件
      onClickContentImg: '=', // 点击图片的事件
      onClickBlank: '=', // 点击空白区域的事件
      onDelete: '=', // 删除整个circleContent时触发的事件
      staticUrl: '=', // 静态资源的baseUrl
      kind: '@' // 卡片类型，默认为company,允许的值有company, user
    },
    link: function(scope, ele, attrs, ctrl) {
      if (!scope.kind) {
        scope.kind = 'company';
      }
      scope.showAction = function (option) {
        if(option.type){
          var hideSheet = $ionicActionSheet.show({
            buttons: [
             { text: '确定' }
            ],
            titleText: option.titleText||'',
            cancelText: option.cancelText||'取消',
            cancel: function() {
              option.cancelFun && option.cancelFun();
              hideSheet();
            },
            buttonClicked: function(index) {
              hideSheet();
              option.fun && option.fun();
              
            }
          });
        }
        else{
          var hideSheet = $ionicActionSheet.show({
            titleText: option.titleText||'',
            buttons: [
             { text: '确定' }
            ],
            buttonClicked: function() {
              hideSheet();
              option.cancelFun && option.cancelFun();
            }
          });
        }
        
      }
      scope.uid = localStorage.id;

      scope.goToCampaignPage = function(id) {
        $state.go('campaigns_detail', {
          id: id
        });
      };

      scope.goToUserPage = function(user) {
        if (user.cid === localStorage.cid) {
          $state.go('user_info', {
            userId: user._id
          });
        }
      };

      scope.goToTeamPage = function(id) {
        $state.go('team', {
          teamId: id
        });
      };

      var isOnlyToContent = true;
      var currentPlaceHolderText = '';
      var targetUserId = null;

      scope.clickImg = function(images, img) {
        if (scope.onClickContentImg) {
          scope.onClickContentImg(images, img);
        }
      };

      var focusLinkOnShow = ele[0].querySelector('.focus_on_show_comment_op');
      var focusLinkOnHide = ele[0].querySelector('.focus_on_hide_comment_op');
      scope.toggleComment = function() {
        scope.circle.isToComment = !scope.circle.isToComment;
        if (scope.circle.isToComment === true) {
          focusLinkOnShow.focus();
        }
        else {
          focusLinkOnHide.focus();
        }
      };

      scope.hideCommentOperators = function() {
        scope.circle.isToComment = false;
      };

      scope.focusToHide = function() {
        focusLinkOnHide.focus();
      };

      scope.clickBlank = function() {
        if (scope.onClickBlank) {
          scope.onClickBlank();
        }
        focusLinkOnHide.focus();
      };

      // 点击评论按钮
      scope.commentToContent = function() {
        var isOnlyToContent = true;
        var currentPlaceHolderText = '';
        var targetUserId = null;
        if (scope.onClickCommentButton) {
          scope.onClickCommentButton(currentPlaceHolderText, scope.circle);
        }
      };

      // 回复
      scope.replyTo = function(circle, comment) {
        scope.stopComment();
        if (comment.post_user_id === localStorage.id) {
          // 将回复自己的评论转为回复内容
          isOnlyToContent = true;
          currentPlaceHolderText = '';
          targetUserId = null;
        } else {
          isOnlyToContent = false;
          currentPlaceHolderText = '回复 ' + comment.poster.nickname;
          targetUserId = comment.post_user_id;
        }
        if (scope.onClickCommentButton) {
          scope.onClickCommentButton(currentPlaceHolderText, scope.circle);
        }
      };

      // 是否赞过
      scope.hasAppreciate = function(circle) {
        for (var i = 0, apprLen = circle.appreciate.length; i < apprLen; i++) {
          var appr = circle.appreciate[i];
          if (appr.poster._id === localStorage.id) {
            return true;
          }
        }
        return false;
      };

      // 赞
      scope.appreciate = function(circle) {
        Circle.comment(circle.content._id, {
            kind: 'appreciate',
            is_only_to_content: true
          })
          .success(function(data) {
            circle.isToComment = false;
            circle.appreciate.push(data.circleComment);
          })
          .error(function(data) {
            scope.showAction({titleText:data.msg || '操作失败'})
          });
      };

      // 取消赞
      scope.cancelAppreciate = function(circle) {
        for (var i = 0, apprLen = circle.appreciate.length; i < apprLen; i++) {
          var appr = circle.appreciate[i];
          if (appr.poster._id === localStorage.id) {
            scope.deleteComment(appr._id, circle.appreciate, function() {
              circle.isToComment = false;
            });
            break;
          }
        }
      };

      var hideDeleteActionSheet;
      // 长按某条评论的事件处理
      scope.commentOnHoldHandler = function(comment, ownerArray) {
        if (localStorage.id !== comment.poster._id) {
          return;
        }
        hideDeleteActionSheet = $ionicActionSheet.show({
          destructiveText: '删除',
          cancelText: '取消',
          cancel: function() {},
          destructiveButtonClicked: function() {
            scope.deleteComment(comment._id, ownerArray);
          }
        });
      };

      // 删除评论或赞
      scope.deleteComment = function(id, ownerArray, successCallback) {
        Circle.deleteComment(id)
          .success(function(data) {
            if (hideDeleteActionSheet) {
              hideDeleteActionSheet();
            }
            for (var i = 0, arrLen = ownerArray.length; i < arrLen; i++) {
              if (ownerArray[i]._id === id) {
                ownerArray.splice(i, 1);
                break;
              }
            }
            if (successCallback) {
              successCallback();
            }
          })
          .error(function(data) {
            scope.showAction({titleText:data.msg || '删除失败'})
          });
      };

      // 删除整个circleContent
      scope.deleteCircleContent = function(circle) {
        scope.showAction({type:1,titleText:'确定删除吗?',fun:function () {
          Circle.deleteCompanyCircle(circle.content._id)
            .success(function(data) {
              if (scope.onDelete) {
                scope.onDelete(circle.content._id);
              }
              scope.showAction({titleText:'删除成功'});
            })
            .error(function(data) {
              scope.showAction({titleText:data.msg || '删除失败'});
            });
        }})
      };

      scope.postComment = function(content, callback) {
        if (!content || content === '') {
          if (callback) {
            callback();
          }
          return;
        }
        scope.isCommenting = false;
        scope.circle.isToComment = false;
        $ionicLoading.show({
          template: '发表中...',
          duration: 5000
        });
        var postData = {
          kind: 'comment',
          is_only_to_content: isOnlyToContent,
          content: content
        };
        if (targetUserId) {
          postData.target_user_id = targetUserId;
        }

        Circle.comment(scope.circle.content._id, postData)
          .success(function(data) {
            scope.circle.textComments.push(data.circleComment);
            $ionicLoading.hide();
            targetUserId = null;
            if (callback) {
              callback();
            }
          })
          .error(function(data) {
            scope.showAction({titleText:data.msg || '操作失败'});
          });
      };

      scope.stopComment = function() {
        scope.isCommenting = false;
        scope.circle.isToComment = false;
      };

      scope.$watch('ctrl', function(ctrl) {
        if (ctrl) {
          ctrl.postComment = scope.postComment;
          ctrl.stopComment = scope.stopComment;
        }
      });

      // 文本多行显示
      scope.showContentStatus = {
        showOverAll: false,
        showPartial: false
      };

      scope.$watch('circle', function(newVal) {
        if (newVal) {
          var domEle = ele[0];
          var textArea = domEle.querySelector('.content_text');
          if (textArea) {
            var lineHeight = 18;
            var maxLine = 6;
            var maxHeight = lineHeight * maxLine;
            if (textArea.scrollHeight > maxHeight) {
              textArea.style.height = 'auto';
              textArea.style.height = maxHeight + 'px';
              $timeout(function(){
                scope.showContentStatus.showOverAll = true;
              }, 10);
            }

            scope.showAllContent = function() {
              scope.showContentStatus.showOverAll = false;
              scope.showContentStatus.showPartial = true;
              textArea.style.height = 'auto';
              textArea.style.height = textArea.scrollHeight + 'px';
            };

            scope.showPartialContent = function() {
              scope.showContentStatus.showOverAll = true;
              scope.showContentStatus.showPartial = false;
              textArea.style.height = 'auto';
              textArea.style.height = maxHeight + 'px';
            };
          }

        }
      });

    },
    templateUrl: './views/circle-card.html'
  };
}])

.directive('circleCommentBox', ['Emoji', function(Emoji) {
  return {
    restrict: 'E',
    transclude: true,
    scope: {
      ctrl: '=',
      onPost: '='
    },
    link: function(scope, ele, attrs, ctrl) {
      scope.isCommenting = false;
      scope.isShowEmotions = false;
      scope.commentFormData = {
        content: ''
      };
      scope.toggleEmotions = function() {
        scope.isShowEmotions = !scope.isShowEmotions;
      };
      scope.hideEmotions = function() {
        scope.isShowEmotions = false;
      };

      scope.emojiList = [];
      var emoji = Emoji.getEmojiList();
      var dict = Emoji.getEmojiDict();

      for (var i = 0; emoji.length > 24; i++) {
        scope.emojiList.push(emoji.splice(24, 24));
      }
      scope.emojiList.unshift(emoji);
      scope.addEmotion = function(emotion) {
        scope.commentFormData.content += '[' + dict[emotion] + ']';
      };

      scope.stopComment = function() {
        scope.isCommenting = false;
        scope.isShowEmotions = false;
      };

      var setPlaceHolderText = function(text) {
        scope.placeholderText = text;
      };
      var open = function() {
        scope.isCommenting = true;
      };

      scope.postComment = function() {
        if (scope.onPost) {
          scope.onPost(scope.commentFormData.content);
        }
        scope.commentFormData.content = '';
        scope.stopComment();
      };

      scope.$watch('ctrl', function(ctrl) {
        if (ctrl) {
          ctrl.setPlaceHolderText = setPlaceHolderText;
          ctrl.open = open;
          ctrl.stopComment = scope.stopComment;
        }
      });
    },
    templateUrl: './views/circle-comment-box.html'
  };
}])

.directive('photoSwipe', ['$cordovaStatusbar', 'Image', 'CONFIG', function($cordovaStatusbar, ImageService, CONFIG) {
  return {
    restrict: 'E',
    transclude: true,
    scope: {
      photos: '=',
      ctrl: '='
    },
    link: function(scope, ele, attrs, ctrl) {
      var pswpEle = ele[0].querySelector('.pswp');

      /**
       * 打开，用于固定的集合
       * @param  {Number} index 照片的索引
       */
      var open = function(index) {
        var options = {
          history: false,
          focus: false,
          index: index || 0,
          showAnimationDuration: 0,
          hideAnimationDuration: 0
        };
        var pwsp = new PhotoSwipe(pswpEle, PhotoSwipeUI_Default, scope.photos, options);
        if (window.StatusBar) {
          $cordovaStatusbar.hide();
        }
        pwsp.listen('close', function() {
          if (window.StatusBar) {
            $cordovaStatusbar.show();
          }
        });
        pwsp.init();
      };

      /**
       * 初始化并打开，用于非固定集合
       * @param  {Array} photos 未处理的照片对角数组
       * @param  {Object} photo  需要打开的查看大图的照片
       */
      var init = function(photos, photo) {
        var index = photos.indexOf(photo); // 这里可以直接使用数组的indexOf方法
        if (index < 0) {
          index = 0;
        }

        // 复制photos并添加属性
        var pswpPhotos = [];
        for (var i = 0, photosLen = photos.length; i < photosLen; i++) {
          var photo = photos[i];
          var size = ImageService.getFitSize(photo.width, photo.height);
          pswpPhotos.push({
            w: size.width * 2,
            h: size.height * 2,
            src: CONFIG.STATIC_URL + photo.uri + '/' + size.width * 2 + '/' + size.height * 2
          });
        }

        var options = {
          history: false,
          focus: false,
          index: index,
          showAnimationDuration: 0,
          hideAnimationDuration: 0
        };
        var pwsp = new PhotoSwipe(pswpEle, PhotoSwipeUI_Default, pswpPhotos, options);
        if (window.StatusBar) {
          $cordovaStatusbar.hide();
        }
        pwsp.listen('close', function() {
          if (window.StatusBar) {
            $cordovaStatusbar.show();
          }
        });
        pwsp.init();
      };

      scope.$watch('ctrl', function(ctrl) {
        if (ctrl) {
          ctrl.open = open;
          ctrl.init = init;
        }
      });

    },
    templateUrl: './views/photo-swipe-directive.html'
  };
}])

// 发精彩瞬间
.directive('postCircle', ['$q', '$ionicModal', '$ionicLoading', '$ionicActionSheet', '$cordovaCamera', '$cordovaFile', 'CommonHeaders', 'Circle', 'CONFIG', function($q, $ionicModal, $ionicLoading, $ionicActionSheet, $cordovaCamera, $cordovaFile, CommonHeaders, Circle, CONFIG) {
  return {
    restrict: 'A',
    scope: {
      campaign: '=',
      afterPost:'&'
    },
    link: function(scope, ele, attrs, ctrl) {

      scope.uploadURIs = [];
      var maxUploadCount = 9;
      var hasInit = false; // 是否初始化，即选过一次图片到达预览页面

      var hideActionSheet; // it's a function

      var actionSheetOptions = {
        buttons: [{
          text: '拍照'
        }, {
          text: '从本地图片中选择'
        }],
        titleText: '发图片到精彩瞬间',
        cancelText: '取消',
        buttonClicked: onClick
      };
      var showAction = function (option) {
        if(option.type){
          var hideSheet = $ionicActionSheet.show({
            buttons: [
             { text: '确定' }
            ],
            titleText: option.titleText||'',
            cancelText: option.cancelText||'取消',
            cancel: function() {
              option.cancelFun && option.cancelFun();
              hideSheet();
            },
            buttonClicked: function(index) {
              hideSheet();
              option.fun && option.fun();
              
            }
          });
        }
        else{
          var hideSheet = $ionicActionSheet.show({
            titleText: option.titleText||'',
            buttons: [
             { text: '确定' }
            ],
            buttonClicked: function() {
              hideSheet();
              option.cancelFun && option.cancelFun();
            }
          });
        }
      }
      function showActionSheet() {
        hideActionSheet = $ionicActionSheet.show(actionSheetOptions);
      }

      function takePhoto() {
        var options = {
          quality: 50,
          destinationType: Camera.DestinationType.FILE_URI,
          sourceType: Camera.PictureSourceType.CAMERA,
          encodingType: Camera.EncodingType.JPEG,
          popoverOptions: CameraPopoverOptions,
          saveToPhotoAlbum: true,
          correctOrientation: true
        };
        return $cordovaCamera.getPicture(options);
      }

      function pickImages(maxCount) {
        return $q(function(resolve, reject) {
          window.imagePicker.getPictures(function(results) {
            resolve(results);
          }, function (err) {
            reject(err);
          }, {
            maximumImagesCount: maxCount,
            quality: 50 // 0~100
          });
        });
      }

      scope.canUploadMore = true; // 是否还能继续添加图片
      function leftCount() {
        return maxUploadCount - scope.uploadURIs.length;
      }

      function canUploadMore() {
        return leftCount() > 0;
      }

      function onClick(index) {
        if (index === 0) {
          // take photo
          takePhoto().then(function(uri) {
            scope.uploadURIs.push(uri);
            scope.canUploadMore = canUploadMore();
            onChooseSuccess();
          }).then(null, function(err) {
            console.log(err);
            if (err !== 'no image selected' && err !== 'Selection cancelled.') {
              showAction({titleText:'抱歉，获取照片失败。'});
            }
          });
        }
        else if (index === 1) {
          // pick images
          pickImages(leftCount()).then(function(uris) {
            if (uris.length > 0) {
              scope.uploadURIs = scope.uploadURIs.concat(uris);
              scope.canUploadMore = canUploadMore();
              onChooseSuccess();
            }
          }).then(null, function(err) {
            console.log(err);
            showAction({titleText:'抱歉，获取图片失败。'});
          });
        }
        return true;
      }

      function onChooseSuccess() {
        if (!hasInit) {
          openModal();
          hasInit = true;
        }
        hideActionSheet();
      }

      function canChooseImages() {
        return (window.Camera && window.imagePicker);
      }

      function add() {
        if (canChooseImages()) {
          showActionSheet();
        }
        else {
          showAction({titleText:'抱歉，网页版暂不支持上传图片。'});
        }
      }
      scope.add = add;

      var postModal;
      function openModal() {
        $ionicModal.fromTemplateUrl('./views/circle-post.html', {
          scope: scope,
          animation: 'slide-in-up'
        }).then(function(modal) {
          postModal = modal;
          postModal.show();
        }).then(null, function(err) {
          console.log(err.stack || err);
        });
      }

      scope.closeModal = function () {
        postModal.hide();
        postModal.remove();
        scope.uploadURIs = [];
        scope.canUploadMore = true;
        hasInit = false;
      };

      ele.on('click', add);

      /**
       * 上传一张图片
       * @params {String} uri 文件uri
       * @params {String} circleContentId 对应的circleContent的id
       * @returns {Promise}
       */
      function upload(uri, circleContentId) {
        var addr = CONFIG.BASE_URL + '/files';
        var headers = CommonHeaders.get();
        headers['x-access-token'] = localStorage.accessToken;
        var options = {
          fileKey: 'files',
          headers: headers,

          // 此处有坑！！！这里只允许简单的键值对，允许字符串或数字类型，不可以是对象
          // 估计是因为这里是使用上传插件，底层调用Object-C方法，为了逻辑简单不接受复杂的参数
          params: {
            owner_kind: 'CircleContent',
            owner_id: circleContentId
          }
        };
        return $cordovaFile.uploadFile(addr, uri, options);
      }

      scope.formCtrl = {
        unOverMax: true
      };
      scope.publishFormData = {
        content: ''
      };
      function reset() {
        scope.formCtrl = {
          unOverMax: true
        };
        scope.publishFormData = {
          content: ''
        };
      }

      scope.change = function() {
        var element = document.getElementById('circle_post_page_publish_content');
        element.style.height = 'auto';
        element.style.height = element.scrollHeight + "px";
      };

      scope.publish = function() {
        var circleContentId;
        Circle.preCreate(scope.campaign._id, scope.publishFormData.content)
        .then(function (response) {
          circleContentId = response.data.id;
          var uploadPromises = scope.uploadURIs.map(function (uri) {
            return upload(uri, circleContentId);
          });
          $ionicLoading.show({
            template: '上传中...',
            duration: 5000
          });
          return $q.all(uploadPromises);
        })
        .then(function (results) {
          return Circle.active(circleContentId);
        })
        .then(function (response) {
          $ionicLoading.hide();
          scope.closeModal();
          reset();
          scope.afterPost &&scope.afterPost();
          showAction({titleText:'发表成功'});
        })
        .then(null, function (response) {
          if (response instanceof Error) {
            console.log(response.stack);
            showAction({titleText:response.message || '发表失败'});
          }
          else {
            var msg;
            if (response && response.data && response.data.msg) {
              msg = response.data.msg;
            }
            else {
              msg = '发表失败';
            }
            showAction({titleText:msg});
          }
        });
      };

    }
  };
}])
.directive('autoHeight', function() {
  return {
    restrict: 'A',
    link: function (scope, element, attrs, ctrl) {
      var subHeight = parseInt(attrs.autoHeight);
      var height = window.innerHeight - subHeight - 10;
      element[0].style.height = height + 'px';
      element[0].querySelector('.scroll').style.height = height + 'px';
    }
  };
})