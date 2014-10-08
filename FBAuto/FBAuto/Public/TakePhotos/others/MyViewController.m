//
//  MyViewController.m
//  FBCircle
//
//  Created by soulnear on 14-5-12.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "MyViewController.h"

@interface MyViewController ()

@end

@implementation MyViewController
@synthesize leftButtonType = _leftButtonType;
@synthesize rightString = _rightString;
@synthesize leftImageName = _leftImageName;
@synthesize rightImageName = _rightImageName;
@synthesize leftString = _leftString;

@synthesize my_right_button = _my_right_button;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
       self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [self.navigationController.navigationBar setBackgroundImage:FBAUTO_NAVIGATION_IMAGE forBarMetrics: UIBarMetricsDefault];
//    FBCircleNavBackGroundImage@2x
    
    UIColor * cc = RGBCOLOR(91,138,59);
    
    
//    NSDictionary * dict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:cc,[UIFont systemFontOfSize:20],[UIColor clearColor],nil] forKeys:[NSArray arrayWithObjects:NSShadowAttributeName,NSFontAttributeName,NSShadowAttributeName,nil]];
    
    NSDictionary * dict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:cc,[UIFont systemFontOfSize:20],[UIColor clearColor],nil] forKeys:[NSArray arrayWithObjects:UITextAttributeTextColor,UITextAttributeFont,UITextAttributeTextShadowColor,nil]];
    
//
    self.navigationController.navigationBar.titleTextAttributes = dict;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (IOS7_OR_LATER) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.view.backgroundColor = RGBCOLOR(214,214,214);
	
    
    spaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceButton.width = IOS7_OR_LATER ? -5:5;
    
    self.navigationController.navigationBarHidden=NO;
   
}

-(void)setMyViewControllerLeftButtonType:(MyViewControllerLeftbuttonType)theType WithRightButtonType:(MyViewControllerRightbuttonType)rightType
{
    if (theType == MyViewControllerLeftbuttonTypeBack)
    {
        UIButton *button_back=[[UIButton alloc]initWithFrame:CGRectMake(10,8,12,21.5)];
        [button_back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [button_back setImage:FBAUTO_BACK_IMAGE forState:UIControlStateNormal];
        UIBarButtonItem *back_item=[[UIBarButtonItem alloc]initWithCustomView:button_back];
        self.navigationItem.leftBarButtonItems=@[spaceButton,back_item];
    }else if (theType == MyViewControllerLeftbuttonTypelogo)
    {
        UIImageView * leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ios7logo"]];
        leftImageView.center = CGPointMake(IOS7_OR_LATER ? 18:30,22);
        UIView *lefttttview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];
        [lefttttview addSubview:leftImageView];
        UIBarButtonItem * leftButton = [[UIBarButtonItem alloc] initWithCustomView:lefttttview];
        
        self.navigationItem.leftBarButtonItems = @[spaceButton,leftButton];
    }else if(theType == MyViewControllerLeftbuttonTypeOther)
    {
        UIImage * leftImage = [UIImage imageNamed:_leftImageName];
        
        UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [leftButton addTarget:self action:@selector(otherTypeButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [leftButton setImage:[UIImage imageNamed:self.leftImageName] forState:UIControlStateNormal];
        
        leftButton.frame = CGRectMake(0,0,leftImage.size.width,leftImage.size.height);
        
        UIBarButtonItem * leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
        
        self.navigationItem.leftBarButtonItems = @[spaceButton,leftBarButton];;
        
    }else if (theType == MyViewControllerRightbuttonTypeText)
    {
        UIButton * left_button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        left_button.frame = CGRectMake(0,0,30,44);
        
        left_button.titleLabel.textAlignment = NSTextAlignmentRight;
        
        [left_button setTitle:_leftString forState:UIControlStateNormal];
        
        left_button.titleLabel.font = [UIFont systemFontOfSize:15];
        
        [left_button setTitleColor:RGBCOLOR(91,138,59) forState:UIControlStateNormal];
        
        [left_button addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationItem.leftBarButtonItems = @[spaceButton,[[UIBarButtonItem alloc] initWithCustomView:left_button]];
    }else
    {
        
    }
    
    
    
    if (rightType == MyViewControllerRightbuttonTypeRefresh)
    {
        _my_right_button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_my_right_button setImage:[UIImage imageNamed:@"ios7_refresh4139.png"] forState:UIControlStateNormal];
        _my_right_button.frame = CGRectMake(0,0,41/2,39/2);
        _my_right_button.center = CGPointMake(300,20);
        [_my_right_button addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationItem.rightBarButtonItems= @[spaceButton,[[UIBarButtonItem alloc] initWithCustomView:_my_right_button]];
        
    }else if (rightType == MyViewControllerRightbuttonTypeSearch)
    {
        UIButton *rightview=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 37, 37/2)];
        rightview.backgroundColor=[UIColor clearColor];
        [rightview addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventTouchUpInside];
        
        
        _my_right_button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_my_right_button setImage:[UIImage imageNamed:@"ios7_newssearch.png"] forState:UIControlStateNormal];
        _my_right_button.frame = CGRectMake(IOS7_OR_LATER ? 25:10, 0, 37/2, 37/2);
        //    refreshButton.center = CGPointMake(300,20);
        [rightview addSubview:_my_right_button];
        [_my_right_button addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *_rightitem=[[UIBarButtonItem alloc]initWithCustomView:rightview];
        self.navigationItem.rightBarButtonItem=_rightitem;
        
    }else if(rightType == MyViewControllerRightbuttonTypeText)
    {
        _my_right_button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _my_right_button.frame = CGRectMake(0,0,30,44);
        
        _my_right_button.titleLabel.textAlignment = NSTextAlignmentRight;
        
        [_my_right_button setTitle:_rightString forState:UIControlStateNormal];
        
        _my_right_button.titleLabel.font = [UIFont systemFontOfSize:15];
        
        [_my_right_button setTitleColor:RGBCOLOR(91,138,59) forState:UIControlStateNormal];
        
        [_my_right_button addTarget:self action:@selector(submitData:) forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationItem.rightBarButtonItems = @[spaceButton,[[UIBarButtonItem alloc] initWithCustomView:_my_right_button]];
        
    }else if (rightType == MyViewControllerRightbuttonTypeDelete)
    {
        
    }else if (rightType == MyViewControllerRightbuttonTypePerson)
    {
        _my_right_button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _my_right_button.frame = CGRectMake(0,0,36/2,33/2);
        
        [_my_right_button setImage:[UIImage imageNamed:@"chat_people.png"] forState:UIControlStateNormal];
        
        [_my_right_button addTarget:self action:@selector(PeopleView:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem * People_button = [[UIBarButtonItem alloc] initWithCustomView:_my_right_button];
        
        self.navigationItem.rightBarButtonItems = @[spaceButton,People_button];
        
        
    }else if(rightType == MyViewControllerRightbuttonTypeOther)
    {
        UIImage * rightImage = [UIImage imageNamed:_rightImageName];
        
        _my_right_button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_my_right_button addTarget:self action:@selector(otherRightTypeButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [_my_right_button setImage:[UIImage imageNamed:self.rightImageName] forState:UIControlStateNormal];
        
        _my_right_button.frame = CGRectMake(0,0,rightImage.size.width,rightImage.size.height);
        
        UIBarButtonItem * rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:_my_right_button];
        
        self.navigationItem.rightBarButtonItems = @[spaceButton,rightBarButton];;
        
    }else
    {
        
    }
}

-(void)otherTypeButton:(UIButton *)sender
{
    
}

-(void)otherRightTypeButton:(UIButton *)sender
{
    
}

-(void)leftButtonClick:(UIButton *)sender
{
    
}

-(void)PeopleView:(UIButton *)sender
{
    [self nextResponder];
}


-(void)submitData:(UIButton *)sender
{
    
}


-(void)refresh:(UIButton *)sender
{
    
}

-(void)refreshData:(UIButton *)sender
{
    //    [self nextResponder];
}


-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
