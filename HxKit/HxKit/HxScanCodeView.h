//
//  HxScanCodeView.h
//  HxKit
//
//  Created by han xiao on 2019/9/28.
//  Copyright © 2019 hanxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

//这是一个很好玩的扫描框，支持条形码和二维码的扫描

@protocol HxScanCodeDelegate <NSObject>

@required

///获取扫描的内容
-(void)dataString:(NSString*_Nullable)StringValue;

@end

NS_ASSUME_NONNULL_BEGIN

@interface HxScanCodeView : UIView

@property(nonatomic,weak) id<HxScanCodeDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
