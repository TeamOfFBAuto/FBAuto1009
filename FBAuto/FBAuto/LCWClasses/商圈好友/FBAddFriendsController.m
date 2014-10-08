//
//  FBAddFriendsController.m
//  FBAuto
//
//  Created by lichaowei on 14-7-4.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FBAddFriendsController.h"
#import "FBMayKnowFriendsController.h"
#import "FBSearchFriendsController.h"
#import "Section_Button.h"

@interface FBAddFriendsController ()

@end

@implementation FBAddFriendsController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = @"添加好友";
    [self createView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - mark 创建视图

- (void)createView
{
    NSArray *titles = @[@"手机号/姓名",@"可能认识的人"];
    NSArray *images = @[[UIImage imageNamed:@"fangdajing_icon36_36"],[UIImage imageNamed:@"xiaoren_icon36_342"]];
    for (int i = 0; i < 2; i ++) {
        Section_Button *btn = [[Section_Button alloc]initWithFrame:CGRectMake(10, 10 + (10 + 60) * i, 300, 60) title:[titles objectAtIndex:i] target:self action:@selector(clickToDoSomething:) sectionStyle:Section_Image image:[images objectAtIndex:i]];
        btn.tag = 100 + i;
        [self.view addSubview:btn];
    }

}

- (void)clickToDoSomething:(UIButton *)btn
{
    switch (btn.tag) {
        case 100:
        {
            
            FBSearchFriendsController *addFriend = [[FBSearchFriendsController alloc]init];
            [self.navigationController pushViewController:addFriend animated:YES];
            
        }
            break;
        case 101:
        {
            FBMayKnowFriendsController *addFriend = [[FBMayKnowFriendsController alloc]init];
            addFriend.navigationTitle = @"可能认识的人";
            [self.navigationController pushViewController:addFriend animated:YES];
            
        }
            break;
            
        default:
            break;
    }
 
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
