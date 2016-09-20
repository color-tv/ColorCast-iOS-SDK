#ColorTV GoogleCast SDK

##Getting started

Before getting started make sure you have:

* Added your app in the My Applications section of the Color Dashboard. You need to do this so that you can get your App ID that you'll be adding to your app with our SDK.

* Our newest iOS SDK supports the newest Xcode (8.0). Please ensure you are using Xcode (8.0) or higher to ensure smooth integration.

---

##Adding iOS SDK

###Connecting Your App
There are two ways to add Color to your Xcode project:

####1. Cocoapods
Easily add Color to your project by adding the following code to your Podfile:

```
pod 'Color-GoogleCast-SDK'
```

After adding this value, run `pod install` and the latest version of our iOS SDK will be installed!

If you are using CocoaPods and Swift, you might encounter a compiler error: "Include of non-modular header inside framework...". It is [a bug in CocoaPods](https://github.com/CocoaPods/CocoaPods/issues/4420) which was fixed in 1.0.0.beta.1. If you are using an earlier version of CocoaPods, please add the following lines to your `Podfile`:

```ruby
post_install do |installer|
   `rm Pods/Headers/Public/ColorCast-iOS-SDK/COLORAdFramework/*.h`
end
```

####2. Manual Integration

[Download the iOS SDK here](https://github.com/color-tv/ColorCast-iOS-SDK)

####Download & Unzip SDK 

Unzip and open the folder, then navigate to the ColorTV framework folder. Included are both frameworks for simulator and actual devices. Use the framework from the tvos-device folder for production, **only** use the framework for simulator for testing. 

Click on your Application at the top-left side of Xcode and go to project settings. Select *General* and choose proper target, it name in most cases corresponds to name of your project. Then drag and drop the COLORAdFramework.framework directory into the **Embeded Binaries** section.

Once complete, you will see the COLORAdFramework in both the **Embedded Binaries and Linked Frameworks and Libraries** sections. Please note that the framework will be automatically added to **Linked Frameworks and Libraries**. It will **not** be automatically added to both if you add it to Linked Frameworks and Libraries first.

---

##Initializing SDK

Open AppDelegate.m and modify body of function `application:DidFinishLaunchingWithOptions:` with the App ID generated in the dashboard

```objective-c
[[COLORCastManager sharedManager] startWithAppIdentifier:@"YOUR_APP_ID_HERE"];
```

```Swift
COLORCastManager.sharedManager().startWithAppIdentifier("YOUR_APP_ID_HERE");
```

Remember to import COLORCastFramework module. Add following line of code above class implementation.

```objective-c
@import COLORCastFramework;
```

```Swift
@import COLORCastFramework
```

---

##Binding COLORCastFramework to Device

Now you should bind GCKChannel, which is used for communication with our server side framework with session created between mobile and cast devices. There are several ways how it may be done. The easiest and most convenient is to implement GCKSessionManagerListener as a part of AppDelegate.
Add interface extension and make sure it conforms to GCKSessionManagerListener.

```objective-c
@interface AppDelegate ()<GCKSessionManagerListener>
```

Add AppDelegate as listener. application:DidFinishLaunchingWithOptions should be the most appropriate place to add following line of code.

```objective-c
[[[GCKCastContext sharedInstance] sessionManager] addListener:self];
```

Finally implement some methods required.

```objective-c

#pragma mark - GCKSessionManagerListener

-(void)sessionManager:(GCKSessionManager *)sessionManager willStartCastSession:(GCKCastSession *)session {
    NSLog(@"::>> %@", NSStringFromSelector(_cmd));
}

-(void)sessionManager:(GCKSessionManager *)sessionManager didStartCastSession:(GCKCastSession *)session {

    [[sessionManager currentCastSession] addChannel:[[COLORCastManager sharedManager] adChannel]];
}

-(void)sessionManager:(GCKSessionManager *)sessionManager didEndCastSession:(GCKCastSession *)session withError:(NSError *)error {

    [[sessionManager currentCastSession] removeChannel:[[COLORCastManager sharedManager] adChannel]];
}

-(void)sessionManager:(GCKSessionManager *)sessionManager didResumeCastSession:(GCKCastSession *)session {
    [[sessionManager currentCastSession] addChannel:[[COLORCastManager sharedManager] adChannel]];
}

```

---

##Handling events triggered by COLORCastFramework

COLORCastManagerDelegate is to be implemented in order to catch events triggered by our SDK. Its definition is as follows (please note that the two first methods are required).

```objective-c
@protocol COLORCastManagerDelegate <NSObject>

-(void)COLORCastManager:(COLORCastManager * _Nonnull)manager presentViewController:(UIViewController * _Nullable)vc;
-(void)COLORCastManager:(COLORCastManager * _Nonnull)manager dismissViewController:(UIViewController * _Nullable)vc;

@optional
-(void)COLORCastManager:(COLORCastManager * _Nonnull)manager didEarnVirtualCurrency:(NSDictionary * _Nullable)dictionary;

@end
```

###Interacting with ads on TV screen.

Let's comment the protocol for a while. As the picture displayed on TV screen changes when COLOR framework comes to play you need to adjust GoogleCast controls displayed on mobile device. We prepared several types of controllers which perfectly integrates into ad units displayed on TV screen. You do not need to care about what is inside. Just display or hide requested controller. If you do not have an idea what to do please copy and paste following block of code.

```objective-c

#pragma mark - COLORCastManagerDelegate

-(void)COLORCastManager:(COLORCastManager*)manager presentViewController:(UIViewController*)vc {
    [self presentViewController:vc animated:YES completion:nil];
}

-(void)COLORCastManager:(COLORCastManager*)manager dismissViewController:(UIViewController*)vc {
    [self dismissViewControllerAnimated:YES completion:nil];
}

```

Basically it shows and hides view controller as modal view controller. You have some freedom and can sow these controllers however you wish not to interup native user experience. In majority of cases presenting these controllers modally will be enought.

---

###Earning virtual currency

Integrating virtual currency inside of your advertisments greatly increases user interaction as well as monetization for your app. We offer a mechanism to provide users a variety of incentives using your app's virtual currency. Virtual Currency must first be set up in the dashboard for your application and then a few lines of code need to be added to be fully setup.

Ad conversions are monitored by our server and you will be informed when some currency is assigned. Please note that you will be informed when currency is earned on both sides i.e. Chromecast and Mobile Device. It is up to you how and where you implement it.

```objective-c
-(void)COLORCastManager:(COLORCastManager*)manager didEarnVirtualCurrency:(NSDictionary*)dictionary {
    NSLog(@"::>> didEarnVirtualCurrency: %@", dictionary);
}
```

The dictionary will contain information about currency earned by user. Following keys are expected:
*currencyType (NSString)
*currencyAmount (NSNumber)
*status (NSNumber);
*timestamp (NSDate);
