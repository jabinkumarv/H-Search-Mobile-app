//
//  AppDelegate.h
//  TestApp
//
//  Created by Jabin on 10/12/16.
//  Copyright (c) 2016 Jabin. All rights reserved.
//


#import "ServiceHelper.h"
#import "ConstantFile.h"

@implementation ServiceHelper

#pragma mark ============HTTP Methods======================
// -------------------------------------------------------------------------------
/*
 @method        stringWithUrl
 @abstract      gets the data from server and load in to UITableview
 @param         postData --> Form the JSON to send the server and get response
 @param         url --> Pass the url to get the respose
 @param         url --> Define the RESTpull method GET/POST
 @return        NSDictionary - get the JSON response
 */
// -------------------------------------------------------------------------------

+ (NSDictionary *)stringWithUrl:(NSURL *)url postData:(NSData *)postData httpMethod:(NSString *)method withCallbackBlock:(void (^)(NSError *error)) callback
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

#pragma ==================Service requset ==========================
// -------------------------------------------------------------------------------
/*
 @method        feedsList
 @abstract      gets the data from server and load in to UITableview
 @param         nil
  @return       NSMutableArray - JSON response added in to array using Model object
 */
// -------------------------------------------------------------------------------

+ (NSMutableArray *)feedsList:(NSString *)LatString  longString:(NSString *)LongString withCallbackBlock:(void (^)(NSError *error)) callback

//+(NSMutableArray *)feedsList:(void (^)(NSError *error)) callback
{
    FeedsData *feeds;
    NSMutableArray *allfeeds = nil;
    
    @try
    {
        NSError *error;

        NSString *serviceOperationUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%@,%@&rankby=distance&types=hospital&key=AIzaSyB2JHCWEC7xuEbORA-0MbYpHIliqCUxTiA",LatString,LongString];
        
        NSURL *serviceUrl = [NSURL URLWithString:[serviceOperationUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
        
        id response = [ServiceHelper stringWithUrl:serviceUrl postData:nil httpMethod:@"GET"withCallbackBlock:^(NSError *error){
            callback(nil);
        }];
        
        response=[response valueForKey:@"results"];
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
                [feeds setFeedTitle:[self checkEmptyValue:[List valueForKey:@"name"]]];
                [feeds setFeedDescription:[self checkEmptyValue:[List valueForKey:@"vicinity"]]];
                [feeds setFeedImageUrl:[self checkEmptyValue:[List valueForKey:@"icon"]]];
                [feeds setFeedLocationLatStr:[self checkEmptyValue:[[[List valueForKey:@"geometry"] valueForKey:@"location"] valueForKey:@"lat"]]];
                [feeds setFeedLocationLongStr:[self checkEmptyValue:[[[List valueForKey:@"geometry"] valueForKey:@"location"] valueForKey:@"lng"]]];
                [allfeeds addObject:feeds];
            }
        }
        else{
            [ServiceHelper createNSError:0 errString:kErrorMsgURL errObject:&error];
            callback(error);
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


// -------------------------------------------------------------------------------
/*
 @method        downloadImageWIthURL
 @abstract      gets the image from server and load in to UITableview
 @param         ImageUrl
 @return        void
 */
// -------------------------------------------------------------------------------

+(void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}

#pragma mark - ==========Check for empty values and NSNull check======

// -------------------------------------------------------------------------------
/*
 @method        checkEmptyValue
 @abstract      To check empty/nil values from JSON response
 @param         string --> passing string values
 @return       NSString
 */
// -------------------------------------------------------------------------------
+(NSString *)checkEmptyValue:(id )string
{
    NSString *displayNameType = @"";
    if (string != [NSNull null])
        displayNameType = (NSString *)string;
    
    return displayNameType;
}


#pragma mark - ==========Error code with Message====================

// -------------------------------------------------------------------------------
/*
 @method        createNSError
 @abstract      To create a Error values and description
 @param         errCode --> define error code -(400/402)
 @param         aString --> define error description
 @param         anObject --> define error object to reflect the condition check
 @return       BOOL
 */
// -------------------------------------------------------------------------------

+ (BOOL)createNSError:(NSInteger)errCode errString:(NSString *)aString errObject:(NSError **)anObject {
    if (anObject) {
        NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
        [errorDetail setValue:aString forKey:NSLocalizedDescriptionKey];
        *anObject = [NSError errorWithDomain:aString code:errCode userInfo:errorDetail];
        return TRUE;
    }
    
    return FALSE;
}
@end
