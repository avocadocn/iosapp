angular.module('donlerApp.services', [])
  .factory('myInterceptor', ['$q', '$location', '$rootScope', function($q, $location, $rootScope) {
      var signOut = function(){
        var isLogin = true;
        var path = $location.path();
        var fun = function () {
          var userType = localStorage.userType;
          if (userType === 'company') {
            $location.path('/hr/login');
          } else {
            $location.path('/user/login');
          }
          localStorage.removeItem('accessToken');
          localStorage.removeItem('userType');
          localStorage.removeItem('id');
        }
        if (path ==='/user/login' || path ==='/hr/login') {
          isLogin = false;
        }
        if (isLogin) {
          $rootScope.showAction({titleText:'您的登录已经过期或者您的设备在其他设备上登录，请重新登录！',fun:fun,cancelFun:fun});
        }
      }
      var requestInterceptor = {
        'responseError': function(rejection) {
          if (rejection.status == 401) {
            signOut()
          }
          return $q.reject(rejection);
        },
        'response': function (response) {
          if (response.status == 401) {
            signOut()
          }
          return response || $q.when(response);
        }
      };

      return requestInterceptor;
  }])
  .config(['$httpProvider', function ($httpProvider) {
    $httpProvider.interceptors.push('myInterceptor');
    $httpProvider.defaults.headers["delete"] = {'Content-Type': 'application/json;charset=utf-8'};
  }])
  .constant('CONFIG', {
    BASE_URL: 'http://www.donler.com:3002/v1_4',
    STATIC_URL: 'http://www.donler.com',
    SOCKET_URL: 'http://www.donler.com:3005',
    APP_ID: 'id1a2b3c4d5e6f',
    API_KEY: 'key1a2b3c4d5e6f'
  })
  .value('INFO', {
    memberContent:'',
    sponsorBackUrl:'',
    discussName:'',
    lastDate:'',
    companyId:'',
    companyName:'',
    email:'',//注册传递用
    discussList:{},//讨论列表缓存
    screenWidth: 320,
    screenHeight: 568,
    team:'',//hr编辑小队用
    backFromCampaignDetail: false //供活动列表页面判断是否刷新，若从活动详情页转到活动列表，则不刷新，其余情况，均刷新
  })
  .factory('Persistence', ['$q', 'CONFIG', function($q,CONFIG) {
    //persistence.store.memory.config(persistence);  
    persistence.store.cordovasql.config(
      persistence,
      'donler',
      '1.0',                // DB version
      'donler_db',          // DB display name
      5 * 1024 * 1024,        // DB size
      0                       // SQLitePlugin Background processing disabled
    );

    var entities = {};

    entities.Hash = persistence.define('Hash', {
      name: 'TEXT',
      timehash:'INT'
    });
    // entities.ChatRoom = persistence.define('ChatRoom', {
    //   name: 'TEXT',
    //   _id:'TEXT',
    //   logo:'TEXT',
    //   kind:'TEXT'
    // });
    // entities.Chat = persistence.define('Chat', {
    //   _id:'TEXT',
    //   create_date:'DATE',
    //   status:'TEXT',
    //   chatroom_id:'TEXT',
    //   chat_type:'INT',
    //   photos:'JSON',
    //   content:'Text'
    // });
    // entities.User = persistence.define('User', {
    //   _id:'TEXT',
    //   nickname:'TEXT',
    //   photo:'TEXT',
    //   timehash:'INT'
    // });
    // entities.Team = persistence.define('Team', {
    //   _id:'TEXT',
    //   name:'TEXT',
    //   logo:'TEXT',
    //   cname:'TEXT',
    //   timehash:'INT'
    // });
    entities.Company = persistence.define('Company', {
      _id:'TEXT',
      address:'TEXT',
      logo:'TEXT',
      name:'TEXT',
      cover:'TEXT',
      city:'TEXT',
      shortName:'TEXT',
      timehash:'INT'
    });

    entities.DonlerUser = persistence.define('DonlerUser', {
      _id:'TEXT',
      realname:'TEXT',
      nickname:'TEXT',
      email:'TEXT',
      photo:'TEXT'
    });

    entities.DonlerTeam = persistence.define('DonlerTeam', {
      _id:'TEXT',
      active:'BOOL',
      name:'TEXT',
      logo:'TEXT',
      groupType:'TEXT',
      memberCount: 'INT',
      campaignCount: 'INT',
      leaders:'JSON',
      score:'JSON',
      isLeader:'BOOL',
      hasJoined:'BOOL',
      easemobId: 'TEXT'
    });

    entities.DonlerCampaign = persistence.define('DonlerCampaign', {
      _id:'TEXT',
      active:'BOOL', //- the field reserved for HR. If common users and HR have separated databases, it's redundant for common users.
      theme:'TEXT',
      is_start:'BOOL',
      is_end:'BOOL',
      campaign_unit:'JSON',
      photo_album:'JSON',
      campaign_type:'INT',
      start_time:'DATE',
      end_time:'DATE',
      create_time:'DATE',
      location: 'JSON',
      members_count:'INT',
      member_max:'INT',
      confirm_status:'BOOL',
      comment_sum:'INT',
      circle_content_sum:'INT',
      type:"INT" //- the function of this field: filter the campaign's status(start soon(join), running, end, start soon(unjoin))  
    });

    
    entities.Hash.index('name');
    // entities.ChatRoom.index('_id');
    // entities.Chat.index('_id');
    // entities.User.index('_id');

    entities.DonlerUser.index('_id');
    entities.DonlerTeam.index('_id');
    entities.DonlerCampaign.index('_id');

    // entities.Team.index('_id');
    // entities.User.hasMany('chats' , entities.Chat, 'poster');
    // entities.Team.hasMany('chats', entities.Chat, 'poster_team');
    // entities.Team.hasMany('chats', entities.Chat, 'opponent_team');
    persistence.debug = false;//debug模式开关
    persistence.schemaSync();

    return {
      Entities: entities,
      /**
       * 添加数据
       * @param {Entities}   data     需要添加的数据
       * @param {Function} callback  回调函数
       */
      add: function(data, callback) {
        persistence.add(data);
        persistence.flush(callback);
      },
      /**
       * 查询列表
       * @param  {[type]} queryCollection 查询集合，可以包括，limit,filter,prefetch,skip等条件
       * @return {promise}                 promise
       */
      get: function(queryCollection) {
        var defer = $q.defer();
        queryCollection.list(null, function (data) {
          defer.resolve(data);
        });
        return defer.promise;
      },
      /**
       * 查询单个数据
       * @param  {[type]} queryCollection 查询集合，可以包括，limit,filter,prefetch,skip等条件
       * @return {promise}                 promise
       */
      getOne: function(queryCollection) {
        var defer = $q.defer();
        queryCollection.one(function (data) {
          defer.resolve(data);
        });
        return defer.promise;
      },
      /**
       * 编辑数据
       * @param  {queryCollection} queryCollection 查询集合，可以包括，limit,filter,prefetch,skip等条件
       * @param  {Object} data            修改的数据对象
       * @return {promise}                 promise
       */
      edit: function(queryCollection, data){
        var defer = $q.defer();
        queryCollection.one(function(entity){
          if(entity){
            for(var i in data) {
              entity[i] = data[i];
            }
            persistence.flush(function () {
              defer.resolve(entity);
            });
          }
          else{
            defer.reject(404);
          }
        });
        return defer.promise;
      },
      /**
       * 删除数据
       * @param  {queryCollection} queryCollection 查询集合，可以包括，limit,filter,prefetch,skip等条件
       * @return {promise}                 promise
       */
      delete: function(queryCollection){
        var defer = $q.defer();
        queryCollection.destroyAll(function(){
          persistence.flush(function () {
            defer.resolve(true);
          });
        });
        return defer.promise;
      }
    };
  }])
  .factory('CommonHeaders', ['$http', 'CONFIG', function ($http, CONFIG) {

    return {

      /**
       * 设置默认的headers
       * 示例:
       *  set({
       *    'x-app-id': 'appid',
       *    'x-api-key': 'apikey'
       *  })
       * @param {Object} headers
       */
      set: function (headers) {

        $http.defaults.headers.common['x-app-id'] = CONFIG.APP_ID;
        $http.defaults.headers.common['x-api-key'] = CONFIG.API_KEY;
        if (headers) {
          for (var key in headers) {
            $http.defaults.headers.common[key] = headers[key];
          }
        } else {
          $http.defaults.headers.common['x-device-id'] = 'did1a2b3c4d5e6f';
          $http.defaults.headers.common['x-device-type'] = 'iphone 6';
          $http.defaults.headers.common['x-platform'] = 'iOS';
          $http.defaults.headers.common['x-version'] = '8.0';
        }

      },

      get: function () {
        return {
          'x-app-id': $http.defaults.headers.common['x-app-id'],
          'x-api-key': $http.defaults.headers.common['x-api-key'],
          'x-device-id': $http.defaults.headers.common['x-device-id'],
          'x-device-type': $http.defaults.headers.common['x-device-type'],
          'x-platform': $http.defaults.headers.common['x-platform'],
          'x-version': $http.defaults.headers.common['x-version']
        };

      }

    };

  }])
  .factory('UserAuth', ['$http', 'CONFIG', 'Socket', 'INFO', function ($http, CONFIG, Socket, INFO) {
    return {
      login: function (email, password, callback) {
        $http.post(CONFIG.BASE_URL + '/users/login', {
          email: email,
          password: password,
          pushInfo:INFO.pushInfo
        })
          .success(function (data, status) {
            easemob.login(function (augument) {
              console.log('登录成功');
            }, function(argument) {
              console.log('登录失败');
            },[data.id, data.id]);
            localStorage.accessToken = data.token;
            localStorage.userType = 'user';
            localStorage.id = data.id;
            localStorage.cid = data.cid;
            localStorage.role = data.role;
            localStorage.guide_step = data.guide_step;
            $http.defaults.headers.common['x-access-token'] = data.token;
            Socket.login();
            if(window.analytics){
              window.analytics.setUserId(data.id);
            }
            callback();
          })
          .error(function (data, status) {
            callback(data.msg);
          });
      },

      refreshToken: function (callback) {
        $http.post(CONFIG.BASE_URL + '/users/refresh/token')
          .success(function (data) {
            localStorage.accessToken = data.newToken;
            $http.defaults.headers.common['x-access-token'] = data.newToken;
            callback();
            easemob.login(function (augument) {
              console.log('登录成功');
            }, function(argument) {
              console.log('登录失败');
            },[localStorage.id, localStorage.id]);
          })
          .error(function (data) {
            callback(data);
          });
      },

      logout: function (callback) {
        Socket.logout();
        easemob.logout();
        $http.post(CONFIG.BASE_URL + '/users/logout')
          .success(function (data, status) {
            localStorage.removeItem('accessToken');
            localStorage.removeItem('userType');
            localStorage.removeItem('id');
            localStorage.removeItem('cid');
            localStorage.removeItem('role');
            localStorage.removeItem('guide_step');
            $http.defaults.headers.common['x-access-token'] = null;
            callback();
          })
          .error(function (data, status) {
            callback('error');
          });
      }
    };
  }])
  .factory('CompanyAuth', ['$http', 'CONFIG', function ($http, CONFIG) {
    return {
      login: function (username, password, callback) {
        $http.post(CONFIG.BASE_URL + '/companies/login', {
          username: username,
          password: password
        })
          .success(function (data, status) {
            localStorage.accessToken = data.token;
            localStorage.userType = 'company';
            localStorage.id = data.id;
            $http.defaults.headers.common['x-access-token'] = data.token;
            if(window.analytics){
              window.analytics.setUserId(data.id);
            }
            callback();
          })
          .error(function (data, status) {
            callback(data ? data.msg : '网络连接错误');
          });
      },

      refreshToken: function (callback) {
        $http.post(CONFIG.BASE_URL + '/companies/refresh/token')
          .success(function (data) {
            localStorage.accessToken = data.newToken;
            $http.defaults.headers.common['x-access-token'] = data.newToken;
            callback();
          })
          .error(function (data) {
            callback(data);
          });
      },

      logout: function (callback) {
        $http.post(CONFIG.BASE_URL + '/companies/logout')
          .success(function (data, status) {
            localStorage.removeItem('accessToken');
            localStorage.removeItem('userType');
            localStorage.removeItem('id');
            $http.defaults.headers.common['x-access-token'] = null;
            callback();
          })
          .error(function (data, status) {
            localStorage.removeItem('accessToken');
            localStorage.removeItem('userType');
            localStorage.removeItem('id');
            $http.defaults.headers.common['x-access-token'] = null;
            console.log(data,status);
            // todo
            callback('error');
          });
      }
    };
  }])
  .factory('CompanySignup', ['$http', 'CONFIG', function ($http, CONFIG) {
    return {
      /**
       * [validate description] 验证
       * @param  {string}   mail
       * @param  {string}   name
       * @param  {Function} callback
       */
      validate: function (email, name, callback) {
        var data;
        if(!email&&!name) {
          callback('参数错误');
        }else{
          if(email && !name)
            data = {email: email};
          else if(!email && name)
            data = {name: name};
          else
            data = {email: email, name: name};
          $http.post(CONFIG.BASE_URL + '/companies/validate',data)
          .success(function (data, status) {
            callback(data.msg, data);
          }).error(function (data, status) {
            callback(data ? data.msg : '网络连接错误');
          });
        }

      },
      /**
       * [signup description] 注册
       * @param  {object}   data
       * @param  {Function} callback
       */
      signup: function(data, callback) {
        $http.post(CONFIG.BASE_URL + '/companies', data)
        .success(function (data, status) {
          callback();
        }).error(function (data, status) {
          callback(data.msg);
        });
      },

      /**
       * [quickSignup description] 快速注册
       * @param  {[type]}   data     [description]
       * @param  {Function} callback [description]
       * @return {[type]}            [description]
       */
      quickSignup: function(data, callback) {
        $http.post(CONFIG.BASE_URL + '/companies/quickRegister', data)
        .success(function (data, status) {
          callback(null, data);
        }).error(function (data, status) {
          callback(data ? data.msg : '网络连接错误');
        });
      },
      /**
       * [quickSignupTeams description] 快速注册小队
       * @param  {[type]}   data     [description]
       * @param  {Function} callback [description]
       * @return {[type]}            [description]
       */
      quickSignupTeams: function(data, callback) {
        $http.post(CONFIG.BASE_URL + '/companies/quickRegisterTeams', data)
        .success(function (data, status) {
          callback(null, data);
        }).error(function (data, status) {
          callback(data ? data.msg : '网络连接错误');
        });
      }
    }
  }])
  .factory('UserSignup', ['$http', 'CONFIG', function ($http, CONFIG) {
    return{
      validate: function (email, cid, inviteKey, callback) {
        $http.post(CONFIG.BASE_URL + '/users/validate', {'email':email, 'cid':cid, 'inviteKey':inviteKey})
        .success(function (data, status) {
          callback(null,data);
        }).error(function (data, status) {
          callback(data ? data.msg : '网络连接错误');
        });
      },
      searchCompany: function (email, page, limit, callback) {
        $http.post(CONFIG.BASE_URL + '/search/companies', {'email':email, 'page': page, 'limit': limit})
        .success(function (data, status) {
          callback(null,data);
        }).error(function (data, status) {
          callback(data ? data.msg : '网络连接错误');
        });
      },
      signup: function(data, callback) {
        $http.post(CONFIG.BASE_URL + '/users', data)
        .success(function (data, status) {
          callback(null);
        }).error(function (data, status) {
          callback(data ? data.msg : '网络连接错误');
        });
      },
      resendActiveEmail: function(data, callback) {
        $http.post(CONFIG.BASE_URL + '/users/resend/activeEmail', data)
        .success(function (data, status) {
          callback(null);
        }).error(function (data, status) {
          callback(data ? data.msg : '网络连接错误');
        });
      }
    }
  }])
  .factory('Campaign', ['$http', 'CONFIG', 'Tools', 'Persistence', '$q', function ($http, CONFIG, Tools, Persistence, $q) {
    var nowCampaign;

    return {
      /**
       * 获取所有活动
       * @param {Object} params 请求参数，参见api /campaigns说明
       * @param {Function} callback
       */
      getList:function(params, callback, hcallback) {
        if(params.sqlite) {
          var hashCampaign;
          var campaignData;
          var cloneData;
          var dataArray;
          /**
           * Filter used for filter the campaigns from sqlite
           */
          var unStartCampaignFilter = function(campaign) {
            if(campaign.type === 1) {
              return true;
            }
            return false;
          };

          var nowCampaignFilter = function(campaign) {
            if(campaign.type === 2) {
              return true;
            }
            return false;
          };
          var newCampaignFilter = function(campaign) {
            if(campaign.type === 3) {
              return true;
            }
            return false;
          };
          var finishedCampaignFilter = function(campaign) {
            if(campaign.type === 4) {
              return true;
            }
            return false;
          };
          /**
           * parseCampaign the function generates the useful text.
           * @param  {[campaign]} arr 
           * @return {[campaign]}     
           */
          var parseCampaign = function(arr) {
            arr.forEach(function(campaign) {
              var startTime = new Date(campaign.start_time);
              var endTime = new Date(campaign.end_time);
              var textJson = Tools.formatCampaignTime(startTime, endTime);
              campaign.is_end = textJson.start_flag === -1 ? true : false;
              campaign.time_text = textJson.time_text;
              campaign.remind_text = textJson.remind_text;
            });
            return arr;
          };
          /**
           * compareFunction used for sort
           */
          var compareFunction = {
            startTimeAsc: function(a, b) {
              return new Date(a.create_time) - new Date(b.create_time);
            },
            startTimeDesc : function(a, b) {
              return new Date(b.start_time) - new Date(a.start_time);
            },
            endTimeAsc : function(a, b) {
              return new Date(a.end_time) - new Date(b.end_time);
            },
            endTimeDesc : function(a, b) {
              return new Date(b.end_time) - new Date(a.end_time);
            },
            createTimeDesc: function(a, b) {
              return new Date(b.create_time) - new Date(a.create_time);
            }
          };
          /**
           * handleCampaignArray handle the new data from server
           * @param  {[campaign]} srcArr  data's array from server
           * @param  {[campaign]} destArr the array of campaignData
           * @param  {int}        type    campaign's type(reference entities.Campaign)
           * @param  {json}       t       used for max hash time
           */
          var handleCampaignArray = function(srcArr, destArr, type, t) {
            if(srcArr.length === 0) {
              return;
            }
            srcArr.forEach(function(campaign) {

              var index = Tools.arrayObjectIndexOf(cloneData, campaign._id, '_id');
              
              if (index > -1) {
                var pos = cloneData[index].type - 1;
                var destIndex = Tools.arrayObjectIndexOf(campaignData[pos], campaign._id, '_id');
                if(campaign.active) {
                  if (cloneData[index].type !== type) {
                    campaignData[pos].splice(destIndex, 1);
                    destArr.push(campaign);
                  } else {
                    destArr[destIndex] = campaign;
                  }

                  campaign.type = type;

                  var campaignCollection = Persistence.Entities.DonlerCampaign.all().filter('_id', '=', campaign._id);
                  Persistence.edit(campaignCollection, campaign)
                  .then(null, function(error) {
                    // console.log(error);
                  })
                } else {
                  campaignData[pos].splice(destIndex, 1);
                  var campaignCollection = Persistence.Entities.DonlerCampaign.all().filter('_id', '=', campaign._id);
                  Persistence.delete(campaignCollection)
                  .then(null, function(error) {
                    console.log(error);
                  })
                }

              } else {
                if(campaign.active) {
                  destArr.push(campaign);
                  var _campaign = new Persistence.Entities.DonlerCampaign();
                  _campaign._id = campaign._id;
                  _campaign.active = campaign.active;
                  _campaign.theme = campaign.theme;
                  _campaign.is_start = campaign.is_start;
                  _campaign.is_end = campaign.is_end;
                  _campaign.campaign_unit = campaign.campaign_unit;
                  _campaign.photo_album = campaign.photo_album;
                  _campaign.campaign_type = campaign.campaign_type;
                  _campaign.start_time = campaign.start_time;
                  _campaign.end_time = campaign.end_time;
                  _campaign.create_time = campaign.create_time;
                  _campaign.location = campaign.location;
                  _campaign.members_count = campaign.members_count;
                  _campaign.member_max = campaign.member_max;
                  _campaign.confirm_status = campaign.confirm_status;
                  _campaign.comment_sum = campaign.comment_sum;
                  _campaign.circle_content_sum = campaign.circle_content_sum;
                  _campaign.type = type;
                  Persistence.add(_campaign);
                }
              }

              var date = (new Date(campaign.timeHash)).valueOf();
              if (date > t.max) {
                t.max = date;
              }
            })
          };
          /**
           * updateCampaign function
           */
          var updateCampaign = {
            unStartCampaign: function(campaign, type) {
              Persistence.getOne(Persistence.Entities.DonlerCampaign.all().filter('_id', '=', campaign._id))
              .then(function(campaign) {
                campaign.type = type;
                persistence.flush();
              })
            },
            nowCampaign: function(campaign) {
              Persistence.getOne(Persistence.Entities.DonlerCampaign.all().filter('_id', '=', campaign._id))
              .then(function(campaign) {
                campaign.type = 4;
                persistence.flush();
              })
            },
            newCampaign: function(campaign) {
              Persistence.delete(Persistence.Entities.DonlerCampaign.all().filter('_id', '=', campaign._id))
              .then(null, function(error) {
                console.log(error);
              })
            }
          };
          /**
           * updateCampaignArray -> update campaign status
           * @param  arr  campaign array
           * @param  type campaign's type(reference entities.Campaign)
           */
          var updateCampaignArray = function(arr, type) {
            var now = Date.now();
            switch(type) {
              case 1:
                return arr.filter(function(campaign) {
                  if((new Date(campaign.end_time)) <= now) {
                    updateCampaign.unStartCampaign(campaign, 4);
                    dataArray[3].push(campaign);
                    return false;
                  } else if((new Date(campaign.start_time)) <= now) {
                    updateCampaign.unStartCampaign(campaign, 2);
                    dataArray[1].push(campaign);
                    return false;
                  }
                  return true;
                });
                break;
              case 2:
                return arr.filter(function(campaign) {
                  if((new Date(campaign.end_time)) <= now) {
                    updateCampaign.nowCampaign(campaign);
                    dataArray[3].push(campaign);
                    return false;
                  }
                  return true;
                });
                break;
              case 3:
                return arr.filter(function(campaign) {
                  if((new Date(campaign.end_time)) <= now) {
                    updateCampaign.newCampaign(campaign);
                    return false;
                  }
                  return true;
                });
                break;
              default:
                return arr;
                break;
            }
          };
          var sortCampaignArray = function(array) {
            array.forEach(function(arr, index) {
              switch (index) {
                case 0:
                  arr.sort(compareFunction.startTimeAsc);
                  break;
                case 1:
                  arr.sort(compareFunction.endTimeAsc);
                  break;
                default:
                  arr.sort(compareFunction.createTimeDesc);
                  break;
              }
            });
          };
          /**
           * limit the number of finished campaign -> number(5)
           */
          var removeFinishedCampaign = function() {
            //- can't use Persistence's delete function, because of queryCollection's incorrectness(can't get correct queryCollection)
            //- can't use skip, because of skip(n) behaves nothing
            Persistence.Entities.DonlerCampaign.all().filter('type', '=', 4).order('end_time', false).list(null, function(results) {
              results.slice(5).forEach(function(result) {
                //- TODO remove the element from data[3]
                Persistence.delete(Persistence.Entities.DonlerCampaign.all().filter('_id', '=', result._id))
                  .then(null, function(error) {
                    console.log(error);
                  })
              });
            });
          };

          var getCampaignDataFromSqlite = function(promises, callback) {
            var deferred = $q.defer();
            Persistence.get(Persistence.Entities.DonlerCampaign.all().order('create_time', false)).then(function(_data) {
              dataArray = [];

              cloneData = _data;

              //- TODO simplify the operation
              dataArray.push(parseCampaign(_data.filter(unStartCampaignFilter)));
              dataArray.push(parseCampaign(_data.filter(nowCampaignFilter)));
              dataArray.push(parseCampaign(_data.filter(newCampaignFilter)));
              dataArray.push(parseCampaign(_data.filter(finishedCampaignFilter)));
              //- update campaign(mainly for campaign status(进行中、即将开始) because status change don't affect the timeHash in the server and front app change info via timeHash)
              for (var i = 0; i < dataArray.length; i++) {
                dataArray[i] = updateCampaignArray(dataArray[i], i + 1);
              }
              //- sort campaign order by time
              sortCampaignArray(dataArray);
              //- limit the number of finished campaign -> number(5)
              removeFinishedCampaign();

              callback(null, dataArray);
              // console.log(data);
              campaignData = dataArray;
              deferred.resolve();
            });
            promises.push(deferred.promise);
          };

          var getCampaignNewDataFromServer = function(promises) {
            var deferred = $q.defer();
            Persistence.getOne(Persistence.Entities.Hash.all().filter('name', '=', 'DonlerCampaign'))
              .then(function(hash) {
                hashCampaign = hash;
                var url = CONFIG.BASE_URL + '/campaigns';
                if (hash) {
                  url += ('?timehash=' + hash.timehash);
                }
                $http.get(url, {
                    params: params
                  })
                  .success(function(data, status) {
                    deferred.resolve(data);
                  })
                  .error(function(data, status) {
                    deferred.resolve(null);
                  });
              });
              promises.push(deferred.promise);
          };

          var promises = [];
          getCampaignNewDataFromServer(promises);
          getCampaignDataFromSqlite(promises, function(err, data) {
            callback(err, data);
          });
          
          $q.all(promises).then(function(res) {
            if (res[0] === null) {
              hcallback(data ? data.msg : '网络连接错误' || 'error');
            } else {
              var data = res[0];
              var timeObject = {
                max: -1
              }; //- use object not number

              //- handle the new data
              data.forEach(function(arr, index) {
                handleCampaignArray(arr, campaignData[index], index + 1, timeObject);
              });
              //- update campaign (mainly for campaign status(进行中、即将开始) because status change don't affect the timeHash in the server and front app change info via timeHash)
              // for (var i = 0; i < data.length; i++) {
              //   data[i] = updateCampaignArray(data[i], i + 1);
              // }
              if (timeObject.max !== -1) {
                //- sort campaign order by time
                sortCampaignArray(campaignData);

                data = campaignData;
                //- limit the number of finished campaign -> number(5)
                removeFinishedCampaign();

                if (hashCampaign) {
                  hashCampaign.timehash = timeObject.max;
                  var hashCollection = Persistence.Entities.Hash.all().filter('name', '=', 'DonlerCampaign');
                  Persistence.edit(hashCollection, hashCampaign)
                    .then(null, function(error) {
                      console.log(error);
                    })
                } else {
                  var hash = new Persistence.Entities.Hash();
                  hash.name = 'DonlerCampaign';
                  hash.timehash = timeObject.max;
                  Persistence.add(hash);
                }
                hcallback(null, data);
              } else {
                hcallback('no new data');
              }
            }
          });
          // Persistence.get(Persistence.Entities.DonlerCampaign.all().order('create_time', false)).then(function (_data) {
          //   dataArray = [];

          //   cloneData = _data;

          //   //- TODO simplify the operation
          //   dataArray.push(parseCampaign(_data.filter(unStartCampaignFilter)));
          //   dataArray.push(parseCampaign(_data.filter(nowCampaignFilter)));
          //   dataArray.push(parseCampaign(_data.filter(newCampaignFilter)));
          //   dataArray.push(parseCampaign(_data.filter(finishedCampaignFilter)));
          //   //- update campaign(mainly for campaign status(进行中、即将开始) because status change don't affect the timeHash in the server and front app change info via timeHash)
          //   for(var i = 0; i < dataArray.length; i++) {
          //     dataArray[i] = updateCampaignArray(dataArray[i], i + 1);
          //   }
          //   //- sort campaign order by time
          //   sortCampaignArray(dataArray);
          //   //- limit the number of finished campaign -> number(5)
          //   removeFinishedCampaign();

          //   callback(null, dataArray);
          //   // console.log(data);
          //   campaignData = dataArray;
          //   Persistence.getOne(Persistence.Entities.Hash.all().filter('name','=', 'DonlerCampaign'))
          //   .then(function(hash) {
          //     hashCampaign = hash;
          //     var url = CONFIG.BASE_URL + '/campaigns';
          //     if(hash) {
          //       url += ('?timehash=' + hash.timehash);
          //     }
          //     $http.get(url, {
          //       params: params
          //     })
          //     .success(function (data, status) {
          //       var timeObject = {max: -1}; //- use object not number

          //       //- handle the new data
          //       data.forEach(function(arr, index) {
          //         handleCampaignArray(arr, campaignData[index], index + 1, timeObject);
          //       });
          //       //- update campaign (mainly for campaign status(进行中、即将开始) because status change don't affect the timeHash in the server and front app change info via timeHash)
          //       // for (var i = 0; i < data.length; i++) {
          //       //   data[i] = updateCampaignArray(data[i], i + 1);
          //       // }
          //       if (timeObject.max !== -1) {
          //         //- sort campaign order by time
          //         sortCampaignArray(campaignData);

          //         data = campaignData;
          //         //- limit the number of finished campaign -> number(5)
          //         removeFinishedCampaign();

          //         if (hashCampaign) {
          //           hashCampaign.timehash = timeObject.max;
          //           var hashCollection = Persistence.Entities.Hash.all().filter('name', '=', 'DonlerCampaign');
          //           Persistence.edit(hashCollection, hashCampaign)
          //             .then(null, function(error) {
          //               console.log(error);
          //             })
          //         } else {
          //           var hash = new Persistence.Entities.Hash();
          //           hash.name = 'DonlerCampaign';
          //           hash.timehash = timeObject.max;
          //           Persistence.add(hash);
          //         }
          //         hcallback(null, data);
          //       } else {
          //         hcallback('no new data');
          //       }
          //     })
          //     .error(function (data, status) {
          //       hcallback(data ? data.msg:'网络连接错误' || 'error');
          //     });
          //   });
          // });
        } else {
          $http.get(CONFIG.BASE_URL + '/campaigns', {
            params: params
          })
          .success(function(data, status) {
            callback(null, data);
          })
          .error(function(data, status) {
            callback(data ? data.msg : '网络连接错误' || 'error');
          });
        }

      },
      getCompetitionOfTeams:function(data, callback){
        $http.get(CONFIG.BASE_URL + '/campaigns/competition/'+data.targetTeamId, {
          page: data.page
        })
        .success(function (data, status) {
          callback(null,data);
        })
        .error(function (data, status) {
          // todo
          callback(data && data.msg ? data.msg:'网络连接错误');
        });
      },
      get: function (id, callback,reload) {
        if(nowCampaign&&nowCampaign._id==id && !reload ) {
          callback(null,nowCampaign);
        }
        else{
          $http.get(CONFIG.BASE_URL + '/campaigns/' + id)
          .success(function (data, status) {
            nowCampaign = data;
            callback(null,data);
          })
          .error(function (data, status) {
            // todo
            callback(data ? data.msg:'网络连接错误');
          });
        }

      },
      create: function (data, callback) {
        $http.post(CONFIG.BASE_URL + '/campaigns', data)
        .success(function (data, status) {
          callback(null,data);
        })
        .error(function (data, status) {
          // todo
          callback(data ? data.msg : '网络连接错误');
        });
      },
      edit: function (id, campaignData, callback) {
        $http.put(CONFIG.BASE_URL + '/campaigns/' + id, campaignData)
        .success(function (data, status) {
          callback(null,data);
        })
        .error(function (data, status) {
          // todo
          callback(data ? data.msg : '网络连接错误');
        });
      },
      close: function (id, callback) {
        $http.delete(CONFIG.BASE_URL + '/campaigns/' + id)
        .success(function (data, status) {
          callback(null,data);
        })
        .error(function (data, status) {
          // todo
          callback(data ? data.msg : '网络连接错误');
        });
      },
      join: function(campaign, uid, callback) {
        $http.post(CONFIG.BASE_URL + '/campaigns/' + campaign._id +'/users/'+uid)
        .success(function (data, status) {
          callback(null,data);
          if(window.plugin){
            var remindTimeDay = 1000 * 60 * 60 * 24;//one day
            var remindTimeHour = 1000 * 60 * 60;//one hour
            var scheduleTimeDay = new Date(new Date(campaign.start_time).getTime()-remindTimeDay);
            if(scheduleTimeDay>=new Date()){
              window.plugin.notification.local.isScheduled(campaign._id+'1', function (isScheduled) {
                if(!isScheduled){
                  window.plugin.notification.local.add({
                    id:         campaign._id + '1',  // A unique id of the notifiction
                    date:       scheduleTimeDay,    // This expects a date object
                    message:    '活动' + campaign.theme +'明天就要开始了，请准时参加哦。',  // The message that is displayed
                    title:      '活动提醒',  // The title of the message
                    //sound:      String,  // A sound to be played
                    json:       JSON.stringify({ id: campaign._id }),  // Data to be passed through the notification
                    autoCancel: true // Setting this flag and the notification is automatically canceled when the user clicks it
                  });
                }
              });
            }
            var scheduleTimeHour = new Date(new Date(campaign.start_time).getTime()-remindTimeHour);
            if(scheduleTimeHour>=new Date()){
              window.plugin.notification.local.isScheduled(campaign._id+'2', function (isScheduled) {
                if(!isScheduled){
                  window.plugin.notification.local.add({
                    id:         campaign._id + '2',  // A unique id of the notifiction
                    date:       scheduleTimeHour,    // This expects a date object
                    message:    '活动' + campaign.theme + '再过一小时就要开始了，请准时参加哦。',  // The message that is displayed
                    title:      '活动提醒',  // The title of the message
                    //sound:      String,  // A sound to be played
                    json:       JSON.stringify({ id: campaign._id }),  // Data to be passed through the notification
                    autoCancel: true // Setting this flag and the notification is automatically canceled when the user clicks it
                  });
                }
              });
            }
          }
        })
        .error(function (data, status) {
          // todo
          callback(data ? data.msg : '网络连接错误');
        });
      },
      quit: function(id, uid, callback) {
        $http.delete(CONFIG.BASE_URL + '/campaigns/' + id+'/users/'+uid)
        .success(function (data, status) {
          callback(null,data);
          if(window.plugin){
            window.plugin.notification.local.cancel(id + '1', function () { });
            window.plugin.notification.local.cancel(id + '2', function () { });
          }
        })
        .error(function (data, status) {
          // todo
          callback(data ? data.msg : '网络连接错误');
        });
      },
      dealProvoke: function(id, dealType, callback) {
        $http.put(CONFIG.BASE_URL + '/campaigns/' + id+'/dealProvoke',{dealType:dealType})
        .success(function (data, status) {
          callback(null,data);
        })
        .error(function (data, status) {
          // todo
          callback(data ? data.msg : '网络连接错误');
        });
      },
      getMolds: function(hostType, hostId, callback) {
        $http.get(CONFIG.BASE_URL + '/campaigns/mold/' + hostType +'/'+ hostId)
        .success(function (data, status) {
          callback(null,data);
        })
        .error(function (data, status) {
          // todo
          callback(data ? data.msg : '网络连接错误');
        });
      }
    }
  }])

  .factory('Easemob', ['$rootScope','CONFIG', function socket($rootScope, CONFIG) {
    return {
      on: function(name, callback) {
        
      }
    }
      
  }])

  .factory('Socket', ['$rootScope','CONFIG', function socket($rootScope, CONFIG) {
    var token = localStorage.accessToken;
    var socket;
    if(token){
      socket = io.connect(CONFIG.SOCKET_URL,{query:'token=' + token});
    }
    return {
      login: function() {
        token = localStorage.accessToken;
        if (socket) {
          socket = io.connect(CONFIG.SOCKET_URL,{ query: 'token=' + token, forceNew: true });
        } else {
          socket = io.connect(CONFIG.SOCKET_URL,{query:'token=' + token});
        }
      },
      logout: function() {
        socket.disconnect();
      },
      on: function (eventName, callback) {
        socket.on(eventName, function () {
          var args = arguments;
          $rootScope.$apply(function () {
            callback.apply(socket, args);
          });
        });
      },
      emit: function (eventName, data, callback) {
        socket.emit(eventName, data, function () {
          var args = arguments;
          $rootScope.$apply(function () {
            if (callback) {
              callback.apply(socket, args);
            }
          });
        });
      }
    };
  }])
  .factory('Comment', ['$http', 'CONFIG', function ($http, CONFIG) {
    return {
      getComments: function(data,callback) {
        $http.get(CONFIG.BASE_URL + '/comments',{
          params:{
            requestType: data.requestType,
            requestId: data.requestId,
            limit: data.limit,
            createDate: data.createDate
          }
        }).success(function (data, status) {
          callback(null,data);
        }).error(function (data, status) {
          // todo
          callback(data ? data.msg:'error');
        });;
      },
      /**
       * 发评论
       * @param  {Object}   data     hostType，hostId，content，randomId
       * @param  {Function} callback [description]
       * @return {[type]}            [description]
       */
      publishComment: function(data, callback) {
        // console.log(data);
        $http.post(CONFIG.BASE_URL +'/comments/host_type/'+data.hostType+'/host_id/'+data.hostId,{
          'content':data.content
          // 'randomId':data.randomId
        })
        .success(function (data, status) {
          callback(null,data);
        }).error(function (data, status) {
          // todo
          callback('publish error');
        });
      }
    }
  }])
  .factory('Chat', ['$http', 'CONFIG', 'Tools', 'Team', 'User', function ($http, CONFIG, Tools, Team, User) {
    var chatroomList = [];//缓存chatroomList

    var addMissingTeams = function(conversations, teams) {
      // var promised = teams.map(function(team) {
      //   var index = Tools.arrayObjectIndexOf(conversations, teams[i].easemobId, 'chatter');
      //   if(index === -1) {
      //     var tempConv = {
      //       'groupId': teams[i]._id,
      //       'easemobId': teams[i].easemobId,
      //       'logo':teams[i].logo,
      //       'name': teams[i].name
      //       //'unreadMessagesCount': 0
      //     };
      //     resultConversations.push(tempConv);
      //   }
      //   else {
      //     resultConversations[index].groupId = teams[i].logo;
      //     resultConversations[index].easemobId = teams[i].easemobId;
      //     resultConversations[index].logo = teams[i].logo;
      //     resultConversations[index].name = teams[i].name;
      //     var latestMessage = resultConversations[index].latestMessage;
      //     if(latestMessage) {
      //       User.getData(latestMessage.from, function(err, user) {
      //         if(!err) latestMessage.nickname = user.nickname;
      //       });
      //     }
      //   }
      // })
      //遍历teams, conversations里有的就加logo,name和easemobId，没有就创建一个塞进去
      var resultConversations = conversations.slice(0);
      for(var i=teams.length-1; i>=0; i--){
        var index = -1;
        if(conversations.length > 0){
          index = Tools.arrayObjectIndexOf(conversations, teams[i].easemobId, 'chatter');
        }
        if(index === -1) {
          var tempConv = {
            'chatter': teams[i].easemobId,
            'teamId': teams[i]._id,
            'easemobId': teams[i].easemobId,
            'logo': teams[i].logo,
            'name': teams[i].name,
            'isGroup': true
            //'unreadMessagesCount': 0
          };
          resultConversations.push(tempConv);
        }
        else {
          resultConversations[index].teamId = teams[i]._id;
          resultConversations[index].easemobId = teams[i].easemobId;
          resultConversations[index].logo = teams[i].logo;
          resultConversations[index].name = teams[i].name;
          var latestMessage = resultConversations[index].latestMessage;
          if(latestMessage) {
            //添加user name todo
            latestMessage.posterNickname = '';
          }
        }
      }
      return resultConversations;
    }
    return {
      /**
       * 获取聊天室列表
       * @param  {boolean} force 是否要强制刷新
       * @param  {Function} callback 形如function(err, list)
       */
      getChatroomList: function(force, callback, hcallback) {
        //先取会话，[排序]，后加上没有加入会话的小队.
        if(!force && chatroomList.length) {
          callback(null, chatroomList);
        }
        else {
          var conversations =[];
          var resultList = [];
          easemob.getAllConversations(function(arguments) {
            //success 
            conversations = arguments;
            //暂不排序;
            Team.getList('user', localStorage.id, false, function(err, teams){
              //往conversations里加没有的
              resultList = addMissingTeams(conversations, teams);
              callback(err, resultList);
            }, function(err, teams) {
              //更新http来的小队
              if(!err && teams.length) {
                resultList = addMissingTeams(resultList, teams);
                hcallback(err, resultList);
                chatroomList = resultList;
              }
            });
          },function(arguments) {
            //fail
            callback(arguments);
          });
        }
      },

      getChatroomUnread: function(callback) {
        //不需要了
      },
      /**
       * 获取某聊天室的聊天记录
       * @param  {Object}   params  查询query:{chatroom,nextDate,nextId}
       * @param  {Function} callback 形如:function(err,data)
       */
      getChats: function(params, callback,hcallback) {
        
      },

      /**
       * 发布聊天
       * @param  {[type]}   chatroomId [description]
       * @param  {[type]}   postData   [description]
       * @param  {Function} callback   [description]
       * @return {[type]}              [description]
       */
      postChat: function(chatroomId, postData, callback) {
        
      },
      /**
       * 出聊天室触发
       * @param  {[type]}   chatroomId [description]
       * @param  {Function} callback   [description]
       * @return {[type]}              [description]
       */
      readChat: function(chatroomId, callback) {
        
      },
      /**
       * 保存当前chatroomList(离开列表页时)
       * @param  {array} chatrooms
       */
      saveChatroomList: function(chatrooms) {
        chatroomList = chatrooms;
      },
      /**
       * 当socket来了数据时更新缓存chatroomList
       * todo 改为后台来了消息
       * @param  {Object} chat
       */
      updateChatroomList: function(chat) {
        if(chatroomList) {
          var index = Tools.arrayObjectIndexOf(chatroomList,chat.chatroom_id,'_id');
          if(index>-1) {
            if(chat.poster._id.toString()!=localStorage.id) {
              chatroomList[index].unread ++;
            }
            chatroomList[index].latestChat = chat;
            //移到最前
            var temp = chatroomList[index];
            chatroomList.splice(index, 1);
            chatroomList.unshift(temp); 
          }
        }
      },
      /**
       * 退出登录清除
       */
      clearChatroomList: function() {
        chatroomList = null;
      }
    }
  }])
  .factory('Tools', [function () {
    return{
      arrayObjectIndexOf: function (myArray, searchTerm, property) {
        var _property = property.split('.');
        for(var i = 0, len = myArray.length; i < len; i++) {
          var item = myArray[i];
          _property.forEach( function (_pro) {
            item = item[_pro];
          });
          if (item.toString() === searchTerm.toString()) return i;
        }
        return -1;
      },

      /**
       * 判断两个日期是否是同一天
       * @param {Date|String} d1
       * @param {Date|String} d2
       */
      isTheSameDay: function (d1, d2) {
        if (typeof d1 === 'string') {
          d1 = new Date(d1);
        }
        if (typeof d2 === 'string') {
          d2 = new Date(d2);
        }
        return d1.getFullYear() === d2.getFullYear()
          && d1.getMonth() === d2.getMonth()
          && d1.getDate() === d2.getDate();
      },

      /**
       * 判断两个日期是否是同一个月
       * @param {Date|String} d1
       * @param {Date|String} d2
       */
      isTheSameMonth: function (d1, d2) {
        if (!(d1 instanceof Date)) {
          d1 = new Date(d1);
        }
        if (!(d2 instanceof Date)) {
          d2 = new Date(d2);
        }
        return d1.getFullYear() === d2.getFullYear()
          && d1.getMonth() === d2.getMonth();
      },

      /**
       * 获取生日对应的星座
       * @param  {Number} mon 月份，1-12
       * @param  {Number} day 日期，1-31
       * @return {String}     星座名
       */
      birthdayToConstellation: function(mon, day) {
        var s = "魔羯水瓶双鱼白羊金牛双子巨蟹狮子处女天秤天蝎射手魔羯";
        var d = [20, 19, 21, 20, 21, 22, 23, 23, 23, 24, 23, 22];
        var i = mon * 2 - (day < d[mon - 1] ? 2 : 0);
        return s.substring(i, i + 2) + "座";
      },

      formatCampaignTime: function(start_time, end_time) {
        var remind_text, time_text, start_flag;
        var now = new Date();
        var diff_end = now - end_time;
        if (diff_end >= 0) {
          // 活动已结束
          remind_text = '活动已结束';
          time_text = '';
          start_flag = -1;
        } else {
          // 活动未结束
          var temp_start_time = new Date(start_time);
          var during = moment.duration(moment(now).diff(temp_start_time));
          // 活动已开始
          if (during >= 0) {
            start_flag = 1;
            remind_text = '距离结束';
            var temp_end_time = new Date(end_time);
            var during = moment.duration(moment(now).diff(temp_end_time));
          } else {
            // 活动未开始
            start_flag = 0;
            remind_text = '距离开始';
          }
          var years = Math.abs(during.years());
          var months = Math.abs(during.months());
          var days = Math.floor(Math.abs(during.asDays()));
          var hours = Math.abs(during.hours());
          var minutes = Math.abs(during.minutes());
          var seconds = Math.abs(during.seconds());
          if (years >= 1) {
            time_text = years + '年';
          } else if (months >= 1) {
            time_text = months + '月';
          } else if (days >= 1) {
            time_text = days + '天';
          } else if (hours >= 1) {
            time_text = hours + '时';
          } else if (minutes >= 1) {
            time_text = minutes + '分';
          } else {
            time_text = seconds + '秒';
          }
        }
        return {
          start_flag: start_flag,
          remind_text: remind_text,
          time_text: time_text
        };
      }


    };
  }])
  .factory('User', ['$http', 'CONFIG', 'Persistence', 'Tools', function ($http, CONFIG, Persistence, Tools) {
    var currentUser;//存下自己的数据，我的、发评论时用
    return {
      /**
       * 获取用户数据
       * @param {String} id 用户id
       * @param {Function} callback 获取后的回调函数，形式为function(err, data)
       */
      getData: function (id, callback) {
        if(id===localStorage.id){
          if(currentUser) {
            callback(null, currentUser);
            return;
          }
        }
        $http.get(CONFIG.BASE_URL + '/users/' + id)
          .success(function (data, status, headers, config) {
            if(id===localStorage.id)
              currentUser = data;
            callback(null, data);
          })
          .error(function (data, status, headers, config) {
            callback('error');
          });
      },

      editData: function (id, data, callback) {
        $http.put(CONFIG.BASE_URL + '/users/' + id, data)
          .success(function (data, status, headers, config) {
            currentUser = null;
            callback();
          })
          .error(function (data, status, headers, config) {
            if (status === 400) {
              callback(data.msg);
            } else {
              callback('出错了');
            }
          });
      },

      findBack: function (email, callback) {
        $http.post(CONFIG.BASE_URL + '/users/forgetPassword',{email: email})
        .success(function (data, status) {
          callback(null);
        })
        .error(function (data, status) {
          callback('error');
        });
      },

      /**
       * 发送反馈
       * @param  {string}   content 反馈内容
       * @param {Function} callback 获取后的回调函数，形式为function(err, data)
       */
      feedback: function(content, callback) {
        $http.post(CONFIG.BASE_URL + '/users/sendFeedback',{content: content})
        .success(function (data, status) {
          callback(null);
        })
        .error(function (data, status) {
          callback('err');
        });
      },

      /**
       * 获取免打扰状态
       * @param  {String}   id
       * @param  {Function} callback 获取后的回调函数，形式为function(err, data)
       */
      getPushToggle: function(id, callback) {
        $http.get(CONFIG.BASE_URL + '/users/' + id, {params:{responseKey:'pushToggle'}})
        .success(function (data, status, headers, config) {
          callback(null, data);
        })
        .error(function (data, status, headers, config) {
          callback('error');
        });
      },

      /**
       * 获取公司通讯录
       * @param  {String}   cid  公司id
       * @param  {Function} callback 获取后的回调函数，形式为function(err, data)
       */
      getCompanyUsers: function(cid, callback, hcallback) {
        Persistence.get(Persistence.Entities.DonlerUser.all()).then(function (data) {
          callback(null,data);
          var userData = data;
          Persistence.getOne(Persistence.Entities.Hash.all().filter('name','=', 'DonlerUser'))
          .then(function(hash) {
            var hashUser = hash;
            var url = CONFIG.BASE_URL + '/users/list/' + cid;
            if(hash) {
              url += ('?timehash=' + hash.timehash);
            }
            $http.get(url)
            .success(function(data, status) {
              if(data.length) {
                var maxTime = -1;
                data.forEach(function(user) {
                  var index = Tools.arrayObjectIndexOf(userData, user._id, '_id');

                  if(index > -1) {
                    if(!user.active) {
                      userData.splice(index, 1);
                      var userDeletedCollection = Persistence.Entities.DonlerUser.all().filter('_id','=', user._id);
                      Persistence.delete(userDeletedCollection)
                        .then(null, function(error) {
                          console.log(error);
                        })
                    } else {
                      userData[index] = user;
                      var userCollection = Persistence.Entities.DonlerUser.all().filter('_id','=',user._id);
                      Persistence.edit(userCollection, user)
                        .then(null, function(error) {
                          console.log(error);
                        })
                    }
                  } else {
                    if(user.active) {
                      userData.push(user);
                      var _user = new Persistence.Entities.DonlerUser();
                      _user._id = user._id;
                      _user.email = user.email;
                      _user.nickname = user.nickname;
                      _user.photo = user.photo;
                      _user.realname = user.realname;
                      Persistence.add(_user);
                    }
                  }

                  var date = (new Date(user.timeHash)).valueOf();
                  if(date > maxTime) {
                    maxTime = date;
                  }
                })
                data = userData;
                if(hashUser) {
                  hashUser.timehash = maxTime;
                  var hashCollection = Persistence.Entities.Hash.all().filter('name', '=', 'DonlerUser');
                  Persistence.edit(hashCollection, hashUser)
                    .then(null, function(error) {
                      console.log(error);
                    })
                } else {
                  var hash = new Persistence.Entities.Hash();
                  hash.name = 'DonlerUser';
                  hash.timehash = maxTime;
                  Persistence.add(hash);
                }
                hcallback(null, data);
              } else {
                hcallback(null, []);
              }
            })
            .error(function(data, status) {
              hcallback(data ? data.msg : 'error');
            });
          })

        })
      },

      clearCurrentUser: function() {
        currentUser = null;
      }

    };

  }])
  .factory('Team', ['$http', '$ionicActionSheet', 'CONFIG', 'User', 'Persistence', 'Tools', function ($http, $ionicActionSheet, CONFIG, User, Persistence, Tools) {

    /**
     * 每调用Team.getData方法时，会将小队数据保存到这个变量中，在进入小队子页面时不必再去请求小队数据，
     * 同时也避免了使用rootScope
     */
    var currentTeam;

    return {

      /**
       * 获取小队列表
       * @param {String} hostType 小队所属，只可以是'company','user'
       * @param {String} hostId 所属者id
       * @param {Function} callback 形式为function(err, teams)
       * @param {Object} other gid,personalFlag
       */
      getList: function (hostType, hostId, personalFlag, callback, hcallback) {
        if(!hostId || hostId === localStorage.id.toString()) {
          var teamCollection = Persistence.Entities.DonlerTeam.all();
          var hashCollection;
          if(hostType === 'user') {
            teamCollection = teamCollection.filter('hasJoined','=', true);
            hashCollection = Persistence.Entities.Hash.all().filter('name','=', 'userTeam'); // for personal team update
          } else {
            hashCollection = Persistence.Entities.Hash.all().filter('name','=', 'companyTeam'); // for company team update
          }
          Persistence.get(teamCollection).then(function (data) {
            callback(null,data);
            var teamData = data;
            Persistence.getOne(hashCollection)
            .then(function(hash) {
              var hashTeam = hash;

              var url = CONFIG.BASE_URL + '/teams';
              if(hash) {
                url += ('?timehash=' + hash.timehash);
              }
              $http.get(url, {
                  params: {
                    hostType: hostType,
                    hostId: hostId,
                    personalFlag: personalFlag
                  }
                })
                .success(function(data, status) {
                  if (data.length) {
                    var maxTime = -1;
                    data.forEach(function(team) {
                      var index = Tools.arrayObjectIndexOf(teamData, team._id, '_id');

                      if (index > -1) {
                        if (!team.active) {
                          teamData.splice(index, 1);
                          var userDeletedCollection = Persistence.Entities.DonlerTeam.all().filter('_id', '=', team._id);
                          Persistence.delete(userDeletedCollection)
                            .then(null, function(error) {
                              console.log(error);
                            })
                        } else {
                          teamData[index] = team;
                          var userCollection = Persistence.Entities.DonlerTeam.all().filter('_id', '=', team._id);
                          Persistence.edit(userCollection, team)
                            .then(null, function(error) {
                              console.log(error);
                            })
                        }
                      } else {
                        if (team.active) {
                          teamData.push(team);
                          var _team = new Persistence.Entities.DonlerTeam();
                          _team._id = team._id;
                          _team.active = team.active;
                          _team.name = team.name;
                          _team.logo = team.logo;
                          _team.leaders = team.leaders;
                          _team.score = team.score;
                          _team.groupType = team.groupType;
                          _team.memberCount = team.memberCount;
                          _team.isLeader = team.isLeader;
                          _team.hasJoined = team.hasJoined;
                          _team.campaignCount = team.campaignCount;
                          _team.easemobId = team.easemobId;
                          Persistence.add(_team);
                        }
                      }

                      var date = (new Date(team.timeHash)).valueOf();
                      if (date > maxTime) {
                        maxTime = date;
                      }
                    })
                    data = teamData;
                    if (hashTeam) {
                      hashTeam.timehash = maxTime;
                      Persistence.edit(hashCollection, hashTeam)
                        .then(null, function(error) {
                          console.log(error);
                        })
                    } else {
                      var hash = new Persistence.Entities.Hash();
                      hash.name = hostType + 'Team';
                      hash.timehash = maxTime;
                      Persistence.add(hash);
                    }
                    hcallback(null, data);
                  } else {
                    hcallback(null, []);
                  }
                })
                .error(function(data, status) {
                  hcallback(data ? data.msg : 'error');
                });
            })

          });
        } else {
          $http.get(CONFIG.BASE_URL + '/teams', {
            params: {
              hostType: hostType,
              hostId: hostId,
              personalFlag: personalFlag
            }
          })
          .success(function(data, status) {
            callback(null, data);
          })
          .error(function(data, status) {
            callback(data ? data.msg : 'error');
          });
        }
      },

      /**
       * 获取某个小队的数据
       * @param {String} tid 小队id
       * @param {Function} callback 形式为function(err, team)
       */
      getData: function (tid, callback,queryData) {
        $http.get(CONFIG.BASE_URL + '/teams/' + tid,{
          params:queryData
        })
          .success(function (data, status, headers, config) {
            if(!queryData || !queryData.resultType || queryData.resultType!='simple'){
              currentTeam = data;
            }
            callback(null, data);
          })

          .error(function (data, status, headers, config) {
            if (status === 400) {
              callback(data.msg);
            } else {
              callback('error');
            }
          });
      },

      edit: function (tid, postData, callback) {
        $http.put(CONFIG.BASE_URL + '/teams/' + tid, postData)
          .success(function (data, status, headers, config) {
            callback();
          })
          .error(function (data, status, headers, config) {
            if (data.msg) {
              callback(data.msg);
            } else {
              callback('error');
            }
          });
      },

      /**
       * 获取小队成员列表
       * @param {String} teamId 小队id
       * @param {Function} callback 形式为function(err, members)
       */
      getMembers: function (teamId, callback) {
        $http.get(CONFIG.BASE_URL + '/teams/' + teamId + '/members')
          .success(function (data, status, headers, config) {
            callback(null, data);
          })
          .error(function (data, status, headers, config) {
            if (status === 400) {
              callback(data.msg);
            } else {
              callback('error');
            }
          });
      },

      /**
       * 获取当前小队数据
       * @return {Object}
       */
      getCurrentTeam: function () {
        return currentTeam;
      },
      joinTeam: function(tid, uid, callback) {
        $http.put(CONFIG.BASE_URL + '/teams/' + tid +'/users/'+ uid)
          .success(function (data, status, headers, config) {
            callback(null, data);
            User.clearCurrentUser();
          })
          .error(function (data, status, headers, config) {
            callback((data && data.msg) || '操作失败，这可能是网络问题或服务器错误');
          });
      },
      quitTeam: function(tid, uid, callback) {
        var uploadSheet = $ionicActionSheet.show({
          buttons:[{text: '确定'}],
          titleText: '您确定要退出小队吗?',
          cancelText: '取消',
          buttonClicked: function (index) {
            quit();
            return true;
          }
        });
        var quit = function() {
          $http.delete(CONFIG.BASE_URL + '/teams/' + tid +'/users/'+ uid)
            .success(function (data, status, headers, config) {
              callback(null, data);
              User.clearCurrentUser();
            })
            .error(function (data, status, headers, config) {
              callback((data && data.msg) || '操作失败，这可能是网络问题或服务器错误');
            });
        };
      },
      getLeadTeam: function(gid, callback){
        var requestUrl = CONFIG.BASE_URL + '/teams/lead/list';
        if(gid) {
          requestUrl += '?gid=' + gid;
        }
        $http.get(requestUrl)
          .success(function (data, status, headers, config) {
            callback(null, data);
          })
          .error(function (data, status, headers, config) {
            if (status === 400) {
              callback(data.msg);
            } else {
              callback('error');
            }
          });
      },

      getFamilyPhotos: function (teamId, callback) {
        $http.get(CONFIG.BASE_URL + '/teams/' + teamId + '/family_photos')
          .success(function (data, status, headers, config) {
            callback(null, data);
          })
          .error(function (data, status, headers, config) {
            callback('error');
          });
      },

      toggleSelectFamilyPhoto: function (teamId, familyPhotoId, callback) {
        $http.put(CONFIG.BASE_URL + '/teams/' + teamId + '/family_photos/' + familyPhotoId)
          .success(function (data, status, headers, config) {
            callback();
          })
          .error(function (data, status, headers, config) {
            callback('error');
          });
      },

      //获取供新建小队用的全部类型group
      getGroups: function(callback) {
        $http.get(CONFIG.BASE_URL + '/groups/')
          .success(function (data, status, headers, config) {
            callback(null, data);
          })
          .error(function (data, status, headers, config) {
            callback('error');
          });
      },

      createTeam: function(data, callback) {
        $http.post(CONFIG.BASE_URL + '/teams', data)
          .success(function (data, status, headers, config) {
            callback(null, data);
          })
          .error(function (data, status, headers, config) {
            callback(data.msg||'error');
          });
      },
      updatePersonalTeam: function(teamId, callback) {
        $http.put(CONFIG.BASE_URL + '/teams/'+teamId+'/update', data)
          .success(function (data, status, headers, config) {
            callback(null, data);
          })
          .error(function (data, status, headers, config) {
            callback(data.msg||'error');
          });
      },
      /**
       * 查找小队
       * @param  {Object}   data     type,tid,page,key,latitude,longitude
       *                         type:sameCity,nearbyTeam,search
       * @param  {Function} callback [description]
       * @return {[type]}            [description]
       */
      getSearchTeam: function (data,callback) {
        $http.get(CONFIG.BASE_URL + '/teams/search/'+data.type,{
          params:{
            tid: data.tid,
            page: data.page,
            key: data.key,
            latitude: data.latitude,
            longitude: data.longitude
          }
        })
        .success(function (data, status) {
          callback(null, data);
        })
        .error(function (data, status) {
          callback(data ? data.msg:'网络连接错误');
        });
      }

    };
  }])
  .factory('Company', ['$http', 'CONFIG', function ($http, CONFIG) {
      return {
        getInviteKey: function (cid, callback) {
          $http.get(CONFIG.BASE_URL + '/companies/' + cid + '?responseKey=inviteKey')
          .success(function(data, status){
            callback(null,data);
          })
          .error(function(data, status){
            callback(data.msg);
          });
        },
        getTeams: function (cid, target, type, callback) {
          //type todo
          $http.get(CONFIG.BASE_URL + '/companies/' + cid +'/statistics', {
            params: {
              target: target,
              type: type
            }
          })
          .success(function (data, status) {
            callback(null, data);
          })
          .error(function (data, status) {
            callback(data.msg);
          });
        },
        findBack: function (email, callback) {
          $http.post(CONFIG.BASE_URL + '/companies/forgetPassword',{email: email})
          .success(function (data, status) {
            callback(null);
          })
          .error(function (data, status) {
            callback('error');
          });
        },
        getData: function(id) {
          return $http.get(CONFIG.BASE_URL + '/companies/' + id);
        },
        edit: function(cid, postData, callback) {
          $http.put(CONFIG.BASE_URL + '/companies/' + cid, postData)
          .success(function (data, status) {
            callback(null);
          })
          .error(function (data, status) {
            callback('error');
          });          
        }
      };
    }])
  .factory('Message', ['$http', 'CONFIG', function ($http, CONFIG) {
    var nowCampaignMessages;
    return {

      /**
       * 获取活动的公告列表
       * @param {String} hostId campaignId
       * @param {Function} callback 形式为function(err, teams)
       */
      getCampaignMessages: function (hostId, callback,reload) {
        if(!reload && nowCampaignMessages&&nowCampaignMessages._id==hostId) {
          callback(null,nowCampaignMessages);
        }
        else{
          var requestUrl = CONFIG.BASE_URL + '/messages?requestType=campaign&requestId=' + hostId;
          $http.get(requestUrl)
            .success(function (data, status, headers, config) {
              nowCampaignMessages = data;
              callback(null, data);
            })
            .error(function (data, status, headers, config) {
              if (status === 400) {
                callback(data.msg);
              } else {
                callback('error');
              }
            })
        }
      },

      /**
       * 获取个人的站内信列表
       * @param {String} userId
       * @param {Function} callback function(err, messages)
       */
      getUserMessages: function (userId, callback) {
        $http.get(CONFIG.BASE_URL + '/messages', {
          params: {
            requestType: 'all',
            requestId: userId
          }
        })
          .success(function (data, status, headers, config) {
            callback(null, data);
          })
          .error(function (data, status, headers, config) {
            // todo
            callback('error');
          });
      },

      /**
       * 收取个人的站内信
       * @param {String} userId
       * @param {Function} callback function(err, messagesCount)
       */
      receiveUserMessages: function (userId, callback) {
        $http.get(CONFIG.BASE_URL + '/messages/user/' + userId)
          .success(function (data, status, headers, config) {
            callback(null, data.count);
          })
          .error(function (data, status, headers, config) {
            // todo
            callback('error');
          });
      },
      postMessage: function (data, callback) {
        $http.post(CONFIG.BASE_URL + '/messages', data)
          .success(function (data, status, headers, config) {
            callback(null, data);
          })
          .error(function (data, status, headers, config) {
            // todo
            callback(data.msg || 'error');
          });
      }

    };
  }])
  .factory('PhotoAlbum', ['$http', 'CONFIG', function ($http, CONFIG) {
    return {

      /**
       * 获取某个小队的相册列表
       * @param {Object} params 查询query
       * @param {Function} callback 形式为function(err, photoAlbums)
       */
      getList: function (params, callback) {
        $http.get(CONFIG.BASE_URL + '/photo_albums', {
          params: params
        })
          .success(function (data, status, headers, config) {
            callback(null, data);
          })
          .error(function (data, status, headers, config) {
            if (status === 400) {
              callback(data.msg);
            } else {
              callback('error');
            }
          });
      },

      /**
       * 获取某个相册的id
       * @param {String} photoAlbumId 相册id
       * @param {Function} callback 形式为function(err, photoAlbum)
       */
      getData: function (photoAlbumId, callback) {
        $http.get(CONFIG.BASE_URL + '/photo_albums/' + photoAlbumId)
          .success(function (data, status, headers, config) {
            callback(null, data);
          })
          .error(function (data, status, headers, config) {
            if (status === 400) {
              callback(data.msg);
            } else {
              callback('error');
            }
          });
      },

      /**
       * 获取某个相册的所有照片
       * @param {String} photoAlbumId 相册id
       * @param {Function} callback 形式为function(err, photos)
       */
      getPhotos: function (photoAlbumId, callback) {
        $http.get(CONFIG.BASE_URL + '/photo_albums/' + photoAlbumId + '/photos')
          .success(function (data, status, headers, config) {
            callback(null, data);
          })
          .error(function (data, status, headers, config) {
            if (status === 400) {
              callback(data.msg);
            } else {
              callback('error');
            }
          });
      }

    };
  }])
  .factory('TimeLine', ['$http', 'CONFIG', function ($http, CONFIG) {
    return {

      /**
       * 获取timeline的记录
       * @param {String} hostType 数据主体类型，只可以是'company','team','user'
       * @param {String} hostId 主体的id
       * @param {Function} callback 形式为function(err, timelineRecord)
       */
      getTimelineRecord: function (hostType, hostId, callback) {
        $http.get( CONFIG.BASE_URL + '/timeline/record/' + hostType +'/'+hostId )
          .success(function (data, status, headers, config) {
            callback(null, data);
          })
          .error(function (data, status, headers, config) {
            if (status === 400) {
              callback(data.msg);
            } else {
              callback('error');
            }
          })
      },
      /**
       * 获取timeline的数据
       * @param {String} hostType 数据主体类型，只可以是'company','team','user'
       * @param {String} hostId 主体的id
       * @param {String} year 获取数据的年份
       * @param {String} month  获取数据的月份
       * @param {Function} callback 形式为function(err, timelineData)
       */
      getTimelineData: function (hostType, hostId, year, month, callback) {
        $http.get( CONFIG.BASE_URL + '/timeline/data/' + hostType + '/'+ hostId +'?year='
          +year+'&month='+month)
          .success(function (data, status, headers, config) {
            callback(null, data);
          })
          .error(function (data, status, headers, config) {
            if (status === 400) {
              callback(data.msg);
            } else {
              callback('error');
            }
          })
      },
      /**
       * 获取timelines
       * @param {String} hostType 数据主体类型，只可以是'company','team','user'
       * @param {String} hostId 主体的id
       * @param {String} page timeline的页数
       * @param {Function} callback 形式为function(err, timelineData)
       */
      getTimelines: function (hostType, hostId, page, callback, unfinishFlag) {
        $http.get( CONFIG.BASE_URL + '/timeline/' + hostType + '/'+ hostId,{
          params:{
            page: page,
            unfinishFlag:unfinishFlag
          }
        })
        .success(function (data, status, headers, config) {
          callback(null, data);
        })
        .error(function (data, status, headers, config) {
          callback(data.msg||'网络连接错误');
        })
      },
    };
  }])
  .factory('Report', ['$http', 'CONFIG', function ($http, CONFIG) {
    return {

      /**
       * 举报
       * @param {String} hostType 数据主体类型，只可以是'comment','team','photo'
       * @param {String} hostId 主体的id
       * @param {Function} callback 形式为function(err, data)
       */
      pushReport: function (data, callback) {
        $http.post( CONFIG.BASE_URL + '/report', data )
          .success(function (data, status, headers, config) {
            callback(null, data);
          })
          .error(function (data, status, headers, config) {
            if (status === 400) {
              callback(data.msg);
            } else {
              callback('error');
            }
          });
      }
    };
  }])
  .factory('Upload', ['$cordovaFile', '$ionicModal', '$ionicActionSheet', '$ionicLoading', '$cordovaCamera', 'CommonHeaders', '$rootScope', function($cordovaFile, $ionicModal, $ionicActionSheet, $ionicLoading, $cordovaCamera, CommonHeaders, $rootScope) {
    return {
      /**
       * 用户选择图片接口
       * @param  {boolean}   needEdit 是否需要剪裁
       * @param  {Function} callback 形式：callback(err, imageURI)
       */
      getPicture: function(needEdit, callback) {
        var getPhotoFrom = function (source) {
          var sourceType = Camera.PictureSourceType.PHOTOLIBRARY;
          var save = false;
          if (source === 'camera') {
            sourceType = Camera.PictureSourceType.CAMERA;
            save = true;
          }

          var options = {
            quality: 50,
            destinationType: Camera.DestinationType.FILE_URI,
            sourceType: sourceType,
            encodingType: Camera.EncodingType.JPEG,
            popoverOptions: CameraPopoverOptions,
            saveToPhotoAlbum: save,
            correctOrientation: true
          };
          if(needEdit) {
            options.allowEdit = true;
            options.targetWidth = 256;
            options.targetHeight = 256;
          }

          $cordovaCamera.getPicture(options).then(function(imageURI) {
            callback(null, imageURI);
          }, function(err) {
            if (err !== 'no image selected' && err !=='Selection cancelled.') {
              $rootScope.showAction({titleText:'获取照片失败,请选择正确类型的图片'})
            }
            callback(err);
          });
        };
        var uploadSheet = $ionicActionSheet.show({
          buttons: [{
            text: '拍照上传'
          }, {
            text: '本地上传'
          }],
          titleText: '请选择上传方式',
          cancelText: '取消',
          buttonClicked: function (index) {
            if (index === 0) {
              getPhotoFrom('camera');
            } else if (index === 1) {
              getPhotoFrom('file');
            }
            return true;
          }
        });
      },

      /**
       * 上传图片接口
       * @param  {string}   source   来源，enum:[discuss,photoAlbum,logo,photo,family] 相册、评论、logo、头像
       * @param  {string}   addr     上传server地址
       * @param  {object}   data     imageURI等需要上传的数据
       * @param  {Function} callback 返回函数 形式：callback(err)
       */
      upload: function (source, addr, data, callback) {
        var headers = CommonHeaders.get();
        headers['x-access-token'] = localStorage.accessToken;
        var options = {
          fileKey: 'photo',
          httpMethod: 'POST',
          headers: headers,
          mimeType: 'image/jpeg'
        };

        if(source==='discuss') {
          options.params= {randomId: data.randomId};
        }
        else if(source==='photo'|| source === 'logo' || source === 'cover') {
          options.httpMethod = 'PUT';
        }
        if(source === 'logo') {
          options.fileKey = 'logo';//为什么这个这么特别= -
        }
        if(source === 'cover') {
          options.fileKey = 'cover';//为什么这个这么特别= -
        }
        $ionicLoading.show({
          template: '上传中',
          duration: 5000
        });

        $cordovaFile.uploadFile(addr, data.imageURI, options)
        .then(function(result) {
          $ionicLoading.hide();
          callback();
        }, function(err) {//发送失败
          $ionicLoading.hide();
          callback(err);
        });
      }
    }

  }])
  .factory('Circle', ['$http', 'CONFIG', 'Socket', 'INFO', function($http, CONFIG, Socket, INFO) {
    /**
     * 用于临时保存需要上传的图片的URI
     */
    var uploadImages = [];

    return {
      /**
       * 发同事圈文字
       * @param  {String}   campaignId 活动id
       * @param  {String}   content    文字内容
       * @param  {Function} callback   返回函数 形式：callback(err)
       */
      postCircleContent: function(campaignId, content, callback) {
        var fd = new FormData();
        fd.append('campaign_id', campaignId);
        fd.append('content', content);
        var req = {
          method: 'POST',
          url: CONFIG.BASE_URL + '/circle_contents',
          headers: {
            'Content-Type': undefined
          },
          data: fd,
          transformRequest: angular.identity
        }
        $http(req)
          .success(function(data, status) {
            callback(null, data);
          })
          .error(function(data, status) {
            callback(data.msg || 'error');
          });
      },
      /**
       * 获取公司同事圈内容
       * @param  {Date|String}     latestContentDate 最新消息的发布时间(页面显示)
       * @param  {[Date|String]}   lastContentDate   最早消息的发布时间(页面显示)
       * @return {HttpPromise}
       */
      getCompanyCircle: function(latestContentDate, lastContentDate) {
        var url = CONFIG.BASE_URL + '/circle/company';
        if (latestContentDate && lastContentDate) {
          url = url + '?latest_content_date=' + latestContentDate + '&last_content_date=' + lastContentDate;
        } else if (latestContentDate && !lastContentDate) {
          url = url + '?latest_content_date=' + latestContentDate;
        } else if (!latestContentDate && lastContentDate) {
          url = url + '?last_content_date=' + lastContentDate;
        }
        return $http.get(url);
      },

      /**
       * 获取小队的精彩瞬间（同事圈）的内容
       * @param {String} id 用户id
       * @param {Object} query 查询条件
       * @return {HttpPromise}
       */
      getTeamCircle: function(id, query) {
        return $http.get(CONFIG.BASE_URL + '/circle/team/' + id, {
          params: query
        });
      },

      /**
       * 获取个人的精彩瞬间（同事圈）的内容
       * @param {String} id 用户id
       * @param {Object} query 查询条件
       * @return {HttpPromise}
       */
      getUserCircle: function(id, query) {
        return $http.get(CONFIG.BASE_URL + '/circle/user/' + id, {
          params: query
        });
      },
      /**
       * 获取活动的精彩瞬间（同事圈）的内容
       * @param {String} id 活动id
       * @return {HttpPromise}
       */
      getCampaignCircle: function(id) {
        return $http.get(CONFIG.BASE_URL + '/circle/campaign/' + id);
      },
      /**
       * 获取某个同事圈的内容
       * @param {String} 内容id
       * @return {HttpPromise}
       */
      getCircleContent: function(id) {
        return $http.get(CONFIG.BASE_URL + '/circle_contents/' + id);
      },

      /**
       * 删除公司同事圈内容
       * @param  {String}   contentId 同事圈消息id
       * @returns  {HttpPromise}
       */
      deleteCompanyCircle: function(contentId) {
        return $http.delete(CONFIG.BASE_URL + '/circle_contents/' + contentId);
      },

      /**
       * 发布前的准备，创建一个处于等待状态的CircleContent
       * @param {String} campaignId 活动id
       * @param {String} content 文本内容
       * @returns {HttpPromise}
       */
      preCreate: function (campaignId, content) {
        return $http.post(CONFIG.BASE_URL + '/circle_contents', {
          isUploadImgFromFileApi: true,
          uploadStep: 'create',
          campaign_id: campaignId,
          content: content
        });
      },

      /**
       * 文件上传完毕后，激活其对应的CircleContent
       * @param circleContentId
       * @returns {HttpPromise}
       */
      active: function (circleContentId) {
        return $http.post(CONFIG.BASE_URL + '/circle_contents', {
          isUploadImgFromFileApi: true,
          uploadStep: 'active',
          circleContentId: circleContentId
        });
      },

      /**
       * 保存准备上传的图片的URI
       * @param {Array} images uri数组
       */
      setUploadImages: function (images) {
        uploadImages = images;
      },

      /**
       * 获取准备上传的图片的URI
       */
      getUploadImages: function () {
        return uploadImages;
      },

      /**
       * 评论或赞
       * @param {String} id 同事圈内容的id
       * @param {Object} data 请求数据
       * @returns {HttpPromise}
       */
      comment: function (id, data) {
        return $http.post(CONFIG.BASE_URL + '/circle_contents/' + id + '/comments', data);
      },

      /**
       * 删除评论或取消赞
       * @param {String} id 评论或赞的id
       * @return {HttpPromise}
       */
      deleteComment: function(id) {
        return $http.delete(CONFIG.BASE_URL + '/circle_comments/' + id);
      },

      /**
       * 获取新消息提醒
       */
      getRemindComments: function(queryData) {
        return $http.get(CONFIG.BASE_URL + '/circle_reminds/comments', {params: queryData});
      },

      getReminds: function(callback) {
        $http.get(CONFIG.BASE_URL + '/circle_reminds', {
          params: {
            last_read_time: localStorage.lastGetCircleTime || new Date(),
            last_comment_date: localStorage.lastGetCompanyCircleRemindTime || new Date()
          }
        }).success(function(data, status) {
          callback(null, data);
        }).error(function(data, status) {
          callback('err');
        });
      },

      pickAppreciateAndComments: function(circle) {
        circle.appreciate = [];
        circle.textComments = [];
        for (var i = 0, commentsLen = circle.comments.length; i < commentsLen; i++) {
          var comment = circle.comments[i];
          switch (comment.kind) {
            case 'appreciate':
              circle.appreciate.push(comment);
              break;
            case 'comment':
              circle.textComments.push(comment);
              break;
          }
        }
      }

    };

  }])
  .factory('Image', ['INFO', function(INFO) {
    return {
      getFitSize: function(width, height) {
        var size = {
          width: width || INFO.screenWidth,
          height: height || INFO.screenHeight
        };
        if (width > INFO.screenWidth || height > INFO.screenHeight) {
          var result = width * INFO.screenHeight - height * INFO.screenWidth;
          if (result > 0) {
            size.width = INFO.screenWidth;
            size.height = Math.floor(size.width * height / width);
          }
          else {
            size.height = INFO.screenHeight;
            size.width = Math.floor(size.height * width / height);
          }
        }
        return size;
      }
    };
  }])
  .factory('Rank', ['$http', 'CONFIG', function ($http, CONFIG) {
    return {

      /**
       * 获取排行榜
       * @param  {Object}   data     query的数据包括：province，city，gid
       * @param  {Function} callback 回调函数
       */
      getRank: function (data, callback) {
        $http.get( CONFIG.BASE_URL + '/rank', {
          params: {
            province: data.province,
            city: data.city,
            gid: data.gid
          }
        })
        .success(function (data, status, headers, config) {
          callback(null, data);
        })
        .error(function (data, status, headers, config) {
          if (status === 400) {
            callback(data.msg);
          } else {
            callback('error');
          }
        });
      },
      /**
       * 获取小队的排行列表
       * @param  {[type]}   teamId   小队id
       * @param  {Function} callback 回调函数
       */
      getTeamRank: function (teamId, callback) {
        $http.get( CONFIG.BASE_URL + '/rank/team/' + teamId )
        .success(function (data, status, headers, config) {
          callback(null, data);
        })
        .error(function (data, status, headers, config) {
          if (status === 400) {
            callback(data.msg);
          } else {
            callback('error');
          }
        });
      }
    };
  }])
  .factory('CompetitionMessage', ['$http', 'CONFIG', function ($http, CONFIG) {
    return {
      /**
       * 创建挑战信
       * @param  {Object}   data     发送的数据
       * @param  {Function} callback [description]
       * @return {[type]}            [description]
       */
      createCompetitionMessage: function (data, callback) {
        $http.post( CONFIG.BASE_URL + '/competition_messages', {
          sponsor: data.sponsor,
          opposite: data.opposite,
          type: data.type,
          content: data.content
        })
        .success(function (data, status, headers, config) {
          callback(null, data);
        })
        .error(function (data, status, headers, config) {
          callback(data.msg?data.msg:'error');
        });
      },
      /** 
       * 获取挑战信列表
       * @param  {Object}   data     query的数据包括： sponsor， opposite，messageType,page
       * @param  {Function} callback 回调函数
       */
      getCompetitionMessages: function (data, callback) {
        $http.get( CONFIG.BASE_URL + '/competition_messages', {
          params: data
        })
        .success(function (data, status, headers, config) {
          callback(null, data);
        })
        .error(function (data, status, headers, config) {
          if (status === 400) {
            callback(data.msg);
          } else {
            callback('error');
          }
        });
      },
      /**
       * 获取挑战信详情
       * @param  {[type]}   messageId   挑战信id
       * @param  {Function} callback 回调函数
       */
      getCompetitionMessage: function (messageId, callback) {
        $http.get( CONFIG.BASE_URL + '/competition_messages/' + messageId )
        .success(function (data, status, headers, config) {
          callback(null, data);
        })
        .error(function (data, status, headers, config) {
          if (status === 400) {
            callback(data.msg);
          } else {
            callback('error');
          }
        });
      },
      /**
       * 处理挑战
       * @param  {[type]}   messageId   挑战信id
       * @param  {Function} callback 回调函数
       */
      dealCompetition: function (messageId, action, callback) {
        $http.put( CONFIG.BASE_URL + '/competition_messages/' + messageId,{
          action: action
        } )
        .success(function (data, status, headers, config) {
          callback(null, data);
        })
        .error(function (data, status, headers, config) {
          if (status === 400) {
            callback(data.msg);
          } else {
            callback('error');
          }
        });
      }
    };
  }])
  .factory('Vote', ['$http', 'CONFIG', function ($http, CONFIG) {
    return {
      /**
       * 获取投票信息
       * @param  {Object}   data     query的数据包括： sponsor， opposite，messageType
       * @param  {Function} callback 回调函数
       */
      getVote: function (voteId, callback) {
        $http.get( CONFIG.BASE_URL + '/components/Vote/'+voteId )
        .success(function (data, status, headers, config) {
          callback(null, data);
        })
        .error(function (data, status, headers, config) {
          if (status === 400) {
            callback(data.msg);
          } else {
            callback('error');
          }
        });
      },
      /**
       * 获取挑战信详情
       * @param  {[type]}   messageId   挑战信id
       * @param  {Function} callback 回调函数
       */
      vote: function (voteId, tid, callback) {
        $http.post( CONFIG.BASE_URL + '/components/Vote/'+voteId, {
          tid: tid
        })
        .success(function (data, status, headers, config) {
          callback(null, data);
        })
        .error(function (data, status, headers, config) {
          if (status === 400) {
            callback(data.msg);
          } else {
            callback('error');
          }
        });
      },
      cancelVote: function (voteId, tid, callback) {
        $http.delete( CONFIG.BASE_URL + '/components/Vote/'+voteId, {
          data: {
            tid: tid
          }
        })
        .success(function (data, status, headers, config) {
          callback(null, data);
        })
        .error(function (data, status, headers, config) {
          if (status === 400) {
            callback(data.msg);
          } else {
            callback('error');
          }
        });
      }
    };
  }])
  .factory('Emoji', function() {

    return {

      getEmojiList: function() {
        return ["laugh", "smile", "happy", "snag", "snaky", "heart_eyes", "kiss", "blush", "howl", "angry",
        "blink", "tongue", "tired", "logy", "asquint", "embarassed", "cry", "laugh_cry", "sigh", "sweat",
        "good", "yeah", "pray", "finger", "clap", "muscle", "bro", "ladybro", "flash", "sun",
        "cat", "dog", "hog_nose", "horse", "plumpkin", "ghost", "present", "trollface", "diamond", "mahjong",
        "hamburger", "fries", "ramen", "bread", "lollipop", "cherry", "cake", "icecream"];
      },

      getEmojiDict: function() {
        return {"laugh":"大笑","smile":"微笑","happy":"高兴","snag":"龇牙","snaky":"阴险","heart_eyes":"心心眼","kiss":"啵一个","blush":"脸红","howl":"鬼嚎","angry":"怒",
        "blink":"眨眼","tongue":"吐舌","tired":"困","logy":"呆","asquint":"斜眼","embarassed":"尴尬","cry":"面条泪","laugh_cry":"笑cry","sigh":"叹气","sweat":"汗",
        "good":"棒","yeah":"耶","pray":"祈祷","finger":"楼上","clap":"鼓掌","muscle":"肌肉","bro":"基友","ladybro":"闺蜜","flash":"闪电","sun":"太阳",
        "cat":"猫咪","dog":"狗狗","hog_nose":"猪鼻","horse":"马","plumpkin":"南瓜","ghost":"鬼","present":"礼物","trollface":"贱笑","diamond":"钻石","mahjong":"红中",
        "hamburger":"汉堡","fries":"薯条","ramen":"拉面","bread":"面包","lollipop":"棒棒糖","cherry":"樱桃","cake":"蛋糕","icecream":"冰激凌"};
      }

    };
  })
  .factory('ScoreBoard', ['$http', 'CONFIG', function ($http, CONFIG) {
    return {
      /**
       * 设置比分
       * @param {String}   componetId 比分板ID
       * @param {Obeject}   postData   {
          "data": {
            "scores": [
              0,0
            ],
            "results": [
              0,0
            ]
          },
          "isInit": true
        }
       * @param {Function} callback   [description]
       */
      setScore: function (componetId, postData, callback) {
        $http.post( CONFIG.BASE_URL + '/components/ScoreBoard/'+componetId,postData )
        .success(function (data, status, headers, config) {
          callback(null, data);
        })
        .error(function (data, status, headers, config) {
          if (status === 400) {
            callback(data.msg);
          } else {
            callback(data.msg?data.msg:'错误');
          }
        });
      },
      /**
       * 确认比分
       * @param  {String}   componetId 比分板ID
       * @param  {Function} callback   [description]
       */
      confirmScore: function (componetId, callback) {
        $http.put( CONFIG.BASE_URL + '/components/ScoreBoard/'+componetId)
        .success(function (data, status, headers, config) {
          callback(null, data);
        })
        .error(function (data, status, headers, config) {
          if (status === 400) {
            callback(data.msg);
          } else {
            callback(data.msg?data.msg:'错误');
          }
        });
      },
      /**
       * 获取比分板信息
       * @param  {String}   componetId 比分板ID
       * @param  {Function} callback   [description]
       */
      getScore: function (componetId, callback) {
        $http.get( CONFIG.BASE_URL + '/components/ScoreBoard/'+componetId)
        .success(function (data, status, headers, config) {
          callback(null, data);
        })
        .error(function (data, status, headers, config) {
          if (status === 400) {
            callback(data.msg);
          } else {
            callback(data.msg?data.msg:'错误');
          }
        });
      },
      /**
       * 获取比分设置记录
       * @param  {String}   componetId 比分板ID
       * @param  {Function} callback   [description]
       * @return {[type]}              [description]
       */
      getLogs: function (componetId, callback) {
        $http.get( CONFIG.BASE_URL + '/components/ScoreBoard/logs/'+componetId)
        .success(function (data, status, headers, config) {
          callback(null, data);
        })
        .error(function (data, status, headers, config) {
          if (status === 400) {
            callback(data.msg);
          } else {
            callback(data.msg?data.msg:'错误');
          }
        });
      }
    };
  }])
  .factory('Region', ['$http', 'CONFIG', function ($http, CONFIG) {
    return {
      getRegion: function (callback) {
        $http.get( CONFIG.BASE_URL + '/region')
        .success(function (data, status, headers, config) {
          callback(null, data);
        })
        .error(function (data, status, headers, config) {
        });
      },
      getCurrentRegion: function(callback) {
        $http.jsonp('http://api.map.baidu.com/location/ip?ak=krPnXlL3wNORRa1KYN1RAx3c&callback=JSON_CALLBACK')
        .success(function(data, status) {
          callback(null, data);
        })
        .error(function(data, status) {

        });
      }
    };
  }])
 