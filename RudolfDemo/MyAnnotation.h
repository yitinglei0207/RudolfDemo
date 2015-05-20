//
//  MyAnnotation.h
//  RudolfDemo
//
//  Created by Jason Lei on 2015/5/5.
//  Copyright (c) 2015年 AlphaCamp. All rights reserved.
//
#import <MapKit/MapKit.h>
#import <Foundation/Foundation.h>

@interface MyAnnotation : NSObject <MKAnnotation>

-(id)initWithCoordinate:(CLLocationCoordinate2D)argCoordinate title:(NSString*)argTitle subtitle:(NSString*)argSubtitle;

@end
