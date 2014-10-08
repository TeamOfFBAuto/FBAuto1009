//
//  GzhuceViewController.m
//  FBAuto
//
//  Created by gaomeng on 14-7-1.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GzhuceViewController.h"
#import "GzhuceTableViewCell.h"

#define Iphone5TableViewHeight 444
#define Iphone4TableViewHeight 360


@interface GzhuceViewController ()

@end

@implementation GzhuceViewController




- (void)dealloc
{
    
    NSLog(@"%s",__FUNCTION__);
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSLog(@"%s",__FUNCTION__);
    
    //分配内存
    self.contenTfArray = [[NSMutableArray alloc]init];
    
    //自定义返回按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"fanhui_24_42.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(fanhui) forControlEvents:UIControlEventTouchUpInside];
//    leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    leftBtn.frame = CGRectMake(0, 0, 52, 21);
    UIBarButtonItem *aa = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    UIBarButtonItem * space_button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space_button.width = -27;
    
    self.navigationItem.leftBarButtonItems = @[space_button,aa];
    
    
    
    
    self.navigationItem.title = @"经纪人注册";
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.alpha = 1;
    
    //个人注册
    _btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btn1 setTitle:@"个人注册" forState:UIControlStateNormal];
    [_btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _btn1.frame = CGRectMake(0, 0, 160, 50);
    _btn1.backgroundColor = [UIColor whiteColor];
    [_btn1 setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [_btn1 addTarget:self action:@selector(gerenzhuce:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn1];
    
    
    //商家注册
    _btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btn2 setTitle:@"商家注册" forState:UIControlStateNormal];
    [_btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _btn2.frame = CGRectMake(160, 0, 160, 50);
    _btn2.backgroundColor = RGBCOLOR(238, 238, 238);
    [_btn2 addTarget:self action:@selector(shagnjiazhuce:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn2];
    
    
    //个人注册
    _gerenTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 60, 320, iPhone5?Iphone5TableViewHeight:Iphone4TableViewHeight) style:UITableViewStylePlain];
    _gerenTableView.delegate = self;
    _gerenTableView.dataSource = self;
    _gerenTableView.tag = 5;
    [self.view addSubview:_gerenTableView];
    
    //商家注册
    _shangjiaTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 60, 320, iPhone5?Iphone5TableViewHeight:Iphone4TableViewHeight) style:UITableViewStylePlain];
    _shangjiaTableView.delegate = self;
    _shangjiaTableView.dataSource = self;
    _shangjiaTableView.tag = 6;
    [self.view addSubview:_shangjiaTableView];
    _shangjiaTableView.hidden = YES;
    
    
    
    //地区pickview
    _pickeView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 20, 320, 216)];
    _pickeView.delegate = self;
    _pickeView.dataSource = self;
    [self.view addSubview:_pickeView];
    _isChooseArea = NO;
    
    //确定按钮
    UIButton *quedingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    quedingBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [quedingBtn setTitle:@"确定" forState:UIControlStateNormal];
    [quedingBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    quedingBtn.frame = CGRectMake(270, 0, 35, 30);
    [quedingBtn addTarget:self action:@selector(shouPickerView) forControlEvents:UIControlEventTouchUpInside];
    //上下横线
    UIView *shangxian = [[UIView alloc]initWithFrame:CGRectMake(270, 5, 35, 0.5)];
    shangxian.backgroundColor = [UIColor blackColor];
    UIView *xiaxian = [[UIView alloc]initWithFrame:CGRectMake(270, 25, 35, 0.5)];
    xiaxian.backgroundColor = [UIColor blackColor];
    
    //地区选择
    UIView *backPickView = [[UIView alloc]initWithFrame:CGRectMake(0, 568, 320, 216+30)];
    backPickView.backgroundColor = [UIColor whiteColor];
    [backPickView addSubview:_pickeView];
    [backPickView addSubview:shangxian];
    [backPickView addSubview:xiaxian];
    [backPickView addSubview:quedingBtn];
    self.backPickView = backPickView;
    [self.view addSubview:self.backPickView];
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"area" ofType:@"plist"];
    _data = [NSArray arrayWithContentsOfFile:path];
    
    
    _gerenTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _shangjiaTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    
}


//收pickerView
-(void)shouPickerView{
    NSLog(@"%s",__FUNCTION__);
    
    [self areaHidden];
    
    
}

//返回上一个界面
-(void)fanhui{
    [self.navigationController popViewControllerAnimated:YES];
}



//个人注册
-(void)gerenzhuce:(UIButton *)sender{
    _gerenTableView.hidden = NO;
    _shangjiaTableView.hidden = YES;
    
    //个人按钮
    [_btn1 setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    _btn1.backgroundColor = [UIColor whiteColor];
    
    //商家按钮
    [_btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _btn2.backgroundColor = RGBCOLOR(238, 238, 238);
    
    
    self.navigationItem.title = @"经纪人注册";
}

//商家注册
-(void)shagnjiazhuce:(UIButton *)sender{
    _shangjiaTableView.hidden = NO;
    _gerenTableView.hidden = YES;
    
    //商家按钮
    [_btn2 setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];//字体颜色
    _btn2.backgroundColor = [UIColor whiteColor];//背景色
    
    //个人按钮
    [_btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];//字体颜色
    _btn1.backgroundColor = RGBCOLOR(238, 238, 238);//背景色
    
    
    
    self.navigationItem.title = @"商家注册";
}





//#pragma mark - 提交
//-(void)tijiaoBtnClicked{
//    NSLog(@"%s",__FUNCTION__);
//}




#pragma mark - UITableViewDelegate && UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    if (indexPath.row == 0) {
        if (tableView.tag == 5) {//个人注册
            height = 395;
        }else if(tableView.tag ==6){//商家注册
            height = 505;
        }
    }else if (indexPath.row ==1){
        height = 50;
    }
    return height;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str1 = @"geren";
    static NSString *str2 = @"shangjia";
    
    GzhuceTableViewCell *Gcell = nil;
    if (tableView.tag == 5) {//个人
        GzhuceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str1];
        if (!cell) {
            cell = [[GzhuceTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str1];
        }
        Gcell = cell;
        [Gcell areaFuzhi];
        
    }else if (tableView.tag == 6){//商家
        GzhuceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str2];
        if (!cell) {
            cell = [[GzhuceTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str2];
        }
        Gcell = cell;
        
        [Gcell areaFuzhi];
        
    }
    
    
    
    
    if (indexPath.row == 1) {
        for (UIView *view in Gcell.contentView.subviews) {
            [view removeFromSuperview];
        }
        
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 300, 32)];
        label1.font = [UIFont systemFontOfSize:12];
        
        label1.numberOfLines = 2;
        [Gcell.contentView addSubview:label1];
        
        if (tableView.tag == 5) {
            label1.text = @"经纪人请使用个人注册，注册简单、永久免费，无需审核马上使用。用户注册的手机号码即为登陆账号。";
        }else if (tableView.tag == 6){
            label1.numberOfLines = 3;
            label1.frame = CGRectMake(10, 0, 300, 45);
            label1.text = @"商家注册需要人工审核，后期申请认证的商家需要提供企业营业执照等相关信息。用户注册的手机号码即为登陆账号。";
        }
        
        
        
    }
    
    
    Gcell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    __weak typeof (_gerenTableView)bgerenTableView = _gerenTableView;
    __weak typeof (_shangjiaTableView)bshangjiaTableView = _shangjiaTableView;
    __weak typeof (self)bself = self;
    
    //上移tableview
    [Gcell setTfBlock:^(long tt) {
        
        NSLog(@"%ld",tt);
        
        if (iPhone5) {
            if (tt == 13|| tt == 14) {
                [UIView animateWithDuration:0.3 animations:^{
                    bgerenTableView.frame = CGRectMake(0, -50, 320, Iphone5TableViewHeight);
                } completion:^(BOOL finished) {
                    
                }];
            }else if (tt == 23 || tt == 24 || tt == 25 || tt == 26 ) {
                [UIView animateWithDuration:0.3 animations:^{
                    bshangjiaTableView.frame = CGRectMake(0, -90, 320, Iphone5TableViewHeight);
                } completion:^(BOOL finished) {
                    
                }];
                
                
            }else if (tt == 27) {
                [UIView animateWithDuration:0.3 animations:^{
                    bshangjiaTableView.frame = CGRectMake(0, -150, 320, 500);
                } completion:^(BOOL finished) {
                    
                }];
            }else if (tt == 15){
                [UIView animateWithDuration:0.3 animations:^{
                    bgerenTableView.frame = CGRectMake(0, -110, 320, Iphone5TableViewHeight);
                } completion:^(BOOL finished) {
                    
                }];
            }
        }else{//不是iphone5屏幕适配
            
            if ( tt == 12 || tt == 13|| tt == 14 || tt == 15 ) {
                if (tt == 12) {
                    [UIView animateWithDuration:0.3 animations:^{
                        bgerenTableView.frame = CGRectMake(0, -50, 320, Iphone4TableViewHeight);
                    } completion:^(BOOL finished) {
                        
                    }];
                }else if (tt == 13) {//重复密码
                    [UIView animateWithDuration:0.3 animations:^{
                        bgerenTableView.frame = CGRectMake(0, -60, 320, Iphone4TableViewHeight);
                    } completion:^(BOOL finished) {
                        
                    }];
                }else if (tt == 14 || tt == 15){
                    [UIView animateWithDuration:0.3 animations:^{
                        bgerenTableView.frame = CGRectMake(0, -150, 320, Iphone4TableViewHeight);
                    } completion:^(BOOL finished) {
                        
                    }];
                }
                
            }else if (tt == 21 || tt == 22 || tt == 23 || tt == 24 || tt == 25 || tt == 26 || tt == 27) {//商家注册 地址23
                
                if (tt == 21) {
                    
                    [UIView animateWithDuration:0.3 animations:^{
                        bshangjiaTableView.frame = CGRectMake(0, 40, 320, Iphone4TableViewHeight);
                    } completion:^(BOOL finished) {
                        
                    }];
                }else if (tt == 23){
                    [UIView animateWithDuration:0.3 animations:^{
                        bshangjiaTableView.frame = CGRectMake(0, -70, 320, Iphone4TableViewHeight);
                    } completion:^(BOOL finished) {
                        
                    }];
                }else if (tt == 24){
                    [UIView animateWithDuration:0.3 animations:^{
                        bshangjiaTableView.frame = CGRectMake(0, -150, 320, Iphone4TableViewHeight);
                    } completion:^(BOOL finished) {
                        
                    }];
                }else if (tt == 25){
                    [UIView animateWithDuration:0.3 animations:^{
                        bshangjiaTableView.frame = CGRectMake(0, -190, 320, Iphone4TableViewHeight+100);
                    } completion:^(BOOL finished) {
                        
                    }];
                }else if (tt ==26){
                    [UIView animateWithDuration:0.3 animations:^{
                        bshangjiaTableView.frame = CGRectMake(0, -240, 320, Iphone4TableViewHeight+100);
                    } completion:^(BOOL finished) {
                        
                    }];
                }
                
                
                
            }
                
            
            
            
            
        }
        
        
        
        
        
        
    }];
    
    //收键盘时下移tableview
    [Gcell setShouTablevBlock:^{
        _isChooseArea = NO;
        [UIView animateWithDuration:0.3 animations:^{
            bgerenTableView.frame = CGRectMake(0, 60, 320, iPhone5?Iphone5TableViewHeight:Iphone4TableViewHeight);
            bshangjiaTableView.frame = CGRectMake(0, 60, 320, iPhone5?Iphone5TableViewHeight:Iphone4TableViewHeight);
            [bself areaHidden];
        } completion:^(BOOL finished) {
            
        }];
        
        
    }];
    
    
    //设置弹出datePickView block
    __weak typeof (Gcell)bGcell = Gcell;
    
    [Gcell setChooseAreaBlock:^{
        [bGcell allShou];
        if (_isChooseArea == NO) {
            [bself areaShow];
        }else{
            [bself areaHidden];
        }
        _isChooseArea = !_isChooseArea;
    }];
    
    
    
    
    Gcell.delegate = self;
    
    return Gcell;
}




#pragma mark - 地区选择弹出
-(void)areaShow{//地区出现
    NSLog(@"_backPickView");
    __weak typeof (self)bself = self;
    [UIView animateWithDuration:0.3 animations:^{
        bself.backPickView.frame = CGRectMake(0,iPhone5?300:216, 320, 216);
    }];
    
    
}

-(void)areaHidden{//地区隐藏
    __weak typeof (self)bself = self;
    //NSLog(@"sss ssss ssss %@ %@",self.province,self.city);
    if (_gerenTableView.hidden == NO) {
        [_gerenTableView reloadData];
    }
    if (_shangjiaTableView.hidden == NO) {
        [_shangjiaTableView reloadData];
    }
    [UIView animateWithDuration:0.3 animations:^{
        bself.backPickView.frame = CGRectMake(0, 568, 320, iPhone5?Iphone5TableViewHeight:Iphone4TableViewHeight);
        
    }];
    
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (component == 0) {
        return _data.count;
    } else if (component == 1) {
        NSArray * cities = _data[_flagRow][@"Cities"];
        return cities.count;
    }
    return 0;
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (component == 0) {
        //个人
        if (_gerenTableView.hidden == NO) {
            
            if ([_data[row][@"State"] isEqualToString:@"省份"]) {
                self.province = @"";
            }else{
                self.province = _data[row][@"State"];
                self.provinceIn = (9+row)*100;//上传
            }
        }
        //商家
        if ((_shangjiaTableView.hidden == NO)) {
            if ([_data[row][@"State"] isEqualToString:@"省份"]) {
                self.province1 = @"";
            }else{
                self.province1 = _data[row][@"State"];
                self.provinceIn1 = (9+row)*100;
            }
            
        }
        return _data[row][@"State"];
    } else if (component == 1) {
        NSArray * cities = _data[_flagRow][@"Cities"];
        if (_gerenTableView.hidden == NO) {
            if ([cities[row][@"city"] isEqualToString:@"市区县"]) {
                self.city = @"";
            }else{
                self.city = cities[row][@"city"];
                self.cityIn = self.provinceIn + row;
            }
            
        }
        if (_shangjiaTableView.hidden == NO) {
            if ([cities[row][@"city"] isEqualToString:@"市区县"]) {
                self.city1 = @"";
            }else{
                self.city1 = cities[row][@"city"];
                self.cityIn1 = self.provinceIn1 + row;
            }
            
        }
        
        return cities[row][@"city"];
    }
    return 0;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    

    if (component == 0) {
        _flagRow = row;
        _isChooseArea = YES;
    }else if (component == 1){
        _isChooseArea = YES;
    }
    
    [pickerView reloadAllComponents];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






@end
