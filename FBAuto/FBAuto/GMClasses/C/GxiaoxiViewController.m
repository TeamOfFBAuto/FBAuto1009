//
//  GxiaoxiViewController.m
//  FBAuto
//
//  Created by gaomeng on 14-7-24.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GxiaoxiViewController.h"

#import "GxiaoxiTableViewCell.h"

#import "FBCityData.h"

#import "XMPPMessageModel.h"

@interface GxiaoxiViewController ()
{
    
    NSArray *_dataArray;//数据源
    
}
@end

@implementation GxiaoxiViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self queryHistoryMessage];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.titleLabel.text = @"我的消息";
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, iPhone5?455:365) style:UITableViewStylePlain];

    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    [self.view addSubview:_tableView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - mark 消息历史最新一条

//获取数据 : 来自本地数据库
- (void)queryHistoryMessage
{
//    NSUserDefaults *defalts = [NSUserDefaults standardUserDefaults];
//    NSString *userName = [defalts objectForKey:XMPP_USERID];
//    
//    NSArray *arr = [FBCityData queryAllNewestMessageForUser:userName];
//    
//    NSLog(@"queryAllNewestMessageForUser userId %@ %d",arr,arr.count);
//    
//    _dataArray = arr;
//    
//    [_tableView reloadData];
}

#pragma mark - UITableViewDelegate && UITableViewDatasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
//    return 20;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    
    GxiaoxiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GxiaoxiTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    XMPPMessageModel *aModel = [_dataArray objectAtIndex:indexPath.row];
    
    [cell configWithData:aModel];
    
    cell.separatorInset = UIEdgeInsetsZero;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.f;
}





- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;

    height = 65;
    return height;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"%@",indexPath);
//    FBChatViewController *chat = [[FBChatViewController alloc]init];
//    XMPPMessageModel *aModel = [_dataArray objectAtIndex:indexPath.row];
//    chat.chatWithUser = aModel.fromPhone;
//    chat.chatWithUserName = aModel.fromName;
//    chat.chatUserId = aModel.fromId;
//    chat.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:chat animated:YES];
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}




@end
