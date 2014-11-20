//
//  MyPedometer.m
//  SetpCounter
//
//  Created by syweic on 14/11/20.
//  Copyright (c) 2014年 ___iSoftStone___. All rights reserved.
//

#import "MyPedometer.h"

@implementation MyPedometerDataModel

@end

@implementation MyPedometer

+(void)getPedometerDataWith:(CMPedometerData *)pedometerData handle:(MyPedometerDataHandle)pedometerDataHandle
{
    MyPedometerDataModel *myPedometerDataModel = [[MyPedometerDataModel alloc] init];
    myPedometerDataModel.startDate = [MyPedometer getDateStringWith:pedometerData.startDate];
    myPedometerDataModel.startDate = [MyPedometer getDateStringWith:pedometerData.endDate];
    myPedometerDataModel.startDate = [MyPedometer getNumberStringWith:pedometerData.numberOfSteps];
    // 单位：m 转换为 km
    myPedometerDataModel.startDate = [NSString stringWithFormat:@"%.2f km",pedometerData.distance.doubleValue/1000];
    myPedometerDataModel.startDate = [MyPedometer getNumberStringWith:pedometerData.floorsAscended];
    myPedometerDataModel.startDate = [MyPedometer getNumberStringWith:pedometerData.floorsDescended];
    
    pedometerDataHandle(myPedometerDataModel);
}



#pragma mark - NSNumber to NSString

+(NSString*)getNumberStringWith:(NSNumber*)number
{
    return [NSString stringWithFormat:@"%d",number.intValue];
}

#pragma mark - NSDate to NSString
+(NSString*)getDateStringWith:(NSDate*)date
{
    return [[MyPedometer getDateFormatter] stringFromDate:date];
}

+(NSDateFormatter*)getDateFormatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return dateFormatter;
}

@end
