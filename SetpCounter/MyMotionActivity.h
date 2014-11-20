//
//  MyMotionActivity.h
//  SetpCounter
//
//  Created by syweic on 14/11/20.
//  Copyright (c) 2014年 ___iSoftStone___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>


typedef void (^MyMotionActivityHandle)(NSString *confidenceStr, NSString *type);

@interface MyMotionActivity : NSObject

+(void)getMotionActivityDataWith:(CMMotionActivity*)activity handle:(MyMotionActivityHandle)motionActivityHandle;

+(NSString*)getMotionActivityConfidenceWith:(CMMotionActivityConfidence)confidence;

+(NSString*)getMotionActivityTypeWith:(CMMotionActivity*)activity;


@end
