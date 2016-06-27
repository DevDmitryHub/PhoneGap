
# PhoneGap AppsFlyer plugin for Android and iOS. 

Built against Phonegap >= 3.3.x.
## PhoneGap Build ##
Add the following line to your config xml:
```
<gap:plugin name="com.appsflyer.phonegap.plugins.appsflyer" version="1.0.1" />
```
Add following lines to your code to be able to initialize tracking with your own AppsFlyer dev key:
```javascript
document.addEventListener("deviceready", function(){
    var args = [];
    var devKey = "xxXXXXXxXxXXXXxXXxxxx8";   // your AppsFlyer devKey
    args.push(devKey);
    var userAgent = window.navigator.userAgent.toLowerCase();
                          
    if (/iphone|ipad|ipod/.test( userAgent )) {
        var appId = "123456789";            // your ios app id in app store
        args.push(appId);
    }
	window.plugins.appsFlyer.initSdk(args);
}, false);
```

## Installation using CLI:
```
$ cordova plugin add https://github.com/AppsFlyerSDK/PhoneGap.git
```
Then reference `appsflyer.js` in `index.html`, after `cordova.js`/`phonegap.js`. Mind the path:
```html
<script type="text/javascript" src="js/plugins/appsflyer.js"></script>
```
## Manual installation:
1\. Add the following xml to your `config.xml` in the root directory of your `www` folder:
```xml
<!-- for iOS -->
<feature name="AppsFlyerPlugin">
  <param name="ios-package" value="AppsFlyerPlugin" />
</feature>
```
```xml
<!-- for Android -->
<feature name="AppsFlyerPlugin">
  <param name="android-package" value="com.appsflyer.cordova.plugin.AppsFlyerPlugin" />
</feature>
```
2\. For Android, add the following xml to your `AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.READ_PHONE_STATE" />
```
3\. Copy appsflyer.js to `www/js/plugins` and reference it in `index.html`:
```html
<script type="text/javascript" src="js/plugins/appsflyer.js"></script>
```
4\. Download the source files and copy them to your project.

iOS: Copy `AppsFlyerPlugin.h`, `AppsFlyerPlugin.m`, `AppsFlyerTracker.h` and `libAppsFlyerLib.a` to `platforms/ios/<ProjectName>/Plugins`

Android: Copy `AppsFlyerPlugin.java` to `platforms/android/src/com/appsflyer/cordova/plugins` (create the folders)
        
## Usage:

#### 1\. Set your App_ID (iOS only), Dev_Key and enable AppsFlyer to detect installations, sessions (app opens), and updates.  
**Note: ** *This is the minimum requirement to start tracking your app installs and it's already implemented in this plugin. You **_MUST_** modify this call and provide:  *
- *devKey* - Your application devKey provided by AppsFlyer.
- *appId*  - **For iOS only.** Your iTunes application id.
```javascript
document.addEventListener("deviceready", function(){
    var args = [];
    var devKey = "xxXXXXXxXxXXXXxXXxxxx8";   // your AppsFlyer devKey
    args.push(devKey);
    var userAgent = window.navigator.userAgent.toLowerCase();
                          
    if (/iphone|ipad|ipod/.test( userAgent )) {
        var appId = "123456789";            // your ios app id in app store
        args.push(appId);
    }
	window.plugins.appsFlyer.initSdk(args);
}, false);
```

#### 2\. Set currency code (optional)
```javascript
//USD is default value. Acceptable ISO(http://www.xe.com/iso4217.php) Currency codes here. Examples:  
//British Pound: window.plugins.appsFlyer.setCurrencyCode("GBP");  
window.plugins.appsFlyer.setCurrencyCode("USD");
```
#### 3\. Set customer user ID (Advance)
*Setting your own custom ID will enable you to cross-reference your own unique ID with AppsFlyer’s user ID and the 
other devices’ IDs. This ID will be available at AppsFlyer CSV reports along with postbacks APIs for cross-referencing 
with you internal IDs.*  
**Note:** *The ID must be set during the first launch of the app at the SDK initialization. The best practice is to call to this API during `deviceready` event if possible.*
```javascript
window.plugins.appsFlyer.setAppUserId(userId);
```
#### 4\. In App Events Tracking API (optional)
*These events help you track how loyal users discover your app and attribute them to specific campaign/source.*
- *These in-app events help you track how loyal users discover your app, and attribute them to specific 
campaigns/media-sources. Please take the time define the event/s you would like to measure to allow you 
to track ROI (Return on Investment) and LTV (Lifetime Value).*
- *The “trackEvent” method allows you to send in-app events to AppsFlyer analytics. This method allows you to 
add events dynamically by adding them directly to the application code.*
```javascript
// eventName - any string to define the event name. For example: “registration” or “purchase”
// eventValue - the sales value. For example: 0.99 or 0.79
window.plugins.appsFlyer.sendTrackingWithEvent(eventName, eventValue);
// window.plugins.appsFlyer.sendTrackingWithEvent(eventName, "");
```
#### 4\.1 Rich In App Events Tracking API (optional)
AppsFlyer’s rich in­app events provide advertisers with the ability to track any post­install event and attribute it to a media source and campaign.An in­app event is comprised of an event name and event parameters

```javascript
var eventName = "af_add_to_cart";
var eventValues = {"af_content_id": "id123", "af_currency":"USD", "af_revenue": "2"};
window.plugins.appsFlyer.trackEvent(eventName, eventValues);
```
#### 5\. Get AppsFlyer’s Unique Device UID (Advanced)
*Get AppsFlyer’s proprietary device ID. AppsFlyer device ID is the main ID used by AppsFlyer in the Reports and API’s.*
```javascript
// getUserIdCallbackFn - callback function
window.plugins.appsFlyer.getAppsFlyerUID(getUserIdCallbackFn);
```
###### Example:
```javascript
var getUserIdCallbackFn = function(id) {
	alert('received id is: ' + id);
}
window.plugins.appsFlyer.getAppsFlyerUID(getUserIdCallbackFn);
```
#### 6\. Accessing AppsFlyer Attribution / Conversion Data from the SDK (Deferred 
Deep-linking). Read more: [Android](http://support.appsflyer.com/entries/69796693-Accessing-AppsFlyer-Attribution-Conversion-Data-from-the-SDK-Deferred-Deep-linking-), [iOS](http://support.appsflyer.com/entries/22904293-Testing-AppsFlyer-iOS-SDK-Integration-Before-Submitting-to-the-App-Store-)  
**Note:** AppsFlyer plugin will fire `onInstallConversionDataLoaded` event with attribution data. You must implement listener to receive the data.
###### Example:
```javascript
document.addEventListener('onInstallConversionDataLoaded', function(e){
	var attributionData = (JSON.stringify(e.detail));
	alert(attributionData);
}, false);
```
