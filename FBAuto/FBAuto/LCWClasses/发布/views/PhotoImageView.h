//
//  PhotoImageView.h
//  FBAuto
//
//  Created by lichaowei on 14-7-2.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  带有删除按钮
 */

typedef void(^ DeleteBlock) (UIImageView *deleteImageView,UIImage *deleteImage);

@interface PhotoImageView : UIImageView
{
    DeleteBlock deleteBlock;
}

- (id)initWithFrame:(CGRect)frame image:(UIImage*)image deleteBlock:(DeleteBlock)aBlock;

@end
