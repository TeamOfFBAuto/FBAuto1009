//
//  LoadingIndicatorView.h
//  FBCircle
//
//  Created by gaomeng on 14-5-27.
//  Copyright (c) 2014年 szk. All rights reserved.
//

//上提加载更多的view

#import <UIKit/UIKit.h>


@interface LoadingIndicatorView : UIView

@property (nonatomic, strong) UIActivityIndicatorView *loadingIndicator;
@property (nonatomic, strong) UILabel *loadingLabel, *normalLabel;

@property(nonatomic,assign)BOOL isMessage;//是否为消息界面

// type: 1: table footer,  2: view loading, 3: block loading
/**
 *  <#Description#>
 */

@property (nonatomic, assign) int type;

- (void)startLoading;

- (void)stopLoading:(int)loadingType;



@end
