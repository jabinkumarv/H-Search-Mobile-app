//
//  AppDelegate.h
//  TestApp
//
//  Created by Jabin on 10/12/16.
//  Copyright (c) 2016 Jabin. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FeedsData : NSObject
{
    NSString *feedTitle;
    NSString *feedImageUrl;
    NSString *feedDescription;
    NSString *feedLocationLatStr;
    NSString *feedLocationLongStr;
    NSString *feedLocationName;
    UIImage *imageCache;
}

@property(strong, nonatomic) NSString *feedTitle;
@property(strong, nonatomic) NSString *feedImageUrl;
@property(strong, nonatomic) NSString *feedDescription;
@property(strong, nonatomic) UIImage *imageCache;
@property (strong, nonatomic) NSString *feedLocationLatStr;
@property (strong, nonatomic) NSString *feedLocationLongStr;
@property (strong, nonatomic)  NSString *feedLocationName;
@end
