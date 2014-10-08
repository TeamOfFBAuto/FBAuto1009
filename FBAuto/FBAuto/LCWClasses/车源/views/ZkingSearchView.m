//
//  ZkingSearchView.m
//  FBCircle
//
//  Created by 史忠坤 on 14-5-16.
//  Copyright (c) 2014年 szk. All rights reserved.
//
//
//tag=1,代表取消按钮；tag=2代表开始编辑状态；tag=3代表点击了搜索按钮

#import "ZkingSearchView.h"

#define HEIGHT  self.frame.size.height

#define SEARCH_NORMAL_WIDTH 274


@implementation ZkingSearchView

- (id)initWithFrame:(CGRect)frame imgBG:(UIImage *) bgimg shortimgbg:(UIImage*)theimgShort imgLogo:(UIImage *)logoimg  placeholder:(NSString *)_placeholder searchWidth:(CGFloat)searchWidth ZkingSearchViewBlocs:(ZkingSearchViewBloc)_bloc
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _imgshortbg=[[UIImage alloc]init];
        _imgshortbg=theimgShort;
        
        _imglongbg=[[UIImage alloc]init];
        _imglongbg=bgimg;
        
        
        _mybloc=_bloc;
        
        searchBarWidth = searchWidth;;
        
        _searchBG=[[UIImageView alloc]initWithFrame:CGRectMake((self.width-searchBarWidth)/2.0, 0, searchBarWidth, _imglongbg.size.height)];
        _searchBG.image=_imglongbg;
        _searchBG.backgroundColor = [UIColor clearColor];
        _searchBG.userInteractionEnabled=YES;
        [self addSubview:_searchBG];
        
        _aSearchField=[[UITextField alloc]init];
        _aSearchField.delegate=self;
        _aSearchField.returnKeyType=UIReturnKeySearch;
        _aSearchField.placeholder=_placeholder;
        _aSearchField.font=[UIFont systemFontOfSize:14];
        [_searchBG addSubview:_aSearchField];
        
        
        _searchLogo=[[UIImageView alloc]initWithImage:logoimg];
        [_searchBG addSubview:_searchLogo];
        
        _cancelButton =[[UIButton alloc]init];
        [_cancelButton addTarget:self action:@selector(doCancelButton) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton.hidden=YES;
        _cancelButton.backgroundColor=[UIColor clearColor];
        [_cancelButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [_cancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _cancelButton.titleLabel.font=[UIFont systemFontOfSize:15];
        [self addSubview:_cancelButton];
        
        self.cancelLabel = [[UILabel alloc]initWithFrame:CGRectMake(264 + 3 + 5, 0, 40, 30)];
        _cancelLabel.text = @"取消";
        _cancelLabel.font = [UIFont systemFontOfSize:15];
        _cancelLabel.textColor = [UIColor whiteColor];
        [self addSubview:_cancelLabel];
        _cancelLabel.userInteractionEnabled = NO;
        
        _cancelLabel.hidden = YES;
        

        _aSearchField.frame=CGRectMake(30, (HEIGHT-15)/2, 260, 16);
        _aSearchField.backgroundColor = [UIColor clearColor];
        
        _searchLogo.center=CGPointMake(8+_searchLogo.image.size.width/2, HEIGHT/2);
        
        _cancelButton.frame=CGRectMake(264 + 3 - 20, 0, 40+20 + 20, 44);
        
       
    }
    return self;
}

-(void)testBegain{

    [_aSearchField becomeFirstResponder];
}

-(void)doCancelButton{
//取消
    
    [self backToNormal];
    
    _mybloc(@"",1);

}

- (void)backToNormal
{
    _cancelButton.hidden=YES;
    
    _cancelLabel.hidden = YES;
    
    _searchBG.image=_imglongbg;
    _searchBG.frame=CGRectMake((self.width-searchBarWidth)/2.0, 0, searchBarWidth, _imglongbg.size.height);
    
    _aSearchField.text=@"";
    [_aSearchField resignFirstResponder];
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{

    if (textView.text.length>=30) {
        return NO;
    }else{
        return YES;
    }

}
-(void)textFieldDidBeginEditing:(UITextField *)textField{

    _cancelButton.hidden = NO;
    
    _cancelLabel.hidden = NO;
    
    _searchBG.image=_imgshortbg;
    
    CGFloat left = 12.0;
    if (self.isLeft) {
        left = 0.0;
        
        _cancelButton.frame = CGRectMake(264 + 3 - 10, 0, 40, 30);
    }

    _searchBG.frame=CGRectMake(left, 0,searchBarWidth - 20 , 30);
    
    _mybloc(@"",2);
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
//    [self backToNormal];
    _mybloc(textField.text,3);
    return YES;
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
   [_aSearchField becomeFirstResponder]; 
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
