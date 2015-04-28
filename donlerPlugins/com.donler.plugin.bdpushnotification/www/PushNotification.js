var argscheck = require('cordova/argscheck'),
  exec = require('cordova/exec'),
  cordova = require('cordova'),
	channel = require('cordova/channel');

var bdPushNotification = function() {
	this.registered = false;
	//
	// this.appId = null;
	// this.channelId = null;
	// this.clientId = null;

	// var me = this;

	// me.getInfo(function(info) {
	// 	me.appId = info.appId;
	// 	me.channelId = info.channelId;
	// 	me.clientId = info.clientId;
	// });

	//alert("me >>>> " + JSON.stringify(me));
};

bdPushNotification.prototype.customSuccess = {};
bdPushNotification.prototype.customFail = {};

bdPushNotification.prototype.init = function(api_key) {
	// alert(api_key);
	// customSuccess = success;
	// customFail = fail;
	exec(bdPushNotification.successFn, bdPushNotification.failureFn, 'bdPushNotification', 'init', [api_key]);
};

// bdPushNotification.prototype.register = function(options, successCallback, errorCallback) {

// 	//alert("options" + JSON.stringify(options));

// 	// customSuccess = success;
// 	// customFail = fail;
// 	// exec(bdPushNotification.successFn, bdPushNotification.failureFn, 'bdPushNotification', 'init', [api_key]);

// 	//alert("PushNotification.prototype.register");
// 	alert("opt  >>>> " + JSON.stringify(options));

// 	if (errorCallback == null) {
// 		errorCallback = function() {
// 		}
// 	}

// 	if ( typeof errorCallback != "function") {
// 		console.log("PushNotification.register failure: failure parameter not a function");
// 		return
// 	}

// 	if ( typeof successCallback != "function") {
// 		console.log("PushNotification.register failure: success callback parameter must be a function");
// 		return
// 	}

// 	cordova.exec(successCallback, errorCallback, "PushPlugin", "register", [options]);

// };

bdPushNotification.prototype.successFn = function(info) {
	// alert(JSON.stringify(info));
	if (info) {
		// customSuccess(info);
		bdPushNotification.registered = true;
		cordova.fireDocumentEvent("cloudPushRegistered", info);
	}
};

bdPushNotification.prototype.failureFn = function(info) {
  // alert(JSON.stringify(info));
	bdPushNotification.registered = false;
};

bdPushNotification.prototype.onNotificationClicked = function(pushMessage) {
};
var bdPushNotification = new bdPushNotification();

channel.onCordovaReady.subscribe( function () {
    // The cordova device plugin is ready now
    channel.onCordovaInfoReady.subscribe( function () {
        if (device.platform == 'Android') {
            channel.onPause.subscribe( function () {
                // Necessary to set the state to `background`
                cordova.exec(null, null, 'bdPushNotification', 'pause', []);
            });

            channel.onResume.subscribe( function () {
                // Necessary to set the state to `foreground`
                cordova.exec(null, null, 'bdPushNotification', 'resume', []);
            });

            // Necessary to set the state to `foreground`
            cordova.exec(null, null, 'bdPushNotification', 'resume', []);
        }
    });
});
module.exports = bdPushNotification;
    