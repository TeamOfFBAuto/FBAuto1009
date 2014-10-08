//
//  GloadingView.h
//  FBCircle
//
//  Created by gaomeng on 14-6-7.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GloadingView : UIView

@property (nonatomic, strong) UIActivityIndicatorView *loadingIndicator;
@property (nonatomic, strong) UILabel *loadingLabel, *normalLabel;

@property(nonatomic,assign)BOOL isMessage;//是否为消息界面


@property (nonatomic, assign) int type;

- (void)startLoading;

- (void)stopLoading:(int)loadingType;


@end
