//
//  AppDelegate.m
//  ColorTV Chromecast Demo
//
//  Created by Jordan Jasinski on 01/08/16.
//  Copyright © 2016 Color Media Group inc. All rights reserved.
//

#import "AppDelegate.h"

@import GoogleCast;
@import COLORCastFramework;

@interface AppDelegate ()<GCKLoggerDelegate, GCKSessionManagerListener>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    GCKCastOptions *options = [[GCKCastOptions alloc] initWithReceiverApplicationID:@"3C1F0065"];
    [GCKCastContext setSharedInstanceWithOptions:options];
    
    [[GCKLogger sharedInstance] setDelegate:self];
    
    [[[GCKCastContext sharedInstance] sessionManager] addListener:self];
    
    [[COLORCastManager sharedManager] startWithAppIdentifier:@"08271056-5211-4ae6-bf1c-12e344455383"];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - GCKLoggerDelegate

-(void)logMessage:(NSString *)message fromFunction:(NSString *)function {
    //NSLog(@"%@  %@", function, message);
}

#pragma mark - GCKSessionManagerListener

-(void)sessionManager:(GCKSessionManager *)sessionManager willStartCastSession:(GCKCastSession *)session {
    NSLog(@"::>> %@", NSStringFromSelector(_cmd));
}

-(void)sessionManager:(GCKSessionManager *)sessionManager didStartCastSession:(GCKCastSession *)session {
    
    NSLog(@"::>> %@", NSStringFromSelector(_cmd));
    NSLog(@"::>> CURRENT SESSION: %@", [[[GCKCastContext sharedInstance] sessionManager] currentCastSession]);
    
    [[sessionManager currentCastSession] addChannel:[[COLORCastManager sharedManager] adChannel]];
}

-(void)sessionManager:(GCKSessionManager *)sessionManager willEndCastSession:(GCKCastSession *)session {
    NSLog(@"::>> %@", NSStringFromSelector(_cmd));
}

-(void)sessionManager:(GCKSessionManager *)sessionManager didEndCastSession:(GCKCastSession *)session withError:(NSError *)error {
    NSLog(@"::>> %@ >> %@", NSStringFromSelector(_cmd), error);
    NSLog(@"::>> CURRENT SESSION: %@", [[[GCKCastContext sharedInstance] sessionManager] currentCastSession]);
    
    [[sessionManager currentCastSession] removeChannel:[[COLORCastManager sharedManager] adChannel]];
}

-(void)sessionManager:(GCKSessionManager *)sessionManager didSuspendCastSession:(GCKCastSession *)session withReason:(GCKConnectionSuspendReason)reason {
    NSLog(@"::>> %@", NSStringFromSelector(_cmd));
}

-(void)sessionManager:(GCKSessionManager *)sessionManager didResumeCastSession:(GCKCastSession *)session {
    NSLog(@"::>> %@", NSStringFromSelector(_cmd));
    
    [[sessionManager currentCastSession] addChannel:[[COLORCastManager sharedManager] adChannel]];
}

-(void)sessionManager:(GCKSessionManager *)sessionManager didFailToStartCastSession:(GCKCastSession *)session withError:(NSError *)error {
    NSLog(@"::>> %@ >> %@", NSStringFromSelector(_cmd), error);
}

-(void)sessionManager:(GCKSessionManager *)sessionManager castSession:(GCKCastSession *)session didReceiveDeviceStatus:(NSString *)statusText {
    
    NSLog(@"::>> didReciveDeviceStatus: %@ -> %@", statusText, session);
}

@end
