//
//  CarResourceViewController.m
//  FBAuto
//
//  Created by lcw on 14-6-25.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "CarResourceViewController.h"
#import "FBAutoAPIHeader.h"
#import "Menu_Advanced.h"
#import "Menu_Normal.h"
#import "Menu_button.h"
#import "Menu_Car.h"
#import "FBPhotoBrowserController.h"
#import "FBDetailController.h"
#import "FBDetail2Controller.h"
#import "FBSearchResultController.h"

#import "LSearchView.h"

#import "GloginViewController.h"

#import "CarBrand.h"
#import "CarStyle.h"
#import "CarType.h"

#import "FBCityData.h"

#import "AppDelegate.h"

#import "CarSourceCell.h"
#import "CarSourceClass.h"

#import "CarClass.h"

#define CAR_LIST @"CAR_LIST" //车源列表
#define CAR_SEARCH @"CAR_SEARCH" //搜索车源

@interface CarResourceViewController ()<RefreshDelegate>
{
    RefreshTableView *_table;
    
    Menu_Advanced *menu_Advanced;//高级
    Menu_Normal *menu_Standard;//（版本）
    Menu_Normal *menu_Source;//来源
    Menu_Normal *menu_Timelimit;//库存
    Menu_Car *menu_Car;//车型选择
    
    //    ZkingSearchView *zkingSearchV;
    
    UIView *navigationView;
    LSearchView *searchView;
    UIButton *cancelButton;
    
    UIView *menuBgView;
    long openIndex;//当前打开的是第几个
    
    //车源列表参数
    NSString *_car;
    int _spot_future;
    int _color_out;
    int _color_in;
    int _carfrom;
    int _usertype;
    int _province;
    int _city;
    int _page;
    
    //搜索参数
    int _searchPage;//搜索页数
    
    //    BOOL _isSearch;//是否在搜索(只有当点击搜索之后变为YES,此时刷新、加载更多都基于 搜索；只有点击了选项按钮才设为 NO)
    
    NSString *_lastRequest;//判断两次 请求接口是否一致,如果一致需要更新dataArray
    
    NSString *_searchKeyword;//搜索关键词

    
    UIView *maskView;//遮罩
    
    BOOL _needRefreshCarBrand;//是否需要更新车型数据
}

@end

@implementation CarResourceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    
    NSLog(@"%d",[GMAPI getUsername].length);
    
    BOOL loginSuccess = [[NSUserDefaults standardUserDefaults]boolForKey:LOGIN_SUCCESS];
    
    if (!loginSuccess) {
        
        [self presentViewController:[[UINavigationController alloc]initWithRootViewController:[[GloginViewController alloc]init]] animated:NO completion:^{
        }];
        
    }else{
        NSLog(@"xxname===%@ id:%@",[GMAPI getUsername],[GMAPI getUid]);
    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [navigationView removeFromSuperview];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.navigationController.navigationBar addSubview:navigationView];
    
    //定时更新
    
    if ([self needGetCarTypeData]) {
        
        //        [self getCarData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor=RGBCOLOR(22, 233, 3);
    self.view.backgroundColor = [UIColor whiteColor];
    
    //适配ios7navigationbar高度
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"daohanglan_bg_640_88"] forBarMetrics: UIBarMetricsDefault];
    
    [self createNavigationView];
    
    //menu选项
    [self createMenu];
    
    //数据展示table
    _table = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, menuBgView.bottom, 320, self.view.height - 44 - menuBgView.height - 49 - 20)];
    
    _table.refreshDelegate = self;
    _table.dataSource = self;
    
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_table];
    
    //搜索遮罩
    [_table showRefreshHeader:YES];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateAllParams:) name:UPDATE_CARSOURCE_PARAMS object:nil];
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
    
//    _searchKeyword = nil;
//    
//    [self clearSearchCondition];
//    
//    [_table showRefreshHeader:NO];
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
    
    [menu_Advanced removeFromSuperview];
    menu_Advanced = nil;//高级
    [menu_Standard removeFromSuperview];
    menu_Standard = nil;//版本
    [menu_Source removeFromSuperview];
    menu_Source = nil;//来源
    [menu_Timelimit removeFromSuperview];
    menu_Timelimit = nil;//（库存）
    [menu_Car removeFromSuperview];
    menu_Car = nil;//车型选择
    
    [self conditionViews];
}

#pragma - mark 添加寻车信息

- (void)createNavigationView
{
    navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    navigationView.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar addSubview:navigationView];
    
    //搜索
    searchView = [[LSearchView alloc]initWithFrame:CGRectMake((320 - 550 / 2.0) / 2.0, (44 - 30)/2.0, 550 / 2.0, 30) placeholder:@"请输入车型" logoImage:[UIImage imageNamed:@"sousuo_icon26_26"] maskViewShowInView:self.view searchBlock:^(SearchStyle actionStyle, NSString *searchText) {
        
        [self searchStyle:actionStyle searchText:searchText];
        
    }];
    
    [navigationView addSubview:searchView];
    
    //取消按钮
    cancelButton =[[UIButton alloc]initWithFrame:CGRectMake(320 - 44 - 10,0,44,44)];
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
//            FBSearchResultController *result = [[FBSearchResultController alloc]initWithStyle:Search_carSource];
//            result.searchKeyword = text;
//            result.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:result animated:YES];
            
            _searchKeyword = text;
            
            [self clearSearchCondition];
            
//            [self searchCarSourceWithKeyword:text page:1];
            
            [_table showRefreshHeader:YES];
            
            [self updateSearchViewNormal:YES];
        }
        
    }else if (aStyle == Search_Cancel)
    {
        [self updateSearchViewNormal:YES];
        searchView.searchField.text = @"";
    }
}

- (void)updateSearchViewNormal:(BOOL)isNormal
{
    cancelButton.hidden = isNormal;
    
    CGRect aFrame = searchView.frame;
    if (isNormal) {
        
        aFrame.origin.x = (320 - 550 / 2.0) / 2.0;
        aFrame.size.width = 550 / 2.0;
        
    }else
    {
        aFrame.origin.x = 10.f;
        aFrame.size.width = 320 - 3 * 10 - 44;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        searchView.frame = aFrame;
    }];
}


#pragma - mark 创建导航menu

- (void)createMenu
{
    menuBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    menuBgView.backgroundColor = [UIColor colorWithHexString:@"ff9c00"];
    [self.view addSubview:menuBgView];
    
    NSArray *items = @[@"车型",@"版本",@"来源",@"库存",@"高级"];
    
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
        
        
        UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(menuBtn.right, 0, 0.5, 40)];
        line.backgroundColor = [UIColor colorWithHexString:@"ffb14d"];
        [menuBgView addSubview:line];
    }
    
    [self conditionViews];
}

- (void)conditionViews
{
    menu_Advanced = [[Menu_Advanced alloc]initWithFrontView:menuBgView contentStyle:Content_All];
    
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
    
    [menu_Advanced selectCityBlock:^(NSString *cityName, NSString *provinceId, NSString *cityId) {
        
        NSLog(@"选择城市:%@ %@ %@",cityName,provinceId,cityId);
        
        _province = [provinceId intValue];
        _city = [cityId intValue];
        
        [self updateParam];
        
    }];
    
    menu_Standard = [[Menu_Normal alloc]initWithFrontView:menuBgView menuStyle:Menu_Standard];
    [menu_Standard selectNormalBlock:^(MenuStyle style, NSString *select) {
        NSLog(@"%@",select);
        
        _carfrom = [select intValue];
        
        [self updateParam];
    }];
    
    menu_Source = [[Menu_Normal alloc]initWithFrontView:menuBgView menuStyle:Menu_Source];
    [menu_Source selectNormalBlock:^(MenuStyle style, NSString *select) {
        NSLog(@"%@",select);
        
        _usertype = [select intValue];
        
        [self updateParam];
    }];
    
    menu_Timelimit = [[Menu_Normal alloc]initWithFrontView:menuBgView menuStyle:Menu_Timelimit];
    [menu_Timelimit selectNormalBlock:^(MenuStyle style, NSString *select) {
        NSLog(@"%@",select);
        
        _spot_future = [select intValue];
        
        [self updateParam];
    }];
    
    menu_Car = [[Menu_Car alloc]initWithFrontView:menuBgView];
    [menu_Car selectBlock:^(NSString *select) {
        
        NSLog(@"选择车辆信息 %@",select);
        
        _car = select;
        
        [self updateParam];
    }];

}

#pragma - mark 通过修改参数获取数据

- (void)updateParam
{
    _page = 1;
    _table.isReloadData = YES;
    [self getCarSourceList];
}

#pragma - mark 搜索车源数据

- (void)searchCarSourceWithKeyword:(NSString *)keyword page:(int)page
{
    _searchPage = page;
    
    //比较两次请求关键词是否一致,如果不一致，则刷新数据
    
    _searchKeyword = keyword;
    
    NSString *url = [NSString stringWithFormat:FBAUTO_CARSOURCE_SEARCH,keyword,_table.pageNum,KPageSize];
    
    NSLog(@"搜索车源列表 %@",url);
    
    __weak typeof(CarResourceViewController *)weakSelf = self;
    
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
        
//        [_table loadFail];
//        
//        if (_table.isReloadData) {
//            
//            [_table loadFail];
//        }else
//        {
//            
//            [LCWTools showDXAlertViewWithText:[failDic objectForKey:ERROR_INFO]];
//        }
        
        [LCWTools showDXAlertViewWithText:[failDic objectForKey:ERROR_INFO]];
        
        int errocode = [[failDic objectForKey:@"errocode"]integerValue];
        if (errocode == 1) {
            NSLog(@"结果为空");
            [_table reloadData:nil total:0];
        }
    }];
    
}

#pragma - mark 判读是否获取车型数据

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

- (NSManagedObjectContext *)context
{
    return ((AppDelegate *)[[UIApplication sharedApplication]delegate]).managedObjectContext;
}


#pragma - mark 网络获取车型数据

- (void)getCarData
{
    LCWTools *tools = [[LCWTools alloc]initWithUrl:FBAUTO_CARSOURCE_CARTYPE isPost:NO postData:nil];
    [tools requestCompletion:^(NSDictionary *result, NSError *erro) {
        NSLog(@"result %@",result);
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            
            int erroCode = [[result objectForKey:@"errcode"]intValue];
            NSString *erroInfo = [result objectForKey:@"errinfo"];
            
            if (erroCode != 0) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:erroInfo delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                
                return ;
            }
            
            __weak typeof(CarResourceViewController *)weakSelf = self;
            __weak typeof (Menu_Car *)weak_menu_car = menu_Car;
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                
                
                [weakSelf localCardata:result];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [weak_menu_car reloadFirstTable];
                });
            });
        }
    }failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"failDic %@",failDic);
        [LCWTools showDXAlertViewWithText:[failDic objectForKey:ERROR_INFO]];
    }];
}

//存储本地
- (void)localCardata:(NSDictionary *)result
{
    NSArray *dataInfo = [result objectForKey:@"datainfo"];
    
    //品牌、车型、车款
    
    NSMutableArray *brand_Arr = [NSMutableArray arrayWithCapacity:dataInfo.count];//品牌
    NSMutableArray *type_arr = [NSMutableArray array];//车型
    NSMutableArray *style_arr = [NSMutableArray array];//车款
    
    //dataInfo为数组,有效数据从下标为1开始
    for (int i = 1; i < dataInfo.count; i ++) {
        
        NSArray *carTypeArray = [dataInfo objectAtIndex:i];
        
        //carType下标为 0时代表上级名称，下标从 1 开始代表车型数据
        
        NSString *brand = [carTypeArray objectAtIndex:0];//品牌名称
        
        NSArray *brandArr = [brand componentsSeparatedByString:@"  "];
        NSString *firstLetter = [brandArr objectAtIndex:0];
        NSString *brandName = [brandArr objectAtIndex:1];
        
        CarClass *aCarBrand = [[CarClass alloc]initWithBrandId:[self carCodeForIndex:i] brandName:brandName brandFirstName:firstLetter];
        [brand_Arr addObject:aCarBrand];
        
        [FBCityData insertCarBrandId:[self carCodeForIndex:i] brandName:brandName firstLetter:firstLetter];
        
        
        for (int j = 1; j < carTypeArray.count; j ++) {
            
            NSArray *carStyleArray = [carTypeArray objectAtIndex:j];
            
            NSString *type = [carStyleArray objectAtIndex:0];//车型名称
            
            NSArray *typeArr = [type componentsSeparatedByString:@"  "];
            NSString *typeFirstLetter = [typeArr objectAtIndex:0];
            NSString *typeName = [typeArr objectAtIndex:1];
            
            CarClass *aClassType = [[CarClass alloc]initWithParentId:[self carCodeForIndex:i] typeId:[self carCodeForIndex:j] typeName:typeName firstLetter:typeFirstLetter];
            [type_arr addObject:aClassType];
            
            [FBCityData insertCarTypeId:[self carCodeForIndex:j] parentId:[self carCodeForIndex:i] typeName:typeName firstLetter:typeFirstLetter];
            
            for (int k = 1; k < carStyleArray.count; k ++) {
                
                NSString *carStyle = [carStyleArray objectAtIndex:k];
                
                NSString *style_parentId = [NSString stringWithFormat:@"%@%@",[self carCodeForIndex:i],[self carCodeForIndex:j]];
                
                CarClass *aCarStyle = [[CarClass alloc]initWithParentId:[self carCodeForIndex:j] styleId:[self carCodeForIndex:k] styleName:carStyle];
                [style_arr addObject:aCarStyle];
                
                [FBCityData insertCarStyleId:[self carCodeForIndex:k] parentId:style_parentId StyleName:carStyle];
            }
            
        }
    }
    //
    //    [[[LCWTools alloc]init]insertDataClassType:CARSOURCE_BRAND_INSERT dataArray:brand_Arr unique:nil];
    //    [[[LCWTools alloc]init]insertDataClassType:CARSOURCE_TYPE_INSETT dataArray:type_arr unique:nil];
    //    [[[LCWTools alloc]init]insertDataClassType:CARSOURCE_STYLE_INSETT dataArray:style_arr unique:nil];
    
    NSLog(@"车型数据保存完成");
    
    //记录请求数据成功时间
    
    [[NSUserDefaults standardUserDefaults]setObject:[NSDate date] forKey:FBAUTO_CARSOURCE_TIME];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}

/**
 *  一位数补两个0，两位数补一个0，三个数不用补
 *
 *  @param index 数组下标
 */
- (NSString *)carCodeForIndex:(int)index
{
    NSString *code = @"";
    if (index < 10)
    {
        code = [NSString stringWithFormat:@"00%d",index];
        
    }else if (index < 100)
    {
        code = [NSString stringWithFormat:@"0%d",index];
        
    }else
    {
        code = [NSString stringWithFormat:@"0%d",index];
    }
    return code;
}

#pragma - mark 获取车源数据

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

- (void)getCarSourceList
{
    _car = (_car == nil) ? @"000000000" : _car;
    NSString *url = [NSString stringWithFormat:@"%@&car=%@&spot_future=%d&color_out=%d&color_in=%d&carfrom=%d&usertype=%d&province=%d&city=%d&page=%d&ps=%d",FBAUTO_CARSOURCE_LIST,_car,_spot_future,_color_out,_color_in,_carfrom,_usertype,_province,_city,_table.pageNum,KPageSize];
    
    NSLog(@"车源列表 %@",url);
    
    __weak typeof(CarResourceViewController *)weakSelf = self;
    
    LCWTools *tool = [[LCWTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"车源列表erro%@",[result objectForKey:@"errinfo"]);
        //        NSLog(@"车源列表 result %@",result);
        
        NSDictionary *dataInfo = [result objectForKey:@"datainfo"];
        
        if ([dataInfo isKindOfClass:[NSDictionary class]]) {
            
            //说明无结果
            
            int total = [[dataInfo objectForKey:@"total"]intValue];
            
            NSArray *data = [dataInfo objectForKey:@"data"];
            
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:data.count];
            
            for (NSDictionary *aDic in data) {
                
                CarSourceClass *aCar = [[CarSourceClass alloc]initWithDictionary:aDic];
                
                [arr addObject:aCar];
            }
            
//            [weakSelf reloadData:arr isReload:_table.isReloadData];
            
            [_table reloadData:arr total:total];
            
        }else
        {
            
            [_table reloadData:nil total:0];
        }
        
        
        
    }failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        NSLog(@"failDic %@",failDic);
        
        [LCWTools showDXAlertViewWithText:[failDic objectForKey:ERROR_INFO]];
        
        int errocode = [[failDic objectForKey:@"errocode"]integerValue];
        if (errocode == 1) {
            NSLog(@"结果为空");
            [_table reloadData:nil total:0];
        }else
        {
            [_table loadFail];
        }
        
    }];
}


- (void)clickToDetail:(NSString *)infoId car:(NSString *)car
{
    FBDetail2Controller *detail = [[FBDetail2Controller alloc]init];
    detail.style = Navigation_Special;
    detail.navigationTitle = @"详情";
    detail.infoId = infoId;
    detail.carId = car;
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
    
}

- (void)clickToBigPhoto
{
    FBPhotoBrowserController *browser = [[FBPhotoBrowserController alloc]init];
    browser.imagesArray = @[[UIImage imageNamed:@"geren_down46_46"],[UIImage imageNamed:@"haoyou_dianhua40_46"]];
    browser.showIndex = 1;
    browser.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:browser animated:YES];
}

#pragma - mark 点击选项

- (void)clickToDo:(Menu_Button *)selectButton
{
    //    _isSearch = NO;
    
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
                
                menu_Source.itemIndex = aTag;
                
                [menu_Source showInView:self.view];
                
                [self openTag:(int)aTag];
                
            }else
                
            {
                [menu_Source hidden];
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
            [menu_Source hidden];
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
    
    if (searchView.searchField.text.length > 0) {
        
        [self searchCarSourceWithKeyword:_searchKeyword page:_table.pageNum];
        
    }else
    {
         [self getCarSourceList];
    }
    
}

- (void)loadMoreData
{
    NSLog(@"loadMoreData");
    
    if (_searchKeyword.length > 0) {
        
        [self searchCarSourceWithKeyword:_searchKeyword page:_table.pageNum];
        
    }else
    {
        [self getCarSourceList];
    }

}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CarSourceClass *aCar = (CarSourceClass *)[_table.dataArray objectAtIndex:indexPath.row];
    
    [self clickToDetail:aCar.id car:aCar.car];
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath
{
    return 75;
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
    static NSString * identifier = @"CarSourceCell";
    
    CarSourceCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"CarSourceCell" owner:self options:nil]objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row % 2 == 0) {
        cell.contentView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    }else
    {
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    if (indexPath.row < _table.dataArray.count) {
        CarSourceClass *aCar = [_table.dataArray objectAtIndex:indexPath.row];
        [cell setCellDataWithModel:aCar];
    }
    
    return cell;
    
}


@end
