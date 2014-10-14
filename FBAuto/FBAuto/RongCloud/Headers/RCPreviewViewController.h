//
//  PreviewViewController.h
//  RCIM
//
//  Created by Heq.Shinoda on 14-5-27.
//  Copyright (c) 2014年 Heq.Shinoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCIMClient.h"
#import "RCBasicViewController.h"
#import "RCIMClientHeader.h"

@class RCImageMsgProgressView;

@interface RCPreviewViewController : RCBasicViewController<RCDownloadMediaDelegate>
{
    int progressStep;
}
//previewImage包含原图view，根据需要实现缩放
@property (nonatomic,strong) UIImageView* previewImage;
@property (nonatomic,strong) NSDictionary *userInfo;
@property (nonatomic,strong) RCMessage *rcMessage;
//@property (nonatomic,strong) UIProgressView *progressView;
@property (nonatomic,strong) RCImageMsgProgressView *rcImageProressView;


/**
 *  导航左面按钮点击事件
 */
-(void)leftBarButtonItemPressed:(id)sender;
/**
 *  导航右面按钮点击事件
 */
-(void)rightBarButtonItemPressed:(id)sender;

-(void)setNavigationTitle:(NSString *)title textColor:(UIColor*)textColor;
/**
 *  如果有需要，可以自定义下载完成的图片操作。
 *
 *  @param image 下载的图片。
 */
-(void)didDownloadImage:(UIImage*)image;

@end