//
//  MyMotionActivity.m
//  SetpCounter
//
//  Created by syweic on 14/11/20.
//  Copyright (c) 2014年 ___iSoftStone___. All rights reserved.
//

#import "MyMotionActivity.h"
#import <CoreMedia/CoreMedia.h>

@implementation MyMotionActivity

/*
+(void)startMotionActivityManagerWith:(id)target
{
    if ([CMMotionActivityManager isActivityAvailable] && !_motionActivityManager) {
        _motionActivityManager = [[CMMotionActivityManager alloc] init];
        _motionActivityQueue = [[NSOperationQueue alloc] init];
        
        if (_motionActivityManager && _motionActivityQueue) {
            __weak ViewController *weakSelf = self;
            [_motionActivityManager startActivityUpdatesToQueue:_motionActivityQueue withHandler:^(CMMotionActivity *activity) {
                // 处理监测的数据
                [weakSelf handleMotionSctivityData:activity];
            }];
        }
        
    }else{
        // 无法监测运动状态
        [self showAlertViewWith:@"啊哦!I am sorry!您的设备不具备监测运动状态的条件(iOS7 & M7处理器)哦!"];
    }
}

+(void)handleMotionSctivityData:(CMMotionActivity*)activity
{
    
}
*/

+(void)getMotionActivityDataWith:(CMMotionActivity *)activity handle:(MyMotionActivityHandle)motionActivityHandle
{
    NSString *type = [MyMotionActivity getMotionActivityTypeWith:activity];
    NSString *confidence = [MyMotionActivity getMotionActivityConfidenceWith:activity.confidence];
    motionActivityHandle(confidence, type);
}


+(NSString*)getMotionActivityTypeWith:(CMMotionActivity*)activity
{
    if (activity.stationary) {
        return @"停";
    }else if (activity.walking){
        return @"行走";
    }else if (activity.running){
        return @"跑";
    }else if (activity.cycling){
        return @"自行车";
    }else if (activity.automotive){
        return @"汽车";
    } //else if (activity.unknown){
        return @"未知";
    // }
}

+(NSString*)getMotionActivityConfidenceWith:(CMMotionActivityConfidence)confidence
{
    if (confidence == CMMotionActivityConfidenceHigh) {
        return @"高";
    }else if (confidence == CMMotionActivityConfidenceMedium){
        return @"中";
    }
    return @"低";
}

@end
