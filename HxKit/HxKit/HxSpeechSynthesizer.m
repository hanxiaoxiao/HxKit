//
//  HxSpeechSynthesizer.m
//  HxKit
//
//  Created by han xiao on 2019/11/17.
//  Copyright © 2019 hanxiao. All rights reserved.
//

#import "HxSpeechSynthesizer.h"
#import <AVFoundation/AVFoundation.h>

@interface HxSpeechSynthesizer()<AVSpeechSynthesizerDelegate,SFSpeechRecognitionTaskDelegate>

@property(nonatomic,strong) AVSpeechSynthesizer* synthesizer;

@end

@implementation HxSpeechSynthesizer

+(instancetype)shareInstance{
    static HxSpeechSynthesizer* hxSpeechInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hxSpeechInstance = [[HxSpeechSynthesizer alloc]init];
    });
    return hxSpeechInstance;
}
-(void)startSpeaking{
    NSString *string = @"窗前明月光，疑是地上霜，举头望明月，低头思故乡！";
     
     AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:string];
     
     utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
     
     //设置语速
     utterance.rate = 0.3;
     //设置音量
     //    utterance.volume = 0.6;
     
     self.synthesizer = [[AVSpeechSynthesizer alloc] init];
     
     self.synthesizer.delegate = self;
     
     
     [self.synthesizer speakUtterance:utterance];
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance{
    NSLog(@"开始文字转语音");
    
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance{
    NSLog(@"完成文字转语音");
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didPauseSpeechUtterance:(AVSpeechUtterance *)utterance{
    NSLog(@"暂停文字转语音");
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didContinueSpeechUtterance:(AVSpeechUtterance *)utterance{
    NSLog(@"继续文字转语音");
}
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didCancelSpeechUtterance:(AVSpeechUtterance *)utterance{
    NSLog(@"取消文字转语音");
}

-(void)stopSpeaking{
    [self.synthesizer stopSpeakingAtBoundary:AVSpeechBoundaryWord];
}

-(void)pauseSpeaking{
    [self.synthesizer pauseSpeakingAtBoundary:AVSpeechBoundaryWord];
}

-(void)continueSpeaking{
    [self.synthesizer continueSpeaking];
}
// iOS 10 Support
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
-(void)speakingToWord{
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        
        if (status == SFSpeechRecognizerAuthorizationStatusAuthorized) {
                //1.创建本地化标识符
                            NSLocale *local =[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
                            //2.创建一个语音识别对象
                            SFSpeechRecognizer *sf =[[SFSpeechRecognizer alloc] initWithLocale:local];
                          sf.queue = [[NSOperationQueue alloc]init];
                            
                            //3.将bundle 中的资源文件加载出来返回一个url
                            
                            NSString *musicPath = [[NSBundle mainBundle] pathForResource:@"新录音02" ofType:@"m4a"];
                            
                            NSURL *url = [[NSURL alloc] initFileURLWithPath:musicPath];
                            
                            //4.将资源包中获取的url 传递给 request 对象
                            SFSpeechURLRecognitionRequest *res =[[SFSpeechURLRecognitionRequest alloc] initWithURL:url];
            [sf recognitionTaskWithRequest:res delegate:self];
        }
          
      }];
}
- (void)speechRecognitionTask:(SFSpeechRecognitionTask *)task didFinishRecognition:(SFSpeechRecognitionResult *)recognitionResult{
    if ([self.delegate respondsToSelector:@selector(getSpeechToWord:)]) {
        [self.delegate performSelector:@selector(getSpeechToWord:) withObject:recognitionResult.bestTranscription.formattedString];
    }
}
#endif

@end
