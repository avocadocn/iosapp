var exec = require('cordova/exec');

/**
 * Constructor
 */
function SaveToPhotoAlbum() {}


SaveToPhotoAlbum.prototype.saveToPhotoAlbum = function(successCallback, failCallback, uri) {
    console.log('SaveToPhotoAlbum.js: saveToPhotoAlbum: uri:' + uri);
    if (!uri) {
    	if (typeof failCallback === 'function') {
    		failCallback('uri not provided');
    	}
    	return;
    }
	exec(
        successCallback,
        failCallback,
        "SaveToPhotoAlbum",
        "saveToPhotoAlbum",
        [uri]
    );
};

/**
 * Install function
 */
SaveToPhotoAlbum.install = function() {
	if ( !window.plugins ) {
		window.plugins = {};
	} 
	if ( !window.plugins.SaveToPhotoAlbum ) {
		window.plugins.SaveToPhotoAlbum = new SaveToPhotoAlbum();
	}
};

module.exports = new SaveToPhotoAlbum();
