//
//  LSearchView.m
//  FBAuto
//
//  Created by lichaowei on 14-7-18.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "LSearchView.h"

@implementation LSearchView

- (id)initWithFrame:(CGRect)frame
        placeholder:(NSString *)placeholder
          logoImage:(UIImage *)logoImage
 maskViewShowInView:(UIView *)aView
        searchBlock:(SearchBlock)aBlock
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.layer.cornerRadius = 5.0;
        self.backgroundColor = [UIColor whiteColor];
        
        searchBlock = aBlock;
        
        UIImageView *logoImageV =[[UIImageView alloc]initWithImage:logoImage];
        logoImageV.frame = CGRectMake(5, (self.height - logoImage.size.height)/2.0 , logoImage.size.width, logoImage.size.height);
        [self addSubview:logoImageV];
        
        self.searchField = [[UITextField alloc]initWithFrame:CGRectMake(logoImageV.right + 5, 0, 240, self.height)];
        _searchField.delegate = self;
        _searchField.returnKeyType = UIReturnKeySearch;
        _searchField.placeholder = placeholder;
        _searchField.font=[UIFont systemFontOfSize:14];
        [self addSubview:_searchField];
        
        maskView = [[UIView alloc]initWithFrame:aView.frame];
        maskView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        [aView addSubview:maskView];
        maskView.hidden = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
        [maskView addGestureRecognizer:tap];
        
    }
    return self;
}

- (void)cancelSearch
{
    maskView.hidden = YES;
    searchBlock (Search_Cancel,nil);
    [_searchField resignFirstResponder];
}

- (void)hideKeyboard
{
    [_searchField resignFirstResponder];
    maskView.hidden = YES;
}


#pragma - mark UITextFieldDelegate

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    maskView.hidden = NO;
    [maskView.superview bringSubviewToFront:maskView];
    searchBlock (Search_BeginEdit,nil);
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
//    maskView.hidden = YES;
//   searchBlock (Search_Cancel,nil);
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    maskView.hidden = YES;
    
    searchBlock (Search_Search,textField.text);
    
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.searchField becomeFirstResponder];
}


@end
