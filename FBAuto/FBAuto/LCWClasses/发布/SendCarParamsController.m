//
//  SendCarParamsController.m
//  FBAuto
//
//  Created by lichaowei on 14-7-2.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "SendCarParamsController.h"
#import "Menu_Header.h"
#import "CarBrand.h"
#import "CarType.h"
#import "CarStyle.h"
#import "FBCityData.h"
#import "FBCity.h"

@interface SendCarParamsController ()
{
    NSMutableDictionary *brandDic;//存储分组brand
    NSArray *firstLetterArray;//分组首字母数据brand
    
    NSDictionary *provinceDic;//存放省份

}

@end

@implementation SendCarParamsController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.height - 44 - 20) style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource = self;
    [self.view addSubview:_table];
    
    NSString *title = nil;
    switch (self.dataStyle) {
        case Data_Car_Brand:
        {
            
            title = @"车型";
            [self getCarsource];
        }
            break;
        case Data_Standard:
        {
            title = @"版本";
            self.dataArray = self.haveLimit ? MENU_STANDARD : MENU_STANDARD_2;
        }
            break;
        case Data_Timelimit:
        {
            title = @"库存";
            self.dataArray = self.haveLimit ? MENU_TIMELIMIT : MENU_TIMELIMIT_2;
        }
            break;
        case Data_Color_Out:
        {
            title = @"外观颜色";
            self.dataArray = self.haveLimit ? MENU_HIGHT_OUTSIDE_CORLOR : MENU_HIGHT_OUTSIDE_CORLOR_2;
        }
            break;
        case Data_Color_In:
        {
            title = @"内饰颜色";
            self.dataArray = self.haveLimit ? MENU_HIGHT_INSIDE_CORLOR : MENU_HIGHT_INSIDE_CORLOR_2;
        }
            break;
        case Data_Car_Type:
        {
            NSArray *typeArr = [[[LCWTools alloc]init]queryDataClassType:CARSOURCE_TYPE_QUERY pageSize:0 andOffset:0 unique:self.brandId];
            
            self.dataArray = typeArr;
            
        }
            break;
        case Data_Car_Style:
        {
            NSString *unique = [NSString stringWithFormat:@"%@%@",self.brandId,self.typeId];
            
            NSArray *styteArr = [[[LCWTools alloc]init]queryDataClassType:CARSOURCE_STYLE_QUERY pageSize:0 andOffset:0 unique:unique];
            
            self.dataArray = styteArr;
        }
            break;
        case Data_Area:
        {
            [self loadProvince];
        }
            break;
        case Data_Money:
        {
            self.dataArray = self.haveLimit ? MENU_MONEY : MENU_MONEY_2;
        }
            break;
        case Data_Area_City:
        {
            self.dataArray = [FBCityData getSubCityWithProvinceId:[self.provinceId intValue]];
        }
            break;
            
        default:
            break;
    }
    
    [self.table reloadData];

}

- (void)selectParamBlock:(SelectParamsBlock)aBlock
{
    selectBlock = aBlock;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
    _table.delegate = nil;
    _table.dataSource = nil;
    _table = nil;
    
    brandDic = nil;
    firstLetterArray = nil;
    provinceDic = nil;
    
    _dataArray = nil;
    _selectLabel = nil;
    _lastLevelId = nil;

}

#pragma - mark 自定义处理

- (void)createNewConditionStyle:(DATASTYLE)style title:(NSString *)aTitle
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:aTitle message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 1) {
        
        UITextField *TF = [alertView textFieldAtIndex:0];
        
        if (TF.text.length == 0) {
            
            [self createNewConditionStyle:self.dataStyle title:@"内容不能为空"];
            
            return;
        }

        
        if (self.dataStyle == Data_Car_Type) {
            
            NSString *car = [NSString stringWithFormat:@"%@%@%@",self.brandId,@"000",@"000"];
            selectBlock(Data_Car_Type_Custom,TF.text,car);
            
        }else if (self.dataStyle == Data_Car_Style){
            
            NSString *car = [NSString stringWithFormat:@"%@%@%@",self.brandId,self.typeId,@"000"];
            selectBlock(Data_Car_Style_Custom,TF.text,car);
        }
        
        if (self.rootVC) {
            [self.navigationController popToViewController:self.rootVC animated:YES];
        }else
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}


#pragma  - mark 获取城市地区数据

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

}



#pragma - mark 获取车品牌

- (void)getCarsource
{
    NSArray *brandArray = [[[LCWTools alloc]init]queryDataClassType:CARSOURCE_BRAND_QUERY pageSize:0 andOffset:0 unique:0];
    
    brandDic = [NSMutableDictionary dictionary];
    
    for (CarBrand *aBrand in brandArray) {
        
        NSMutableArray *brandGroup = [NSMutableArray arrayWithArray:[brandDic objectForKey:aBrand.brandFirstLetter]];
        
        [brandGroup addObject:aBrand];
        
        [brandDic setObject:brandGroup forKey:aBrand.brandFirstLetter];
    }
    
    NSArray* arr = [brandDic allKeys];
    arr = [arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        NSComparisonResult result = [obj1 compare:obj2];
        return result==NSOrderedDescending;
    }];
    
    firstLetterArray = arr;
    
    [self.table reloadData];
}

#pragma mark-UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.dataStyle == Data_Car_Brand) {
        
        return firstLetterArray.count;
        
    }else if (self.dataStyle == Data_Area)
    {
        return firstLetterArray.count + 1;
    }
    return 1;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (self.dataStyle == Data_Car_Brand) {
        
        return firstLetterArray;
        
    }else if (self.dataStyle == Data_Area){
        
        NSMutableArray *arr = [NSMutableArray arrayWithArray:firstLetterArray];
        [arr insertObject:@"全" atIndex:0];
        return arr;
    }
    
    return nil ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.dataStyle == Data_Car_Brand) {
        return 20;
    }else if (_dataStyle == Data_Area)
    {
        if (section == 0) {
            return 0;
        }else
        {
            return 20;
        }
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.dataStyle == Data_Car_Brand) {
        
        NSString *letter = [firstLetterArray objectAtIndex:section];
        
        UIView *aView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
        [aView addSubview:titleLabel];
        titleLabel.backgroundColor = [UIColor colorWithHexString:@"dcdcdc"];
        titleLabel.text = [NSString stringWithFormat:@"  %@",letter];
        
        return aView;
    }else if (_dataStyle == Data_Area)
    {
        if (section == 0) {
            return nil;
        }
        
        NSString *letter = [firstLetterArray objectAtIndex:section - 1];
        UIView *aView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 300, 20)];
        [aView addSubview:titleLabel];
        titleLabel.backgroundColor = [UIColor colorWithHexString:@"dcdcdc"];
        titleLabel.text = [NSString stringWithFormat:@"  %@",letter];
        
        return aView;
    }
    
    return nil;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataStyle == Data_Car_Brand) {
        
        NSString *letter = [firstLetterArray objectAtIndex:section];
        
        NSArray *subArr = [brandDic objectForKey:letter];
        
        return subArr.count;
        
    }else if (_dataStyle == Data_Area){
        
        if (section == 0) {
            return 1;
        }
        
        NSString *letter = [firstLetterArray objectAtIndex:section - 1];
        
        NSArray *subCityArr = [provinceDic objectForKey:letter];
        
        return subCityArr.count;
    }else if (_dataStyle == Data_Car_Type || _dataStyle == Data_Car_Style)
    {
        return _dataArray.count + 2;
    }
    return _dataArray.count;
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
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:14.f];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"666666"];
    
    if (self.dataStyle == Data_Car_Brand) {
        
        NSString *letter = [firstLetterArray objectAtIndex:indexPath.section];
        
        NSArray *subArr = [brandDic objectForKey:letter];
        
        CarBrand *aBrand = [subArr objectAtIndex:indexPath.row];
        
        cell.textLabel.text = aBrand.brandName;
        
        return cell;
        
    }else if (_dataStyle == Data_Area)
    {
        if (indexPath.section == 0) {
            
            cell.textLabel.text = @"全国";
            cell.textLabel.textColor = [UIColor colorWithHexString:@"ff9c00"];
            
        }else
        {
            
            NSString *letter = [firstLetterArray objectAtIndex:indexPath.section - 1];
            
            NSArray *subCityArr = [provinceDic objectForKey:letter];
            
            FBCity *aCity = [subCityArr objectAtIndex:indexPath.row];
            
            cell.textLabel.text = aCity.cityName;
            
            cell.textLabel.textColor = [UIColor colorWithHexString:@"666666"];
        }
    }
    else if (self.dataStyle == Data_Car_Type)
    {
        if (indexPath.row == 0) {
            
           cell.textLabel.text = @"不限";
            
        }else if (indexPath.row == 1)
        {
            cell.textLabel.text = @"自定义";
        }else
        {
            CarType *aType = [self.dataArray objectAtIndex:indexPath.row - 1 - 1];
            
            cell.textLabel.text = aType.typeName;

        }
    }else if (self.dataStyle == Data_Car_Style)
    {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"不限";
        }else if (indexPath.row == 1)
        {
            cell.textLabel.text = @"自定义";
            
        }else
        {
            CarStyle *aStyle = [self.dataArray objectAtIndex:indexPath.row - 1 - 1];
            
            cell.textLabel.text = aStyle.styleName;
            
        }
    }else if (_dataStyle == Data_Area_City)
    {
        FBCity *aCity = [self.dataArray objectAtIndex:indexPath.row];
        cell.textLabel.text = aCity.cityName;
        
    }else
    {
        cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    }
    
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataStyle == Data_Car_Brand) {
        
        NSString *letter = [firstLetterArray objectAtIndex:indexPath.section];
        
        NSArray *subArr = [brandDic objectForKey:letter];
        
        CarBrand *aBrand = [subArr objectAtIndex:indexPath.row];
        
        
        SendCarParamsController *base = [[SendCarParamsController alloc]init];
        base.hidesBottomBarWhenPushed = YES;
        base.navigationTitle = aBrand.brandName;
        base.dataStyle = Data_Car_Type;
        base.selectLabel = self.selectLabel;
        
        base.brandId = aBrand.brandId;
        
        base.rootVC = self.rootVC;
        
        [base selectParamBlock:^(DATASTYLE style, NSString *paramName, NSString *paramId) {
            
            selectBlock(style,paramName,paramId);
            
        }];
        
        [self.navigationController pushViewController:base animated:YES];
        
        return;
        
    }else if (self.dataStyle == Data_Car_Type) {
        
        if (indexPath.row == 0) {
            
            NSString *car = [NSString stringWithFormat:@"%@%@%@",self.brandId,@"000",@"000"];
            selectBlock(self.dataStyle,self.navigationTitle,car);
            
            if (self.rootVC) {
                [self.navigationController popToViewController:self.rootVC animated:YES];
            }else
            {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
        }else if (indexPath.row == 1)
        {
            
            NSLog(@"自定义车系");
            
            [self createNewConditionStyle:self.dataStyle title:@"自定义车系"];
            
        }else
        {
            CarType *aType = [self.dataArray objectAtIndex:indexPath.row - 1 - 1];
            
            SendCarParamsController *base = [[SendCarParamsController alloc]init];
            base.hidesBottomBarWhenPushed = YES;
            base.navigationTitle = aType.typeName;
            base.dataStyle = Data_Car_Style;
            base.selectLabel = self.selectLabel;
            base.brandId = self.brandId;
            base.typeId = aType.typeId;
            base.rootVC = self.rootVC;
            
            [base selectParamBlock:^(DATASTYLE style, NSString *paramName, NSString *paramId) {
                
                selectBlock(style,paramName,paramId);
                
            }];
            
            [self.navigationController pushViewController:base animated:YES];
            
        }
        
        
        return;
        
    }else if (self.dataStyle == Data_Car_Style) {
        
        if (indexPath.row == 0) {
            
            
            NSString *car = [NSString stringWithFormat:@"%@%@%@",self.brandId,self.typeId,@"000"];
            selectBlock(self.dataStyle,self.navigationTitle,car);
            
        }else if (indexPath.row == 1)
        {
            
            NSLog(@"自定义车款");
            
            [self createNewConditionStyle:self.dataStyle title:@"自定义车款"];
            
            return;
            
        }else
        {
            CarStyle *aStyle = [self.dataArray objectAtIndex:indexPath.row - 1 - 1];
            
            NSString *car = [NSString stringWithFormat:@"%@%@%@",self.brandId,self.typeId,aStyle.styleId];
            selectBlock(self.dataStyle,aStyle.styleName,car);
        }
        
        if (self.rootVC) {
            [self.navigationController popToViewController:self.rootVC animated:YES];
        }else
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
        return;
        
    }else if (_dataStyle == Data_Area)
    {
        if (indexPath.section == 0) {
            
            NSString *city = [NSString stringWithFormat:@"%@,%@",@"9999",@"9999"];
            selectBlock(_dataStyle,@"全国",city);
            
            if (self.rootVC) {
                [self.navigationController popToViewController:self.rootVC animated:YES];
            }else
            {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
            return;
        }
        
        
        NSString *letter = [firstLetterArray objectAtIndex:indexPath.section - 1];
        
        NSArray *subCityArr = [provinceDic objectForKey:letter];
        
        FBCity *aCity = [subCityArr objectAtIndex:indexPath.row];

        NSString *city = [NSString stringWithFormat:@"%d,%@",aCity.provinceId,@"9999"];
        selectBlock(_dataStyle,aCity.cityName,city);
        
        if (self.rootVC) {
            [self.navigationController popToViewController:self.rootVC animated:YES];
        }else
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
        return;
        
    }else if (self.dataStyle == Data_Area_City) {
        
        FBCity *aCity = [self.dataArray objectAtIndex:indexPath.row];
        NSString *city = [NSString stringWithFormat:@"%@,%d",self.provinceId,aCity.cityId];
        selectBlock(_dataStyle,aCity.cityName,city);
            
        if (self.rootVC) {
            [self.navigationController popToViewController:self.rootVC animated:YES];
        }else
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
        return;
        
    }
    
    NSString *select = [_dataArray objectAtIndex:indexPath.row];
    
    
    int row = self.haveLimit ? (int)indexPath.row : (int)indexPath.row + 1;
    
    selectBlock(self.dataStyle,select,[NSString stringWithFormat:@"%d",row]);
    
    [self clickToBack:nil];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

@end
