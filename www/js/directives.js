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

  .directive('campaignCard', ['$rootScope', 'CONFIG', 'Campaign', 'INFO', 'Tools', '$location', function ($rootScope, CONFIG, Campaign, INFO, Tools, $location) {
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
      link: function (scope, element, attrs, ctrl) {
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

.directive('whenFocus', ['$timeout', function ($timeout) {
  return {
    restrict: 'A',
    scope: {
      whenFocus: '='
    },
    link: function (scope, ele, attrs, ctrl) {
      scope.$watch('whenFocus', function (newVal) {
        if (newVal) {
          $timeout(function () {
            ele[0].focus();
          });
        }
      });
    }
  };
}])

.directive('scoreBoard', ['$rootScope', '$ionicPopup', 'CONFIG', 'ScoreBoard', function ($rootScope, $ionicPopup, CONFIG, ScoreBoard) {
    return {
      restrict: 'E',
      scope: {
        componentId: '='
      },
      templateUrl: './views/score-board.html',
      link: function (scope, element, attrs, ctrl) {
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

        /**
         * 是否可以查看日志
         * @type {Boolean}
         */
        scope.allowManage = false;

        var getScoreBoardData = function () {
          ScoreBoard.getScore(scope.componentId, function (err, scoreBoardData) {
            if (err) {
              $ionicPopup.alert({
                title: '错误',
                template: err
              });
            } else {
              scope.scoreBoard = scoreBoardData;
              scope.scores = [];
              scope.results = [];
              for (var i = 0; i < scope.scoreBoard.playingTeams.length; i++) {
                var playingTeam = scope.scoreBoard.playingTeams[i];
                scope.scores.push(playingTeam.score);
                scope.results.push(playingTeam.result);
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
                  }
                }

                if (playingTeam.allowManage) {
                  scope.allowManage = true;
                }
              }
            }
          });
        };
        getScoreBoardData();

        scope.editing = false;

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
          scope.scoreBoard.status === 1;
          scope.leaderStatus = 'waitConfirm';
          for (var i = 0; i < scope.scoreBoard.playingTeams.length; i++) {
            var playingTeam = scope.scoreBoard.playingTeams[i];
            playingTeam.score = scope.scores[i];
            playingTeam.result = scope.results[i];
          }
        };

        scope.initScore = function () {
          ScoreBoard.setScore(scope.componentId, {
            data:{
              scores: scope.scores,
              results: scope.results
            },
            isInit: true
          }, function (err) {
            if (err) {
              $ionicPopup.alert({
                title: '错误',
                template: err
              });
            } else {
              finishEdit();
            }
          })
        };

        scope.resetScore = function () {
          ScoreBoard.resetScore(scope.componentId, {
            data:{
              scores: cope.scores,
              results: scope.results
            },
            isInit: false
          }, function (err) {
            if (err) {
              $ionicPopup.alert({
                title: '错误',
                template: err
              });
            } else {
              finishEdit();
            }
          })
        };

        scope.confirmScore = function () {
          var remindMsg = '提示：同意后将无法修改，确定要同意吗？';
          var confirmPopup = $ionicPopup.confirm({
            title: '提示',
            template: remindMsg,
            okText: '确定',
            cancelText: '取消'
          });
          confirmPopup.then(function(res) {
            if(res) {
              ScoreBoard.confirmScore(scope.componentId, function (err) {
                if (err) {
                  $ionicPopup.alert({
                    title: '错误',
                    template: err
                  });
                } else {
                  scope.scoreBoard.allConfirm = true;
                  scope.leaderStatus = 'confirm';
                  scope.scoreBoard.status = 2;
                }
              });
            }
          });
        };

        scope.showLogs = false;
        scope.toggleLogs = function () {
          if (!scope.showLogs) {
            ScoreBoard.getLogs(scope.componentId, function (err, logs) {
              if (err) {
                $ionicPopup.alert({
                  title: '错误',
                  template: err
                });
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
    require: 'ngModel',
    link: function(scope, ele, attrs, ngModel) {
      scope.$watch(attrs.ngModel, function(newVal, oldVal) {
        if (newVal) {
          var resText = newVal.replace(/[\u4e00-\u9fa5]/g, '**');
          if (resText.length > attrs.mixMaxLength) {
            ngModel.$setValidity('mixlength', false);
          }
          else {
            ngModel.$setValidity('mixlength', true);
          }
        }
      });
    }
  };
})

