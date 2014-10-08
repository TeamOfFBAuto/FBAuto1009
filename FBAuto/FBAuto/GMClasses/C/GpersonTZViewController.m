//
//  GpersonTZViewController.m
//  FBAuto
//
//  Created by gaomeng on 14-7-9.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GpersonTZViewController.h"

#import "GptzTableViewCell.h"

#import "GTimeSwitch.h"//时间处理类


#import "GtzDetailViewController.h"

@interface GpersonTZViewController ()
{
    int _page;//第几页
    NSArray *_dataArray;//数据源
}
@end

@implementation GpersonTZViewController

- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
    _tableView.refreshDelegate = nil;
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"%s",__FUNCTION__);
    
    self.titleLabel.text = @"通知";
    
    self.view.backgroundColor = [UIColor whiteColor];
    _tableView = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, 0, 320, iPhone5?455:365)];
    _tableView.refreshDelegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    self.userId = [GMAPI getUid];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    
    
    _page = 1;
    
    [_tableView showRefreshHeader:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)prepareNetData{
    
    NSString *api = [FBAUTO_PERSONTZLB stringByAppendingString:[NSString stringWithFormat:@"&page=%d",_page]];
    //请求用户通知接口
    NSLog(@"请求用户通知接口:%@",api);
    
    
    __weak typeof (self)bself = self;
    
    GmPrepareNetData *cc = [[GmPrepareNetData alloc]initWithUrl:api isPost:NO postData:nil];
    [cc requestCompletion:^(NSDictionary *result, NSError *erro) {

        
        NSDictionary *datainfo = [result objectForKey:@"datainfo"];

        NSArray *dataArray = [datainfo objectForKey:@"data"];
        
        if (dataArray.count < 10) {

            _tableView.isHaveMoreData = NO;
        }else
        {
            _tableView.isHaveMoreData = YES;
        }
        
        
        [bself reloadData:dataArray isReload:_tableView.isReloadData];
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
            if (_tableView.isReloadData) {

                _page --;

                [_tableView performSelector:@selector(finishReloadigData) withObject:nil afterDelay:1.0];
            }
    }];
    
}


#pragma mark - UITableViewDelegate && UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    GptzTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GptzTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.contentLabel.text = [_dataArray[indexPath.row]objectForKey:@"content"];
    NSString *time1 = [_dataArray[indexPath.row]objectForKey:@"dateline"];
    NSString *time2 = [GTimeSwitch testtime:time1];
    
    NSString *str = [time2 substringWithRange:NSMakeRange(0, 4)];//年
    NSString *str1 = [time2 substringWithRange:NSMakeRange(5, 2)];
    NSString *str2 = [time2 substringWithRange:NSMakeRange(8, 2)];
    
    NSString *timeStr = [NSString stringWithFormat:@"%@年%@月%@日",str,str1,str2];
    
    cell.timeLabel.text = timeStr;
    
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}






#pragma mark - 下拉刷新上提加载更多
/**
 *  刷新数据列表
 *
 *  @param dataArr  新请求的数据
 *  @param isReload 判断在刷新或者加载更多
 */
- (void)reloadData:(NSArray *)dataArr isReload:(BOOL)isReload
{
    if (isReload) {
        
        _dataArray = dataArr;
        
    }else
    {
        NSMutableArray *newArr = [NSMutableArray arrayWithArray:_dataArray];
        [newArr addObjectsFromArray:dataArr];
        _dataArray = newArr;
    }
    
    [_tableView performSelector:@selector(finishReloadigData) withObject:nil afterDelay:1.0];
}



#pragma - mark RefreshDelegate <NSObject>

- (void)loadNewData
{
    _page = 1;
    
    [self prepareNetData];
}

- (void)loadMoreData
{
    NSLog(@"loadMoreData");
    
    _page ++;
    
    [self prepareNetData];
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    GtzDetailViewController *tzd = [[GtzDetailViewController alloc]init];
    tzd.uid = [_dataArray[indexPath.row]objectForKey:@"id"];
    NSLog(@"%@",tzd.uid);
    [self.navigationController pushViewController:tzd animated:YES];
}

- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}




@end
