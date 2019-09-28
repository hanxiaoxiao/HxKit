//
//  HxActivityKit.m
//  HxKit
//
//  Created by han xiao on 2019/9/17.
//  Copyright © 2019 hanxiao. All rights reserved.
//

#import "HxActivityKit.h"
#import <CoreMotion/CoreMotion.h>

@interface HxActivityKit()

@property (nonatomic, strong) CMPedometer *stepCounter;

@property (nonatomic, strong) CMMotionActivityManager *activityManager;

@property (nonatomic, strong) NSOperationQueue *operationQueue;

@end

@implementation HxActivityKit

+(instancetype)shareInstance{
    static HxActivityKit* _activityshareInstance= nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _activityshareInstance = [[HxActivityKit alloc]init];
    });
    return _activityshareInstance;
}

-(BOOL)isStepCountingAvailable{
    
    return [CMPedometer isStepCountingAvailable];
}
-(BOOL)isDistanceAvailable{
    return [CMPedometer isDistanceAvailable];
}
-(BOOL)isFloorCountingAvailable{
    return [CMPedometer isFloorCountingAvailable];
}
-(BOOL)isPaceAvailable{
    return [CMPedometer isPaceAvailable];
}
-(BOOL)isCadenceAvailable{
    return [CMPedometer isCadenceAvailable];
}
-(BOOL)isActivityAvailable{
    return [CMMotionActivityManager isActivityAvailable];
}

-(NSString*)getNumberOfSteps{
    
    __block NSString *steps = nil;
    self.stepCounter = [[CMPedometer alloc]init];
    NSDate *toDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *fromDate =
    [dateFormatter dateFromString:[dateFormatter stringFromDate:toDate]];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [self.stepCounter startPedometerUpdatesFromDate:fromDate withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
       
            if (!error) {
                steps = pedometerData.numberOfSteps.stringValue;
            }
        dispatch_semaphore_signal(semaphore);
       
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

    return steps;
}
-(NSString*)getActivityStatus{
    __block NSString* status = nil;
    __weak HxActivityKit *weakSelf = self;
    self.activityManager = [[CMMotionActivityManager alloc]init];
    self.operationQueue = [[NSOperationQueue alloc]init];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [self.activityManager startActivityUpdatesToQueue:self.operationQueue withHandler:^(CMMotionActivity * _Nullable activity) {
        
        status = [weakSelf statusForActivity:activity];
        dispatch_semaphore_signal(semaphore);
        
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return status;
}
-(NSString *)statusForActivity:(CMMotionActivity *)activity
{
    
    NSMutableString *status = @"".mutableCopy;
    
    if (activity.stationary) {
        
        [status appendString:@"not moving"];
    }
    
    if (activity.walking)
    {
        
        if (status.length) [status appendString:@", "];
        
        [status appendString:@"on a walking person"];
    }
    
    if (activity.running) {
        
        if (status.length) [status appendString:@", "];
        
        [status appendString:@"on a running person"];
    }
    
    if (activity.automotive) {
        
        if (status.length) [status appendString:@", "];
        
        [status appendString:@"in a vehicle"];
    }
    
    if (activity.unknown || !status.length) {
        
        [status appendString:@"unknown"];
    }
    
    return status;
}
-(void)stopPedometerUpdates{
    [self.stepCounter stopPedometerUpdates];
    
}
-(void)stopActivityUpdates{
    [self.activityManager stopActivityUpdates];
}
-(NSDate*)getCurrentDate{
    // 获取当前时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    // 得到当前时间（世界标准时间 UTC/GMT）
    NSDate *nowDate = [NSDate date];
    // 设置系统时区为本地时区
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    // 计算本地时区与 GMT 时区的时间差
    NSInteger interval = [zone secondsFromGMT];
    // 在 GMT 时间基础上追加时间差值，得到本地时间
    nowDate = [nowDate dateByAddingTimeInterval:interval];
    
    return nowDate;
}

@end
