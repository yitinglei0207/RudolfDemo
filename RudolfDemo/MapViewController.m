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
#import "SWRevealViewController.h"

//#import <SWRevealViewController/SWRevealViewController.m>

@interface MapViewController ()<MKMapViewDelegate,CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    BOOL isFirstGetLocation;
    MyAnnotation *currentAnnotation;
    int estimateTimeOfPickup;
    
    UIView *pinView;
    UILabel *estimationTimeLabel;
    UIImage *pinImage;
}
@property (nonatomic,strong) CLGeocoder *geoCoder;
@property (nonatomic,strong) NSString *addressReturn;
@property (nonatomic,strong) CLLocation *mapCenter;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
  
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    // Do any additional setup after loading the view.
    locationManager = [[CLLocationManager alloc]init];
    [locationManager requestWhenInUseAuthorization];
    self.geoCoder = [[CLGeocoder alloc]init];
    
    estimationTimeLabel = [[UILabel alloc]init];
    estimationTimeLabel.textColor = [UIColor blackColor];
    estimationTimeLabel.textAlignment = NSTextAlignmentCenter;
    [estimationTimeLabel.font fontWithSize:1.5];
    estimationTimeLabel.numberOfLines = 2;
    estimationTimeLabel.backgroundColor = [UIColor clearColor];
    [estimationTimeLabel setFrame:  CGRectMake(25, 5, 30, 45)];
    pinImage = [UIImage  imageNamed:@"pin"];
    
    //set initial map span to Taipei city
    [self.map setRegion:MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(25.022136, 121.547977), 11000, 11000)animated:YES];
    [self addAnnotation];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)mapView:(MKMapView*)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    
    //set the zoom effect
    if (isFirstGetLocation== NO) {
        isFirstGetLocation = YES;
        //zoom into user location in 400m*400m
        [mapView setRegion:MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 400, 400) animated: YES];
    }
}


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
    // set rudolf location
    currentAnnotation = [[MyAnnotation alloc]initWithCoordinate:CLLocationCoordinate2DMake(25.022136, 121.547977) title:@"Rudolf" subtitle:@"Location"];
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
            //set custom pin logo
            annoView.highlighted = NO;
            annoView.image = [UIImage imageNamed:@"AppLogo"];
            
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
    //NSLog(@"chage map View");
    _mapCenter = [[CLLocation alloc]initWithLatitude:self.map.centerCoordinate.latitude longitude:self.map.centerCoordinate.longitude];
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc]init];
    request.transportType = MKDirectionsTransportTypeAutomobile;
    
    // set source
    MKMapItem *mapCenter = [[MKMapItem alloc]init];
    MKPlacemark *centerPlaceMark = [[MKPlacemark alloc]init];
    [centerPlaceMark initWithCoordinate:_mapCenter.coordinate addressDictionary:nil];
    [mapCenter initWithPlacemark:centerPlaceMark];
    [request setDestination:mapCenter];
    // set rudolf position
    MKMapItem *rudolfLocation = [[MKMapItem alloc]init];
    MKPlacemark *placeMark = [[MKPlacemark alloc]init];
    [placeMark initWithCoordinate:currentAnnotation.coordinate addressDictionary:nil];
    
    [request setSource:[rudolfLocation initWithPlacemark:placeMark]];
    //calculating time
    MKDirections *rudolfToYou = [[MKDirections alloc]init];
    [rudolfToYou initWithRequest:request];
    [rudolfToYou calculateETAWithCompletionHandler:^(MKETAResponse *response, NSError *error) {
        NSLog(@"%d",(int)response.expectedTravelTime/60);
        estimateTimeOfPickup = (int)response.expectedTravelTime/60;
        
        double delayInSeconds = 0.9;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            estimationTimeLabel.text = [NSString stringWithFormat:@"%d min",estimateTimeOfPickup];
            
            if (pinView == nil) {
                pinView = [[UIImageView alloc]initWithImage:pinImage];
                [pinView setContentMode:UIViewContentModeScaleAspectFit];
                [pinView setCenter:CGPointMake(self.map.frame.size.width/2, self.map.frame.size.height/2)];
                [pinView setFrame:CGRectMake(self.map.frame.size.width/2 - 40, self.map.frame.size.height/2 -20, 80, 80)];
                [pinView addSubview:estimationTimeLabel];
                [self.view addSubview:pinView];
            }
            
            
        });
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
