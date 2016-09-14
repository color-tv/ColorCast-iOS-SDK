//
//  COLORCastChannel.h
//  COLORCastFramework
//
//  Created by Jordan Jasinski on 09/08/16.
//  Copyright © 2016 Color Media Group inc. All rights reserved.
//

@import GoogleCast;

@class COLORAdvertisement;
@class COLORAdItem;
@class COLORSession;

@protocol COLORCastChannelDelegate <NSObject>

-(void)showCastControlsForAd:(COLORAdvertisement * _Nonnull)ad;
-(void)showWebCastControlsForAd:(COLORAdvertisement * _Nonnull)ad;
-(void)hideCastControlsForAd:(COLORAdvertisement * _Nonnull)ad;
-(void)invokeActionForItem:(COLORAdItem * _Nonnull)adItem;
-(void)didEarnVirtualCurrency:(NSDictionary * _Nonnull)dictionary;

@end

@interface COLORCastChannel : GCKCastChannel

@property (nonatomic, weak) id<COLORCastChannelDelegate> _Nullable delegate;

@property (atomic, copy, readonly) COLORSession * _Nullable serverSession;

-(instancetype _Nullable)init;

-(void)inputEnter;
-(void)inputBack;
-(void)inputLeft;
-(void)inputRight;
-(void)inputUp;
-(void)inputDown;

-(void)reportReturnToApp;
-(void)reportActionButtonTapped;
-(void)reportOtherAction;

@end
