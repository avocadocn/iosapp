/**
 * Created by Sandeep on 11/09/14.
 */
angular.module('donlerApp.services', [])
  .constant('CONFIG', {
    BASE_URL: 'http://localhost:3002'
  })
  .factory('UserAuth', ['$http', 'CONFIG', function ($http, CONFIG) {
    return {
      login: function (email, password, callback) {
        $http.post(CONFIG.BASE_URL + '/users/login', {
          email: email,
          password: password
        })
          .success(function (data, status) {
            // todo save token
            callback();
          })
          .error(function (data, status) {
            callback(data.msg);
          });
      }
    };
  }])

  .factory('Campaign', ['$http', 'CONFIG', function ($http, CONFIG) {
    return {
      getAll: function (type, id) {
        return $http.get(CONFIG.BASE_URL + '/campaigns?requestType=' + type + '&requestId=' + id);
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
