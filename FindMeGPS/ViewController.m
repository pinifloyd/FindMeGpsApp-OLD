//
//  ViewController.m
//  FindMeGPS
//
//  Created by Сергей Ганчар on 05.05.12.
//  Copyright (c) 2012 www.altoros.com. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize locationManager;
@synthesize currentLocationLat;
@synthesize currentLocationLng;
@synthesize oldLocationLat;
@synthesize oldLocationLng;

- (void)viewDidLoad {
  [super viewDidLoad];
  
  locationManager = [[CLLocationManager alloc] init];
  
  // Best performance
  locationManager.desiredAccuracy = kCLLocationAccuracyBest;
  
  // Distance filter
  locationManager.distanceFilter = 100;
  
  locationManager.delegate = self;
  [locationManager startUpdatingLocation];
  
}

- (void)viewDidUnload {
  [self setCurrentLocationLat:nil];
  [self setCurrentLocationLng:nil];
  [self setOldLocationLat:nil];
  [self setOldLocationLng:nil];
  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
  
  // NSLog(@"%+.20f", newLocation.coordinate.latitude);
  
  self.currentLocationLat.text = [NSString stringWithFormat:@"%+.20f", newLocation.coordinate.latitude];
  self.currentLocationLng.text = [NSString stringWithFormat:@"%+.20f", newLocation.coordinate.longitude];
  
  self.oldLocationLat.text = [NSString stringWithFormat:@"%+.20f", oldLocation.coordinate.latitude];
  self.oldLocationLng.text = [NSString stringWithFormat:@"%+.20f", oldLocation.coordinate.longitude];
}
@end
