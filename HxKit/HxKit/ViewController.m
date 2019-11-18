//
//  ViewController.m
//  HxKit
//
//  Created by han xiao on 2019/9/6.
//  Copyright © 2019 hanxiao. All rights reserved.
//

#import "ViewController.h"
#import <MessageUI/MessageUI.h>
#import "HxActivityKit.h"
#import "HxScanCodeView.h"
#import "HxSpeechSynthesizer.h"
@interface ViewController ()<MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,HxScanCodeDelegate,HxSpeechSynthesizerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];


}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

//    if ([HxActivityKit shareInstance].isStepCountingAvailable) {
//        NSLog(@"%@",[HxActivityKit shareInstance].getNumberOfSteps);
//    }
//    HxScanCodeView* scv = [[HxScanCodeView alloc]initWithFrame:self.view.bounds];
//    scv.delegate = self;
//
//    [self.view addSubview:scv];
    
    HxSpeechSynthesizer *speech = [HxSpeechSynthesizer shareInstance];
    
    [speech speakingToWord];
    
    speech.delegate = self;
    
}
-(void)getSpeechToWord:(NSString *)word{
    NSLog(@"word:%@",word);
}

#pragma mark --HxScanCodeDelegate--
-(void)dataString:(NSString*)StringValue
{

    //输出扫描字符串
    NSLog(@"lalala:%@",StringValue);
    
    NSString *regex =@"[a-zA-z]+://[^\\s]*";
    
    
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    if ([urlTest evaluateWithObject:StringValue])
    {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:StringValue]];
    }
    
}
///发送邮件
-(void)sendEmail{
    if ([MFMailComposeViewController canSendMail] == YES) {
        
        MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
        //注意想要使用系统的邮件功能，需要先配置邮箱，否则无法发送
        mailVC.mailComposeDelegate = self;
        //  收件人
        NSArray *sendToPerson = @[@"1559965862@qq.com"];
        [mailVC setToRecipients:sendToPerson];
        //  抄送
        NSArray *copyToPerson = @[@"24886814@qq.com"];
        [mailVC setCcRecipients:copyToPerson];
        //  密送
        NSArray *secretToPerson = @[@"892843577@qq.com"];
        [mailVC setBccRecipients:secretToPerson];
        //  主题
        [mailVC setSubject:@"hello world"];
        
        [mailVC setMessageBody:@"魑魅魍魉,手机发送的测试数据" isHTML:NO];
        [self presentViewController:mailVC animated:YES completion:nil];
        
    }else{
        
        NSLog(@"此设备不支持邮件发送");
        
    }
}
//邮件delegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(nullable NSError *)error{
    
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"取消邮件发送");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"发送邮件失败");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"保存草稿文件");
            break;
        case MFMailComposeResultSent:
            NSLog(@"发送邮件成功");
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
///发送短信
-(void)sendMessage{
    //首先判断当前设备是否可以发送短信
    if ([MFMessageComposeViewController canSendText]) {
        
        MFMessageComposeViewController *message = [[MFMessageComposeViewController alloc]init];
        
        //设置委托
        message.messageComposeDelegate = self;
        
        //短信内容
        message.body = @"哇哦，你懂的";
        
        //设置短信收件方
        message.recipients = @[@"13818142097"];
        
        [self presentViewController:message animated:YES completion:nil];
        
    }
    else{
        
        NSLog(@"此设备不支持短信发送");
    }
}
//发送短信delegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    
    switch (result) {
        case MessageComposeResultSent:
            NSLog(@"短信发送成功");
            break;
        case MessageComposeResultFailed:
            NSLog(@"短信发送失败");
            break;
        case MessageComposeResultCancelled:
            NSLog(@"取消短信发送");
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
