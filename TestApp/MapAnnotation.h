//
//  MapAnnotation.h
//  TestApp
//
//  Created by Jabin on 9/13/16.
//  Copyright © 2016 Anand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface MapAnnotation : NSObject <MKAnnotation>
@property (nonatomic, copy) NSString *title;
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;

- (id)initWithTitle:(NSString *)title andCoordinate:
(CLLocationCoordinate2D)coordinate2d;

@end
