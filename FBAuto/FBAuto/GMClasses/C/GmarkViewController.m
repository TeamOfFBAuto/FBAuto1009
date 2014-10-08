//
//  GmarkViewController.m
//  FBAuto
//
//  Created by gaomeng on 14-7-9.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GmarkViewController.h"
#import "GmarkTableViewCell.h"
#import "CarSourceClass.h"//model



#import "FBDetail2Controller.h"
#import "FBFindCarDetailController.h"





@interface GmarkViewController ()<RefreshDelegate>
{
    int _page;//第几页
    NSMutableArray *_dataArray;
    
}
@end

@implementation GmarkViewController

- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
    _dataArray = nil;
    _tableview.refreshDelegate = nil;
    _tableview.dataSource = nil;
    _tableview.delegate = nil;
    _dview = nil;
    _tmpCell.delegate = nil;
    _tmpCell = nil;
    _numLabel = nil;
    self.indexes = nil;
}

//-(void)viewWillAppear:(BOOL)animated{
//    self.tabBarController.tabBar.hidden = YES;
//}
//
//-(void)viewWillDisappear:(BOOL)animated{
//    self.tabBarController.tabBar.hidden = NO;
//    [_dview removeFromSuperview];
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor=[UIColor redColor];
    NSLog(@"%s",__FUNCTION__);
    
    
    self.titleLabel.text = @"我的收藏";
    
//    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"lajitong44_44.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(ggDel)];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 22, 22)];
    UIImageView *imv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lajitong44_44.png"] highlightedImage:nil];
    [view addSubview:imv];
    
    UITapGestureRecognizer * delle = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ggDel)];
    [view addGestureRecognizer:delle];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:view];
    self.navigationItem.rightBarButtonItem = right;
    
    self.delClicked = NO;
    
    _tableview = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, 0, 320, iPhone5?568-64:415)];
    _tableview.refreshDelegate = self;
    _tableview.dataSource = self;
    _tableview.separatorColor = [UIColor whiteColor];
    [self.view addSubview:_tableview];
    
    //底部删除view
    _dview = [[UIView alloc]initWithFrame:CGRectMake(0, iPhone5?568-64:415, 320, 80)];
    _dview.backgroundColor = [UIColor whiteColor];
    _dview.userInteractionEnabled = YES;
    
    //红色view
    UIView *redView = [[UIView alloc]initWithFrame:CGRectMake(65, 35, 190, 29)];
    redView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doTap1)];
    [redView addGestureRecognizer:tap];
    redView.backgroundColor = [UIColor redColor];
    redView.layer.cornerRadius = 4;
    [_dview addSubview:redView];
    
    //确定删除Label
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(54, 7, 50, 14)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.text = @"确定删除";
    [redView addSubview:titleLabel];
    
    //删除状态下的计数Label
    self.numLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame)+5, titleLabel.frame.origin.y-1, 45, titleLabel.frame.size.height)];
    self.numLabel.font = [UIFont systemFontOfSize:12];
    self.numLabel.text = @"(  )";
    self.numLabel.textColor = [UIColor whiteColor];
    [redView addSubview:self.numLabel];
    
    
    //默认为正常状态
    self.delType = 2;
    
    //网路请求页码标示
    _page =1;
    
    //分配内存
    self.indexes = [NSMutableArray arrayWithCapacity:1];
    
    
    
    
    //添加到window上
    //    [[[UIApplication sharedApplication]keyWindow] addSubview:_dview];
    
    [self.view addSubview:_dview];
    
    
    [_tableview showRefreshHeader:YES];
    
    [self prepareNetData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 请求网络数据
-(void)prepareNetData{
    NSString *api = [NSString stringWithFormat:FBAUTO_MYMARKCAR,[GMAPI getAuthkey],_page,10];
    
    NSLog(@"我的收藏api %@",api);
    
    __weak typeof(GmarkViewController *)weakSelf = self;
    __weak typeof(RefreshTableView *)weakTable = _tableview;
    
    NSString *url = [NSString stringWithFormat:@"%@&page=%d&ps=%d",api,_page,KPageSize];
    LCWTools *tool = [[LCWTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"我的收藏erro%@",[result objectForKey:@"errinfo"]);
        
        NSDictionary *dataInfo = [result objectForKey:@"datainfo"];
        int total = [[dataInfo objectForKey:@"total"]intValue];
        
        if (_page < total) {
            
            weakTable.isHaveMoreData = YES;
        }else
        {
            weakTable.isHaveMoreData = NO;
        }
        
        NSArray *data = [dataInfo objectForKey:@"data"];
        
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:data.count];
        
        
        for (NSDictionary *aDic in data) {
            CarSourceClass *aCar = [[CarSourceClass alloc]initWithDictionary:aDic];
            if ([aCar.stype_name isEqualToString:@"寻车"]) {
                aCar.stype_name = @"求购";
            }
            
            [arr addObject:aCar];
            aCar = nil;
        }
        
        [weakSelf reloadData:arr isReload:weakTable.isReloadData];
        
        
    }failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        NSLog(@"failDic %@",failDic);
        

        [LCWTools showDXAlertViewWithText:[failDic objectForKey:ERROR_INFO]];
        
        if (weakTable.isReloadData) {
            
            _page --;
            
            [weakTable performSelector:@selector(finishReloadigData) withObject:nil afterDelay:1.0];
        }
        
    }];
    
    
    
}



#pragma mark - UITableViewDelegate && UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifer";
    GmarkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GmarkTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.delegate = self;
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    [cell loadViewWithIndexPath:indexPath];//加载控件
    [cell configWithNetData:_dataArray indexPath:indexPath];//填充数据
    
    //记录indexPath 保存到self.indexs数组里
    __weak typeof (cell)bcell = cell;
    __weak typeof(self)weakSelf = self;
    [cell setDelImvClickedBlock:^(NSInteger gtag) {
        NSLog(@"%ld",(long)gtag);
        BOOL isHave = NO;
        for (NSIndexPath *ip in weakSelf.indexes) {
            if (ip.row == gtag) {
                [weakSelf.indexes removeObject:ip];
                [bcell.clickImv setImage:[UIImage imageNamed:@"xuanze_up_44_44.png"]];
                isHave = YES;
                break;
            }
        }
        if (!isHave) {
            [weakSelf.indexes addObject:[NSIndexPath indexPathForRow:gtag inSection:0]];
            [bcell.clickImv setImage:[UIImage imageNamed:@"xuanze_down_44_44.png"]];
        }
        
        NSLog(@"indexs %lu",(unsigned long)weakSelf.indexes.count);
        weakSelf.numLabel.text = [NSString stringWithFormat:@"( %lu )",(unsigned long)weakSelf.indexes.count];
        
    }];
    
    
    //遍历self.indexs数组 找到标记的收藏
    for (NSIndexPath *ip in self.indexes) {
        if (ip.row == indexPath.row) {
            [cell.clickImv setImage:[UIImage imageNamed:@"xuanze_down_44_44.png"]];
        }
    }
    
    
    
    return cell;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}


#pragma mark - 右上角删除按钮
-(void)ggDel{
    
    self.delClicked = !self.delClicked;
    
    NSLog(@"%d",self.delClicked);
    
    __weak typeof(RefreshTableView *)weakTable = _tableview;
    __weak typeof(_dview) weakView = _dview;
    __weak typeof(self) weakSelf = self;
    if (self.delClicked) {//删除界面
        self.delType = 3;
        //清空数据
        [weakSelf.indexes removeAllObjects];
        weakSelf.numLabel.text =  @"(  )";
        [UIView animateWithDuration:0.1 animations:^{
            weakView.frame = CGRectMake(0, iPhone5?568-64-80:415-80, 320, 80);
        } completion:^(BOOL finished) {
            [weakTable reloadData];
        }];
    }else{//正常界面
        weakSelf.delType = 2;
        [UIView animateWithDuration:0.1 animations:^{
            weakView.frame = CGRectMake(0, iPhone5?568-64:415, 320, 80);
        } completion:^(BOOL finished) {
            [weakTable reloadData];
        }];
    }
    
}


#pragma mark - 确认删除
-(void)doTap1{
    
    NSLog(@"------ %lu",(unsigned long)self.indexes.count);
    
    if (self.indexes.count != 0) {//有需要删除的选项
        
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];//需要删除的数据
        
        for (NSIndexPath *indexPath in self.indexes) {
            CarSourceClass *acar = _dataArray[indexPath.row];
            [array addObject:acar];
        }
        
        //本地操作======
        //删除数据
        [_dataArray removeObjectsInArray:array];
        //刷新talbeivew
        [_tableview reloadData];
        
        
        //网络操作=====
        NSMutableArray *carIdArray = [NSMutableArray arrayWithCapacity:1];
        for (CarSourceClass *acar in array) {
            [carIdArray addObject:acar.id];
            
        }
        
        [_dataArray componentsJoinedByString:@","];
        
        __weak typeof(self) weakSelf = self;
        
        NSString *api = [NSString stringWithFormat:FBAUTO_DELMYMARKCAR,[GMAPI getAuthkey],[carIdArray componentsJoinedByString:@","]];
        NSURL *url = [NSURL URLWithString:api];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            NSLog(@"%@",dic);
            if ([[dic objectForKey:@"errcode"]intValue] == 0) {
                NSLog(@"删除成功");
            }else{
                UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请检查网络" delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [al show];
            }
            
        }];
        NSLog(@"%@",api);
    }
    
    
    [self ggDel];
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


- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    if (_tmpCell) {
        height = [_tmpCell loadViewWithIndexPath:indexPath];
    }else{
        _tmpCell = [[GmarkTableViewCell alloc]init];
        _tmpCell.delegate = self;
        height = [_tmpCell loadViewWithIndexPath:indexPath];
    }
    
    return height;
    
}



- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CarSourceClass *aCar = (CarSourceClass *)[_dataArray objectAtIndex:indexPath.row];
    
    [self clickToDetail:aCar.sid car:aCar];
}


- (void)clickToDetail:(NSString *)info car:(CarSourceClass *)aCar
{
    
    NSLog(@"%@",aCar.stype_name);
    if ([aCar.stype_name isEqualToString:@"车源"]) {
        FBDetail2Controller *detail = [[FBDetail2Controller alloc]init];
        detail.style = Navigation_Special;
        detail.navigationTitle = @"详情";
        detail.infoId = info;
        detail.carId = aCar.car;
        detail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];
    }else if ([aCar.stype_name isEqualToString:@"求购"]){
        FBFindCarDetailController *detail = [[FBFindCarDetailController alloc]init];
        detail.style = Navigation_Special;
        detail.navigationTitle = @"详情";
        detail.infoId = info;
        detail.carId = aCar.car;
        detail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];
    }
    
    
    
    
}


/**
 *  刷新数据列表
 *
 *  @param dataArr  新请求的数据
 *  @param isReload 判断在刷新或者加载更多
 */
- (void)reloadData:(NSArray *)dataArr isReload:(BOOL)isReload
{
    if (isReload) {
        
        _dataArray = [NSMutableArray arrayWithArray:dataArr];
        
    }else
    {
        NSMutableArray *newArr = [NSMutableArray arrayWithArray:_dataArray];
        [newArr addObjectsFromArray:dataArr];
        _dataArray = newArr;
    }
    
    [_tableview performSelector:@selector(finishReloadigData) withObject:nil afterDelay:1.0];
}


@end
