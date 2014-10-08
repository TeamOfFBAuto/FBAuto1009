//
//  FBPhotoBrowserController.h
//  FBAuto
//
//  Created by lichaowei on 14-7-2.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FBBaseViewController.h"
/**
 *  浏览大图
 */

@interface FBPhotoBrowserController : FBBaseViewController

@property(nonatomic,retain)NSArray *imagesArray;
@property(nonatomic,assign)int showIndex;//显示第几张

@end
