//
//  Location.h
//  muttCuttsHitsTheRoad
//
//  Created by Jorge Catalan on 7/29/16.
//  Copyright © 2016 Jorge Catalan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Location : NSObject <MKAnnotation>

@property(nonatomic,readonly)CLLocationCoordinate2D coordinate;


@property(nonatomic,readonly,copy,nullable)NSString *title;
@property(nonatomic,copy,nullable)NSString *subtitle;

-(nullable instancetype)initWithCoord:(CLLocationCoordinate2D)coord title:(nullable NSString *)title subtitle:(nullable NSString *)subtitle;

@end
