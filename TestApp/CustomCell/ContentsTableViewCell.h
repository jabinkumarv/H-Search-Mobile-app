//
//  AppDelegate.h
//  TestApp
//
//  Created by Jabin on 10/12/16.
//  Copyright (c) 2016 Jabin. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface ContentsTableViewCell : UITableViewCell
{
    UIImageView *itemImage;
    UILabel *itemTitle;
    UILabel *itemDescription;
    UILabel *lblDistance;

}

@property (nonatomic, strong) UIImageView *itemImage;
@property (nonatomic, strong) UILabel *itemTitle;
@property (nonatomic, strong) UILabel *itemDescription;

@property (nonatomic, strong) UILabel *lblDistance;

@end
