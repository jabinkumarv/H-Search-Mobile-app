//
//  ViewController.h
//  TestApp
//
//  Created by Jabin on 10/12/16.
//  Copyright (c) 2016 Jabin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>
{
    UITableView *feedsTableView;
    UILabel *label ;
    CLLocationManager *locationManager;

    NSString *currLat, *currLong;
}
@property(strong, nonatomic) UITableView *feedsTableView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSString *currLat, *currLong;
//+(void)mapVC;

@end

