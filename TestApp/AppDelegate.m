//
//  AppDelegate.m
//  TestApp
//
//  Created by Jabin on 10/12/16.
//  Copyright (c) 2016 Jabin. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "ConstantFile.h"
#import "MapViewController.h"

///    Notification become independent from UIKit
#if XCODE_VERSION_GREATER_THAN_OR_EQUAL_TO_8
@import UserNotifications;
#endif

@interface AppDelegate () {
    ViewController *Home;
    MapViewController  *mapVC;
    
}
@property (nonatomic,strong)    ViewController *Home;

@end

@implementation AppDelegate

@synthesize  navigationController;
@synthesize Home;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    application.applicationIconBadgeNumber = 0;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10.0")) {
#if XCODE_VERSION_GREATER_THAN_OR_EQUAL_TO_8
        /// schedule localNotification, the delegate must be set before the application returns from applicationDidFinishLaunching:.
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
#endif
    } else {
        UILocalNotification *localNotifacation = [self getLocalNotificationFromLaunchOptions:launchOptions];
        if (localNotifacation) {
            NSString *title = localNotifacation.alertBody;
            [self addLabel:title];
        }
    }
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
     Home = [[ViewController alloc] init];
    
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:Home];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.window.rootViewController = self.navigationController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
    return YES;
}

/*!
 *  avoid other behaviours such as Launching by URL Scheme
 */
- (UILocalNotification *)getLocalNotificationFromLaunchOptions:(NSDictionary *const)launchOptions {
    id notification, candidate;
    @try {
        candidate = launchOptions[UIApplicationLaunchOptionsLocalNotificationKey];
    } @catch (NSException *exception) {}
    BOOL isLocalNotificationLaunchOption = [candidate isKindOfClass:[UILocalNotification class]];
    if (isLocalNotificationLaunchOption) {
        notification = candidate;
    }
    return notification;
}

- (void)addLabel:(NSString *)title {
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.backgroundColor = [UIColor redColor];
    label.text = title;
    [label sizeToFit];
    label.center = CGPointMake([UIScreen mainScreen].bounds.size.width * 0.5, 114);
    [self.window.rootViewController.view addSubview:label];
}

- (void)addLabel:(NSString *)title backgroundColor:(UIColor *)backgroundColor {
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.backgroundColor = backgroundColor;
    label.text = title;
    label.font= [UIFont boldSystemFontOfSize:15];
    label.textColor = [UIColor blackColor];
    [label sizeToFit];
    label.center = CGPointMake([UIScreen mainScreen].bounds.size.width * 0.5, arc4random_uniform([UIScreen mainScreen].bounds.size.height));
    [self.window.rootViewController.view addSubview:label];
}

/// invoked not only when enter foreground but also in foreground,
/// when the user tapped (or slided) the action button (or slider) while in foregroud then we should show alert instead of local notification.
/// but can not invoked when the user tapped (or slided) the action button while the app has already been killed,
/// so we have to handle the launch action in `-application:didFinishLaunchingWithOptions:` and tell the right local notification behaviour.
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    if (application.applicationState == UIApplicationStateInactive) {
        NSLog(@"%@", notification.userInfo);
        if (notification.userInfo) {
            [self addLabel:[NSString stringWithFormat:@"%@", notification.userInfo[@"alertBody"]]];
        }
    }
}

#pragma mark -
#pragma mark - UNUserNotificationCenterDelegate Method

#if XCODE_VERSION_GREATER_THAN_OR_EQUAL_TO_8

// The method will be called on the delegate only if the application is in the foreground. If the method is not implemented or the handler is not called in a timely manner then the notification will not be presented. The application can choose to have the notification presented as a sound, badge, alert and/or in the notification list. This decision should be based on whether the information in the notification is otherwise visible to the user.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    NSLog(@"Notification is triggered");
    //[self addLabel:notification.request.identifier backgroundColor:[UIColor blueColor]];
    // You can either present alert, sound or increase badge while the app is in foreground too with iOS 10
    // Must be called when finished, when you do not want foreground show, pass UNNotificationPresentationOptionNone to the completionHandler()
    completionHandler(UNNotificationPresentationOptionAlert);
    // completionHandler(UNNotificationPresentationOptionBadge);
    // completionHandler(UNNotificationPresentationOptionSound);
}


// The method will be called on the delegate when the user responded to the notification by opening the application, dismissing the notification or choosing a UNNotificationAction. The delegate must be set before the application returns from applicationDidFinishLaunching:.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void(^)())completionHandler {
    NSLog(@"Tapped in notification");
    
    NSString *savedValueLat = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"feedLocationLatStr"];
    NSString *savedValueLong = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"feedLocationLongStr"];


    mapVC = [[MapViewController alloc]init];
    mapVC.latValue =  savedValueLat;
    mapVC.longValue = savedValueLong;
    
    [self.navigationController pushViewController:mapVC animated:YES];

    NSString *actionIdentifier = response.actionIdentifier;
    
    if ([actionIdentifier isEqualToString:@"com.apple.UNNotificationDefaultActionIdentifier"] ||
        [actionIdentifier isEqualToString:@"com.apple.UNNotificationDismissActionIdentifier"]) {
        return;
    }
    BOOL accept = [actionIdentifier isEqualToString:@"com.elonchan.yes"];
    BOOL decline = [actionIdentifier isEqualToString:@"com.elonchan.no"];
    BOOL snooze = [actionIdentifier isEqualToString:@"com.elonchan.snooze"];
    do {
        if (accept) {
            NSString *title = @"Notification accept";
            [self addLabel:title backgroundColor:[UIColor yellowColor]];
            break;
        }
        if (decline) {
            NSString *title = @"Notification decline";
            [self addLabel:title backgroundColor:[UIColor redColor]];
            break;
        }
        if (snooze) {
            NSString *title = @"Notification snooze";
            [self addLabel:title backgroundColor:[UIColor redColor]];
        }
    } while (NO);
    // Must be called when finished
    completionHandler();
}

#endif

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

@end
