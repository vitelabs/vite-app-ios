//
//  Generated file. Do not edit.
//

#import "GeneratedPluginRegistrant.h"
#import <flutter_boost/FlutterBoostPlugin.h>
#import <shared_preferences/SharedPreferencesPlugin.h>
#import <xservice_kit/XserviceKitPlugin.h>
#import <vite_wallet_communication/ViteWalletCommunicationPlugin.h>
#import <firebase_analytics/FirebaseAnalyticsPlugin.h>
#import <firebase_crashlytics/FirebaseCrashlyticsPlugin.h>

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
    [FlutterBoostPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterBoostPlugin"]];
    [XserviceKitPlugin registerWithRegistrar:[registry registrarForPlugin:@"XserviceKitPlugin"]];      [FLTSharedPreferencesPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTSharedPreferencesPlugin"]];
    [ViteWalletCommunicationPlugin registerWithRegistrar:[registry registrarForPlugin:@"ViteWalletCommunicationPlugin"]];

    [FLTFirebaseAnalyticsPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTFirebaseAnalyticsPlugin"]];
    [FirebaseCrashlyticsPlugin registerWithRegistrar:[registry registrarForPlugin:@"FirebaseCrashlyticsPlugin"]];
}

@end
