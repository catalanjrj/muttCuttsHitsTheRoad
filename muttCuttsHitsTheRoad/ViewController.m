//
//  ViewController.m
//  muttCuttsHitsTheRoad
//
//  Created by Jorge Catalan on 6/5/16.
//  Copyright © 2016 Jorge Catalan. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "Location.h"

@interface ViewController ()<CLLocationManagerDelegate>

@property (strong,nonatomic) MKMapView *mapView;
@property (strong,nonatomic)CLLocationManager *manager;
@property(strong,nonatomic)NSMutableArray<Location *> *selectedLocations;


@property(strong,nonatomic)UIView *distanceView;
@property(strong,nonatomic)UILabel *distanceLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    CGRect theFrame = self.view.frame;
    //the rect of a view controller is read-only
    //frame is a sturct
    theFrame.origin.x = 20;
    theFrame.origin.y = 94;
    theFrame.size.width -= 40;
    theFrame.size.height -=114;
    
    self.manager = [[CLLocationManager alloc]init];
    [self.manager requestAlwaysAuthorization];
    
    //create mapView and store in local property.
    self.mapView = [[MKMapView alloc]initWithFrame:theFrame];
    
    self.mapView.showsUserLocation = YES;
    
    [self.view addSubview:self.mapView];
    
    Location * capitalBuilding = [[Location alloc] initWithCoord:CLLocationCoordinate2DMake(35.7804, -78.6391) title:@"Capital Building" subtitle:@"The place where the capital is"];
    self.manager.delegate = self;
    [self.manager startUpdatingLocation];
    [self.mapView addAnnotation:capitalBuilding];
    
    
    CLLocation*capitalLocation = [[CLLocation alloc]initWithLatitude:capitalBuilding.coordinate.latitude longitude:capitalBuilding.coordinate.longitude];
    
    CLLocation *currentLocation = self.mapView.userLocation.location;
    if(currentLocation && capitalLocation){
        
        [self zoomMapToRegionEncapsulatingLocation:capitalLocation andLocation:currentLocation];
    }
    
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)centerMapOnLocation:(CLLocationCoordinate2D)location{
    
    
}
-(void)zoomMapToRegionEncapsulatingLocation:(CLLocation*)firstLoc andLocation:(CLLocation*)secondLoc{
    
    float lat = (firstLoc.coordinate.latitude + secondLoc.coordinate.latitude) /2 ;
    float longitude = (firstLoc.coordinate.longitude + secondLoc.coordinate.longitude)/2;
    
    CLLocationDistance distance = [firstLoc distanceFromLocation:secondLoc]/111.0f;
    
    CLLocation *centerLocation = [[CLLocation alloc]initWithLatitude: lat longitude:longitude];
    
    MKCoordinateSpan span = MKCoordinateSpanMake(distance,distance);
    
    MKCoordinateRegion region = MKCoordinateRegionMake(centerLocation.coordinate, span);
    
    [self.mapView setRegion:region animated:YES];
    
    
}

#pragma mark CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation* firstLocation = [locations firstObject];
    CLLocation* lastLocation = [locations lastObject];
    if ([firstLocation isEqual:lastLocation]) {
        NSLog(@"SAME PLACE!!");
    }else{
        NSLog(@"WHO KNOWS!!");
    }
    Location * capitalBuilding = [[Location alloc] initWithCoord:
                                  
                                  CLLocationCoordinate2DMake(35.7804, -78.6391) title:@"Capital Building" subtitle:@"The place where the capital is"];
    
    
    CLLocation*capitalLocation = [[CLLocation alloc]initWithLatitude:capitalBuilding.coordinate.latitude longitude:capitalBuilding.coordinate.longitude];
    
    CLLocation *currentLocation = firstLocation;
    if(currentLocation && capitalLocation){
        
        [self zoomMapToRegionEncapsulatingLocation:capitalLocation andLocation:currentLocation];
    }
    [manager stopUpdatingLocation];
}

@end

