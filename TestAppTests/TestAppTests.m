//
//  TestAppTests.m
//  TestAppTests
//
//  Created by Jabin on 10/12/16.
//  Copyright (c) 2016 Jabin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ServiceHelper.h"
#import "ViewController.h"
#import "ConstantFile.h"


@interface TestAppTests : XCTestCase

@property(nonatomic,strong) ViewController *vcObj;

@end

@implementation TestAppTests

- (void)setUp {
    [super setUp];
    
    self.vcObj = [[ViewController alloc] init];
    [self.vcObj performSelectorOnMainThread:@selector(loadView) withObject:nil waitUntilDone:YES];
    [self.vcObj view];

    
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

#pragma mark - View loading tests
-(void)testThatViewLoads
{
    XCTAssertNotNil(self.vcObj.view, @"View  initiated properly");
}

- (void)testParentViewHasTableViewSubview
{
    NSArray *subviews = self.vcObj.view.subviews;
    XCTAssertFalse([subviews containsObject:self.vcObj.self.feedsTableView], @"View does not have a table subview");
}

-(void)testThatTableViewLoads
{
    XCTAssertNil(self.vcObj.self.feedsTableView, @"TableView Not initiated");
}

#pragma mark - UITableView tests
- (void)testThatViewConformsToUITableViewDataSource
{
    XCTAssertTrue([self.vcObj conformsToProtocol:@protocol(UITableViewDataSource) ], @"View does not conform to UITableView datasource protocol");
}



- (void)testServiceCallSuccess {
   
    NSString *serviceOperationUrl = [NSString stringWithFormat:kServiceURL];
    
    NSURL *serviceUrl = [NSURL URLWithString:[serviceOperationUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
    
    id response = [ServiceHelper stringWithUrl:serviceUrl postData:nil httpMethod:@"GET" withCallbackBlock:^(NSError *error) {
    }];
    if(response != nil)
    {
        XCTAssertTrue(response, @"Success response from server");
    }
}

- (void)testServiceCallFailure {
    
    NSString *serviceOperationUrl = [NSString stringWithFormat:kServiceURL];
    
    NSURL *serviceUrl = [NSURL URLWithString:[serviceOperationUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
    
    id response = [ServiceHelper stringWithUrl:serviceUrl postData:nil httpMethod:@"GET" withCallbackBlock:^(NSError *error) {
    }];
    if(response == nil)
    {
        XCTAssertTrue(response, @"Failure response from server");
    }
}


@end
