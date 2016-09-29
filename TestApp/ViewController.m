//
//  ViewController.m
//  TestApp
//
//  Created by Jabin on 10/12/16.
//  Copyright (c) 2016 Jabin. All rights reserved.
//

#import "ViewController.h"
#import "UIView+AutolayoutHelper.h"
#import "ContentsTableViewCell.h"
#import "ServiceHelper.h"
#import "FeedsData.h"
#import "Reachability.h"
#import "ConstantFile.h"
#import "MapViewController.h"

/// 1. import UserNotifications
///    Notification become independent from UIKit
#if XCODE_VERSION_GREATER_THAN_OR_EQUAL_TO_8
@import UserNotifications;
#endif
static NSString *const CYLInviteCategoryIdentifier = @"com.elonchan.localNotification";

@interface ViewController ()  <UNUserNotificationCenterDelegate>
{
    NSMutableArray *feedsArray;
    UIActivityIndicatorView *activityIndicator;
    ContentsTableViewCell *cell;
    NSMutableArray * arrGetDistanceFromCurrentLoc;
    
    MapViewController *mapViewController;
    
    NSIndexPath *indexPathofRow;
    
    
    
}

@property(strong, nonatomic) NSMutableArray *feedsArray;


@end

@implementation ViewController
@synthesize feedsTableView;
@synthesize feedsArray;
@synthesize locationManager;
@synthesize currLat,currLong;

#pragma mark - ==========UIViewController Delegates Methods==============
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title=kTitle;
    
    feedsArray=[[NSMutableArray alloc]init];
    
    self.feedsTableView = [[UITableView alloc]init];
    
    self.feedsTableView.delegate=self;
    self.feedsTableView.dataSource=self;
    self.feedsTableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.feedsTableView];
    [self.view fitView:self.feedsTableView];
    
    activityIndicator=[[UIActivityIndicatorView alloc]init];
    activityIndicator.color=[UIColor blackColor];
    activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:activityIndicator];
    [self.view fitView:activityIndicator];
    
    activityIndicator.hidden=YES;
    currLat = @"12.824635";
    currLong = @"80.222215";
    
    UIBarButtonItem *flipButton = [[UIBarButtonItem alloc]
                                   initWithTitle:kTitleRefreshBtn
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(getCurrentLocation:)];
    
    
//    UISlider *slider = [[UISlider alloc]initWithFrame:CGRectMake(10,10, 100, 40)];
//    slider.backgroundColor = [UIColor redColor];
//    slider.minimumValue = 0.5;
//    slider.maximumValue = 5.0;
//    slider.value = 3.0;
//   // [sliderView addSubview:slider];
    
    self.navigationItem.rightBarButtonItem = flipButton;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
    self.feedsTableView.estimatedRowHeight = kTableRowHeight;
    
    self.feedsTableView.rowHeight = UITableViewAutomaticDimension;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(OrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}
- (void)getCurrentLocation:(id)sender {
 
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager startUpdatingLocation];

    }else{
        [self.locationManager startUpdatingLocation];
    }

}
-(void)viewWillAppear:(BOOL)animated
{
  

    [super viewWillAppear:YES];
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    self.feedsTableView.rowHeight = UITableViewAutomaticDimension;
    
    //declare constant lat and long
  
    [self getDataFromServer];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.feedsTableView reloadData];
}



#pragma mark - ==========Webservice call and Data consuming on UI==============
// -------------------------------------------------------------------------------
/*
 @method        getDataFromServer
 @abstract      gets the data from server and load in to UITableview
 @param         nil
 @return        void
 */
// -------------------------------------------------------------------------------

-(void)setDistance{
    UIView *sliderView = [[UIView alloc]initWithFrame:CGRectMake(50, 220, 250, 100)];
    sliderView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:sliderView];
    
    UISlider *slider = [[UISlider alloc]initWithFrame:CGRectMake(10,20, 230, 60)];
    slider.backgroundColor = [UIColor darkGrayColor];
    slider.minimumValue = 0.5;
    slider.maximumValue = 5.0;
    slider.value = 3.0;
    [slider addTarget:self action:@selector(getValue:) forControlEvents:UIControlEventValueChanged];
    [sliderView addSubview:slider];
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, 100, 50)];
    label.textColor = [UIColor blackColor];
    label.text = [NSString stringWithFormat:@"%f", slider.value];
    [sliderView addSubview:label];
 
    
}
-(void)getValue:(UISlider *)sValue{
    NSLog(@"%@",sValue);
    
    
//    label = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, 100, 50)];
//    label.textColor = [UIColor greenColor];
//label.text = [NSString stringWithFormat:@"%f", slider.value];
   //// [sliderView addSubview:label];
    label.text = [NSString stringWithFormat:@"%f",sValue.value];

}
-(void)getDataFromServer
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    BOOL isConnectedToInternet = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable;
    activityIndicator.hidden = NO;
    [activityIndicator startAnimating];
    self.view.userInteractionEnabled=NO;
    if (isConnectedToInternet) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),  ^{
            //feedsArray=[ServiceHelper feedsList:^(NSError *error){
            feedsArray = [ServiceHelper feedsList:currLat longString:currLong withCallbackBlock:^(NSError *error) {
        
            }];;
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
                [activityIndicator stopAnimating];
                activityIndicator.hidden = YES;
                self.view.userInteractionEnabled=YES;
                [self getAllLatandLongDistance];
                
                [self.feedsTableView reloadData];
            });
        });
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kErrorMessageTitle message:kErrorMessageForNetworkConnection delegate:self cancelButtonTitle:kTextOK otherButtonTitles:nil];
        [alert show];
    }
    
}

-(void)getAllLatandLongDistance{
    
   arrGetDistanceFromCurrentLoc=[[NSMutableArray alloc]init];
    for (FeedsData *localtrends_obj in feedsArray) {
        // model object                       // whole array
        // self.latitude = @"12.982672";
        //  self.longitude = @"80.263380";
        NSString *strServerLat=localtrends_obj.feedLocationLatStr;
        NSString *strServerLong =localtrends_obj.feedLocationLongStr ;
       // NSString *strCurrentLat = @"12.982672";
        double latitude = 12.8250437;
        double longitude = 80.2203972;
  // nslog(@"strServerLat====%@",strServerLat);
  // nslog(@"strServerLong====%@",strServerLong);
   CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude: latitude longitude:longitude];
        
CLLocation *serverLocation = [[CLLocation alloc] initWithLatitude:[strServerLat doubleValue]longitude:[strServerLong
                                                                                                    doubleValue]];
 float KilometersFromLatLong= [currentLocation distanceFromLocation:serverLocation]/1609.344;
                               
 NSString *strLatandLon=[NSString stringWithFormat:@"%.02f%@",KilometersFromLatLong,@" Miles"];
                                        
[arrGetDistanceFromCurrentLoc addObject:strLatandLon];
        
        NSLog(@"arrGetDistanceFromCurrentLoc === %@",arrGetDistanceFromCurrentLoc);
        }
    
}

#pragma mark - ==========UITableView Delegats Methods====================

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // The number of sections is based on the number of items in the data property list.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return feedsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedsData *feedsDetail=[feedsArray objectAtIndex:indexPath.row];
    CGRect textHeight = [feedsDetail.feedDescription boundingRectWithSize:CGSizeMake(self.view.frame.size.width-160, 0)
                                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                                               attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                                                                  context:nil];
    if (textHeight.size.height<50) {
        return kTableRowHeight-50;
    }else if (textHeight.size.height<110) {
        return kTableRowHeight;
    }else
    {
        return textHeight.size.height+40;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cellObj forRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    [cellObj setBackgroundColor:[UIColor clearColor]];
    
    CAGradientLayer *grad = [CAGradientLayer layer];
    
    grad.frame = cellObj.bounds;
    
    grad.colors = [NSArray arrayWithObjects:(id)[[UIColor brownColor] CGColor], (id)[[UIColor whiteColor] CGColor], nil];
    
    [cellObj setBackgroundView:[[UIView alloc] init]];
    
    [cellObj.backgroundView.layer insertSublayer:grad atIndex:0];
    
    CAGradientLayer *selectedGrad = [CAGradientLayer layer];
    
    selectedGrad.frame = cellObj.bounds;
    
    selectedGrad.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[UIColor greenColor] CGColor], nil];
    
    [cellObj setSelectedBackgroundView:[[UIView alloc] init]];
    
    [cellObj.selectedBackgroundView.layer insertSublayer:selectedGrad atIndex:0];
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    indexPathofRow =  indexPath;
    
    NSLog(@"FeedsArray -> %@",[[feedsArray objectAtIndex:indexPath.row]valueForKey:@"feedTitle"]);
    
    mapViewController = [[MapViewController alloc]init];
    
    mapViewController.latValue = [[self.feedsArray objectAtIndex:indexPathofRow.row] valueForKey:@"feedLocationLatStr"];
    mapViewController.longValue = [[self.feedsArray objectAtIndex:indexPathofRow.row] valueForKey:@"feedLocationLongStr"];
    mapViewController.distance = [arrGetDistanceFromCurrentLoc objectAtIndex:indexPathofRow.row];
    mapViewController.placeName = [[self.feedsArray objectAtIndex:indexPathofRow.row]valueForKey:@"feedTitle"];
    
    [[NSUserDefaults standardUserDefaults] setObject:mapViewController.latValue forKey:@"feedLocationLatStr"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [[NSUserDefaults standardUserDefaults] setObject:mapViewController.longValue forKey:@"feedLocationLongStr"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    // Notification Added
    [self triggerNotification:nil];
    
    [self.navigationController pushViewController:mapViewController animated:YES];
    
    NSLog(@"%@ %@",mapViewController.longValue,mapViewController.latValue);
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = kCellIdentifier;
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.backgroundColor=[UIColor clearColor];
    
    if (cell == nil)
    {
        cell = [[ContentsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    
    cell.itemTitle.preferredMaxLayoutWidth = CGRectGetWidth(cell.itemTitle.frame);
    cell.itemDescription.preferredMaxLayoutWidth = CGRectGetWidth(cell.itemDescription.frame);
    
    if (indexPath.row<[self.feedsArray count]) {
        FeedsData *feedsDetail=[feedsArray objectAtIndex:indexPath.row];
        
        // set default user image while image is being downloaded
        [cell.itemImage setImage:[UIImage imageNamed:kErrorImage]];
        
        if (feedsDetail.imageCache) {
            cell.itemImage.image = feedsDetail.imageCache;
        } else {
            // download the image asynchronously
            if (feedsDetail.feedImageUrl.length==0) {
                cell.itemImage.image=[UIImage imageNamed:kErrorImage];
                feedsDetail.imageCache=[UIImage imageNamed:kErrorImage];
            }else
            {
                NSURL *imageURL = [NSURL URLWithString:feedsDetail.feedImageUrl];
                [ServiceHelper downloadImageWithURL:imageURL completionBlock:^(BOOL succeeded, UIImage *image) {
                    if (succeeded) {
                        // change the image in the cell
                        cell.itemImage.image = image;
                        
                        feedsDetail.imageCache=image;
                    }
                }];
            }
        }
        
        [cell.itemTitle setText:feedsDetail.feedTitle];
        [cell.itemTitle setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17]];
        [cell.itemDescription setText:feedsDetail.feedDescription];
        [cell.itemDescription setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:15]];
        [cell.itemDescription setTextColor:[UIColor blackColor]];

    }
    
    return cell;
}
/*
#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
      //  longitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
      //  latitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    }
}
 */

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        currLong = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        currLat = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        
        [self.locationManager stopUpdatingLocation];
        [self getDataFromServer];
    }
}
-(void)OrientationDidChange:(NSNotification*)notification

{
    UIDeviceOrientation Orientation=[[UIDevice currentDevice]orientation];
    
    if(Orientation==UIDeviceOrientationLandscapeLeft || Orientation==UIDeviceOrientationLandscapeRight)
    {
        [self.feedsTableView reloadData];
    }else if(Orientation==UIDeviceOrientationPortrait)
    {
        
    }
}

#pragma mark ======== Notification Delegates =================
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
        content.title = [NSString localizedUserNotificationStringForKey:@"Hi" arguments:nil];
        NSString *notificationText = [NSString stringWithFormat:@"%@ %@ %@",@"Hospital available distance is",mapViewController.distance,@"from here!"];
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
        localNotification.alertTitle = @"Hi";
        NSString *notificationText = [NSString stringWithFormat:@"%@ %@ %@",@"Hospital available distance is",mapViewController.distance,@"from here!"];
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

// The method will be called on the delegate when the user responded to the notification by opening the application, dismissing the notification or choosing a UNNotificationAction. The delegate must be set before the application returns from applicationDidFinishLaunching:.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void(^)())completionHandler {
    NSLog(@"Tapped in notification");
    
    mapViewController.latValue = [[self.feedsArray objectAtIndex:indexPathofRow.row] valueForKey:@"feedLocationLatStr"];
    mapViewController.longValue = [[self.feedsArray objectAtIndex:indexPathofRow.row] valueForKey:@"feedLocationLongStr"];
    mapViewController.distance = [arrGetDistanceFromCurrentLoc objectAtIndex:indexPathofRow.row];

    [self.navigationController pushViewController:mapViewController animated:YES];

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
           // NSString *title = @"Notification accept";
           // [self addLabel:title backgroundColor:[UIColor yellowColor]];
            break;
        }
        if (decline) {
           // NSString *title = @"Notification decline";
           // [self addLabel:title backgroundColor:[UIColor redColor]];
            break;
        }
        if (snooze) {
           // NSString *title = @"Notification snooze";
            //[self addLabel:title backgroundColor:[UIColor redColor]];
        }
    } while (NO);
    // Must be called when finished
    completionHandler();
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
