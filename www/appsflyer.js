if(!window.CustomEvent) {
	window.CustomEvent = function(type, config) {
		var e = document.createEvent("CustomEvent");
		e.initCustomEvent(type, true, true, config.detail);
		return e;
	}
}
(function (global, platform) {
	/** @constructor */
	var PromiseDecorator = function(appsFlyer) {
		this.appsFlyer = appsFlyer;
		this.dataLoadedPromise = null;
	};

	/**
	 * @private
	 * @param {Function} resolve
	 */
	var subscribeOnInstallDataLoaded_ = function (resolve) {
		document.addEventListener("onInstallConversionDataLoaded", function (data) {
			resolve(data);
		}, false);
	};

	var installData_ = null, deviceId_ = null;

	PromiseDecorator.prototype.init = function (args) {
		this.initSdk = new Promise(function (resolve, reject) {
			document.addEventListener("deviceready", function () {
				this.appsFlyer.initSdk(args);
				resolve();
			}.bind(this), false);
		}.bind(this));
		this.dataLoadedPromise = new Promise(function (resolve, reject) {
			try {
				subscribeOnInstallDataLoaded_(resolve);
			} catch (e) {
				reject(null);
			}
		});
		this.deviceIdPromise = new Promise(function (resolve, reject) {
			try {
				this.whenSDKInited().then(function () {
					this.appsFlyer.getAppsFlyerUID(function (deviceId) {
						resolve(deviceId);
					});
				}.bind(this)).catch(function () {
					reject(null);
				});
			} catch (e) {
				reject(null);
			}
		}.bind(this));

		this.whenInstallDataLoaded().then(function (data) {
			installData_ = data;
		});
		this.whenDeviceIdReady().then(function (deviceId) {
			deviceId_ = deviceId;
		});

		return this;
	};

	PromiseDecorator.prototype.whenInstallDataLoaded = function () {
		return this.dataLoadedPromise;
	};

	PromiseDecorator.prototype.whenDeviceIdReady = function () {
		return this.deviceIdPromise;
	};

	PromiseDecorator.prototype.whenSDKInited = function () {
		return this.initSdk;
	};

	PromiseDecorator.prototype.getInstallConversionData = function () {
		return installData_;
	};

	PromiseDecorator.prototype.getDeviceId = function () {
		return deviceId_;
	};


	/** @constructor */
	var AppsFlyer = function () {
	};

	AppsFlyer.prototype.initSdk = function (args) {
    	platform.exec(null, null, "AppsFlyerPlugin", "initSdk", args);
	};
	
	AppsFlyer.prototype.setCurrencyCode = function (currencyId) {
    	platform.exec(null, null, "AppsFlyerPlugin", "setCurrencyCode", [currencyId]);
	};
	
	AppsFlyer.prototype.setAppUserId = function (customerUserId) {
    	platform.exec(null, null, "AppsFlyerPlugin", "setAppUserId", [customerUserId]);
	};

	AppsFlyer.prototype.getAppsFlyerUID = function (callbackFn) {
        platform.exec(function(result){
            callbackFn(result);
        }, null,
           "AppsFlyerPlugin",
           "getAppsFlyerUID",
        []);
	};
	
	AppsFlyer.prototype.trackEvent = function(eventName, eventValue) {
    	platform.exec(null, null, "AppsFlyerPlugin", "trackEvent", [eventName,eventValue]);
	};

	AppsFlyer.prototype.onInstallConversionDataLoaded = function(conversionData) {
        var data = conversionData,
            event;
        if (typeof data === "string") {
            data = JSON.parse(conversionData);
        }
		event = new CustomEvent('onInstallConversionDataLoaded', {'detail': data});
		global.document.dispatchEvent(event);
	};

	AppsFlyer.prototype.usePromises = function () {
		return new PromiseDecorator(this);
	};

	platform.addConstructor(function() {
		if (!global.Cordova) {
			global.Cordova = platform;
		}

		if (!global.plugins) {
			global.plugins = {};
		}

		global.plugins.appsFlyer = new AppsFlyer();
	});
}(window, window.cordova));

