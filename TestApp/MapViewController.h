//
//  MapViewController.h
//  TestApp
//
//  Created by Jabin on 9/12/16.
//  Copyright © 2016 Anand. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@interface MapViewController : UIViewController<MKMapViewDelegate>{
    NSString *latValue;
    NSString  *longValue;
    MKMapView *mapView;
    NSString* placeName;
    
    CLLocationCoordinate2D location;

}
@property (nonatomic) NSString* latValue;
@property (nonatomic) NSString* longValue;
@property (nonatomic) NSString* distance;
@property (nonatomic) NSString* placeName;

@end
