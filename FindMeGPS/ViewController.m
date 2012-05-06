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
  
  self.currentLocationLat.text = [NSString stringWithFormat:@"%+.20f", newLocation.coordinate.latitude];
  self.currentLocationLng.text = [NSString stringWithFormat:@"%+.20f", newLocation.coordinate.longitude];
  
  self.oldLocationLat.text = [NSString stringWithFormat:@"%+.20f", oldLocation.coordinate.latitude];
  self.oldLocationLng.text = [NSString stringWithFormat:@"%+.20f", oldLocation.coordinate.longitude];
  
  [self postLocationCoordinates:newLocation.coordinate.latitude :newLocation.coordinate.longitude];
}

- (void) postLocationCoordinates:(float)latitude:(float)longitude {
  NSString *post = [NSString stringWithFormat:@"latitude=%+.20f&longitude=%+.20f", latitude, longitude];
  NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
  NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
  
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
  [request setURL:[NSURL URLWithString:@"http://sergey-hanchar:3000/"]];
  [request setHTTPMethod:@"POST"];
  [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
  [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
  [request setHTTPBody:postData];
  
  // Coonecting to server
  [[NSURLConnection alloc] initWithRequest:request delegate:self];
}
@end
