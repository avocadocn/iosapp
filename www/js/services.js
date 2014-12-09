/**
 * Created by Sandeep on 11/09/14.
 */
angular.module('donlerApp.services', []).factory('Todo', ['$http', 'PARSE_CREDENTIALS', function ($http, PARSE_CREDENTIALS) {
  return {
    getAll: function () {
      return $http.get('https://api.parse.com/1/classes/Todo', {
        headers: {
          'X-Parse-Application-Id': PARSE_CREDENTIALS.APP_ID,
          'X-Parse-REST-API-Key': PARSE_CREDENTIALS.REST_API_KEY,
        }
      });
    },
    get: function (id) {
      return $http.get('https://api.parse.com/1/classes/Todo/' + id, {
        headers: {
          'X-Parse-Application-Id': PARSE_CREDENTIALS.APP_ID,
          'X-Parse-REST-API-Key': PARSE_CREDENTIALS.REST_API_KEY,
        }
      });
    },
    create: function (data) {
      return $http.post('https://api.parse.com/1/classes/Todo', data, {
        headers: {
          'X-Parse-Application-Id': PARSE_CREDENTIALS.APP_ID,
          'X-Parse-REST-API-Key': PARSE_CREDENTIALS.REST_API_KEY,
          'Content-Type': 'application/json'
        }
      });
    },
    edit: function (id, data) {
      return $http.put('https://api.parse.com/1/classes/Todo/' + id, data, {
        headers: {
          'X-Parse-Application-Id': PARSE_CREDENTIALS.APP_ID,
          'X-Parse-REST-API-Key': PARSE_CREDENTIALS.REST_API_KEY,
          'Content-Type': 'application/json'
        }
      });
    },
    delete: function (id) {
      return $http.delete('https://api.parse.com/1/classes/Todo/' + id, {
        headers: {
          'X-Parse-Application-Id': PARSE_CREDENTIALS.APP_ID,
          'X-Parse-REST-API-Key': PARSE_CREDENTIALS.REST_API_KEY,
          'Content-Type': 'application/json'
        }
      });
    }
  }
}])
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
.constant('CONFIG', {
  BASE_URL: 'http://localhost:3002'
})
.factory('Campaign',['$http','CONFIG',function($http,CONFIG){
    return {
        getAll:function(type, id){
            return $http.get(CONFIG.BASE_URL + '/campaigns?requestType=' + type + '&requestId=' + id);
        },
        get:function(id){
            return $http.get(CONFIG.BASE_URL + '/campaigns' + id);
        },
        create:function(data){
            return $http.post(CONFIG.BASE_URL + '/campaigns', data);
        },
        edit:function(id,data){
            return $http.put(BASE_URL+'/campaigns/'+ id, data);
        },
        delete:function(id){
            return $http.delete(CONFIG.BASE_URL + '/campaigns/' + id);
        }
    }
}])
.value('PARSE_CREDENTIALS',{
    APP_ID: '9ehAv41QUFB3K069qrDGc03dVb4BO7qhAvD0bSkV',
    REST_API_KEY: 'rwlHrJzYR9gR2grTcUlCCKK8mqYn1Ao1wySTqhvO'
  })
