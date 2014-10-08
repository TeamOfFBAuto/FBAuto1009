//
//  Menu_Advanced.m
//  FBAuto
//
//  Created by lichaowei on 14-6-30.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "Menu_Advanced.h"
#import "FBAutoAPIHeader.h"
#import "MenuModel.h"
#import "City.h"
#import "Menu_Header.h"
#import "MenuCell.h"

#import "FBCity.h"
#import "FBCityData.h"

#define KLEFT 0.0
#define KTOP 5.0
#define KBOTTOM 10


@implementation Menu_Advanced

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrontView:(UIView *)frontView contentStyle:(ContentStyle)aContentStyle
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
        
        sumHeight = self.height - 49 - KTOP - 44 - 20 - 40;
        
        contentStyle = aContentStyle;
        
        if (aContentStyle == Content_Area) {
            
            [self loadProvince];
            
        }else{
            
            if (aContentStyle == Content_Out_In)
            {
                dataArray = MENU_HIGHT_TITLE_MORE;
                
            }else if (aContentStyle == Content_In)
            {
                dataArray = @[@"内饰颜色"];
                
            }else
            {
                
                dataArray = MENU_HIGHT_TITLE;
            }
            
            table = [[UITableView alloc]initWithFrame:CGRectMake(KLEFT, arrowImage.bottom, self.width - 2 * KLEFT, sumHeight) style:UITableViewStylePlain];
            table.separatorInset = UIEdgeInsetsMake(10, 10, 0, 10);
            table.delegate = self;
            table.dataSource = self;
            [self addSubview:table];
            
            [table reloadData];
            
            CGRect aFrame = table.frame;
            aFrame.size.height = 45 * dataArray.count;
            table.frame = aFrame;
            
        }
        
    }
    
    return self;

}

- (void)selectBlock:(SelectBlock)aBlock
{
    selectBlock = aBlock;
}

- (void)selectCityBlock:(SelectCityBlock)aCityBlock
{
    cityBlock = aCityBlock;
}

#pragma - mark 获取城市数据

- (void)loadProvince
{
    NSArray *cityArr = [FBCityData getAllProvince];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    for (FBCity *aCity in cityArr) {
        
        NSMutableArray *cityGroup = [NSMutableArray arrayWithArray:[dic objectForKey:[aCity.cityName getFirstLetter]]];
        [cityGroup addObject:aCity];
        
        [dic setObject:cityGroup forKey:[aCity.cityName getFirstLetter]];
    }
    
    NSArray *arr = [dic allKeys];
    
    arr = [arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        NSComparisonResult result = [obj1 compare:obj2];
        return result==NSOrderedDescending;
    }];
    
    firstLetterArray = arr;
    provinceDic = dic;
    
    [self reloadSecondTable];
}



#pragma - mark 二级、三级table管理

- (void)loadCityData
{
    if (colorTable) {
        [self insertSubview:colorTable belowSubview:secondTable];
    }
    
    __weak typeof (Menu_Advanced *)weakSelf = self;
    
    NSString * path = [[NSBundle mainBundle] pathForResource:@"city.plist" ofType:nil];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSMutableArray *cityArray = [[NSMutableArray alloc] initWithContentsOfFile:path];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            NSArray *states = [[cityArray objectAtIndex:0]objectForKey:@"states"];
            
            [weakSelf groupCityWithArray:states];
            
        });
    });
}

//城市分组

- (void)groupCityWithArray:(NSArray *)states
{
    cityDic = [NSMutableDictionary dictionary];
    
    for (NSDictionary *aState in states) {
        NSString *stateName = [aState objectForKey:@"state"];
        NSString *firstLetter = [stateName getFirstLetter];
        NSArray *cities = [aState objectForKey:@"cities"];
        City *aCity = [[City alloc]initWithTitle:stateName subCities:cities];
        
        NSMutableArray *cityGroup = [NSMutableArray arrayWithArray:[cityDic objectForKey:firstLetter]];
        [cityGroup addObject:aCity];
        
        [cityDic setObject:cityGroup forKey:firstLetter];
    }
    
    NSArray* arr = [cityDic allKeys];
    arr = [arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        NSComparisonResult result = [obj1 compare:obj2];
        return result==NSOrderedDescending;
    }];
    
    firstLetterArray = arr;
    
    [self reloadSecondTable];
}

//二级table

- (void)reloadSecondTable
{
    
//    arrowImage.bottom
    
    CGFloat aWidth = 243.f;
    CGFloat aLeft = 320.f;
    
    if (contentStyle == Content_Area) {
        aWidth = 300;
        aLeft = 10.0;
    }
    
    if (secondTable == nil) {
        
        secondTable = [[UITableView alloc]initWithFrame:CGRectMake(aLeft, arrowImage.bottom, aWidth, sumHeight) style:UITableViewStylePlain];
        secondTable.delegate = self;
        secondTable.dataSource = self;
        [self addSubview:secondTable];
        
        if (contentStyle != Content_Area) {
            [UIView animateWithDuration:0.2 animations:^{
                CGRect aFrame = secondTable.frame;
                aFrame.origin.x -= 243;
                secondTable.frame = aFrame;
            }];
        }
    }
    
    [self bringSubviewToFront:secondTable];
    
    [secondTable reloadData];
}


//三级table

- (void)reloadThirdTableData:(NSArray *)dataArr provinceName:(NSString *)provinceName provinceId:(int)provinceId
{
    
    if (thirdTable == nil) {
        
        thirdTable = [[UITableView alloc]initWithFrame:CGRectMake(320, arrowImage.bottom, 158, sumHeight) style:UITableViewStylePlain];
        thirdTable.delegate = self;
        thirdTable.dataSource = self;
        [self addSubview:thirdTable];
        
        [UIView animateWithDuration:0.2 animations:^{
            CGRect aFrame = thirdTable.frame;
            aFrame.origin.x -= 158;
            thirdTable.frame = aFrame;
        }];
        
    }
    
    NSString *cityName = @"全省";
    if ([provinceName hasSuffix:@"市"]) {
        
        cityName = @"全市";
    }
    
    if ([provinceName hasSuffix:@"行政区"]) {
        
        cityName = @"全区";
    }
    
    FBCity *newCity = [[FBCity alloc]initSubcityWithName:cityName cityId:0 provinceId:0];
    newCity.provinceId = provinceId;
    
    NSMutableArray *newArr = [NSMutableArray arrayWithObject:newCity];
    [newArr addObjectsFromArray:dataArr];
    
    thirdArray = newArr;
    [thirdTable reloadData];
}


#pragma - mark 控制颜色相关table

- (void)reloadColorTableWithArray:(NSArray *)colorArr
{
    if (colorTable == nil) {
        
        colorTable = [[UITableView alloc]initWithFrame:CGRectMake(320, table.top, 243, sumHeight) style:UITableViewStylePlain];
        colorTable.delegate = self;
        colorTable.dataSource = self;
        [self addSubview:colorTable];
        
        [UIView animateWithDuration:0.2 animations:^{
            CGRect aFrame = colorTable.frame;
            aFrame.origin.x -= 243;
            colorTable.frame = aFrame;
        }];
    }
    
    [self bringSubviewToFront:colorTable];
    colorArray = colorArr;
    [colorTable reloadData];
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
    if (tableView == secondTable) {
        return firstLetterArray.count + 1;
    }
    return 1;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == secondTable) {
        NSMutableArray *arr = [NSMutableArray arrayWithArray:firstLetterArray];
        [arr insertObject:@"全" atIndex:0];
        return arr;
    }
    
    return nil ;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (tableView == secondTable) {
//        NSString *letter = [firstLetterArray objectAtIndex:section];
//        return letter;
//    }
//    return nil;
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == secondTable) {
        if (section == 0) {
            return nil;
        }
        
        NSString *letter = [firstLetterArray objectAtIndex:section - 1];
        UIView *aView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 300, 20)];
        [aView addSubview:titleLabel];
        titleLabel.backgroundColor = [UIColor colorWithHexString:@"dcdcdc"];
        //        titleLabel.te
        titleLabel.text = [NSString stringWithFormat:@"  %@",letter];
        
        return aView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 20;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == secondTable) {
        if (section == 0) {
            return 1;
        }
        
        NSString *letter = [firstLetterArray objectAtIndex:section - 1];
        
        NSArray *subCityArr = [provinceDic objectForKey:letter];
        
        return subCityArr.count;
        
    }else if (tableView == thirdTable)
    {
        return thirdArray.count;
        
    }else if (tableView == colorTable)
    {
        return colorArray.count;
    }
    return dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"menuCell";
    
    MenuCell * cell = (MenuCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MenuCell" owner:self options:nil]objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    if (tableView == secondTable) {
        
        if (indexPath.section == 0) {
            
            cell.contenLabel.text = @"全国";
            cell.contenLabel.textColor = [UIColor colorWithHexString:@"ff9c00"];
            
        }else
        {
            
            NSString *letter = [firstLetterArray objectAtIndex:indexPath.section - 1];
            
            NSArray *subCityArr = [provinceDic objectForKey:letter];
            
            FBCity *aCity = [subCityArr objectAtIndex:indexPath.row];
            
            cell.contenLabel.text = aCity.cityName;
            cell.seg_style = Seg_left;
            
            cell.contenLabel.textColor = [UIColor colorWithHexString:@"666666"];
        }
        
        return cell;
        
    }else if (tableView == thirdTable)
    {
        
        FBCity *aCity = [thirdArray objectAtIndex:indexPath.row];
        cell.contenLabel.text = aCity.cityName;
        
        
    }else if (tableView == colorTable)
    {
        cell.contenLabel.text = [colorArray objectAtIndex:indexPath.row];
        
    }else
    {
        cell.contenLabel.text = [dataArray objectAtIndex:indexPath.row];
        cell.seg_style = Seg_right;
    }
    cell.contenLabel.textColor = [UIColor colorWithHexString:@"666666"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == secondTable) {
        
        if (indexPath.section == 0) {
            
            NSLog(@"全国");
            
            cityBlock(@"全国",@"000",@"000");
            
            [self hidden];
            
            return;
        }
        
        NSString *letter = [firstLetterArray objectAtIndex:indexPath.section - 1];
        
        NSArray *subCityArr = [provinceDic objectForKey:letter];
        
        FBCity *aCity = [subCityArr objectAtIndex:indexPath.row];
        
//        [self reloadThirdTableData:[FBCityData getSubCityWithProvinceId:aCity.cityId] provinceName:aCity.cityName provinceId:aCity.provinceId];
        
        NSString *provinceId = [NSString stringWithFormat:@"%d",aCity.provinceId];
        cityBlock(aCity.cityName,provinceId,@"000");
        
        [self hidden];
        
    }else if (tableView == thirdTable)
    {
        FBCity *aCity = [thirdArray objectAtIndex:indexPath.row];

        NSString *cityName = aCity.cityName;
        NSString *provinceId = [NSString stringWithFormat:@"%d",aCity.provinceId];
        NSString *cityId = [NSString stringWithFormat:@"%d",aCity.cityId];
        
        cityBlock(cityName,provinceId,cityId);

        [self hidden];
        
    }else if (tableView == colorTable)
    {
        NSString *colorName = [colorArray objectAtIndex:indexPath.row];
        selectBlock(blockStyle,colorName,[NSString stringWithFormat:@"%d",indexPath.row]);
        [self hidden];
        
    }else
    {
        if (indexPath.row == 2) {
            
            [self loadProvince];
            
            blockStyle = Select_Area;
        }
        
        if (indexPath.row == 0) {
            NSLog(@"外观颜色");
            
            if (contentStyle == Content_In) {
                
                [self reloadColorTableWithArray:MENU_HIGHT_INSIDE_CORLOR];
                blockStyle = Select_In_Color;
                
            }else
            {
                [self reloadColorTableWithArray:MENU_HIGHT_OUTSIDE_CORLOR];
                blockStyle = Select_Out_Color;
            }
            
            
        }
        
        if (indexPath.row == 1) {
            NSLog(@"内饰颜色");
            [self reloadColorTableWithArray:MENU_HIGHT_INSIDE_CORLOR];
            blockStyle = Select_In_Color;
        }
    }
    
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
