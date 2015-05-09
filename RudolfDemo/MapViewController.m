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
#import "PickDestinationViewController.h"
#import "MyAnnotation.h"

@interface MapViewController ()<MKMapViewDelegate,CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    BOOL isFirstGetLocation;
    MyAnnotation *currentAnnotation;
    int estimateTimeOfPickup;
    
}
@property (nonatomic,strong) CLGeocoder *geoCoder;
@property (nonatomic,strong) NSString *addressReturn;
@property (nonatomic,strong) CLLocation *mapCenter;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    locationManager = [[CLLocationManager alloc]init];
    [locationManager requestWhenInUseAuthorization];
    self.geoCoder = [[CLGeocoder alloc]init];
    
    [self.map setRegion:MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(25.04536, 121.54195), 11400, 11400)animated:YES];
    [self addAnnotation];
    
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
        //zoom into user location in 400m*400m
        
        
        
        
        //MKCoordinateRegion mapRegion;
        //        mapView.region = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 400, 400);
        //        mapRegion.center.latitude  = ( 25.033408 + mapView.userLocation.coordinate.latitude)/2;
        //        mapRegion.center.longitude = (121.564009 + mapView.userLocation.coordinate.longitude)/2;
        //
        //        MKCoordinateSpan mapspan;
        //        mapspan.latitudeDelta = ABS(25.033408 - userLocation.location.coordinate.latitude)*1.5;
        //        mapspan.longitudeDelta = ABS(121.564009 - userLocation.location.coordinate.longitude)*1.5;
        //        mapRegion.span = mapspan;
        //
        
        [mapView setRegion:MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 400, 400) animated: YES];
    }
    
    
    //    double delayInSeconds = 1.0;
    //    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    //    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    //
    //        //UIImage *rudolfImage = [UIImage imageNamed:@"AppLogo"];
    //        UILabel *estimationTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 160, 20)];
    //        estimationTimeLabel.text = [NSString stringWithFormat:@"%d Minutes",estimateTimeOfPickup];
    //        estimationTimeLabel.textColor = [UIColor darkGrayColor];
    //
    //        estimationTimeLabel.backgroundColor = [UIColor yellowColor];
    //        UIView *rudolfEstimationView = [[UIView alloc]initWithFrame:CGRectMake(self.map.frame.size.width/2 - 100, self.map.frame.size.height/2 - 20, 200, 20)];
    //        [rudolfEstimationView addSubview:estimationTimeLabel];
    //
    //
    //
    //        UIImage *pinImage = [UIImage  imageNamed:@"pin"];
    //        UIImageView *pinView = [[UIImageView alloc]initWithImage:pinImage];
    //        [pinView setCenter:CGPointMake(self.map.frame.size.width/2, self.map.frame.size.height/2)];
    //
    //        [pinView setFrame:CGRectMake(self.map.frame.size.width/2 - 13, self.map.frame.size.height/2 + 26, 26, 26)];
    //        [self.view addSubview:pinView];
    //        [self.view addSubview:rudolfEstimationView];
}
//



- (IBAction)selectPostionButtonPressed:(id)sender {
    [self getAddressFromCoordinate];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"selectPosition"]) {
        PickDestinationViewController *destination = segue.destinationViewController;
        destination.receivedSelectionText = _addressReturn;
    }
    
}

#pragma mark - custom map methods
-(void)getCoordinateFromAddress:(NSString*)address{
    //get the coordinate from given address
    [self.geoCoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        if(error == nil && placemarks.count > 0){
            CLPlacemark *placeMark = placemarks[0];
            //NSLog(@"location: %f %f",placeMark.location.coordinate.latitude,placeMark.location.coordinate.longitude);
        }
        else{
            NSLog(@"%@", error);
        }
        
    }];
}
-(void)getAddressFromCoordinate{
    
    //__block NSString *addressReturn;
    [self.geoCoder reverseGeocodeLocation:_mapCenter completionHandler:^(NSArray *placemarks, NSError *error) {
        //NSString *addressReturn;
        if (error == nil && placemarks.count >0) {
            CLPlacemark *placeMark = placemarks[0];
            //            for (NSString *key in placeMark.addressDictionary) {
            //                //NSLog(@"%@ %@", key, placeMark.addressDictionary[key]);
            //
            //            }
            NSArray *addressArray = [placeMark.addressDictionary objectForKey:@"FormattedAddressLines"];
            for (NSString *address in addressArray) {
                //NSLog(@"address: %@",address);
                _addressReturn = address;
            }
            //NSLog(@"addressReturn: %@",_addressReturn);
            [self performSegueWithIdentifier:@"selectPosition" sender:self];
            
        }else{
            NSLog(@"%@",error);
        }
    }];
    
    
}



-(void) addAnnotation{
    
    currentAnnotation = [[MyAnnotation alloc]initWithCoordinate:CLLocationCoordinate2DMake(25.033408, 121.564009) title:@"Rudolf" subtitle:@"Location"];
    [self.map addAnnotation:currentAnnotation];
    
}

-(MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    MKPinAnnotationView *annoView;
    if ([annotation isKindOfClass:[MyAnnotation class]]) {
        annoView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin" ];
        if(annoView == nil){
            annoView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"Pin"];
            annoView.pinColor = MKPinAnnotationColorGreen;
            annoView.canShowCallout = YES;
            
            annoView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            annoView.draggable = YES;
            
        }
    }
    return annoView;
}


-(void) mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    NSLog(@"tapped");
}

-(void) mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    NSLog(@"chage map View");
    _mapCenter = [[CLLocation alloc]initWithLatitude:self.map.centerCoordinate.latitude longitude:self.map.centerCoordinate.longitude];
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc]init];
    request.transportType = MKDirectionsTransportTypeAutomobile;
    
    // set source
    MKMapItem *mapCenter = [[MKMapItem alloc]init];
    MKPlacemark *centerPlaceMark = [[MKPlacemark alloc]init];
    [centerPlaceMark initWithCoordinate:_mapCenter.coordinate addressDictionary:nil];
    [mapCenter initWithPlacemark:centerPlaceMark];
    [request setDestination:mapCenter];
    
    MKMapItem *rudolfLocation = [[MKMapItem alloc]init];
    MKPlacemark *placeMark = [[MKPlacemark alloc]init];
    [placeMark initWithCoordinate:currentAnnotation.coordinate addressDictionary:nil];
    
    [request setSource:[rudolfLocation initWithPlacemark:placeMark]];
    
    MKDirections *rudolfToYou = [[MKDirections alloc]init];
    [rudolfToYou initWithRequest:request];
    [rudolfToYou calculateETAWithCompletionHandler:^(MKETAResponse *response, NSError *error) {
        NSLog(@"%d",(int)response.expectedTravelTime/60);
        estimateTimeOfPickup = (int)response.expectedTravelTime/60;
        
        
        double delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            //UIImage *rudolfImage = [UIImage imageNamed:@"AppLogo"];
            UILabel *estimationTimeLabel = [[UILabel alloc]init];
            estimationTimeLabel.text = [NSString stringWithFormat:@"%d Minutes",estimateTimeOfPickup];
            estimationTimeLabel.textColor = [UIColor darkGrayColor];
            estimationTimeLabel.backgroundColor = [UIColor yellowColor];
            //[estimationTimeLabel sizeToFit];
            [estimationTimeLabel setFrame:  CGRectMake(0, 0, 100, 20)] ;
            
            UIView *rudolfEstimationView = [[UIView alloc]init];
            rudolfEstimationView.center = CGPointMake(self.map.frame.size.width/2, self.map.frame.size.height/2 - 20);
            [rudolfEstimationView sizeToFit];
            [rudolfEstimationView addSubview:estimationTimeLabel];
            
            
            
            UIImage *pinImage = [UIImage  imageNamed:@"pin"];
            UIImageView *pinView = [[UIImageView alloc]initWithImage:pinImage];
            [pinView setContentMode:UIViewContentModeScaleAspectFit];
            [pinView setCenter:CGPointMake(self.map.frame.size.width/2, self.map.frame.size.height/2)];
            
            [pinView setFrame:CGRectMake(self.map.frame.size.width/2 - 13, self.map.frame.size.height/2 + 26, 26, 26)];
            [self.view addSubview:pinView];
            [self.view addSubview:rudolfEstimationView];
            
        });
    }];
    //[request calculateETAWithCompletionHandler:];
    
}

/*
 - (void)mapView:(MKMapView *)mapViewregionDidChange Animated:(BOOL)animated{
 CLLocationCoordinate2D center = self.map.centerCoordinate;
 CLLocation *location = [[CLLocation alloc] initWithLatitude:center.latitude longitude:center.longitude];
 currentAnnotation.coordinate = location.coordinate;
 
 
 //CLLocation *plocation = [[CLLocation alloc] initWithLatitude:currentAnnotation.coordinate.latitude longitude:currentAnnotation.coordinate.longitude];
 
 //pinLocation = plocation;
 //    [_geoCoder reverseGeocodeLocation:plocation completionHandler:
 //     ^(NSArray *placemarks, NSError *error) {
 //         if(error ==nil && [placemarks count] > 0){
 //             placemark = [placemarks lastObject];
 //             //self.addressField.hidden = NO;
 //             //self.addressField.text = [NSString stringWithFormat:@"%@ %@, %@",  placemark.thoroughfare, placemark.subThoroughfare, placemark.locality];
 //             //NSLog(@"thoroughfare %@, subThoroughfare %@, locality %@", placemark.thoroughfare, placemark.subThoroughfare, placemark.locality);
 //             //NSString *undesired = @"(null)";
 //             //NSString *desired   = @"";
 //
 //             //self.addressField.text = [self.addressField.text stringByReplacingOccurrencesOfString:undesired withString:desired];
 //
 //         }
 //     }];
 }
 */
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
