//
//  HxScanCodeView.m
//  HxKit
//
//  Created by han xiao on 2019/9/28.
//  Copyright © 2019 hanxiao. All rights reserved.
//

#import "HxScanCodeView.h"
#import <AVFoundation/AVFoundation.h>


@interface HxScanCodeView()<AVCaptureMetadataOutputObjectsDelegate>

@property(nonatomic,strong) AVCaptureSession* session;

@property(nonatomic,strong) CAGradientLayer* scanLayer;

@property(nonatomic,strong) UIView* scanBox;

@property(nonatomic,strong) NSTimer* timer;

@end

@implementation HxScanCodeView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self loadScanSetting];
                });
            }
        }];
    }
    return self;
    
}
-(void)loadScanSetting{
    //获取捕捉设备
    AVCaptureDevice* device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput* input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //创建输出流
    AVCaptureMetadataOutput* output = [[AVCaptureMetadataOutput alloc]init];
    //设置代理，在主线程中刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    _session = [[AVCaptureSession alloc]init];
    //设置采集率
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    [_session addInput:input];
    [_session addOutput:output];
    //设置扫码支持的编码格式
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeCode128Code];
    //实例化预览图层
    AVCaptureVideoPreviewLayer* layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    //设置预览图层边界
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    layer.frame = self.layer.bounds;
    [self.layer insertSublayer:layer atIndex:0];
    
    //创建背景遮罩
    UIView* maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [maskView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.7]];
    [self addSubview:maskView];
    
    
    //画个钜形
    UIBezierPath* path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [path appendPath:[[UIBezierPath bezierPathWithRoundedRect:CGRectMake(SCREEN_WIDTH *0.2f, SCREEN_HEIGHT*0.35f, SCREEN_WIDTH - SCREEN_WIDTH*0.4f, SCREEN_HEIGHT - SCREEN_HEIGHT *0.7f) cornerRadius:0] bezierPathByReversingPath]];
    CAShapeLayer* shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    [maskView.layer setMask:shapeLayer];
    
    //设置捕获有效区域
    output.rectOfInterest = CGRectMake(0.2f, 0.2f, 0.6f, 0.6f);
    
    //设置扫描边框
    _scanBox = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH *0.2f, SCREEN_HEIGHT*0.35f, SCREEN_WIDTH - SCREEN_WIDTH*0.4f, SCREEN_HEIGHT - SCREEN_HEIGHT *0.7f)];
    
    _scanBox.layer.borderColor = [UIColor greenColor].CGColor;
    _scanBox.layer.borderWidth = 1.0f;
    [self addSubview:_scanBox];
    
    //扫描线
    _scanLayer = [CAGradientLayer layer];
    _scanLayer.frame = CGRectMake(0, 0, _scanBox.frame.size.width, 2);
    _scanLayer.backgroundColor = [UIColor greenColor].CGColor;
    [_scanBox.layer addSublayer:_scanLayer];
    
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(moveScanLayer) userInfo:nil repeats:YES];
    [_timer fire];
    
    //开始捕获
    [_session startRunning];
    
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        
        [_session stopRunning];
     
        
        [_scanLayer removeFromSuperlayer];
        
        if ([_delegate respondsToSelector:@selector(dataString:)])
        {
            [_delegate dataString:metadataObject.stringValue];
        }
        
    }
}
- (void)moveScanLayer
{
    __weak typeof(self) weakself = self;
    CGRect frame = _scanLayer.frame;
    if (_scanBox.frame.size.height < (_scanLayer.frame.origin.y+2+ 5)) {
        frame.origin.y = -5;
        _scanLayer.frame = frame;
    }else{
        frame.origin.y += 5;
        [UIView animateWithDuration:0.1 animations:^{
            weakself.scanLayer.frame = frame;
        }];
    }
    
    
}
-(void)dealloc{
    [self.timer invalidate];
    self.timer = nil;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
