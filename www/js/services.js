/**
 * Created by Sandeep on 11/09/14.
 */
angular.module('donlerApp.services', [])
  .config(['$httpProvider', function ($httpProvider) {
    var interceptor = ['$q', function ($q) {
      var success = function (response) {
        return response;
      };
      var error = function (response) {
        var status = response.status;
        var isLogin = false;
        if (response.config.url.indexOf('/users/login') !== -1
        || response.config.url.indexOf('/companies/login') !== -1) {
          isLogin = true;
        }
        if (status === 401 && !isLogin) {
          var userType = localStorage.userType;
          if (userType === 'company') {
            window.location.href = '#/company/login';
          } else {
            window.location.href = '#/user/login';
          }
          localStorage.removeItem('accessToken');
          localStorage.removeItem('userType');
          localStorage.removeItem('id');
          return response;
        }
        // otherwise
        return $q.reject(response);
      };
      return function (promise) {
        return promise.then(success, error);
      }
    }];
    $httpProvider.responseInterceptors.push(interceptor);
  }])
  .constant('CONFIG', {
    BASE_URL: 'http://localhost:3002',
    SOCKET_URL: 'http://localhost:3005'
  })
  .value('INFO', {
    campaignBackUrl:'#/app/campaigns',
    teamBackUrl:'#/app/personal_teams',
    photoAlbumBackUrl:'',
    memberBackURL:'',
    memberContent:'',
    discussName:'',
    lastDate:''
  })
  .factory('CommonHeaders', ['$http', function ($http) {

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
        if (!headers) {
          $http.defaults.headers.common['x-app-id'] = 'id1a2b3c4d5e6f';
          $http.defaults.headers.common['x-api-key'] = 'key1a2b3c4d5e6f';
          $http.defaults.headers.common['x-device-id'] = 'did1a2b3c4d5e6f';
          $http.defaults.headers.common['x-device-type'] = 'iphone 6';
          $http.defaults.headers.common['x-platform'] = 'ios';
          $http.defaults.headers.common['x-version'] = '8.0';
        } else {
          for (var key in headers) {
            $http.defaults.headers.common[key] = headers[key];
          }
        }
      }

    };

  }])
  .factory('UserAuth', ['$http', 'CONFIG', function ($http, CONFIG) {
    return {
      login: function (email, password, callback) {
        $http.post(CONFIG.BASE_URL + '/users/login', {
          email: email,
          password: password
        })
          .success(function (data, status) {
            localStorage.accessToken = data.token;
            localStorage.userType = 'user';
            localStorage.id = data.id;
            $http.defaults.headers.common['x-access-token'] = data.token;
            callback();
          })
          .error(function (data, status) {
            // todo
            callback(data.msg);
          });
      },

      logout: function (callback) {
        $http.post(CONFIG.BASE_URL + '/users/logout')
          .success(function (data, status) {
            localStorage.removeItem('accessToken');
            localStorage.removeItem('userType');
            localStorage.removeItem('id');
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
            callback();
          })
          .error(function (data, status) {
            // todo
            callback(data.msg);
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
          if(email)
            data = {email: email};
          else
            data = {name: name};
          $http.post(CONFIG.BASE_URL + '/companies/validate',data)
          .success(function (data, status) {
            if(data.validate)
              callback();
            else
              callback(data.msg);
          }).error(function (data, status) {
            callback(data.msg);
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
      }
    }
  }])
  .factory('Campaign', ['$http', 'CONFIG', function ($http, CONFIG) {
    return {
      /**
       * 获取所有活动
       * @param {Object} params 请求参数，参见api /campaigns说明
       * @param {Function} callback
       */
      getList:function(params, callback){
        $http.get(CONFIG.BASE_URL + '/campaigns', {
          params: params
        })
        .success(function (data, status) {
          callback(null,data);
        })
        .error(function (data, status) {
          // todo
          callback('error');
        });
      },
      get: function (id, callback) {
        $http.get(CONFIG.BASE_URL + '/campaigns/' + id+'?populate=photo_album')
        .success(function (data, status) {
          callback(null,data);
        })
        .error(function (data, status) {
          // todo
          callback('error');
        });
      },
      create: function (data, callback) {
        $http.post(CONFIG.BASE_URL + '/campaigns', data)
        .success(function (data, status) {
          callback(null,data);
        })
        .error(function (data, status) {
          // todo
          callback('error');
        });
      },
      edit: function (id, campaignData, callback) {
        $http.put(CONFIG.BASE_URL + '/campaigns/' + id, campaignData)
        .success(function (data, status) {
          callback(null,data);
        })
        .error(function (data, status) {
          // todo
          callback('error');
        });
      },
      close: function (id, callback) {
        $http.delete(CONFIG.BASE_URL + '/campaigns/' + id)
        .success(function (data, status) {
          callback(null,data);
        })
        .error(function (data, status) {
          // todo
          callback('error');
        });
      },
      join: function(id, uid, callback) {
        $http.post(CONFIG.BASE_URL + '/campaigns/' + id+'/users/'+uid)
        .success(function (data, status) {
          callback(null,data);
        })
        .error(function (data, status) {
          // todo
          callback('error');
        });
      },
      quit: function(id, uid, callback) {
        $http.delete(CONFIG.BASE_URL + '/campaigns/' + id+'/users/'+uid)
        .success(function (data, status) {
          callback(null,data);
        })
        .error(function (data, status) {
          // todo
          callback('error');
        });
      },
      dealProvoke: function(id, dealType, callback) {
        $http.put(CONFIG.BASE_URL + '/campaigns/' + id+'/dealProvoke',{dealType:dealType})
        .success(function (data, status) {
          callback(null,data);
        })
        .error(function (data, status) {
          // todo
          callback(data.msg);
        });
      }
    }
  }])

  .factory('Socket', ['$rootScope','CONFIG', function socket($rootScope, CONFIG) {
    var token =  localStorage.accessToken;
    var socket = io.connect(CONFIG.SOCKET_URL,{query:'token=' + token});
    socket.emit('login');
    return {
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
      getList: function (type) {
        return $http.get(CONFIG.BASE_URL + '/comments/list/?type=' + type);
      },
      getComments: function(campaignId, limit, createDate) {
        var url = CONFIG.BASE_URL + '/comments/?requestType=campaign&requestId='+campaignId;
        if (limit) {
          url+='&limit=' + limit;
        }
        if (createDate) {
          url+='&createDate=' + createDate;
        }
        return $http.get(url);
      },
      publishComment: function(campaignId, content, photo, callback) {
        $http.post(CONFIG.BASE_URL +'/comments/host_type/campaign/host_id/'+campaignId,{content:content})
        .success(function (data, status) {
          callback();
        }).error(function (data, status) {
          // todo
          callback('publish error');
        });
      }
    }
  }])
  .factory('Tools', [ function () {
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
      }
    }
  }])
  .factory('User', ['$http', 'CONFIG', function ($http, CONFIG) {

    return {

      /**
       * 获取用户数据
       * @param {String} id 用户id
       * @param {Function} callback 获取后的回调函数，形式为function(err, data)
       */
      getData: function (id, callback) {
        $http.get(CONFIG.BASE_URL + '/users/' + id)
          .success(function (data, status, headers, config) {
            callback(null, data);
          })
          .error(function (data, status, headers, config) {
            callback('error');
          });
      }

    };

  }])
  .factory('Team', ['$http', 'CONFIG', function ($http, CONFIG) {

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
       */
      getList: function (hostType, hostId, callback) {
        var requestUrl = CONFIG.BASE_URL + '/teams?hostType=' + hostType;
        if(hostId){
          requestUrl += '&hostId=' + hostId;
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

      /**
       * 获取某个小队的数据
       * @param {String} tid 小队id
       * @param {Function} callback 形式为function(err, team)
       */
      getData: function (tid, callback) {
        $http.get(CONFIG.BASE_URL + '/teams/' + tid)
          .success(function (data, status, headers, config) {
            currentTeam = data;
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
          })
          .error(function (data, status, headers, config) {
            if (status === 400) {
              callback(data.msg);
            } else {
              callback('error');
            }
          });
      },
      quitTeam: function(tid, uid, callback) {
        $http.delete(CONFIG.BASE_URL + '/teams/' + tid +'/users/'+ uid)
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
  .factory('Message', ['$http', 'CONFIG', function ($http, CONFIG) {
    return {

      /**
       * 获取活动的公告列表
       * @param {String} hostId campaignd
       * @param {Function} callback 形式为function(err, teams)
       */
      getCampaignMessages: function (hostId, callback) {
        var requestUrl = CONFIG.BASE_URL + '/messages?requestType=campaign&requestId=' + hostId;
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
          })
      }

    };
  }])
  .factory('PhotoAlbum', ['$http', 'CONFIG', function ($http, CONFIG) {
    return {

      /**
       * 获取某个小队的相册列表
       * @param {String} tid 小队id
       * @param {Function} callback 形式为function(err, photoAlbums)
       */
      getList: function (tid, callback) {
        $http.get(CONFIG.BASE_URL + '/photo_albums?ownerType=team&ownerId=' + tid)
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
      }
    };
  }])


