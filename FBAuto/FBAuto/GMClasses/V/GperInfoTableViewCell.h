//
//  GperInfoTableViewCell.h
//  FBAuto
//
//  Created by gaomeng on 14-7-10.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GperInfoViewController;

typedef void (^userFaceBlock)();//头像点击block

@interface GperInfoTableViewCell : UITableViewCell

@property(nonatomic,assign)GperInfoViewController *delegate;//推简介和详细的界面

//block
@property(nonatomic,copy)userFaceBlock userFaceBlock;

//block set方法
-(void)setUserFaceBlock:(userFaceBlock)userFaceBlock;

//加载控件并返回高度
-(CGFloat)loadViewWithIndexPath:(NSIndexPath*)theIndexPath;





@end
