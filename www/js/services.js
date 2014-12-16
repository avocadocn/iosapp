/**
 * Created by Sandeep on 11/09/14.
 */
angular.module('donlerApp.services', [])
  .constant('CONFIG', {
    BASE_URL: 'http://localhost:3002',
    SOCKET_URL: 'http://localhost:3005'
  })
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
            // todo
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
  .factory('Campaign', ['$http', 'CONFIG', function ($http, CONFIG) {
    return {
      getAll:function(type, id,callback){
        $http.get(CONFIG.BASE_URL + '/campaigns?select_type=0&populate=photo_album&requestType=' + type + '&requestId=' + id)
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
  .factory('Tools', [ function (myArray, searchTerm, property) {
    return{
      arrayObjectIndexOf: function () {
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
          })
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
      },

      /**
       * 获取某个小队的数据
       * @param {String} tid 小队id
       * @param {Function} callback 形式为function(err, team)
       */
      getData: function (tid, callback) {
        $http.get(CONFIG.BASE_URL + '/teams/' + tid)
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
      }

    };
  }])
  .factory('TimeLine', ['$http', 'CONFIG', function ($http, CONFIG) {
    return {

      /**
       * 获取活动的公告列表
       * @param {String} hostId campaignd
       * @param {Function} callback 形式为function(err, teams)
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
      getTimelineData: function (hostType, hostId, callback) {
        $http.get( CONFIG.BASE_URL + '/timeline/record/' + hostType + '/'+ hostId)
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


