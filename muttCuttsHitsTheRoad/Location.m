//
//  Location.m
//  muttCuttsHitsTheRoad
//
//  Created by Jorge Catalan on 7/29/16.
//  Copyright © 2016 Jorge Catalan. All rights reserved.
//

#import "Location.h"

@implementation Location
-(instancetype)initWithCoord:(CLLocationCoordinate2D)coord title:(NSString *)title subtitle:(NSString *)subtitle{
    self =[super init];
    if(self){
    _coordinate = coord;
    _title = title;
    _subtitle = subtitle;
    }
    return self;

}


@end
