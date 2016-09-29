//
//  AppDelegate.h
//  TestApp
//
//  Created by Anand on 10/15/15.
//  Copyright (c) 2015 Anand. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FeedsData.h"

@interface HelperClass : NSObject<NSURLConnectionDelegate>
{
    NSMutableData *receivedData;
    NSURLConnection *connection;
    id currentReceivedData;
}


+ (NSDictionary *)stringWithUrl:(NSURL *)url postData:(NSData *)postData httpMethod:(NSString *)method;
+(NSString *)checkEmptyValue:(id )string;
+(NSMutableArray *)feedsList;
+(HelperClass *)helperInstance;

@end
