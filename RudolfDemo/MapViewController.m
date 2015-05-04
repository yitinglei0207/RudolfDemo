//
//  MapViewController.m
//  RudolfDemo
//
//  Created by Jason Lei on 2015/4/24.
//  Copyright (c) 2015年 AlphaCamp. All rights reserved.
//

#import "MapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface MapViewController ()<MKMapViewDelegate,CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    BOOL isFirstGetLocation;
    
    
}
@property (nonatomic,strong)CLGeocoder *geoCoder;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    locationManager = [[CLLocationManager alloc]init];
    [locationManager requestWhenInUseAuthorization];
    self.geoCoder = [[CLGeocoder alloc]init];
    
    [self.geoCoder geocodeAddressString:@"臺北市中山區敬業一路59號" completionHandler:^(NSArray *placemarks, NSError *error) {
        if(error == nil && placemarks.count > 0){
            CLPlacemark *placeMark = placemarks[0];
            NSLog(@"location: %f %f",placeMark.location.coordinate.latitude,placeMark.location.coordinate.longitude);
        }
        else{
            NSLog(@"error %@", error);
        }
        
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)mapView:(MKMapView*)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    //get the coordinate
    

    
    //NSLog(@"location latitude:%f longitude:%f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    
    //NSLog(@"accuracy:%f",userLocation.location.horizontalAccuracy);
    
    //set the zoom effect
    if (isFirstGetLocation== NO) {
        isFirstGetLocation = YES;
        
        //MKCoordinateRegion mapRegion;
        
        //mapView.region = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 400, 400);
        
//        mapRegion.center = mapView.userLocation.coordinate;
//        MKCoordinateSpan mapspan;
//        mapspan.latitudeDelta = 0.01;
//        mapspan.longitudeDelta = 0.01;
//        mapRegion.span = mapspan;
        
        [mapView setRegion:MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 400, 400) animated: YES];
        
    }
    
 
    
    //[self.geoCoder cancelGeocode];
    
    [self.geoCoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil && placemarks.count >0) {
            CLPlacemark *placeMark = placemarks[0];
//            for (NSString *key in placeMark.addressDictionary) {
//                //NSLog(@"%@ %@", key, placeMark.addressDictionary[key]);
//                
//            }
            NSArray *addressArray = [placeMark.addressDictionary objectForKey:@"FormattedAddressLines"];
            for (NSString *address in addressArray) {
                NSLog(@"address1: %@",address);
                
            }
        }else{
            NSLog(@"%@",error);
        }
    }];
    
    
    //[self getCoordinateFromAddress];
   
}


-(void)getCoordinateFromAddress{
    [self.geoCoder geocodeAddressString:@"臺北市中山區敬業一路59號" completionHandler:^(NSArray *placemarks, NSError *error) {
        if(error == nil && placemarks.count > 0){
            CLPlacemark *placeMark = placemarks[0];
            NSLog(@"location: %f %f",placeMark.location.coordinate.latitude,placeMark.location.coordinate.longitude);
        }
        else{
            NSLog(@"%@", error);
        }
            
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
