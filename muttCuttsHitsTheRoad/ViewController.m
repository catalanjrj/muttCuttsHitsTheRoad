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
#import "popOverControllerViewController.h"

@interface ViewController ()<CLLocationManagerDelegate, UIPopoverPresentationControllerDelegate>

@property (strong,nonatomic) MKMapView *mapView;
@property (strong,nonatomic)CLLocationManager *manager;
@property(strong,nonatomic)NSMutableArray<Location *> *selectedLocations;


@property(strong,nonatomic)UIView *distanceView;
@property(strong,nonatomic)UILabel *distanceLabel;

@property(strong,nonatomic)popOverControllerViewController *controller;
@property(strong,nonatomic)UIPopoverPresentationController *popoverController;

-(IBAction)showPopover:(id)sender;
-(IBAction)getLocation:(id)sender;
-(void)stringToLocation:(NSString *)addressString;
-(IBAction)dismiss:(id)sender;
-(IBAction)cancel:(id)sender;

-(void)zoomMapToRegionEncapsulatingLocation;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Mutt Cutts Hits The Road!";
    
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor purpleColor];
    
    self.selectedLocations = [[NSMutableArray alloc]init];
    
    //add bar button for navigation controller
    UIBarButtonItem *popoverButton =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showPopover:)];
    self.navigationController.navigationBar.topItem.rightBarButtonItem = popoverButton;
    UIBarButtonItem *currentLocationButton =[[UIBarButtonItem alloc]initWithTitle:@"Current" style:UIBarButtonItemStylePlain target:self action:@selector(getLocation:)];
    self.navigationController.navigationBar.topItem.leftBarButtonItem = currentLocationButton;
    
    
    CGRect theFrame = self.view.frame;
    //the rect of a view controller is read-only
    //frame is a sturct
    theFrame.origin.x = 0;
    theFrame.origin.y = 64;
    theFrame.size.height -= 64;
    theFrame.size.width -= 0;
    
    CGRect distanceFrame = self.view.frame;
    distanceFrame.origin.x = 20;
    distanceFrame.origin.y = 84;
    distanceFrame.size.height = 50;
    distanceFrame.size.width = self.view.frame.size.width *0.9;
    self.distanceView = [[UIView alloc]initWithFrame:distanceFrame];
    self.distanceView.backgroundColor = [UIColor colorWithWhite:1 alpha: 0.8];
    
    self.distanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.distanceView.frame.size.width, self.distanceView.frame.size.height)];
    self.distanceLabel.textColor = [UIColor blackColor];
    self.distanceLabel.textAlignment = NSTextAlignmentCenter;
    [self.distanceView addSubview:self.distanceLabel];
    
    
    
    //get authorazation to get user location
    self.manager = [[CLLocationManager alloc]init];
    self.manager.delegate = self;
    [self.manager requestAlwaysAuthorization];
    
    //create mapView and store in local property.
    self.mapView = [[MKMapView alloc]initWithFrame:theFrame];
    
    self.mapView.showsUserLocation = YES;
    //add views to main view
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.distanceView];
    
    }
-(void)stringToLocation:(NSString *)addressString{
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    __block Location *addressLocation = nil;
    __block ViewController *weakSelf = self;
    [geoCoder geocodeAddressString:addressString completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if(error){
            NSLog(@"%@",[error description]);
        }else{
            CLPlacemark *placemark = [placemarks lastObject];
            addressLocation = [[Location alloc]initWithCoord:CLLocationCoordinate2DMake(placemark.location.coordinate.latitude, placemark.location.coordinate.longitude) title:placemark.locality  subtitle:@""];
            [weakSelf.mapView addAnnotation:addressLocation];
            [weakSelf.selectedLocations addObject:addressLocation];
            [weakSelf zoomMapToRegionEncapsulatingLocation];
        
        }
    }];

}

-(void)zoomMapToRegionEncapsulatingLocation{
    if(self.selectedLocations.count >= 2){
        CLLocation *firstLocation = [[CLLocation alloc]initWithLatitude:self.selectedLocations[0].coordinate.latitude longitude:self.selectedLocations[0].coordinate.longitude];
        CLLocation *secondLocation = [[CLLocation alloc]initWithLatitude:self.selectedLocations[1].coordinate.latitude longitude:self.selectedLocations[1].coordinate.longitude];

    
    float lat = (firstLocation.coordinate.latitude + secondLocation.coordinate.latitude) /2 ;
    float longitude = (firstLocation.coordinate.longitude + secondLocation.coordinate.longitude)/2;
    CLLocationDistance distance = [firstLocation distanceFromLocation:secondLocation];
    CLLocation *centerLocation = [[CLLocation alloc]initWithLatitude: lat longitude:longitude];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(centerLocation.coordinate, distance, distance);
    
    [self.mapView setRegion:[self.mapView regionThatFits:region]animated:YES];
        
        self.distanceLabel.text = [NSString stringWithFormat:@"Line of sight distance: %f",(distance/1000.0)*0.62137];
        [self.selectedLocations removeAllObjects];
    
    
}
}

#pragma mark = button actions
    -(IBAction)dismiss:(id)sender {
        UITextField *firstAddress = [self.controller.view viewWithTag:1];
        UITextField *secondAdress = [self.controller.view viewWithTag:2];
        [self stringToLocation:firstAddress.text];
        [self stringToLocation:secondAdress.text];
        [self.controller dismissViewControllerAnimated:YES completion:nil];
    }
-(IBAction)cancel:(id)sender{
    [self.controller dismissViewControllerAnimated:YES completion:nil];
    }

-(IBAction)showPopover:(id)sender{
    self.controller = [[popOverControllerViewController alloc]init];
    
    self.controller.modalPresentationStyle = UIModalPresentationPopover;
  
    self.popoverController = [self.controller popoverPresentationController];
    self.popoverController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    self.popoverController.barButtonItem = sender;
    self.popoverController.delegate = self;
    self.popoverController.sourceView = sender;
    
    [self presentViewController:self.controller animated:YES completion:nil];

}
-(IBAction)getLocation:(id)sender{
    [self.manager startUpdatingLocation];
    CLLocation *currentLocation = self.mapView.userLocation.location;
    Location *current = [[Location alloc]initWithCoord:CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude) title:@"current location" subtitle:@""];
    [self.mapView addAnnotation:current];
    [self.manager stopUpdatingLocation];

}

#pragma mark -UIPopoverControllerDelegate
-(BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    return YES;
    }
-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return UIModalPresentationFullScreen;
}
-(UIViewController *)presentationController:(UIPresentationController *)controller viewControllerForAdaptivePresentationStyle:(UIModalPresentationStyle)style{
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:controller.presentedViewController];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    navigationController.navigationBar.topItem.leftBarButtonItem = cancelButton;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismiss:)];
    navigationController.navigationBar.topItem.rightBarButtonItem = doneButton;
    navigationController.navigationBar.barTintColor = [UIColor purpleColor];
    navigationController.navigationBar.tintColor = [UIColor whiteColor];
    return navigationController;


}
#pragma mark - CLLocationManagerDelegate
//-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
//    CLLocation* firstLocation = [locations firstObject];
//    CLLocation* lastLocation = [locations lastObject];
//    if ([firstLocation isEqual:lastLocation]) {
//        NSLog(@"SAME PLACE!!");
//    }else{
//        NSLog(@"WHO KNOWS!!");
//    }
//    Location * capitalBuilding = [[Location alloc] initWithCoord:
//                                  
//                                  CLLocationCoordinate2DMake(35.7804, -78.6391) title:@"Capital Building" subtitle:@"The place where the capital is"];
//    
//    
//    CLLocation*capitalLocation = [[CLLocation alloc]initWithLatitude:capitalBuilding.coordinate.latitude longitude:capitalBuilding.coordinate.longitude];
//    
//    CLLocation *currentLocation = firstLocation;
//    if(currentLocation && capitalLocation){
//        
//        [self zoomMapToRegionEncapsulatingLocation:capitalLocation andLocation:currentLocation];
//    }
//    [manager stopUpdatingLocation];
//}

@end

