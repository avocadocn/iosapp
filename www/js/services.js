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
    STATIC_URL: 'http://localhost:3000',
    SOCKET_URL: 'http://localhost:3005'
  })
  .value('INFO', {
    memberContent:'',
    sponsorBackUrl:'',
    reportBackUrl:'',
    discussName:'',
    lastDate:'',
    companyId:'',
    companyName:'',
    screenWidth: 320,
    screenHeight: 568
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
  .factory('UserAuth', ['$http', 'CONFIG', 'Socket', function ($http, CONFIG, Socket) {
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
            localStorage.cid = data.cid;
            $http.defaults.headers.common['x-access-token'] = data.token;
            Socket.login();
            callback();
          })
          .error(function (data, status) {
            callback(data.msg);
          });
      },

      logout: function (callback) {
        Socket.logout();
        $http.post(CONFIG.BASE_URL + '/users/logout')
          .success(function (data, status) {
            localStorage.removeItem('accessToken');
            localStorage.removeItem('userType');
            localStorage.removeItem('id');
            localStorage.removeItem('cid');
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
  .factory('UserSignup', ['$http', 'CONFIG', function ($http, CONFIG) {
    return{
      validate: function (email, cid, inviteKey, callback) {
        $http.post(CONFIG.BASE_URL + '/users/validate', {email:email, cid:cid, inviteKey:inviteKey})
        .success(function (data, status) {
          callback(null,data);
        }).error(function (data, status) {
          callback(data.msg);
        });
      },
      searchCompany: function (name, callback) {
        $http.post(CONFIG.BASE_URL + '/search/companies', {'name':name})
        .success(function (data, status) {
          callback(null,data);
        }).error(function (data, status) {
          callback(data.msg);
        });
      },
      signup: function(data, callback) {
        $http.post(CONFIG.BASE_URL + '/users', data)
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
          callback(data.msg || '网络连接错误');
        });
      },
      get: function (id, callback) {
        $http.get(CONFIG.BASE_URL + '/campaigns/' + id+'?populate=photo_album')
        .success(function (data, status) {
          callback(null,data);
        })
        .error(function (data, status) {
          // todo
          callback(data.msg|| '网络连接错误');
        });
      },
      create: function (data, callback) {
        $http.post(CONFIG.BASE_URL + '/campaigns', data)
        .success(function (data, status) {
          callback(null,data);
        })
        .error(function (data, status) {
          // todo
          callback(data.msg);
        });
      },
      edit: function (id, campaignData, callback) {
        $http.put(CONFIG.BASE_URL + '/campaigns/' + id, campaignData)
        .success(function (data, status) {
          callback(null,data);
        })
        .error(function (data, status) {
          // todo
          callback(data.msg|| '网络连接错误');
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
          callback(data.msg|| '网络连接错误');
        });
      },
      quit: function(id, uid, callback) {
        $http.delete(CONFIG.BASE_URL + '/campaigns/' + id+'/users/'+uid)
        .success(function (data, status) {
          callback(null,data);
        })
        .error(function (data, status) {
          // todo
          callback(data.msg|| '网络连接错误');
        });
      },
      dealProvoke: function(id, dealType, callback) {
        $http.put(CONFIG.BASE_URL + '/campaigns/' + id+'/dealProvoke',{dealType:dealType})
        .success(function (data, status) {
          callback(null,data);
        })
        .error(function (data, status) {
          // todo
          callback(data.msg|| '网络连接错误');
        });
      },
      getMolds: function(hostType, hostId, callback) {
        $http.get(CONFIG.BASE_URL + '/campaigns/mold/' + hostType +'/'+ hostId)
        .success(function (data, status) {
          callback(null,data);
        })
        .error(function (data, status) {
          // todo
          callback(data.msg|| '网络连接错误');
        });
      }
    }
  }])

  .factory('Socket', ['$rootScope','CONFIG', function socket($rootScope, CONFIG) {
    var token = localStorage.accessToken;
    var socket ; 
    if(token){
      socket = io.connect(CONFIG.SOCKET_URL,{query:'token=' + token});
    }
    return {
      login: function() {
        token = localStorage.accessToken;
        socket = io.connect(CONFIG.SOCKET_URL,{query:'token=' + token});
      },
      logout: function() {
        socket.disconnect();
        socket = null;
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
      publishComment: function(campaignId, content, randomId, callback) {
        $http.post(CONFIG.BASE_URL +'/comments/host_type/campaign/host_id/'+campaignId,{
          'content':content,
          'randomId':randomId
        })
        .success(function (data, status) {
          callback();
        }).error(function (data, status) {
          // todo
          callback('publish error');
        });
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
        if (typeof d1 === 'string') {
          d1 = new Date(d1);
        }
        if (typeof d2 === 'string') {
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
      }


    };
  }])
  .factory('User', ['$http', 'CONFIG', function ($http, CONFIG) {
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
      getList: function (hostType, hostId, callback, gid, leadFlag) {
        var requestUrl = CONFIG.BASE_URL + '/teams?hostType=' + hostType;
        if(hostId){
          requestUrl += '&hostId=' + hostId;
        }
        if(gid) {
          requestUrl += '&gid=' + gid;
        }
        if(leadFlag) {
          requestUrl += '&leadFlag=' + leadFlag;
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
        //todo
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
              target: target
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
        }
      }
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





