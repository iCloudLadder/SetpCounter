//
//  MyPedometer.h
//  SetpCounter
//
//  Created by syweic on 14/11/20.
//  Copyright (c) 2014年 ___iSoftStone___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>

@interface MyPedometerDataModel : NSString

@property (nonatomic, copy) NSString *startDate;

@property (nonatomic, copy) NSString *endDate;

@property (nonatomic, copy) NSString *numbersOfStep;

@property (nonatomic, copy) NSString *distance;

@property (nonatomic, copy) NSString *floorsAscended;

@property (nonatomic, copy) NSString *floorsDescended;

@end

typedef void (^MyPedometerDataHandle)(MyPedometerDataModel *myPedometerDataModel);

@interface MyPedometer : NSObject

+(void)getPedometerDataWith:(CMPedometerData*)pedometerData handle:(MyPedometerDataHandle)pedometerDataHandle;

@end
