//
//  FBSearchFriendsController.m
//  FBAuto
//
//  Created by lichaowei on 14-7-4.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FBSearchFriendsController.h"
#import "FBFriend2Cell.h"
#import "ZkingSearchView.h"
#import "FBFriendModel.h"
#import "LSearchView.h"
#import "DXAlertView.h"

@interface FBSearchFriendsController ()
{
    ZkingSearchView *zkingSearchV;
    LSearchView *searchView;
    UIButton *cancelButton;
}

@end

@implementation FBSearchFriendsController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [searchView removeFromSuperview];
    [cancelButton removeFromSuperview];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.navigationController.navigationBar addSubview:searchView];
    [self.navigationController.navigationBar addSubview:cancelButton];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createSearchViews];
    
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.height - 44 - 20) style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_table];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    _table.delegate = nil;
    _table.dataSource = nil;
    _table = nil;
    zkingSearchV = nil;
    searchView = nil;
    cancelButton = nil;
}

#pragma - mark 搜索相关view

- (void)createSearchViews
{
    __weak typeof(self)weakSelf  = self;
    //搜索
    searchView = [[LSearchView alloc]initWithFrame:CGRectMake(40, (44 - 30)/2.0, 550 / 2.0 - 4, 30) placeholder:@"请输入手机号或姓名" logoImage:[UIImage imageNamed:@"sousuo_icon26_26"] maskViewShowInView:self.view searchBlock:^(SearchStyle actionStyle, NSString *searchText) {
        
        [weakSelf searchStyle:actionStyle searchText:searchText];
        
    }];
    
    [self.navigationController.navigationBar addSubview:searchView];
    
    //取消按钮
    cancelButton =[[UIButton alloc]initWithFrame:CGRectMake(550/2.0,0,44,44)];
    cancelButton.backgroundColor = [UIColor clearColor];
    [cancelButton addTarget:self action:@selector(clickToCancel:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.navigationController.navigationBar addSubview:cancelButton];
}

#pragma - mark 处理搜索框事件

- (void)searchStyle:(SearchStyle)aStyle searchText:(NSString *)text
{
    if (aStyle == Search_BeginEdit)
    {
        //显示取消按钮、隐藏编辑按钮
        [self updateSearchViewNormal:NO];
        
    }else if (aStyle == Search_Search)
    {
        if (text && ![text isEqualToString:@""]) {
            
            [self updateSearchViewNormal:YES];
            
            [self searchFriendWithKeyword:text];
        }
        
    }else if (aStyle == Search_Cancel)
    {
        [self updateSearchViewNormal:YES];
    }
}

- (void)updateSearchViewNormal:(BOOL)isNormal
{
//    cancelButton.hidden = isNormal;
    
    CGRect aFrame = searchView.frame;
    if (isNormal) {
        
        aFrame.origin.x = 40;
        aFrame.size.width = 550 / 2.0 - 4;
        
    }else
    {
        aFrame.origin.x = 10.f;
        aFrame.size.width = 320 - 10 - 44;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        searchView.frame = aFrame;
    }];
}

- (void)clickToCancel:(UIButton *)sender
{
    [searchView cancelSearch];
}

#pragma - mark 搜索好友

- (void)searchFriendWithKeyword:(NSString *)keyWord
{
    LCWTools *tools = [[LCWTools alloc]initWithUrl:[NSString stringWithFormat:FBAUTO_FRIEND_SEARCH,[GMAPI getAuthkey],keyWord] isPost:NO postData:nil];
    
    __weak typeof (self)weakSelf = self;
    
    [tools requestCompletion:^(NSDictionary *result, NSError *erro){
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            
            int erroCode = [[result objectForKey:@"errcode"]intValue];
            NSString *erroInfo = [result objectForKey:@"errinfo"];
            
            NSLog(@"result %@ erroInfo %@",result,erroInfo);
            
            if (erroCode != 0) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:erroInfo delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                
                return ;
            }
            
            NSArray *dataInfo = [result objectForKey:@"datainfo"];
            NSMutableArray *dataArr = [NSMutableArray arrayWithCapacity:dataInfo.count];
            for (NSDictionary *aDic in dataInfo) {
                FBFriendModel *aFriend = [[FBFriendModel alloc]initWithDictionary:aDic];
                [dataArr addObject:aFriend];
            }
            
            [weakSelf reloadTableWithDataArray:dataArr];
            
        }

    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"failDic %@",failDic);
        [LCWTools showDXAlertViewWithText:[failDic objectForKey:ERROR_INFO]];
    }];
}

- (void)reloadTableWithDataArray:(NSArray *)arr
{
    self.dataArray = arr;
    [self.table reloadData];
}


-(void)searchFriendWithname:(NSString *)strname thetag:(int )_tag{
    //tag=1,代表取消按钮；tag=2代表开始编辑状态；tag=3代表点击了搜索按钮
    
    CGFloat searchLeft = 0.0f;
    
    // self.navigationController.navigationBarHidden=YES;
    switch (_tag) {
        case 1:
        {
            NSLog(@"取消");
            UIBarButtonItem *back_item=[[UIBarButtonItem alloc]initWithCustomView:self.button_back];
            self.navigationItem.leftBarButtonItems=@[back_item];
            
            searchLeft = 25.f;
            
        }
            break;
        case 2:
        {
            UIButton *_button_back=[[UIButton alloc]initWithFrame:CGRectMake(0,0,0,0)];
            UIBarButtonItem *back_item=[[UIBarButtonItem alloc]initWithCustomView:_button_back];
            self.navigationItem.leftBarButtonItems=@[back_item];
            
            searchLeft = 0.0f;
            
        }
            break;
            
        case 3:
        {
            if (strname.length == 0) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"输入内容不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
            [self searchFriendWithKeyword:strname];
        }
            break;
            
            
        default:
            break;
    }
    
    
    CGRect aFrame = zkingSearchV.frame;
    aFrame.origin.x = searchLeft;
    zkingSearchV.frame = aFrame;
    
}


#pragma mark-UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"fbFriend2Cell";
    
    FBFriend2Cell * cell = (FBFriend2Cell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"FBFriend2Cell" owner:self options:nil]objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    FBFriendModel *aModel = [_dataArray objectAtIndex:indexPath.row];
    
    [cell getCellData:aModel];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FBFriendModel *aModel = [_dataArray objectAtIndex:indexPath.row];
    
    if ([aModel.isbuddy intValue] == 1) {
        
        [LCWTools showDXAlertViewWithText:@"已是好友关系"];
        
        return;
    }
    
    NSString *name = aModel.name ? aModel.name : aModel.buddyname;
    NSString *message = [NSString stringWithFormat:@"是否添加%@为好友",name];
    DXAlertView *alert = [[DXAlertView alloc]initWithTitle:message contentText:nil leftButtonTitle:@"添加" rightButtonTitle:@"取消" isInput:NO];
    [alert show];
    
    __weak typeof(self)weakSelf = self;
    alert.leftBlock = ^(){
        NSLog(@"确定");
        [weakSelf addFriend:aModel.uid];
    };
    alert.rightBlock = ^(){
        NSLog(@"取消");
        
    };

}

#pragma - mark UIAlertViewDelegate <NSObject>

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self addFriend:[NSString stringWithFormat:@"%d",alertView.tag - 100]];
    }
}

/**
 *  添加好友
 *
 *  @param friendId userId
 */
- (void)addFriend:(NSString *)friendId
{
    NSLog(@"provinceId %@",friendId);
    
//    __weak typeof (self)weakSelf = self;
    
    LCWTools *tools = [[LCWTools alloc]initWithUrl:[NSString stringWithFormat:FBAUTO_FRIEND_ADD,[GMAPI getAuthkey],friendId]isPost:NO postData:nil];
    
    [tools requestCompletion:^(NSDictionary *result, NSError *erro) {
        NSLog(@"result %@ erro %@",result,[result objectForKey:@"errinfo"]);
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            
            //添加好友通知
            
            [[NSNotificationCenter defaultCenter]postNotificationName:UPDATE_FRIEND_LIST object:nil];
            
//            int erroCode = [[result objectForKey:@"errcode"]intValue];
            NSString *erroInfo = [result objectForKey:@"errinfo"];
            
            DXAlertView *alert = [[DXAlertView alloc]initWithTitle:erroInfo contentText:nil leftButtonTitle:nil rightButtonTitle:@"确定" isInput:NO];
            [alert show];
            
            alert.leftBlock = ^(){
                NSLog(@"确定");
            };
            alert.rightBlock = ^(){
                NSLog(@"取消");
                
            };
        }
    }failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"failDic %@",failDic);
        [LCWTools showDXAlertViewWithText:[failDic objectForKey:ERROR_INFO]];
    }];
}

@end
