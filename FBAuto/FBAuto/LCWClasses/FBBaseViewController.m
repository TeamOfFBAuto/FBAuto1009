//
//  FBBaseViewController.m
//  FBAuto
//
//  Created by lichaowei on 14-7-1.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FBBaseViewController.h"

@interface FBBaseViewController ()

@end

@implementation FBBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (IOS7_OR_LATER) {
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //适配ios7navigationbar高度
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"daohanglan_bg_640_88"] forBarMetrics: UIBarMetricsDefault];
    
    UIBarButtonItem *spaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceButton.width = -5;
    
    self.button_back=[[UIButton alloc]initWithFrame:CGRectMake(0,0,40,44)];
    [_button_back addTarget:self action:@selector(clickToBack:) forControlEvents:UIControlEventTouchUpInside];
    [_button_back setImage:FBAUTO_BACK_IMAGE forState:UIControlStateNormal];
    _button_back.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    UIBarButtonItem *back_item=[[UIBarButtonItem alloc]initWithCustomView:_button_back];
    self.navigationItem.leftBarButtonItems=@[spaceButton,back_item];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 21)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.text = self.navigationTitle;
    
    self.navigationItem.titleView = _titleLabel;
    
    
    if (_style == Navigation_TitleAndBack)
    {
        
        
    }else
    {
        UIButton *saveButton =[[UIButton alloc]initWithFrame:CGRectMake(0,8,30,21.5)];
        [saveButton addTarget:self action:@selector(clickToCollect:) forControlEvents:UIControlEventTouchUpInside];
        [saveButton setImage:[UIImage imageNamed:@"shoucang_46_44"] forState:UIControlStateNormal];
        UIBarButtonItem *save_item=[[UIBarButtonItem alloc]initWithCustomView:saveButton];
        
        
        UIButton *share_Button =[[UIButton alloc]initWithFrame:CGRectMake(0,8,30,21.5)];
        [share_Button addTarget:self action:@selector(clickToShare:) forControlEvents:UIControlEventTouchUpInside];
        [share_Button setImage:[UIImage imageNamed:@"fenxiang42_42"] forState:UIControlStateNormal];
        UIBarButtonItem *share_item=[[UIBarButtonItem alloc]initWithCustomView:share_Button];
        self.navigationItem.rightBarButtonItems = @[share_item,save_item];
    }
}

- (void)dealloc
{
    NSLog(@"--------%@ dealloc",NSStringFromClass([self class]));
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)PushToViewController:(UIViewController *)controller animated:(BOOL)animation
{
    controller.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:controller animated:animation];
}


- (IBAction)clickToBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

//收藏
- (void)clickToCollect:(UIButton *)sender
{
    
}

//分享
- (void)clickToShare:(UIButton *)sender
{
    
}

@end
