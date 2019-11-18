//
//  HxSpeechSynthesizer.h
//  HxKit
//
//  Created by han xiao on 2019/11/17.
//  Copyright © 2019 hanxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <Speech/Speech.h>

@protocol HxSpeechSynthesizerDelegate <NSObject>

@optional

-(void)getSpeechToWord:(NSString*)word;

@end

#endif
//这是一个比较好玩的语音工具类，可以实现文字转语音，也可以实现语音转文字

@interface HxSpeechSynthesizer : NSObject

+(instancetype)shareInstance;

/// 开始文字转语音
-(void)startSpeaking;

/// 取消文字转语音
-(void)stopSpeaking;

///暂停文字转语音
-(void)pauseSpeaking;

/// 继续文字转语音
-(void)continueSpeaking;

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
/// 语音转文字
-(void)speakingToWord;

@property(nonatomic,weak) id <HxSpeechSynthesizerDelegate> delegate;

#endif

@end


