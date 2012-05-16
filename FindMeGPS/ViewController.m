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
    
  [self initializeLocationManager];  
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

- (void)initializeLocationManager {
  locationManager = [[CLLocationManager alloc] init];
  
  locationManager.desiredAccuracy = kCLLocationAccuracyBest;
  locationManager.distanceFilter = 100.0f;
  locationManager.delegate = self;
  
  [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
  
  self.currentLocationLat.text = [NSString stringWithFormat:@"%+.20f", newLocation.coordinate.latitude];
  self.currentLocationLng.text = [NSString stringWithFormat:@"%+.20f", newLocation.coordinate.longitude];
  
  self.oldLocationLat.text = [NSString stringWithFormat:@"%+.20f", oldLocation.coordinate.latitude];
  self.oldLocationLng.text = [NSString stringWithFormat:@"%+.20f", oldLocation.coordinate.longitude];
  
  [self writeLocationsToFile:newLocation];
  [self sendLocationsJsonToServer];
}

- (void) writeLocationsToFile:(CLLocation *)newLocation {
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSString *locationsFileHomePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Locations"];
  
  NSMutableString *locationsFileData = [NSMutableString stringWithString:@""];
  if ([fileManager fileExistsAtPath:locationsFileHomePath]) {
    locationsFileData = [NSMutableString stringWithContentsOfFile:locationsFileHomePath encoding:NSUTF8StringEncoding error:nil];
  }
  
  NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
  [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
  
  [locationsFileData appendString:[NSString stringWithFormat:@"latitude/%+.20f/longitude/%+.20f/horizontal_accuracy/%.2f/speed/%+.2f/created_at/%@;", newLocation.coordinate.latitude, newLocation.coordinate.longitude, newLocation.horizontalAccuracy, newLocation.speed, [dateFormat stringFromDate:newLocation.timestamp]]];

  [locationsFileData writeToFile:locationsFileHomePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

- (void)sendLocationsJsonToServer {
  NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/Locations"];
  NSString *fileData = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
  
  NSDictionary *fileJson = [NSDictionary dictionaryWithObjectsAndKeys:fileData, @"location", nil];
  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:fileJson options:NSJSONWritingPrettyPrinted error:nil];
  
  NSURL *url = [NSURL URLWithString:@"http://sergey-hanchar:3000/api/devices/1/locations/"];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
  [request setHTTPMethod:@"POST"];
  [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
  [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
  [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
  [request setHTTPBody:jsonData];
  
  NSHTTPURLResponse *responseCode = nil;
  NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:nil];
  
  if ([responseCode statusCode] == 200) {
    NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
    
    if ([[responseJson valueForKey:@"saved"] boolValue] == YES) {
      NSFileManager *fileManager = [NSFileManager defaultManager];
      NSString *locationPointsHomePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Locations"];
      
      if ([fileManager fileExistsAtPath:locationPointsHomePath]) {
        [fileManager removeItemAtPath:locationPointsHomePath error:nil];
      }
    }
  }
}
@end
