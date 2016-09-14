//
//  ViewController.m
//  ColorTV Chromecast Demo
//
//  Created by Jordan Jasinski on 01/08/16.
//  Copyright © 2016 Color Media Group inc. All rights reserved.
//

#import "ViewController.h"

@import GoogleCast;

@import COLORCastFramework;

@interface ViewController ()<GCKSessionManagerListener, COLORCastManagerDelegate>

@property (nonatomic, strong) GCKCastChannel *testAppChannel;

@property (nonatomic, weak) IBOutlet UIView *remoteBgView;
@property (nonatomic, weak) IBOutlet UIButton *btnEnter;
@property (nonatomic, weak) IBOutlet UIButton *btnUp;
@property (nonatomic, weak) IBOutlet UIButton *btnDown;
@property (nonatomic, weak) IBOutlet UIButton *btnLeft;
@property (nonatomic, weak) IBOutlet UIButton *btnRight;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSLog(@"::>> Remote BG: %@", self.remoteBgView);
    NSLog(@"##### Remote Bg Layer Size: %fx%f (%fx%f)", self.remoteBgView.layer.bounds.size.width, self.remoteBgView.layer.bounds.size.height, self.remoteBgView.layer.bounds.origin.x, self.remoteBgView.layer.bounds.origin.y);
    CAShapeLayer *remoteBgLayer = [CAShapeLayer layer];
    remoteBgLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0.0f, 0.0f, self.remoteBgView.layer.bounds.size.width, self.remoteBgView.layer.bounds.size.height)].CGPath;
    remoteBgLayer.fillColor = [UIColor colorWithRed:0.6f green:0.6f blue:0.6f alpha:0.8f].CGColor;
    remoteBgLayer.anchorPoint = CGPointMake(0.5f, 0.5f);
    
    [self.remoteBgView.layer addSublayer:remoteBgLayer];
    
    self.remoteBgView.layer.borderColor = [[UIColor redColor] CGColor];
    self.remoteBgView.layer.borderWidth = 10.0f;
    
    GCKUICastButton *castButton = [[GCKUICastButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    castButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:castButton];
    
    self.navigationItem.rightBarButtonItem.width = 24.0f;
    
    [COLORCastManager sharedManager].delegate = self;
    
    /*
     self.testAppChannel = [[GCKCastChannel alloc] initWithNamespace:@"urn:x-cast:com.colortv.testapp"];
     
     NSLog(@"::>> CURRENT SESSION: %@", [[[GCKCastContext sharedInstance] sessionManager] currentCastSession]);
     
     [[[[GCKCastContext sharedInstance] sessionManager] currentCastSession] addChannel:self.testAppChannel];
     */
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[[GCKCastContext sharedInstance] sessionManager] addListener:self];
    
    if([[GCKCastContext sharedInstance] sessionManager].hasConnectedCastSession) {
        [[[[GCKCastContext sharedInstance] sessionManager] currentCastSession] addChannel:self.testAppChannel];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[[GCKCastContext sharedInstance] sessionManager] removeListener:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)moveUp:(id)sender {
    GCKError *error;
    [self.testAppChannel sendTextMessage:@"MOVE_UP" error:&error];
    
    if(error) {
        NSLog(@"::>> %@ ERROR: %@", NSStringFromSelector(_cmd), error);
    }
}

-(IBAction)moveDown:(id)sender {
    GCKError *error;
    [self.testAppChannel sendTextMessage:@"MOVE_DOWN" error:&error];
    
    if(error) {
        NSLog(@"::>> %@ ERROR: %@", NSStringFromSelector(_cmd), error);
    }
}

-(IBAction)moveLeft:(id)sender {
    GCKError *error;
    [self.testAppChannel sendTextMessage:@"MOVE_LEFT" error:&error];
    
    if(error) {
        NSLog(@"::>> %@ ERROR: %@", NSStringFromSelector(_cmd), error);
    }
}

-(IBAction)moveRight:(id)sender {
    GCKError *error;
    [self.testAppChannel sendTextMessage:@"MOVE_RIGHT" error:&error];
    
    if(error) {
        NSLog(@"::>> %@ ERROR: %@", NSStringFromSelector(_cmd), error);
    }
    
}

-(IBAction)enter:(id)sender {
    GCKError *error;
    [self.testAppChannel sendTextMessage:@"MOVE_CENTER" error:&error];
    
    if(error) {
        NSLog(@"::>> %@ ERROR: %@", NSStringFromSelector(_cmd), error);
    }
}

-(void)enableVirtualRemoteButtons:(BOOL)enable {
    self.btnEnter.enabled = enable;
    self.btnUp.enabled = enable;
    self.btnDown.enabled = enable;
    self.btnLeft.enabled = enable;
    self.btnRight.enabled = enable;
}

#pragma mark - GCKSessionManagerListener

-(void)sessionManager:(GCKSessionManager *)sessionManager didStartCastSession:(GCKCastSession *)session {
    self.testAppChannel = [[GCKCastChannel alloc] initWithNamespace:@"urn:x-cast:com.colortv.testapp"];
    NSLog(@"::>> %@", NSStringFromSelector(_cmd));
    NSLog(@"::>> CURRENT SESSION: %@", [[[GCKCastContext sharedInstance] sessionManager] currentCastSession]);
    
    [[sessionManager currentCastSession] addChannel:self.testAppChannel];
    
    [self enableVirtualRemoteButtons:YES];
}

-(void)sessionManager:(GCKSessionManager *)sessionManager willEndCastSession:(GCKCastSession *)session {
    NSLog(@"::>> %@", NSStringFromSelector(_cmd));
}

-(void)sessionManager:(GCKSessionManager *)sessionManager didEndCastSession:(GCKCastSession *)session withError:(NSError *)error {
    NSLog(@"::>> %@ >> %@", NSStringFromSelector(_cmd), error);
    NSLog(@"::>> CURRENT SESSION: %@", [[[GCKCastContext sharedInstance] sessionManager] currentCastSession]);
    [self enableVirtualRemoteButtons:NO];
    
    [[sessionManager currentCastSession] removeChannel:self.testAppChannel];
    
    self.testAppChannel = nil;
}

-(void)sessionManager:(GCKSessionManager *)sessionManager didSuspendCastSession:(GCKCastSession *)session withReason:(GCKConnectionSuspendReason)reason {
    NSLog(@"::>> %@", NSStringFromSelector(_cmd));
    
    [self enableVirtualRemoteButtons:NO];
}

-(void)sessionManager:(GCKSessionManager *)sessionManager didResumeCastSession:(GCKCastSession *)session {
    NSLog(@"::>> %@", NSStringFromSelector(_cmd));
    
    self.testAppChannel = [[GCKCastChannel alloc] initWithNamespace:@"urn:x-cast:com.colortv.testapp"];
    
    [[sessionManager currentCastSession] addChannel:self.testAppChannel];
    
    [self enableVirtualRemoteButtons:YES];
}

#pragma mark - COLORCastManagerDelegate

-(void)COLORCastManager:(COLORCastManager*)manager presentViewController:(UIViewController*)vc {
    NSLog(@"::>> show VC: %@", vc);
    
    //[self.navigationController pushViewController:vc animated:YES];
    [self presentViewController:vc animated:YES completion:nil];
}

-(void)COLORCastManager:(COLORCastManager*)manager dismissViewController:(UIViewController*)vc {
    NSLog(@"::>> hide VC: %@", vc);
    
    //[self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)COLORCastManager:(COLORCastManager*)manager didEarnVirtualCurrency:(NSDictionary*)dictionary {
    NSLog(@"::>> didEarnVirtualCurrency: %@", dictionary);
}

@end
