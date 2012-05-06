//
//  ViewController.h
//  FindMeGPS
//
//  Created by Сергей Ганчар on 05.05.12.
//  Copyright (c) 2012 www.altoros.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate> {
  CLLocationManager *locationManager;
}

@property (nonatomic, retain) CLLocationManager *locationManager;

@property (weak, nonatomic) IBOutlet UILabel *currentLocationLat;
@property (weak, nonatomic) IBOutlet UILabel *currentLocationLng;
@property (weak, nonatomic) IBOutlet UILabel *oldLocationLat;
@property (weak, nonatomic) IBOutlet UILabel *oldLocationLng;

@end
