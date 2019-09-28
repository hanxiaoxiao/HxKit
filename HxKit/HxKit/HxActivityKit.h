//
//  HxActivityKit.h
//  HxKit
//
//  Created by han xiao on 2019/9/17.
//  Copyright © 2019 hanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

///这是一个很好玩的计步器可以获取到你的步数、距离、楼层等信息


NS_ASSUME_NONNULL_BEGIN

@interface HxActivityKit : NSObject


+(instancetype)shareInstance;

/**
 判断当前设备是否可以获取步数

 @return YES:表示可以用，NO:表示不可用
 */
-(BOOL)isStepCountingAvailable;


/**
 判断当前设备是否可以获取距离

 @return YES:表示可以用，NO:表示不可用
 */
-(BOOL)isDistanceAvailable;



/**
 判断当前设备是否可以获取上下楼层数

 @return YES:表示可以用，NO:表示不可用
 */
-(BOOL)isFloorCountingAvailable;



/**
 判断当前设备是否可以获取速度（s/m）

 @return YES:表示可以用，NO:表示不可用
 */
-(BOOL)isPaceAvailable;


/**
 判断当前设备是否可以获取节奏

 @return YES:表示可以用，NO:表示不可用
 */
-(BOOL)isCadenceAvailable;


/**
 判断系统自带的运动状态是否可以用

 @return YES:表示可以用,NO:表示不可用
 */
-(BOOL)isActivityAvailable;


/**
 获取当前的步数

 @return 返回今天走的步数
 */
-(NSString*)getNumberOfSteps;



/**
 获取当前运动状态

 @return 返回运动状态
 */
-(NSString*)getActivityStatus;

/**
 停止当前计步器的更新
 */
-(void)stopPedometerUpdates;

/**
 停止实时更新
 */
-(void)stopActivityUpdates;


/// 获取当前系统时间
-(NSDate*)getCurrentDate;

@end

NS_ASSUME_NONNULL_END
