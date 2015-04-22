//
//  ViewController.m
//  GoogleMapsTest
//
//  Created by Vladislav on 21.04.15.
//  Copyright (c) 2015 Vladislav. All rights reserved.
//

#import "SVNViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>

@interface SVNViewController () <CLLocationManagerDelegate>
// Outlets
@property (weak, nonatomic) IBOutlet GMSMapView *googleMapView;
@property (weak, nonatomic) IBOutlet UIButton *returnToMyLocationButton;
// My objects
@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) CLLocation *currentLocation;
@end

@implementation SVNViewController {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Customizations
    [self customizeReturnToMyLocButton];
    // Location Manager Setups
    [self setupLocationManager];
}

- (void)dealloc {
    [self.locationManager stopUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Buttons actions

- (IBAction)returnToMyLocationButtonPressed:(UIButton *)sender {
    [self.locationManager startUpdatingLocation];
}


#pragma mark - CLLocationManagerDelegate

- (void)setCurrentLocationOnTheMap {
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithTarget:self.currentLocation.coordinate
                                                               zoom:12];
    [self.googleMapView setCamera:camera];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.currentLocation = locations.lastObject;
    [self setCurrentLocationOnTheMap];
    NSLog(@"%@", self.currentLocation.description);
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    if(error.code == kCLErrorDenied) {
        [self.locationManager stopUpdatingLocation];
    } else if(error.code == kCLErrorLocationUnknown) {
        // retry
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error retrieving location"
                                                        message:[error description]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}


#pragma mark - Helpers

- (void)customizeReturnToMyLocButton {
    self.returnToMyLocationButton.layer.cornerRadius = 10.0;
    self.returnToMyLocationButton.layer.borderWidth = 1.0;
    self.returnToMyLocationButton.backgroundColor = [UIColor blueColor];
}

- (void)setupLocationManager {
    self.googleMapView.myLocationEnabled = YES;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.currentLocation = [[CLLocation alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {
        [self.locationManager requestWhenInUseAuthorization];
        // Code to check if the app can respond to the new selector found in iOS 8. If so, request it.
        if([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [self.locationManager requestAlwaysAuthorization];
        }
    }
    [self.locationManager startUpdatingLocation];
}

@end
