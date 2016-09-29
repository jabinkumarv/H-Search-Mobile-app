//
//  MapAnnotation.m
//  TestApp
//
//  Created by Jabin on 9/13/16.
//  Copyright © 2016 Anand. All rights reserved.
//

#import "MapAnnotation.h"

@implementation MapAnnotation

-(id)initWithTitle:(NSString *)title andCoordinate:
(CLLocationCoordinate2D)coordinate2d{
    self.title = title;
    self.coordinate =coordinate2d;
    return self;
}
@end
