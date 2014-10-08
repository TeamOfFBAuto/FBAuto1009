//
//  FindCarPublishController.h
//  FBAuto
//
//  Created by lichaowei on 14-7-19.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FBBaseViewController.h"

//发布寻车信息

typedef enum{
    
    Find_Action_Add = 0,//发布寻车
    Find_Action_Edit //修改寻车
    
}Find_ActionStyle;

@interface FindCarPublishController : FBBaseViewController

@property(nonatomic,assign)Find_ActionStyle actionStyle;

@property(nonatomic,retain)NSString *infoId;

@end
