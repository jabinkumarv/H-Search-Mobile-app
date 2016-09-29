//
//  ConstantFile.h
//  TestApp
//
//  Created by Anand on 10/19/15.
//  Copyright (c) 2016 Jabin. All rights reserved.
//


#ifndef ConstantFile_h
#define ConstantFile_h

#define kServiceURL                       @"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=12.824605,80.222015&rankby=distance&types=hospital&key=AIzaSyB2JHCWEC7xuEbORA-0MbYpHIliqCUxTiA"

//@"https://dl.dropboxusercontent.com/u/746330/facts.json"
#define kErrorMsgURL                      @"Please check the Service URL"

#define kTitle                            @"H-Search"
#define kTitleRefreshBtn                  @"MyPlace"
#define kErrorMessageTitle                @"Oops!"
#define kErrorMessageForNetworkConnection @"Please check your network connection."
#define kTextOK                           @"Ok"
#define kCellIdentifier                   @"CellIdentifier"
#define kErrorImage                       @"noImageError.png"

#define kTableRowHeight                   160

#define XCODE_VERSION_GREATER_THAN_OR_EQUAL_TO_8    __has_include(<UserNotifications/UserNotifications.h>)
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


#endif /* ConstantFile_h */
