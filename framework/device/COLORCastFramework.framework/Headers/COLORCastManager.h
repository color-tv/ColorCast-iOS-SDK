//
//  COLORCastManager.h
//  COLORCastFramework
//
//  Created by Jordan Jasinski on 09/08/16.
//  Copyright © 2016 Color Media Group inc. All rights reserved.
//

@import UIKit;

#import "COLORCastChannel.h"

@class COLORCastManager;

@protocol COLORCastManagerDelegate <NSObject>

-(void)COLORCastManager:(COLORCastManager * _Nonnull)manager presentViewController:(UIViewController * _Nullable)vc;
-(void)COLORCastManager:(COLORCastManager * _Nonnull)manager dismissViewController:(UIViewController * _Nullable)vc;

@optional
-(void)COLORCastManager:(COLORCastManager * _Nonnull)manager didEarnVirtualCurrency:(NSDictionary * _Nullable)dictionary;

@end

@interface COLORCastManager : NSObject

@property (nonatomic, strong, readonly) COLORCastChannel * _Nonnull adChannel;
@property (nonatomic, weak) id<COLORCastManagerDelegate> _Nullable delegate;

+(instancetype _Nullable)sharedManager;

-(void)startWithAppIdentifier:(NSString* _Nonnull)appIdentifier;

@end
