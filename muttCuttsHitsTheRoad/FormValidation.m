//
//  FormValidation.m
//  muttCuttsHitsTheRoad
//
//  Created by Jorge Catalan on 7/29/16.
//  Copyright © 2016 Jorge Catalan. All rights reserved.
//

#import "FormValidation.h"

@implementation FormValidation
-(BOOL)isAddressValid:(NSString *)address{
    if([address isEqualToString:@""]){
        return NO;
    }
    if([address componentsSeparatedByString:@","].count < 2){
        return NO;
    }
    return YES;
}

@end
