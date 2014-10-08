//
//  Menu_Normal.m
//  FBAuto
//
//  Created by lichaowei on 14-7-1.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "Menu_Normal.h"
#import "Menu_Header.h"

#define KLEFT 10.0
#define KTOP 5.0
#define KBOTTOM 10

@implementation Menu_Normal

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrontView:(UIView *)frontView menuStyle:(MenuStyle)style
{
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        
        self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        
        arrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, frontView.bottom, 11, KTOP)];
        arrowImage.backgroundColor = [UIColor clearColor];
        arrowImage.image = [UIImage imageNamed:@"zhankaijiantou22_10"];
        [self addSubview:arrowImage];
        
        frontV = frontView;
        
        sumHeight = self.height - 49 - frontView.bottom - KTOP;
        
        table = [[UITableView alloc]initWithFrame:CGRectMake(KLEFT, arrowImage.bottom, self.width - 2 * KLEFT, sumHeight) style:UITableViewStylePlain];
        
        table.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        table.delegate = self;
        table.dataSource = self;
        [self addSubview:table];
        
        if (style == Menu_Standard)
        {
            dataArray = MENU_STANDARD;
            
        }else if (style == Menu_Source)
        {
            dataArray = MENU_SOURCE;
            
        }else if(style == Menu_Timelimit)
        {
           dataArray = MENU_TIMELIMIT;
            
        }else if(style == Menu_Color_Out)
        {
            dataArray = MENU_HIGHT_OUTSIDE_CORLOR;
        }else
        {
            dataArray = MENU_MONEY;
        }
        
        selectStyle = style;
        
        [table reloadData];
        
        CGRect aFrame = table.frame;
        
        if (style == Menu_Color_Out) {
           aFrame.size.height = 40 * dataArray.count - 49 - 20;
        }else
        {
           aFrame.size.height = 40 * dataArray.count;
        }
        
        table.frame = aFrame;
        
    }
    
    return self;
}

- (void)selectNormalBlock:(SelectNormalBlock)aBlock
{
    selectBlock = aBlock;
}

#pragma - mark 控制视图显示

- (void)showInView:(UIView *)aView
{
    [aView addSubview:self];
    [aView bringSubviewToFront:frontV];
    
    //箭头位置
    CGPoint arrowPoint = arrowImage.center;
    arrowPoint = CGPointMake(self.width / 10 + (self.width / 5) * self.itemIndex, arrowPoint.y);
    arrowImage.center = arrowPoint;
}

- (void)hidden
{
    Menu_Button *button = (Menu_Button *)[frontV viewWithTag:1000 + _itemIndex];
    button.selected = NO;
    [self removeFromSuperview];
}

#pragma mark-UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"identifier";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    cell.textLabel.text = [dataArray objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectBlock(selectStyle,[NSString stringWithFormat:@"%d",indexPath.row]);
    
    [self hidden];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hidden];
}


@end
