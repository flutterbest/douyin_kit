#import "DouyinKitPlugin.h"
#import <DouyinOpenSDK/DouyinOpenSDKApplicationDelegate.h>
#import <DouyinOpenSDK/DouyinOpenSDKAuth.h>
#import <DouyinOpenSDK/DouyinOpenSDKShare.h>
#import <KwaiSDK/KSApi.h>
#import <Photos/Photos.h>

@interface DouyinKitPlugin () <KSApiDelegate>
@end

@implementation DouyinKitPlugin {
    FlutterMethodChannel *_channel;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel *channel =
        [FlutterMethodChannel methodChannelWithName:@"v7lin.github.io/douyin_kit"
                                    binaryMessenger:[registrar messenger]];
    DouyinKitPlugin *instance = [[DouyinKitPlugin alloc] initWithChannel:channel];
    [registrar addApplicationDelegate:instance];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (instancetype)initWithChannel:(FlutterMethodChannel *)channel {
    self = [super init];
    if (self) {
        _channel = channel;
    }
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall *)call
                  result:(FlutterResult)result {
    if ([@"registerApp" isEqualToString:call.method]) {
        NSString *clientKey = call.arguments[@"client_key"];
        [[DouyinOpenSDKApplicationDelegate sharedInstance] registerAppId:clientKey];
        // reg
        [KSApi registerApp:@"ks655836695748529649" universalLink:@"https://b3cgsa.xinstall.com.cn/tolink/" delegate:self];

        result(nil);
    } else if ([@"isInstalled" isEqualToString:call.method]) {
        result([NSNumber numberWithBool:[[DouyinOpenSDKApplicationDelegate sharedInstance] isAppInstalled]]);
    } else if ([@"isSupportAuth" isEqualToString:call.method]) {
        result([NSNumber numberWithBool:YES]);
    } else if ([@"auth" isEqualToString:call.method]) {
        [self handleAuthCall:call result:result];
    } else if ([@"isSupportShare" isEqualToString:call.method]) {
        
    } else if ([@[@"shareImage", @"shareVideo", @"shareMicroApp", @"shareHashTags", @"shareAnchor"] containsObject:call.method]) {
        [self handleShareCall:call result:result]; // call.argument("video_uris")  call.arguments
    } else if ([@"isSupportShareToContacts" isEqualToString:call.method]) {
        
    } else if ([@[@"shareImageToContacts", @"shareHtmlToContacts"] containsObject:call.method]) {
        [self handleShareToContactsCall:call result:result];
    } else if ([@"isSupportOpenRecord" isEqualToString:call.method]) {
        
    } else if ([@"openRecord" isEqualToString:call.method]) {
        [self handleOpenRecordCall:call result:result];
    } else if ([@[@"ksShareVideo"] containsObject:call.method]) {
        [self handleKSShareCall:call result:result]; // call.argument("video_uris")  call.arguments
    } else if ([@"isSupportShareToContacts" isEqualToString:call.method]) {
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)handleAuthCall:(FlutterMethodCall *)call result:(FlutterResult)result {
}


- (void)handleKSShareCall:(FlutterMethodCall *)call
                      result:(FlutterResult)result {
    NSDictionary *arg = call.arguments;
    if ([arg isKindOfClass:NSDictionary.class]) {
        NSArray *uris = arg[@"video_uris"];
        if ([uris isKindOfClass:NSArray.class]) {
            __block NSMutableArray *assetLocalIds = [NSMutableArray array];
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                
                NSURL *url = [NSURL URLWithString:uris.firstObject]; // file://
                PHAssetChangeRequest *request = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:url];
               NSString *localId = request.placeholderForCreatedAsset.localIdentifier;
               [assetLocalIds addObject:localId];
                
            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                if (success) {
                   dispatch_async(dispatch_get_main_queue(), ^{
                       
                       
                       KSShareMediaAsset *asset = [KSShareMediaAsset assetForPhotoLibrary:assetLocalIds.firstObject isImage:NO];
                       KSShareMediaObject *object = [[KSShareMediaObject alloc] init];
                       object.multipartAssets = @[asset];
                       //object 参数配置
                       KSShareMediaRequest *request = [[KSShareMediaRequest alloc] init];
                       request.mediaFeature = KSShareMediaFeature_VideoPublish;
                       request.mediaObject = object;
                       [KSApi sendRequest:request completion:^(BOOL success) {
                           if (result) {
                               result(nil);
                           }
                           NSLog(@"kuaishou share = %d", success);
                       }];
                   });
                }
            }];
            return;
        }
    }
    if (result) {
        result(nil);
    }
}

- (void)handleShareCall:(FlutterMethodCall *)call
                      result:(FlutterResult)result {
    NSDictionary *arg = call.arguments;
    NSLog(@"test arg=%@", arg);
    if ([arg isKindOfClass:NSDictionary.class]) {
        NSArray *uris = arg[@"video_uris"];
        NSLog(@"test uris=%@", uris);
        if ([uris isKindOfClass:NSArray.class]) {
            __block NSMutableArray *assetLocalIds = [NSMutableArray array];
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                
                NSURL *url = [NSURL URLWithString:uris.firstObject]; // file://
                PHAssetChangeRequest *request = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:url];
               NSString *localId = request.placeholderForCreatedAsset.localIdentifier;
               [assetLocalIds addObject:localId];
                
            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                if (success) {
                   dispatch_async(dispatch_get_main_queue(), ^{
                       
                       DouyinOpenSDKShareRequest *req = [[DouyinOpenSDKShareRequest alloc] init];
                       req.mediaType = DouyinOpenSDKShareMediaTypeVideo;   // 需要传入分享类型
                       req.landedPageType = DouyinOpenSDKLandedPageEdit;    // 设置分享的目标页面
                       req.localIdentifiers = assetLocalIds;
                       [req sendShareRequestWithCompleteBlock:^(DouyinOpenSDKShareResponse * _Nonnull respond) {
                           if (respond.isSucceed) {

                           // Share Succeed

                           } else{

                               NSLog(@"respond = %@", respond.errString);

                           }
                           if (result) {
                               result(nil);
                           }
                       }];
                   });
                }
            }];
        }
    }
    if (result) {
        result(nil);
    }
}

- (void)handleShareToContactsCall:(FlutterMethodCall *)call
                      result:(FlutterResult)result {
}

- (void)handleOpenRecordCall:(FlutterMethodCall *)call
                      result:(FlutterResult)result {
}

#pragma mark - AppDelegate

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    BOOL ret = [[DouyinOpenSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:nil annotation:nil];
    if (!ret) {
        ret = [KSApi handleOpenURL:url];
    }
    return ret;
}

- (BOOL)application:(UIApplication *)application
              openURL:(NSURL *)url
    sourceApplication:(NSString *)sourceApplication
           annotation:(id)annotation {
    BOOL ret = [[DouyinOpenSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!ret) {
        ret = [KSApi handleOpenURL:url];
    }
    return ret;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:
                (NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    BOOL ret = [[DouyinOpenSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey] annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    if (!ret) {
        ret = [KSApi handleOpenURL:url];
    }
    return ret;
}

- (BOOL)application:(UIApplication*)application
    continueUserActivity:(NSUserActivity*)userActivity
      restorationHandler:(void (^)(NSArray*))restorationHandler {
    return [KSApi handleOpenUniversalLink:userActivity];
}

@end
