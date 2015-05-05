//
//  MyAnnotation.m
//  RudolfDemo
//
//  Created by Jason Lei on 2015/5/5.
//  Copyright (c) 2015年 AlphaCamp. All rights reserved.
//

#import "MyAnnotation.h"

@implementation MyAnnotation
@synthesize coordinate;
@synthesize title;
@synthesize subtitle;


-(id)initWithCoordinate:(CLLocationCoordinate2D)argCoordinate title:(NSString*)argTitle subtitle:(NSString*)argSubtitle{
    self = [super init];
    if (self) {
        coordinate = argCoordinate;
        subtitle = argSubtitle;
        title = argTitle;
    }
    return self;
}

-(void)setCoordinate:(CLLocationCoordinate2D)newCoordinate{
    coordinate = newCoordinate;
}
@end
