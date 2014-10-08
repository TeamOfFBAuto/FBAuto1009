//
//  GtzDetailViewController.m
//  FBAuto
//
//  Created by gaomeng on 14-7-30.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GtzDetailViewController.h"

#import "UILabel+GautoMatchedText.h"

#import "GpersonTZdetailTableViewCell.h"


#import "GTimeSwitch.h"

@interface GtzDetailViewController ()

@end

@implementation GtzDetailViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.titleLabel.text = @"内容";
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, iPhone5?455:365) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    
    [self.view addSubview:_tableView];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self prepareNetData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}




-(void)prepareNetData{
    
    NSString *str = [NSString stringWithFormat:FBAUTO_PERSONTZ,self.uid];
    
    NSLog(@"请求单个通知详情的接口 ：%@",str);
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (data.length == 0) {
            return;
        }
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"%@",dic);
        
        NSDictionary *datainfo = [dic objectForKey:@"datainfo"];
        NSString *sss = [datainfo objectForKey:@"dateline"];
        
        NSString *time1 = [GTimeSwitch testtime:sss];
        
        NSString *time2 = [time1 substringWithRange:NSMakeRange(0, 4)];
        NSString *time3 = [time1 substringWithRange:NSMakeRange(5, 2)];
        NSString *time4 = [time1 substringWithRange:NSMakeRange(8, 2)];
        
        
        NSString *time = [NSString stringWithFormat:@"%@年%@月%@日",time2,time3,time4];
        
        self.timeStr = time;
        self.contentStr = [datainfo objectForKey:@"content"];
        
        [_tableView reloadData];
        
    }];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat height = 0;
    
    if (indexPath.row == 0) {//时间
        height = 50;
    }else if (indexPath.row == 1){//内容
        if (_tmpCell) {
            height = [_tmpCell setCellHeight];
        }else{
            _tmpCell = [[GpersonTZdetailTableViewCell alloc]init];
            _tmpCell.delegate = self;
            height = [_tmpCell setCellHeight];
        }
    }
    return height;
    
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    GpersonTZdetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GpersonTZdetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.delegate = self;
    }
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    
    
    [cell loadViewWithIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}







@end
