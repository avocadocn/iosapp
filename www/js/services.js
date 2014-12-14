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
      getAll:function(type, id){
        return $http.get(CONFIG.BASE_URL + '/campaigns?select_type=0&populate=photo_album&requestType=' + type + '&requestId=' + id);
      },
      get: function (id) {
        return $http.get(CONFIG.BASE_URL + '/campaigns' + id);
      },
      create: function (data) {
        return $http.post(CONFIG.BASE_URL + '/campaigns', data);
      },
      edit: function (id, data) {
        return $http.put(BASE_URL + '/campaigns/' + id, data);
      },
      delete: function (id) {
        return $http.delete(CONFIG.BASE_URL + '/campaigns/' + id);
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
