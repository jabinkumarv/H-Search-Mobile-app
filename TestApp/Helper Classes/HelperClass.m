//
//  AppDelegate.h
//  TestApp
//
//  Created by Anand on 10/15/15.
//  Copyright (c) 2015 Anand. All rights reserved.
//


#import "HelperClass.h"

@implementation HelperClass

#pragma mark HTTP Methods
+ (NSDictionary *)stringWithUrl:(NSURL *)url postData:(NSData *)postData httpMethod:(NSString *)method
{
    NSDictionary *returResponse=[[NSDictionary alloc]init];
    
    @try
    {
        
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
        
        [urlRequest setHTTPMethod:method];
        
        if(postData != nil)
        {
            [urlRequest setHTTPBody:postData];
        }
        
        [urlRequest setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
        [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        // Fetch the JSON response
        NSData *urlData;
        NSURLResponse *response;
        
        NSError *error;
        
        // Sending the request
        
        // Make synchronous request
        urlData = [NSURLConnection sendSynchronousRequest:urlRequest
                                        returningResponse:&response
                                                    error:&error];
        NSString *strFileContent = [[NSString alloc] initWithData:urlData encoding:kNilOptions];
        
        returResponse=[NSJSONSerialization JSONObjectWithData:[strFileContent dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
        NSLog(@"Return Response--->%@",returResponse);
        return returResponse;
    }
    @catch (NSException *exception)
    {
        returResponse = nil;
    }
    @finally
    {
        return returResponse;
    }
}

#pragma-mark Data List
+(NSMutableArray *)feedsList
{
    FeedsData *feeds;
    NSMutableArray *allfeeds = nil;
    
    @try
    {
        NSString *serviceOperationUrl = [NSString stringWithFormat:@"https://dl.dropboxusercontent.com/u/746330/facts.json"];
        
        NSURL *serviceUrl = [NSURL URLWithString:[serviceOperationUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
        
        id response = [HelperClass stringWithUrl:serviceUrl postData:nil httpMethod:@"GET"];
        response=[response valueForKey:@"rows"];
        
        if ((response != nil) && [response count]>0)
        {
            id List=nil;
            
            if(allfeeds == nil)
            {
                allfeeds = [[NSMutableArray alloc] init];
            }
            
            NSEnumerator *enumerator = [response objectEnumerator];
            
            while(List=[enumerator nextObject])
            {
                feeds= [[FeedsData alloc] init];
                //Parsing Data
                [feeds setFeedTitle:[self checkEmptyValue:[List valueForKey:@"title"]]];
                [feeds setFeedDescription:[self checkEmptyValue:[List valueForKey:@"description"]]];
                [feeds setFeedImageUrl:[self checkEmptyValue:[List valueForKey:@"imageHref"]]];
                [allfeeds addObject:feeds];
                
            }
        }
        
        
    }
    @catch (NSException *exception)
    {
        allfeeds=nil;
    }
    @finally
    {
        return allfeeds;
    }
}

#pragma mark - Check for empty values
+(NSString *)checkEmptyValue:(id )string
{
    NSString *displayNameType = @"";
    if (string != [NSNull null])
        displayNameType = (NSString *)string;
    
    return displayNameType;
}


static HelperClass *temp=nil;
+(HelperClass *)helperInstance
{
    if (!temp) {
        temp=[[HelperClass alloc]init];
    }
    return temp;
}

@end
