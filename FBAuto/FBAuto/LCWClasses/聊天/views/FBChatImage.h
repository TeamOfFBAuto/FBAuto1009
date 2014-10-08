//
//  FBChatImage.h
//  FBAuto
//
//  Created by lichaowei on 14-7-8.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FBChatImage;

typedef void(^ ClickBlock) (UIImageView *imageView);
typedef void(^ LoadFailBlock)(FBChatImage *chatImageView);//load失败

@interface FBChatImage : UIImageView
{
    ClickBlock aBlock;
    LoadFailBlock aFailBlock;
    
    UIButton *maskView;
    UIActivityIndicatorView *indicator;
}

@property(nonatomic,retain)NSString *imageUrl;

- (void)showBigImage:(ClickBlock )clickBlock;

- (void)startLoading;

- (void)stopLoadingWithFailBlock:(LoadFailBlock)failBlock;

@end
