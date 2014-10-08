//
//  GfindCarViewController.m
//  FBAuto
//
//  Created by gaomeng on 14-7-8.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GfindCarViewController.h"
#import "GfindCarTableViewCell.h"
#import "FBFindCarDetailController.h"
#import "FBDetail2Controller.h"

#import "SendCarViewController.h"
#import "FindCarPublishController.h"
#import "CarSourceClass.h"
#import "GmLoadData.h"

#import "DXAlertView.h"

#import "LShareSheetView.h"
#import <ShareSDK/ShareSDK.h>

#import "FBFriendsController.h"

@interface GfindCarViewController ()<RefreshDelegate>
{
    int _page;//第几页
    NSArray *_dataArray;
}

@end

@implementation GfindCarViewController

- (void)dealloc
{
    
    NSLog(@"%s",__FUNCTION__);
    _tmpCell.delegate = nil;
    _tmpCell = nil;
    _tableView.refreshDelegate = nil;
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
    _tableView = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"%s",__FUNCTION__);
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.flagHeight = 60;
    
    _tableView = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, 0, 320, iPhone5?568-64:415)];
    _tableView.refreshDelegate = self;
    _tableView.dataSource = self;
    
    _tableView.separatorColor = [UIColor whiteColor];
    
    [self.view addSubview:_tableView];
    
    
    if (self.gtype == 2) {//我的车源
        
        self.titleLabel.text = @"我的车源";
        
    }else if (self.gtype == 3){//我的寻车
        
        self.titleLabel.text = @"我的求购";
    }
    
    [_tableView showRefreshHeader:YES];
}

#pragma mark - 请求网络数据
//我的车源
-(void)prepareDataForType:(int)aType{
    //获取我的车源列表
    
    __weak typeof(GfindCarViewController *)weakSelf = self;
    
    __weak typeof(RefreshTableView *)weakTable = _tableView;
    
    NSString *api = @"";
    
    if (aType == 2) {
        api = [NSString stringWithFormat:FBAUTO_CARSOURCE_MYSELF,[GMAPI getUid],_page,KPageSize];
        NSLog(@"我的车源接口:%@",api);
    }else if (aType == 3)
    {
        api = [NSString stringWithFormat:FBAUTO_FINCAR_MYSELF,[GMAPI getUid],_page,KPageSize];
        NSLog(@"我的寻车接口：%@",api);
    }
    
    LCWTools *tool = [[LCWTools alloc]initWithUrl:api isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"寻车列表erro%@",[result objectForKey:@"errinfo"]);
        
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
            
            [arr addObject:aCar];
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


- (void)clickToDetail:(NSString *)info car:(NSString *)car
{
    
    
    if (self.gtype == 2) {//我的车源
        
        FBDetail2Controller *detail = [[FBDetail2Controller alloc]init];
        detail.style = Navigation_Special;
        detail.navigationTitle = @"详情";
        detail.infoId = info;
        detail.carId = car;
        detail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];
        
    }else if (self.gtype == 3){//我的寻车
        
        FBFindCarDetailController *detail = [[FBFindCarDetailController alloc]init];
        detail.style = Navigation_Special;
        detail.navigationTitle = @"详情";
        detail.infoId = info;
        detail.carId = car;
        detail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];
    }
}

/**
 *  删除 我的车源、我的寻车
 *
 *  @param aType  2:车源 3:寻车
 *  @param infoId 信息id
 */

- (void)deleteDataForCell:(NSIndexPath *)indexPath
{
    //获取我的车源列表
    
    __weak typeof(GfindCarViewController *)weakSelf = self;
    
    __weak typeof(RefreshTableView *)weakTable = _tableView;
    
    CarSourceClass *aCar = [_dataArray objectAtIndex:indexPath.row];
    
    NSString *api = @"";
    
    if (self.gtype == 2) {
        
        api = [NSString stringWithFormat:FBAUTO_CARSOURCE_DELETE,[GMAPI getAuthkey],aCar.id];
        
    }else if (self.gtype == 3)
    {
        api = [NSString stringWithFormat:FBAUTO_FINDCAR_DELETE,[GMAPI getAuthkey],aCar.id];
    }
    
    LCWTools *tool = [[LCWTools alloc]initWithUrl:api isPost:NO postData:nil];
    
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"删除信息 erro%@",[result objectForKey:@"errinfo"]);
        
        //成功之后删除数据源,删除cell
        
        NSMutableArray *tempArr = [NSMutableArray arrayWithArray:_dataArray];
        [tempArr removeObjectAtIndex:indexPath.row];
        _dataArray = tempArr;
        
        weakSelf.flagHeight = 60.f;
        
        weakSelf.indexPathArray = nil;
        
        [weakTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [weakTable reloadData];
        
        
    }failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        NSLog(@"failDic %@",failDic);
        
        [LCWTools showDXAlertViewWithText:[failDic objectForKey:ERROR_INFO]];
        
    }];

}


#pragma - mark RefreshDelegate <NSObject>

- (void)loadNewData
{
    _page = 1;
    
    [self prepareDataForType:self.gtype];
}

- (void)loadMoreData
{
    NSLog(@"loadMoreData");
    
    _page ++;
    
    [self prepareDataForType:self.gtype];
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CarSourceClass *aCar = (CarSourceClass *)[_dataArray objectAtIndex:indexPath.row];
    
    [self clickToDetail:aCar.id car:aCar.car];
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    if (_tmpCell) {
        height = [_tmpCell loadView:indexPath];
    }else{
        _tmpCell = [[GfindCarTableViewCell alloc]init];
        _tmpCell.delegate = self;
        height = [_tmpCell loadView:indexPath];
    }
    
    
    NSLog(@"%f",height);
    return height;
}


#pragma mark - UITableiViewDelegate && UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%s",__FUNCTION__);
    static NSString *identifier = @"identifier";
    GfindCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GfindCarTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.delegate = self;
        
    }
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    [cell loadView:indexPath];
    
    __weak typeof (self)weakSelf = self;
    __weak typeof (RefreshTableView *)btableview = _tableView;
    __weak typeof(_dataArray)weakDataArray = _dataArray;
    //设置上下箭头的点击
    [cell setAddviewBlock:^{
        
        //flag不为空的时候赋值给last
        if (weakSelf.flagIndexPath) {
            
            weakSelf.lastIndexPath = weakSelf.flagIndexPath;
        }
        //当前点击的indexPath赋值给flag
        weakSelf.flagIndexPath = indexPath;
        
        //把flag加到数组里
        NSArray *indexPathArray = @[weakSelf.flagIndexPath];

        //如果last有值 并且和flag不同 就加到数组里
        if (weakSelf.lastIndexPath && (weakSelf.lastIndexPath.row!=weakSelf.flagIndexPath.row || weakSelf.lastIndexPath.section != weakSelf.flagIndexPath.section)) {
            indexPathArray = @[weakSelf.lastIndexPath,weakSelf.flagIndexPath];
        }
        
        weakSelf.indexPathArray = indexPathArray;
        
        NSLog(@"%ld  %ld",(long)weakSelf.lastIndexPath.row,(long)weakSelf.flagIndexPath.row);
        
        //单元格高度标示
        if (indexPathArray.count == 2) {//有last 有flag
            weakSelf.flagHeight = 120;
        }else if (indexPathArray.count == 1){//last和flag为同一个
            if (weakSelf.flagHeight == 120) {
                weakSelf.flagHeight = 60;
            }else if (weakSelf.flagHeight == 60){
                weakSelf.flagHeight = 120;
                
            }
        }
        
        [btableview reloadRowsAtIndexPaths:weakSelf.indexPathArray withRowAnimation:UITableViewRowAnimationFade];
        
    }];

    [cell setCaozuoBtnBlock:^(NSInteger btnTag) {
        switch (btnTag) {
            case 10://删除
            {
                
                NSLog(@"delete Alert");
                DXAlertView *al = [[DXAlertView alloc]initWithTitle:@"您确定删除此条消息吗？" contentText:nil leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
                [al show];
                al.leftBlock = ^(){
                    NSLog(@"取消");
                };
                al.rightBlock = ^(){
                    NSLog(@"确定");
                    [weakSelf deleteDataForCell:indexPath];
                    
                };
                
                
                
                
            }
                
                break;
            case 11://修改
            {
                if (indexPath.row < weakDataArray.count) {
                    CarSourceClass *aCar = [weakDataArray objectAtIndex:indexPath.row];
                    
                    if (weakSelf.gtype == 2) {//我的车源
                        
                        [weakSelf gpushToCheyuanWithAcar:aCar];
                        
                    }else if (weakSelf.gtype == 3){//我的寻车
                        [weakSelf gpushToXuncheWithAcar:aCar];
                        
                    }
                }
            }
 
                break;
            case 12://刷新
            {
                weakSelf.lastIndexPath = nil;
                weakSelf.flagIndexPath = nil;
                weakSelf.flagHeight = 60;
                [btableview showRefreshHeader:YES];
            }
                break;
            case 13://分享
                
            {
                CarSourceClass *aCar = [weakDataArray objectAtIndex:indexPath.row];
                [weakSelf clickToShareTitle:aCar.car_name infoId:aCar.id carId:aCar.car];
            }
                
                break;
            default:
                break;
        }
    }];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.separatorInset = UIEdgeInsetsZero;
    
    if (indexPath.row < weakDataArray.count) {
        CarSourceClass *aCar = [weakDataArray objectAtIndex:indexPath.row];
        if (self.gtype == 2) {//车源
            cell.ciLable.text = @"车源";
        }else if (self.gtype == 3){
            cell.ciLable.text = @"求购";
        }
        
        cell.cLabel.text = aCar.car_name;
        cell.tLabel.text = [LCWTools timechange3:aCar.dateline];
    }
    
    return cell;
}




//点击修改跳转界面

//我的车源跳转
-(void)gpushToCheyuanWithAcar:(CarSourceClass*)aCar{
    SendCarViewController *detail = [[SendCarViewController alloc]init];
    detail.actionStyle = Action_Edit;
    detail.infoId = aCar.id;
    [self.navigationController pushViewController:detail animated:YES];
}
//我的寻车跳转
-(void)gpushToXuncheWithAcar:(CarSourceClass*)aCar{
    FindCarPublishController *detail = [[FindCarPublishController alloc]init];
    detail.style = Navigation_Special;
    detail.infoId = aCar.id;
    detail.actionStyle = Find_Action_Edit;
    [self.navigationController pushViewController:detail animated:YES];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//车源分享
- (void)clickToShareTitle:(NSString *)title infoId:(NSString *)ainfoId carId:(NSString *)carId
{
    NSLog(@"分享");
    
    __weak typeof(self) weakSelf = self;
    LShareSheetView *shareView = [[LShareSheetView alloc]initWithFrame:self.view.frame];
    [shareView actionBlock:^(NSInteger buttonIndex, NSString *shareStyle) {
        
        NSString *contentText;
        NSString *shareUrl;
        if (weakSelf.gtype == 2) {
            //车源
            
            contentText = [NSString stringWithFormat:@"我在e族汽车上发了一辆新车，有兴趣的来看(%@）。",title];
            shareUrl = [NSString stringWithFormat:FBAUTO_SHARE_CAR_SOURCE,ainfoId];
            
        }else if (weakSelf.gtype == 3)
        {
            //寻车
            contentText = [NSString stringWithFormat:@"我在e族汽车上发布了一条求购信息，有车源的朋友来看看，（%@）",title];
            
            shareUrl = [NSString stringWithFormat:FBAUTO_SHARE_CAR_FIND,ainfoId];
        }

        NSString *contentWithUrl = [NSString stringWithFormat:@"%@%@",contentText,shareUrl];
        
        UIImage *aImage = [UIImage imageNamed:@"icon114"];
        
        
        buttonIndex -= 100;
        
        NSLog(@"share %d %@",buttonIndex,shareStyle);
        switch (buttonIndex) {
            case 0:
            {
                NSLog(@"微信");
                [LCWTools shareText:contentText title:title image:aImage linkUrl:shareUrl ShareType:ShareTypeWeixiSession];
            }
                break;
            case 1:
            {
                NSLog(@"QQ");
                [LCWTools shareText:contentText title:title image:aImage linkUrl:shareUrl ShareType:ShareTypeQQ];
            }
                break;
            case 2:
            {
                NSLog(@"朋友圈");
                [LCWTools shareText:contentText title:title image:aImage linkUrl:shareUrl ShareType:ShareTypeWeixiTimeline];
            }
                break;
            case 3:
            {
                NSLog(@"微博");
                
                [LCWTools shareText:contentWithUrl title:title image:aImage linkUrl:shareUrl ShareType:ShareTypeSinaWeibo];
            }
                break;
            case 4:
            {
                NSLog(@"站内好友");
                
                FBFriendsController *friend = [[FBFriendsController alloc]init];
                friend.isShare = YES;
                //分享的内容  {@"text",@"infoId"}
                
               
                
                
                NSString *infoId = [NSString stringWithFormat:@"%@,%@",ainfoId,carId];
                
                
                if (self.gtype == 2) {
                    //车源
                    
                    friend.shareContent = @{@"text": contentText,@"infoId":infoId,SHARE_TYPE_KEY:SHARE_CARSOURCE};
                }else if (self.gtype == 3){
                    
                    friend.shareContent = @{@"text": contentText,@"infoId":infoId,SHARE_TYPE_KEY:SHARE_FINDCAR};
                }
                
                
                [self.navigationController pushViewController:friend animated:YES];
                
            }
                break;
                
            default:
                break;
        }
    }];
}


@end
