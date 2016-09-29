//
//  MapViewController.m
//  TestApp
//
//  Created by Jabin on 9/12/16.
//  Copyright © 2016 Anand. All rights reserved.
//

#import "MapViewController.h"
#import "MapAnnotation.h"
#import "ConstantFile.h"

/// 1. import UserNotifications
///    Notification become independent from UIKit
#if XCODE_VERSION_GREATER_THAN_OR_EQUAL_TO_8
@import UserNotifications;
#endif
static NSString *const CYLInviteCategoryIdentifier = @"com.elonchan.localNotification";



@interface MapViewController () {
    NSString *strDistance;
    NSString *strLocName;
    
}
@property (nonatomic,weak)IBOutlet UISwitch *switchNotify;

@end

@implementation MapViewController
@synthesize latValue;
@synthesize longValue;
@synthesize distance;
@synthesize switchNotify;
@synthesize placeName;



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
     strDistance = distance;
    strLocName = placeName;
    [self getDetails];
}
-(void)getDetails{
    
    mapView = [[MKMapView alloc]initWithFrame:
               CGRectMake(-100, 100, self.view.frame.size.width, self.view.frame.size.height)];
    mapView.delegate = self;
//    mapView.centerCoordinate = CLLocationCoordinate2DMake(37.32, -122.03);
    mapView.mapType = MKMapTypeStandard;
    
    location.latitude = [latValue doubleValue]; //13.0827; //
    location.longitude = [longValue doubleValue]; //80.2707; //
    // Add the annotation to our map view
//    MapAnnotation *newAnnotation = [[MapAnnotation alloc]
//                                    initWithTitle:@"Apple Head quaters" andCoordinate:location];
//    [mapView addAnnotation:newAnnotation];
//    CLLocationCoordinate2D location2;
//    location2.latitude = (double) 37.35239;
//    location2.longitude = (double) -122.025919;
    MapAnnotation *newAnnotation2 = [[MapAnnotation alloc]
                                     initWithTitle:strLocName andCoordinate:location];
    [mapView addAnnotation:newAnnotation2];
    [self.view addSubview:mapView];
}
// When a map annotation point is added, zoom to it (1500 range)
- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views
{
    MKAnnotationView *annotationView = [views objectAtIndex:0];
    id <MKAnnotation> mp = [annotationView annotation];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance
    ([mp coordinate], 0, 0);
    
//    double miles = 5.0;
//    double scalingFactor = ABS( (cos(2 * M_PI * [latValue doubleValue] / 360.0) ));
//    
    MKCoordinateSpan span;
//    
//    span.latitudeDelta = miles/69.0;
//    span.longitudeDelta = miles/(scalingFactor * 69.0);
    
   
    //CLLocation *location = [latValue,longValue];
    
//    CLLocationCoordinate2D oldCoordinate =  CLLocationCoordinate2DMake([latValue doubleValue], [longValue doubleValue]);
   
    span.latitudeDelta = 0.1;
    span.longitudeDelta = 0.1;
    region.center = location;
    region.span = span;

   

    [mv setRegion:region animated:YES];
    [mv setShowsScale:YES];

    [mv setZoomEnabled:YES];
    [mv setShowsBuildings:YES];
    [mv setShowsTraffic:YES];
    [mv setRotateEnabled:YES];
    [mv setShowsUserLocation:YES];
    [mv selectAnnotation:mp animated:YES];
    

    
}

-(IBAction)notificationHandler:(id)sender {
    
    UISwitch *switchObject = (UISwitch *)sender;
    if ([switchObject isOn]) {
        
        [self triggerNotification:nil];

    } else {
        [self stopNotification:nil];
        
    }
}
-(IBAction)btnNotificationClicked:(id)sender {
    
    [self triggerNotification:nil];
    
}
- (void)triggerNotification:(id)sender {
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10.0")) {
        // create actions
#if XCODE_VERSION_GREATER_THAN_OR_EQUAL_TO_8
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        // create actions
        UNNotificationAction *acceptAction = [UNNotificationAction actionWithIdentifier:@"com.elonchan.yes"
                                                                                  title:@"Accept"
                                                                                options:UNNotificationActionOptionForeground];
        UNNotificationAction *declineAction = [UNNotificationAction actionWithIdentifier:@"com.elonchan.no"
                                                                                   title:@"Decline"
                                                                                 options:UNNotificationActionOptionDestructive];
        UNNotificationAction *snoozeAction = [UNNotificationAction actionWithIdentifier:@"com.elonchan.snooze"
                                                                                  title:@"Snooze"
                                                                                options:UNNotificationActionOptionDestructive];
        NSArray *notificationActions = @[ acceptAction, declineAction, snoozeAction ];
        
        // create a category
        UNNotificationCategory *inviteCategory = [UNNotificationCategory categoryWithIdentifier:CYLInviteCategoryIdentifier
                                                                                        actions:notificationActions
                                                                              intentIdentifiers:@[]
                                                                                        options:UNNotificationCategoryOptionCustomDismissAction];
        
        
        
        NSSet *categories = [NSSet setWithObject:inviteCategory];
        
        // registration
        [center setNotificationCategories:categories];
#endif
    } else if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        // create actions
        UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
        acceptAction.identifier = @"com.elonchan.yes";
        acceptAction.title = @"Accept";
        acceptAction.activationMode = UIUserNotificationActivationModeBackground;
        acceptAction.destructive = NO;
        acceptAction.authenticationRequired = NO; //If YES requies passcode, but does not unlock the device
        
        UIMutableUserNotificationAction *declineAction = [[UIMutableUserNotificationAction alloc] init];
        declineAction.identifier = @"com.elonchan.no";
        acceptAction.title = @"Decline";
        acceptAction.activationMode = UIUserNotificationActivationModeBackground;
        declineAction.destructive = YES;
        acceptAction.authenticationRequired = NO;
        
        UIMutableUserNotificationAction *snoozeAction = [[UIMutableUserNotificationAction alloc] init];
        snoozeAction.identifier = @"com.elonchan.snooze";
        acceptAction.title = @"Snooze";
        snoozeAction.activationMode = UIUserNotificationActivationModeBackground;
        snoozeAction.destructive = YES;
        snoozeAction.authenticationRequired = NO;
        
        // create a category
        UIMutableUserNotificationCategory *inviteCategory = [[UIMutableUserNotificationCategory alloc] init];
        inviteCategory.identifier = CYLInviteCategoryIdentifier;
        NSArray *notificationActions = @[ acceptAction, declineAction, snoozeAction ];
        
        [inviteCategory setActions:notificationActions forContext:UIUserNotificationActionContextDefault];
        [inviteCategory setActions:notificationActions forContext:UIUserNotificationActionContextMinimal];
        
        // registration
        NSSet *categories = [NSSet setWithObject:inviteCategory];
        UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    
    /// 2. request authorization for localNotification
    
    [self registerNotificationSettingsCompletionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"request authorization succeeded!");
            [self showAlert];
        }
    }];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10.0")) {
#if XCODE_VERSION_GREATER_THAN_OR_EQUAL_TO_8
        // //Deliver the notification at 08:30 everyday
        // NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        // dateComponents.hour = 8;
        // dateComponents.minute = 30;
        // UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:dateComponents repeats:YES];
        
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        content.title = [NSString localizedUserNotificationStringForKey:@"Hi:" arguments:nil];
        NSString *notificationText = [NSString stringWithFormat:@"%@ %@ %@",@"Hospital available distance is",strDistance,@"from here!"];
        content.body = [NSString localizedUserNotificationStringForKey:notificationText
                                                             arguments:nil];
        content.sound = [UNNotificationSound defaultSound];
        content.categoryIdentifier = @"com.elonchan.localNotification";
        /// 4. update application icon badge number
        content.badge = @([[UIApplication sharedApplication] applicationIconBadgeNumber] + 1);
        content.launchImageName = @"img1";
        // Deliver the notification in five seconds.
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger
                                                      triggerWithTimeInterval:60.f repeats:YES];
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"FiveSecond"
                                                                              content:content trigger:trigger];
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        /// 3. schedule localNotification,The delegate must be set before the application returns from applicationDidFinishLaunching:.
        // center.delegate = self;
        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            if (!error) {
                NSLog(@"add NotificationRequest succeeded!");
            }
        }];
#endif
    } else {
        /// 3. schedule localNotification
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:5.f];
        localNotification.alertTitle = @"Hi!";
        NSString *notificationText = [NSString stringWithFormat:@"%@ %@ %@",@"Hospital available distance is",strDistance,@"from here!"];
        localNotification.alertBody = notificationText;
        localNotification.alertAction = @" ";
        //Identifies the image used as the launch image when the user taps (or slides) the action button (or slider).
        localNotification.alertLaunchImage = @"AppIcon.png";
        localNotification.userInfo = @{ @"CategoryIdentifier" : CYLInviteCategoryIdentifier };
        
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        //repeat evey minute,  0 means don't repeat
        localNotification.repeatInterval = NSCalendarUnitMinute;
        /// 4. update application icon badge number
        localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        [self showAlert];
    }
}

- (void)registerNotificationSettingsCompletionHandler:(void (^)(BOOL granted, NSError *__nullable error))completionHandler; {
    /// 2. request authorization for localNotification
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10.0")) {
#if XCODE_VERSION_GREATER_THAN_OR_EQUAL_TO_8
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert)
                              completionHandler:completionHandler];
#endif
    } else if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))  {
        UIUserNotificationSettings *userNotificationSettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge)
                                                                                                 categories:nil];
        UIApplication *application = [UIApplication sharedApplication];
        [application registerUserNotificationSettings:userNotificationSettings];
        //FIXME:
        // !completionHandler ?: completionHandler(granted, error);
    }
}

- (void)stopNotification:(id)sender {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10.0")) {
#if XCODE_VERSION_GREATER_THAN_OR_EQUAL_TO_8
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        // remove all local notification:
        [center removeAllPendingNotificationRequests];
        // or you can remove specifical local notification:
        //         [center removePendingNotificationRequestsWithIdentifiers:@[ CYLInviteCategoryIdentifier ]];
#endif
    } else {
        // remove all local notification:
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        // or you can remove specifical local notification:
        //        NSString *specificalIDToCancel = CYLInviteCategoryIdentifier;
        
        //        UILocalNotification *notificationToCancel = nil;
        //        for(UILocalNotification *aNotif in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        //            if([[aNotif.userInfo objectForKey:@"CategoryIdentifier"] isEqualToString:specificalIDToCancel]) {
        //                notificationToCancel = aNotif;
        //                break;
        //            }
        //        }
        //        if(notificationToCancel) {
        //            [[UIApplication sharedApplication] cancelLocalNotification:notificationToCancel];
        //        }
    }
}


- (void)showAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"please enter background now"
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil];
    [alert show];
    int delayInSeconds = 1;
    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(when, dispatch_get_main_queue(), ^{
        [alert dismissWithClickedButtonIndex:0 animated:YES];
    });
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
