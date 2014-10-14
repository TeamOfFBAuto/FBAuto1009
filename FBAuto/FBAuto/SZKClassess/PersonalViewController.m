//
//  PersonalViewController.m
//  FBAuto
//
//  Created by 史忠坤 on 14-6-25.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "PersonalViewController.h"
#import "FBFriendsController.h"
#import "FBPhotoBrowserController.h"

#import "GPersonTableViewCell.h"//自定义单元格
#import "GChangePwViewController.h"//修改密码
#import "GfindCarViewController.h"//寻车界面
#import "GpersonTZViewController.h"//通知
#import "GMessageSViewController.h"//消息设置
#import "GmarkViewController.h"//我的收藏
#import "GperInfoViewController.h"//我的资料
#import "GlxwmViewController.h"//联系我们
#import "GmLoadData.h"//网路请求类
#import "GlocalUserImage.h"//本地化图片
#import "GxiaoxiViewController.h"//消息

//测试
//用户主页

#import "GuserZyViewController.h"
#import "FBChatListController.h"

//退出登录
#import "CarResourceViewController.h"
#import "FBCityData.h"

#import "GloginViewController.h"



@interface PersonalViewController ()

@end

@implementation PersonalViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    
//    for (UIView *view in self.view.subviews) {
//        [view removeFromSuperview];
//    }
    
    
    //进入页面更新未读消息
    
    [self updateUnreadNumber:nil];
    
    
    //请求网络数据
    [self prepareNetData];
    
    //未读消息通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateUnreadNumber:) name:@"unReadNumber" object:nil];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=RGBCOLOR(22, 23, 3);
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.titleLabel.text = @"个人中心";
    self.button_back.hidden = YES;
    
    //头像
    self.userFaceImv = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 45, 45)];
    self.userFaceImv.backgroundColor = RGBCOLOR(180, 180, 180);
    if ([GlocalUserImage getUserFaceImage]) {
        [self.userFaceImv setImage:[GlocalUserImage getUserFaceImage]];
    }else
    {
        [self.userFaceImv setImage:[UIImage imageNamed:@"defaultFace"]];
    }
    
    [self.view addSubview:self.userFaceImv];
    
    //公司名称
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.userFaceImv.frame)+10, CGRectGetMinY(self.userFaceImv.frame)+4, 245, 17)];
    self.nameLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:self.nameLabel];
    
    //公司全称
    self.nameLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(self.nameLabel.frame.origin.x, CGRectGetMaxY(self.nameLabel.frame)+6, 245, 14)];
    self.nameLabel1.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:self.nameLabel1];
    
    
    
    NSArray *titileArray = @[@"商圈",@"消息",@"通知"];
    NSArray *imageArray = @[[UIImage imageNamed:@"shangquam182_58.png"],[UIImage imageNamed:@"xiaoxi182_58.png"],[UIImage imageNamed:@"tongzhi182_58.png"]];
    
    
    //商圈 消息 通知
    for (int i = 0; i<3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        //文字
        [btn setTitle:titileArray[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(8, 43, 8, 22)];
        //图片
        [btn setBackgroundImage:imageArray[i] forState:UIControlStateNormal];
        
        //frame
        btn.frame = CGRectMake(9+i*105, CGRectGetMaxY(self.userFaceImv.frame)+14, 91, 30);
        btn.backgroundColor = [UIColor orangeColor];
        btn.layer.cornerRadius = 4;
        btn.tag = 50+i;
        [btn addTarget:self action:@selector(clickToDetail:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        
        if (i == 0) {
            _shangquanBtn = btn;
        }else if (i == 1){
            _xiaoxiBtn = btn;
        }else if (i == 2){
            _tongzhiBtn = btn;
        }
        
        
    }
    
    
    //展示信息的tableView
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 114, 320, iPhone5?568-64-164:250) style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    
    
    
    //小红点
    self.xiaoxiRedPointView = [[UIView alloc]initWithFrame:CGRectZero];
    self.xiaoxiRedPointView.frame = CGRectMake(0, 0, 18, 18);
    self.xiaoxiRedPointView.layer.cornerRadius = 9;
    self.xiaoxiRedPointView.backgroundColor = [UIColor redColor];
    self.xiaoxiRedPointView.center = CGPointMake(CGRectGetMaxX(_xiaoxiBtn.frame), CGRectGetMinY(_xiaoxiBtn.frame));
    
    self.tongzhiRedPointView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tongzhiRedPointView.frame = CGRectMake(0, 0, 18, 18);
    self.tongzhiRedPointView.layer.cornerRadius = 9;
    self.tongzhiRedPointView.backgroundColor = [UIColor redColor];
    self.tongzhiRedPointView.center = CGPointMake(CGRectGetMaxX(_tongzhiBtn.frame), CGRectGetMinY(_tongzhiBtn.frame));
    
    
    //数字label
    self.xiaoxiNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 18, 18)];
    self.xiaoxiNumLabel.center = self.xiaoxiRedPointView.center;
    self.xiaoxiNumLabel.font = [UIFont systemFontOfSize:12];
    self.xiaoxiNumLabel.textColor = [UIColor whiteColor];
    self.xiaoxiNumLabel.textAlignment = NSTextAlignmentCenter;
    
    
    self.tongzhiNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 18, 18)];
    self.tongzhiNumLabel.center = self.tongzhiRedPointView.center;
    self.tongzhiNumLabel.font = [UIFont systemFontOfSize:12];
    self.tongzhiNumLabel.textColor = [UIColor whiteColor];
    self.tongzhiNumLabel.textAlignment = NSTextAlignmentCenter;
    
    
    
    
    [self.view addSubview:self.xiaoxiRedPointView];
    [self.view addSubview:self.tongzhiRedPointView];
    [self.view addSubview:self.xiaoxiNumLabel];
    [self.view addSubview:self.tongzhiNumLabel];
    
    self.xiaoxiRedPointView.hidden = YES;
    self.xiaoxiNumLabel.hidden = YES;
    
    self.tongzhiRedPointView.hidden = YES;
    self.tongzhiNumLabel.hidden = YES;
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - mark 更新未读消息

- (void)updateUnreadNumber:(NSNotification *)notification
{
    
    int number = [[RCIM sharedRCIM] getTotalUnreadCount];
    
    if (number == 0) {
        self.xiaoxiRedPointView.hidden = YES;
        self.xiaoxiNumLabel.hidden = YES;
    }else{
        self.xiaoxiNumLabel.text = [NSString stringWithFormat:@"%d",number];
        self.xiaoxiNumLabel.hidden = NO;
        self.xiaoxiRedPointView.hidden = NO;
    }
    
    NSLog(@"未读条数:%d",number);
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [delegate updateTabbarNumber:number];
}


#pragma mark - 请求网络数据
-(void)prepareNetData{
    GmLoadData *gmloadData = [[GmLoadData alloc]init];
    [gmloadData SeturlStr:[NSString stringWithFormat:FBAUTO_GET_USER_INFORMATION,[GMAPI getUid]] block:^(NSDictionary *dataInfo, NSString *errorinfo, NSInteger errcode) {
        if (errcode == 0) {
            NSLog(@"请求用户信息成功");
            //公司头像
             
             [self.userFaceImv sd_setImageWithURL:[NSURL URLWithString:[dataInfo objectForKey:@"headimage"]] placeholderImage:[UIImage imageNamed:@"defaultFace"]];
            
            [FBChatTool cacheUserHeadImage:[dataInfo objectForKey:@"headimage"] forUserId:[GMAPI getUid]];
            
            //公司名称
            self.nameLabel.text = [dataInfo objectForKey:@"name"];
            NSLog(@"公司名称：%@",self.nameLabel.text);
            self.nameLabel1.text = [dataInfo objectForKey:@"fullname"];
            
            NSLog(@"公司全称：%@",self.nameLabel1.text);
            [self.view reloadInputViews];
        }else{
            NSLog(@"请求用户信息失败");
            NSLog(@"%@",errorinfo);
        }
    }];
}



#pragma mark - UITableViewDelegate && UITableViewDataSource


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger num = 0;
    if (section == 0) {
        num = 4;
    }else if (section == 1){
        num = 4;
    }
    
    return num;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,17, 60, 13)];
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.textColor = RGBCOLOR(129, 129, 129);
    [view addSubview:titleLabel];
    
    
    if (section == 0) {
        titleLabel.text = @"个人信息";
    }else if (section == 1){
        titleLabel.text = @"系统设置";
    }
    return view;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    GPersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GPersonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    //添加控件
    [cell loadViewWithIndexPath:indexPath];
    
    //遮挡重叠的黑线
    UIView *xiatiao = [[UIView alloc]initWithFrame:CGRectMake(10.5, 43, 299, 1)];
    xiatiao.backgroundColor = [UIColor whiteColor];
    [cell.contentView addSubview:xiatiao];
    if ((indexPath.row == 3 && indexPath.section == 0)||(indexPath.row ==3 && indexPath.section == 1)) {
        xiatiao.hidden = YES;
    }
    
    //给titleLabel赋值
    [cell dataWithTitleLableWithIndexPath:indexPath];
    
    
    __weak typeof (cell)bcell = cell;
    
    [cell setKuangBlock:^(NSInteger index) {
        NSLog(@"%ld",(long)(index));
        [UIView animateWithDuration:0.05 animations:^{
            bcell.kuang.backgroundColor = RGBCOLOR(244, 244, 244);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.05 animations:^{
                bcell.kuang.backgroundColor = [UIColor whiteColor];
            } completion:^(BOOL finished) {
                
            }];
        }];
        
        NSLog(@"%ld",(long)index);
        
        if (index == 5) {//修改密码
            
            [self.navigationController pushViewController:[[GChangePwViewController alloc]init] animated:YES];
            
        }else if (index == 1){//我的资料
            [self.navigationController pushViewController:[[GperInfoViewController alloc]init] animated:YES];
            
        }else if (index == 2){//我的车源
            GfindCarViewController *mm = [[GfindCarViewController alloc]init];
            mm.gtype = 2;
            [self.navigationController pushViewController:mm animated:YES];
            
        }else if (index == 3){//我的寻车
            GfindCarViewController *gg = [[GfindCarViewController alloc]init];
            gg.gtype = 3;
            [self.navigationController pushViewController:gg animated:YES];
            
        }else if (index == 4){//我的收藏
            GmarkViewController *gmarkvc = [[GmarkViewController alloc]init];
            gmarkvc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:gmarkvc animated:YES];
            
        }else if (index == 6){//联系我们
            [self.navigationController pushViewController:[[GlxwmViewController alloc]init] animated:YES];
            //测试
            //[self.navigationController pushViewController:[[GyhzyViewController alloc]init] animated:YES];
            
            
        }else if (index == 7){//消息设置
            [self.navigationController pushViewController:[[GMessageSViewController alloc]init]animated:YES];
        }else if (index == 8){//退出登录
            
            UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:@"退出登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [al show];
        }
        
        
    }];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        [self tuichuDenglu];
    }
}




- (void)clickToDetail:(UIButton *)sender
{
    if (sender.tag == 50) {//商圈
        FBFriendsController *friends = [[FBFriendsController alloc]init];
        friends.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:friends animated:YES];
    }else if (sender.tag == 51){//消息
        
        FBChatListController *temp = [[FBChatListController alloc]init];
        
        [self.navigationController pushViewController:temp animated:YES];
        temp.portraitStyle = UIPortraitViewRound;
        
//        [self.navigationController pushViewController:[[GxiaoxiViewController alloc]init] animated:YES];
    }else if(sender.tag == 52){//通知
        [self.navigationController pushViewController:[[GpersonTZViewController alloc]init] animated:YES];
    }
    
}



#pragma mark - 退出登录
-(void)tuichuDenglu{
    
    NSString *api = [NSString stringWithFormat:FBAUTO_LOG_OUT,[GMAPI getUid]];
    NSLog(@"%@",api);
    
    NSURL *url = [NSURL URLWithString:api];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    //清除UserDefaults里的数据
    NSUserDefaults *standUDef=[NSUserDefaults standardUserDefaults];
    [standUDef setObject:@""  forKey:USERAUTHKEY];
    [standUDef setObject:@""  forKey:USERID];
    [standUDef setObject:@""  forKey:USERNAME];

    [standUDef setBool:NO forKey:LOGIN_SUCCESS];
    
    [standUDef setObject:NO forKey:@"switchOnorOff"];
    
    [standUDef synchronize];
    
    NSLog(@"authkey===%@",[GMAPI getAuthkey]);
    
    //清除沙盒里的数据
    
    //上传标志位
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"gIsUpFace"];
    
    //document路径
    NSString *documentPathStr = [GlocalUserImage documentFolder];
    NSString *userFace = @"/guserFaceImage.png";
    
    //文件管理器
    NSFileManager *fileM = [NSFileManager defaultManager];
    
    //清除 头像和 banner
    [fileM removeItemAtPath:[documentPathStr stringByAppendingString:userFace] error:nil];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError==0) {
            NSLog(@"成功");
            
            
            [[RCIM sharedRCIM] disconnect:NO];
            
        }else{
            NSLog(@"xxssx===%@",connectionError);
        }
    }];
    
    if (self.tabBarController.selectedIndex == 0) {
        
        UIViewController *vc = [[self.tabBarController viewControllers]objectAtIndex:0];
        [vc presentViewController:[[UINavigationController alloc]initWithRootViewController:[[GloginViewController alloc]init]] animated:NO completion:^{
        }];

    }else
    {
        self.tabBarController.selectedIndex = 0;

    }
    
}

@end
