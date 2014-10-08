//
//  FindCarViewController.m
//  FBAuto
//
//  Created by lcw on 14-6-25.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FindCarViewController.h"
#import "FBFriendsController.h"
#import "FBSearchResultController.h"
#import "FindCarPublishController.h"
#import "FBFindCarDetailController.h"

#import "ZkingSearchView.h"

#import "Menu_Advanced.h"
#import "Menu_Normal.h"
#import "Menu_button.h"
#import "Menu_Car.h"

#import "FindCarCell.h"
#import "CarSourceClass.h"

#import "LSearchView.h"


#define CAR_LIST @"CAR_LIST" //车源列表
#define CAR_SEARCH @"CAR_SEARCH" //搜索车源

@interface FindCarViewController ()<UITableViewDataSource,UITableViewDelegate,RefreshDelegate>
{
    UIView *navigationView;
    
    RefreshTableView *_table;
    
    Menu_Advanced *menu_Advanced;//高级
    Menu_Normal *menu_Standard;//版本
    Menu_Advanced *menu_Area;//地区
    Menu_Normal *menu_Timelimit;//定金
    Menu_Car *menu_Car;//车型选择
    
    UIView *menuBgView;
    long openIndex;//当前打开的是第几个
    
    //车源列表参数
    NSString *_car;
    int _deposit;//是否支付定金
    int _color_out;
    int _color_in;
    int _carfrom;
    int _usertype;
    int _province;
    int _spot_future;//现货或期货
    int _city;
    int _page;

    
    NSString *_lastRequest;//判断两次 请求接口是否一致,如果一致需要更新dataArray
    
    NSString *_searchKeyword;//搜索关键词
    
    BOOL _needRefreshCarBrand;//是否需要更新车型数据
    
    LSearchView *searchView;
    UIButton *editButton;
    UIButton *cancelButton;
}

@end

@implementation FindCarViewController

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
    [navigationView removeFromSuperview];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar addSubview:navigationView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor=RGBCOLOR(22, 233, 30);

    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.titleLabel.text = @"求购";
    self.button_back.hidden = YES;
    
    [self createNavigationView];
    
    //menu选项
    
    [self createMenu];
    
    //数据展示table
    
    _table = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, menuBgView.bottom, 320, self.view.height -searchView.height - menuBgView.height - 49 - 15 - 20)];
    
    _table.refreshDelegate = self;
    _table.dataSource = self;
    
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_table];
    
    [_table showRefreshHeader:YES];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateAllParams:) name:UPDATE_FINDCAR_PARAMS object:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//更新筛选条件及列表内容
- (void)updateAllParams:(NSNotification *)notification
{
    if ((![_car isEqualToString:@"000000000"])|| _spot_future || _color_in || _color_out || _carfrom || _usertype || _province || _city || (_searchKeyword.length > 0)) {
        
        NSLog(@"更新");
        
        _searchKeyword = nil;
        
        [self clearSearchCondition];
        
        [_table showRefreshHeader:NO];
    }else
    {
        NSLog(@"不更新");
    }
}


/**
 *  清空筛选条件
 */
- (void)clearSearchCondition
{
    _car = @"000000000";
    _spot_future = 0;
    _color_out = 0;
    _color_in = 0;
    _carfrom = 0;
    _usertype = 0;
    _province = 0;
    _city = 0;
    _page = 1;
    _deposit = 0;
    
    [menu_Advanced removeFromSuperview];
    menu_Advanced = nil;//高级
    [menu_Standard removeFromSuperview];
    menu_Standard = nil;//版本

    [menu_Timelimit removeFromSuperview];
    menu_Timelimit = nil;//库存
    [menu_Car removeFromSuperview];
    menu_Car = nil;//车型选择
    
    [self conditionViews];
}


- (void)conditionViews
{
    menu_Advanced = [[Menu_Advanced alloc]initWithFrontView:menuBgView contentStyle:Content_In];
    
    [menu_Advanced selectBlock:^(BlockStyle style, NSString *colorName, NSString *colorId) {
        
        if (style == Select_Out_Color) {
            NSLog(@"选择颜色:外观 %@ %@",colorName,colorId);
            
            _color_out = [colorId intValue];
            
        }else
        {
            NSLog(@"选择颜色:内饰 %@ %@",colorName,colorId);
            _color_in = [colorId intValue];
        }
        
        [self updateParam];
    }];
    
    
    menu_Standard = [[Menu_Normal alloc]initWithFrontView:menuBgView menuStyle:Menu_Standard];
    [menu_Standard selectNormalBlock:^(MenuStyle style, NSString *select) {
        NSLog(@"%@",select);
        
        _carfrom = [select intValue];
        
        [self updateParam];
    }];
    
    menu_Area = [[Menu_Advanced alloc]initWithFrontView:menuBgView contentStyle:Content_Area];
    
    [menu_Area selectCityBlock:^(NSString *cityName, NSString *provinceId, NSString *cityId) {
        
        NSLog(@"选择城市:%@ %@ %@",cityName,provinceId,cityId);
        
        _province = [provinceId intValue];
        _city = [cityId intValue];
        
        [self updateParam];
        
    }];
    
    menu_Timelimit = [[Menu_Normal alloc]initWithFrontView:menuBgView menuStyle:Menu_Color_Out];
    [menu_Timelimit selectNormalBlock:^(MenuStyle style, NSString *select) {
        NSLog(@"%@",select);
        
//        _spot_future = [select intValue];
        
        NSLog(@"选择颜色:外观 %@",select);
        
        _color_out = [select intValue];
        
        [self updateParam];
    }];
    
    menu_Car = [[Menu_Car alloc]initWithFrontView:menuBgView];
    [menu_Car selectBlock:^(NSString *select) {
        
        NSLog(@"选择车辆信息 %@",select);
        
        _car = select;
        
        [self updateParam];
    }];
    
}

#pragma - mark 添加导航条

- (void)createNavigationView
{
    navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    navigationView.backgroundColor = [UIColor clearColor];
    
    //编辑按钮
    editButton =[[UIButton alloc]initWithFrame:CGRectMake(320 - 40,0,40,44)];
    [editButton addTarget:self action:@selector(clickToPublish:) forControlEvents:UIControlEventTouchUpInside];
//    editButton.backgroundColor = [UIColor orangeColor];
    [editButton setImage:[UIImage imageNamed:@"xubxhe_fabu_44_44"] forState:UIControlStateNormal];
    [navigationView addSubview:editButton];
    
    [self.navigationController.navigationBar addSubview:navigationView];
    
    //搜索
    searchView = [[LSearchView alloc]initWithFrame:CGRectMake(10, (44 - 30)/2.0, 320 - 3 * 10 - 22, 30) placeholder:@"请输入车型" logoImage:[UIImage imageNamed:@"sousuo_icon26_26"] maskViewShowInView:self.view searchBlock:^(SearchStyle actionStyle, NSString *searchText) {
        
        [self searchStyle:actionStyle searchText:searchText];
        
    }];
    
    [navigationView addSubview:searchView];
    
    //取消按钮
    cancelButton =[[UIButton alloc]initWithFrame:CGRectMake(searchView.right,0,44,44)];
    cancelButton.backgroundColor = [UIColor clearColor];
    [cancelButton addTarget:self action:@selector(clickToCancel:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [navigationView addSubview:cancelButton];
    cancelButton.hidden = YES;
    
}

- (void)clickToCancel:(UIButton *)sender
{
    [searchView cancelSearch];
}

- (void)clickToPublish:(UIButton *)sender
{
    FindCarPublishController *publish = [[FindCarPublishController alloc]init];
    publish.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:publish animated:YES];
}


#pragma - mark 处理搜索框事件

- (void)searchStyle:(SearchStyle)aStyle searchText:(NSString *)text
{
    if (aStyle == Search_BeginEdit)
    {
        //显示取消按钮、隐藏编辑按钮
        cancelButton.hidden = NO;
        editButton.hidden = YES;
        
    }else if (aStyle == Search_Search)
    {
        cancelButton.hidden = YES;
        editButton.hidden = NO;
        
        if (text && ![text isEqualToString:@""]) {
//            FBSearchResultController *result = [[FBSearchResultController alloc]initWithStyle:search_findCar];
//            result.searchKeyword = text;
//            result.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:result animated:YES];
            
            _searchKeyword = text;
            
            [self clearSearchCondition];
            
            [_table showRefreshHeader:YES];

        }
        
    }else if (aStyle == Search_Cancel)
    {
        cancelButton.hidden = YES;
        editButton.hidden = NO;
        searchView.searchField.text = @"";
    }
}



#pragma - mark 创建导航menu

- (void)createMenu
{
    menuBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    menuBgView.backgroundColor = [UIColor colorWithHexString:@"ff9c00"];
    [self.view addSubview:menuBgView];
    
//    NSArray *items = @[@"车型",@"版本",@"地区",@"定金",@"更多"];
    NSArray *items = @[@"车型",@"版本",@"地区",@"外观",@"更多"];
    
    CGFloat everyWidth = (320 - 4) / items.count;//每个需要的宽度
    CGFloat needWidth = 0.0;
    
    for (int i = 0; i < items.count; i ++) {
        
        needWidth = everyWidth;
        if (i == items.count - 1) { //最后一个宽 + 1
            needWidth += 1;
        }
        
        Menu_Button *menuBtn = [[Menu_Button alloc]initWithFrame:CGRectMake((everyWidth + 1) * i, 0, needWidth, 40) title:[items objectAtIndex:i] target:self action:@selector(clickToDo:)];
        menuBtn.tag = 1000 + i;
        menuBtn.backgroundColor = [UIColor clearColor];
        [menuBgView addSubview:menuBtn];
        
        if (i == items.count - 1) {
            menuBtn.arrowImageView.image = [UIImage imageNamed:@"jiantou_bai10_18"];
            menuBtn.arrowImageView.height = 8;
            menuBtn.arrowImageView.top -= 2;
            menuBtn.backgroundColor = [UIColor colorWithHexString:@"a0a0a0"];
            menuBtn.normalColor = @"a0a0a0";
        }else
        {
            menuBtn.arrowImageView.hidden = YES;
        }
        
        
        UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(menuBtn.right, 0, 0.5, 40)];
        line.backgroundColor = [UIColor colorWithHexString:@"ffb14d"];
        [menuBgView addSubview:line];
    }
    
    [self conditionViews];
}

#pragma - mark 通过修改参数获取数据

- (void)updateParam
{
    _page = 1;
    _table.isReloadData = YES;
    [self getFindCarSourceList];
}


#pragma - mark 获取车型数据

/**
 *  是否需要获取车型数据，一天请求一次
 */
- (BOOL)needGetCarTypeData
{
    NSLog(@"----现在时间%@",[NSDate date]);
    
    NSDate *lastDate = [[NSUserDefaults standardUserDefaults]objectForKey:FBAUTO_CARSOURCE_TIME];
    
    if (lastDate) {
        
        NSTimeInterval timeIn = [lastDate timeIntervalSinceNow];
        NSLog(@"lastDate:%@ timeInterval:%f",lastDate,timeIn);
        
        CGFloat daySeconds = 24 * 60 * 60.f;//一天的时间的秒数
        
        if ((timeIn * -1) >= daySeconds) { //超过一天
            
            return YES;
        }else
        {
            return NO;
        }
    }
    
    return YES;
}

#pragma - mark 网络请求———获取寻车列表数据

/**
 *  获取车源列表
 *
 *  @param car         车型编码 如 000001001
 *  @param spot_future 现货或者期货id（如果不选择时为0）
 *  @param color_out   外观颜色id（如果不选择时为0）
 *  @param color_in    内饰颜色id（如果不选择时为0）
 *  @param carfrom     汽车版本id（美规，中规，如果不选择时为0）
 *  @param usertype    用户类型id（商家或者个人，如果不选择时为0）
 *  @param province    省份id （如果不选择时为0）
 *  @param city        城市id（如果不选择时为0）
 *  @param page        页码
 */

- (void)getFindCarSourceList
{
    _car = (_car == nil) ? @"000000000" : _car;
    NSString *url = [NSString stringWithFormat:@"%@&car=%@&deposit=%d&color_out=%d&color_in=%d&carfrom=%d&province=%d&city=%d&spot_future=%d&page=%d&ps=%d",FBAUTO_FINDCAR_LIST,_car,_deposit,_color_out,_color_in,_carfrom,_province,_city,_spot_future,_table.pageNum,KPageSize];
    
//    __weak typeof(FindCarViewController *)weakSelf = self;
    
    LCWTools *tool = [[LCWTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"寻车列表erro%@",[result objectForKey:@"errinfo"]);
        
        NSDictionary *dataInfo = [result objectForKey:@"datainfo"];
        int total = [[dataInfo objectForKey:@"total"]intValue];
        
        NSArray *data = [dataInfo objectForKey:@"data"];
        
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:data.count];
        
        for (NSDictionary *aDic in data) {
            
            CarSourceClass *aCar = [[CarSourceClass alloc]initWithDictionary:aDic];
            
            [arr addObject:aCar];
        }
        
        [_table reloadData:arr total:total];
        
    }failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        NSLog(@"failDic %@",failDic);
        
        [LCWTools showDXAlertViewWithText:[failDic objectForKey:ERROR_INFO]];
        
        
        int errocode = [[failDic objectForKey:@"errocode"]integerValue];
        if (errocode == 1) {
            NSLog(@"结果为空");
            [_table reloadData:nil total:0];
        }
        
        [_table loadFail];
        
    }];
}

#pragma - mark 搜索车源数据

- (void)searchCarSourceWithKeyword:(NSString *)keyword page:(int)page
{
    
    NSString *url = [NSString stringWithFormat:FBAUTO_FINDCAR_SEARCH,keyword,_table.pageNum,KPageSize];
    
    NSLog(@"搜索车源或寻车列表 %@",url);
    
    __weak typeof(self)weakSelf = self;
    
    LCWTools *tool = [[LCWTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"搜索车源列表 result %@, erro%@",result,[result objectForKey:@"errinfo"]);
        
        NSDictionary *dataInfo = [result objectForKey:@"datainfo"];
        int total = [[dataInfo objectForKey:@"total"]intValue];
        
        NSArray *data = [dataInfo objectForKey:@"data"];
        
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:data.count];
        
        for (NSDictionary *aDic in data) {
            
            CarSourceClass *aCar = [[CarSourceClass alloc]initWithDictionary:aDic];
            
            [arr addObject:aCar];
        }
        
        [_table reloadData:arr total:total];
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        NSLog(@"failDic %@",failDic);
        
        [_table loadFail];
        
        if (_table.isReloadData) {
            
            
        }else
        {
            [LCWTools showDXAlertViewWithText:[failDic objectForKey:ERROR_INFO]];
        }
    }];
    
}


- (void)clickToDetail:(NSString *)info car:(NSString *)car
{
    FBFindCarDetailController *detail = [[FBFindCarDetailController alloc]init];
    detail.style = Navigation_Special;
    detail.navigationTitle = @"详情";
    detail.infoId = info;
    detail.carId = car;
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
    
}

#pragma - mark 点击选项

- (void)clickToDo:(Menu_Button *)selectButton
{
    //搜索框恢复
    
    [searchView cancelSearch];
    
    NSInteger aTag = selectButton.tag - 1000;
    
    
    //控制选择项的显示
    
    selectButton.selected = !selectButton.selected;
    
    NSLog(@"%d",selectButton.selected);
    
    switch (aTag) {
        case 0:
        {
            Menu_Button *button = (Menu_Button *)[menuBgView viewWithTag:1000];
            
            if (button.selected) {
                
                menu_Car.itemIndex = aTag;
                [menu_Car showInView:self.view];
                
                [self openTag:(int)aTag];
                
            }else
            {
                [menu_Car hidden];
            }
        }
            break;
        case 1:
        {
            if (selectButton.selected) {
                
                menu_Standard.itemIndex = aTag;
                
                [menu_Standard showInView:self.view];
                
                [self openTag:(int)aTag];
                
            }else
                
            {
                [menu_Standard hidden];
            }
        }
            break;
        case 2:
        {
            if (selectButton.selected) {
                
                menu_Area.itemIndex = aTag;
                
                [menu_Area showInView:self.view];
                
                [self openTag:(int)aTag];
                
            }else
                
            {
                [menu_Area hidden];
            }
        }
            break;
        case 3:
        {
            if (selectButton.selected) {
                
                menu_Timelimit.itemIndex = aTag;
                
                [menu_Timelimit showInView:self.view];
                
                [self openTag:(int)aTag];
                
            }else
                
            {
                [menu_Timelimit hidden];
            }
        }
            break;
        case 4:
        {
            if (selectButton.selected) {
                
                menu_Advanced.itemIndex = aTag;
                
                [menu_Advanced showInView:self.view];
                
                [self openTag:(int)aTag];
                
            }else
                
            {
                [menu_Advanced hidden];
            }
        }
            break;
            
        default:
            break;
    }
    
}

- (void)openTag:(int)openTag
{
    long newIndex = openTag + 1000;
    if (newIndex == openIndex) {
        return;
    }
    
    switch (openIndex - 1000) {
        case 0:
        {
            [menu_Car hidden];
        }
            break;
        case 1:
        {
            [menu_Standard hidden];
        }
            break;
        case 2:
        {
            [menu_Area hidden];
        }
            break;
        case 3:
        {
            [menu_Timelimit hidden];
        }
            break;
        case 4:
        {
            [menu_Advanced hidden];
        }
            break;
            
        default:
            break;
    }
    
    openIndex = newIndex;
    
}

#pragma - mark RefreshDelegate <NSObject>

- (void)loadNewData
{
    NSLog(@"loadNewData");
    
    if (_searchKeyword.length > 0) {
        
        [self searchCarSourceWithKeyword:_searchKeyword page:_table.pageNum];
        
    }else
    {
        [self getFindCarSourceList];
    }

}

- (void)loadMoreData
{
    NSLog(@"loadMoreData");

    if (_searchKeyword.length > 0) {
        
        [self searchCarSourceWithKeyword:_searchKeyword page:_table.pageNum];
        
    }else
    {
        [self getFindCarSourceList];
    }
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CarSourceClass *aCar = (CarSourceClass *)[_table.dataArray objectAtIndex:indexPath.row];
    
    [self clickToDetail:aCar.id car:aCar.car];
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

#pragma mark - UITableViewDelegate


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _table.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"FindCarCell";
    
    FindCarCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"FindCarCell" owner:self options:nil]objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    
    if (indexPath.row < _table.dataArray.count) {
        CarSourceClass *aCar = [_table.dataArray objectAtIndex:indexPath.row];
        [cell setCellDataWithModel:aCar];
    }
    
    return cell;
    
}


@end
