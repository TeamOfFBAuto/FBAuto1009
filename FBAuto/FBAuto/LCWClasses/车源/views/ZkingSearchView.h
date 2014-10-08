//
//  ZkingSearchView.h
//  FBCircle
//
//  Created by 史忠坤 on 14-5-16.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ZkingSearchViewBloc)(NSString *strSearchText,int tag);


@interface ZkingSearchView : UIView<UITextFieldDelegate,UITextViewDelegate>
{
    CGFloat searchBarWidth;//搜索框的宽度
}

@property(nonatomic,strong)UITextField *aSearchField;

@property(nonatomic,strong)UIImageView *searchLogo;

@property(nonatomic,strong)UIImageView *searchBG;

@property(nonatomic,strong)UIImage *imgshortbg;

@property(nonatomic,strong)UIImage *imglongbg;


@property(nonatomic,strong)UIButton *cancelButton;

@property(nonatomic,retain)UILabel *cancelLabel;

@property(nonatomic,assign)BOOL isLeft;//是否靠左



@property(nonatomic,copy)ZkingSearchViewBloc mybloc;


- (id)initWithFrame:(CGRect)frame imgBG:(UIImage *) bgimg shortimgbg:(UIImage*)theimgShort imgLogo:(UIImage *)logoimg  placeholder:(NSString *)_placeholder searchWidth:(CGFloat)searchWidth ZkingSearchViewBlocs:(ZkingSearchViewBloc)_bloc;

-(void)doCancelButton;//取消按钮

@end
