#import "AppsFlyerPlugin.h"
#import "AppsFlyerTracker.h"

@implementation AppsFlyerPlugin


static NSString *const NO_DEVKEY_FOUND = @"No 'devKey' found or its empty";
static NSString *const NO_APPID_FOUND  = @"No 'appId' found or its empty";
static NSString *const SUCCESS         = @"Success";

//  never called, use pluginInitialize instead
//- (CDVPlugin *)initWithWebView:(UIWebView *)theWebView
//{
//    [self pluginInitialize];
//    return self;
//}

- (void)pluginInitialize
{
  [AppsFlyerTracker sharedTracker].delegate = self;
}

- (void)initSdk:(CDVInvokedUrlCommand*)command
{
    NSString* callbackId = command.callbackId;

    NSDictionary* initSdkOptions = [command argumentAtIndex:0 withDefault:[NSNull null]];

    NSString* devKey = nil;
    NSString* appId = nil;
    BOOL isDebug = YES;

    if (![initSdkOptions isKindOfClass:[NSNull class]]) {

        id value = nil;
        devKey = (NSString*)[initSdkOptions objectForKey: afDevKey];
        appId = (NSString*)[initSdkOptions objectForKey: afAppId];

        value = [initSdkOptions objectForKey: afIsDebug];
        if ([value isKindOfClass:[NSNumber class]]) {
            // isDebug is a boolean that will come through as an NSNumber
            isDebug = [(NSNumber*)value boolValue];
        }
    }

    NSString* error = nil;

    if (!devKey || [devKey isEqualToString:@""]) {
        error = NO_DEVKEY_FOUND;
    }
    else if (!appId || [appId isEqualToString:@""]) {
        error = NO_APPID_FOUND;
    }


    if(error != nil){
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: error];
        [self.commandDelegate sendPluginResult:result callbackId:callbackId];
        return;

    }
    else{
        [AppsFlyerTracker sharedTracker].appleAppID = appId;
        [AppsFlyerTracker sharedTracker].appsFlyerDevKey = devKey;
       // [AppsFlyerTracker sharedTracker].delegate = self;  // moved to 'pluginInitialize'
        [AppsFlyerTracker sharedTracker].isDebug = isDebug;
        [[AppsFlyerTracker sharedTracker] trackAppLaunch];

        //TODO: connect to static lib success callback
         CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:SUCCESS];
        [self.commandDelegate sendPluginResult:result callbackId:callbackId];
    }
  }

- (void)setCurrencyCode:(CDVInvokedUrlCommand*)command
{
    if ([command.arguments count] == 0) {
        return;
    }
    
    NSString* currencyId = [command.arguments objectAtIndex:0];
    [AppsFlyerTracker sharedTracker].currencyCode = currencyId;
}

- (void)setAppUserId:(CDVInvokedUrlCommand *)command
{
    if ([command.arguments count] == 0) {
        return;
    }
    
    NSString* userId = [command.arguments objectAtIndex:0];
    [AppsFlyerTracker sharedTracker].customerUserID  = userId;
}

- (void)getAppsFlyerUID:(CDVInvokedUrlCommand *)command
{
    NSString* userId = [[AppsFlyerTracker sharedTracker] getAppsFlyerUID];
    CDVPluginResult *pluginResult = [ CDVPluginResult
                                    resultWithStatus    : CDVCommandStatus_OK
                                    messageAsString: userId
                                    ];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)sendTrackingWithEvent:(CDVInvokedUrlCommand *)command
{
    if ([command.arguments count] < 2) {
        return;
    }
    
    NSString* eventName = [command.arguments objectAtIndex:0];
    NSString* eventValue = [command.arguments objectAtIndex:1];
    [[AppsFlyerTracker sharedTracker] trackEvent:eventName withValue:eventValue];
}

-(void)onConversionDataReceived:(NSDictionary*) installData {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:installData
                                            options:0
                                            error:&error];
    if (jsonData) {
        NSString *JSONString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
        
        [self performSelectorOnMainThread:@selector(reportConversionData:) withObject:JSONString waitUntilDone:NO];
        NSLog(@"JSONString = %@",JSONString);

    } else {
        NSLog(@"%@",error);
    }
}


//-(void) reportConversionData_old:(NSString *)data {
//    [[super webViewEngine] evaluateJavaScript:[NSString stringWithFormat:@"javascript:window.plugins.appsFlyer.onInstallConversionDataLoaded(%@)", data] completionHandler:nil];
//}

-(void) reportConversionData:(NSString *)data {
    NSString *js = [NSString stringWithFormat:@"window.plugins.appsFlyer.onInstallConversionDataLoaded(%@)", data];
    [self.commandDelegate evalJs:js];
}

-(void)onConversionDataRequestFailure:(NSError *) error {
    
    NSLog(@"%@",error);
    
}

- (void)trackEvent:(CDVInvokedUrlCommand*)command {

    NSString* eventName = [command.arguments objectAtIndex:0];
    NSDictionary* eventValues = [command.arguments objectAtIndex:1];
    [[AppsFlyerTracker sharedTracker] trackEvent:eventName withValues:eventValues];

}

- (void)registerUninstall:(CDVInvokedUrlCommand*)command {

    NSData* token = [command.arguments objectAtIndex:0];
    NSString *deviceToken = [NSString stringWithFormat:@"%@",token];
    
    if(deviceToken!=nil){
        [[AppsFlyerTracker sharedTracker] registerUninstall:token];
    }else{
        NSLog(@"Invalid device token");
    }

}

@end
