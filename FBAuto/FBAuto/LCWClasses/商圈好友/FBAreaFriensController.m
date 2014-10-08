//
//  FBAreaFriensController.m
//  FBAuto
//
//  Created by lichaowei on 14-7-7.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FBAreaFriensController.h"
#import "FBMayKnowFriendsController.h"
#import "FBAutoAPIHeader.h"
#import "MenuModel.h"
#import "City.h"
#import "Menu_Header.h"
#import "MenuCell.h"

#import "FBCityData.h"
#import "FBCity.h"

#define KLEFT 0.0
#define KTOP 5.0
#define KBOTTOM 10

@interface FBAreaFriensController ()

@end

@implementation FBAreaFriensController

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
    
    self.titleLabel.text = @"我的好友";
    
    secondTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width - 2 * KLEFT, self.view.height - 20 - 44) style:UITableViewStylePlain];
    
    secondTable.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    secondTable.delegate = self;
    secondTable.dataSource = self;
    [self.view addSubview:secondTable];
    
//    [self loadCityData];
    
    [self loadProvince];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    [secondTable reloadData];
}

#pragma - mark 二级、三级table管理



//三级table

- (void)reloadThirdTableData:(NSArray *)dataArr provinceName:(NSString *)provinceName provinceId:(int)provinceId
{
    
    if (thirdTable == nil) {
        
        thirdTable = [[UITableView alloc]initWithFrame:CGRectMake(320, 0, 320 - 270/2.0 + 20, self.view.height) style:UITableViewStylePlain];
        thirdTable.delegate = self;
        thirdTable.dataSource = self;
        [self.view addSubview:thirdTable];
        
        [UIView animateWithDuration:0.2 animations:^{
            CGRect aFrame = thirdTable.frame;
            aFrame.origin.x -= (320 - 270/2.0);
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

#pragma mark-UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == secondTable) {
        return firstLetterArray.count + 1;
    }
    return 1;
}

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
        
    }
    return 0;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:firstLetterArray];
    [arr insertObject:@"全" atIndex:0];
    
    return arr ;
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

        cell = [[[NSBundle mainBundle]loadNibNamed:@"MenuCell" owner:self options:nil]objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
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
        
    }
    cell.contenLabel.textColor = [UIColor colorWithHexString:@"666666"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == secondTable) {
        
        if (indexPath.section == 0) {
            return;
        }
        
        NSString *letter = [firstLetterArray objectAtIndex:indexPath.section - 1];
        
        NSArray *subCityArr = [provinceDic objectForKey:letter];
        
        FBCity *aCity = [subCityArr objectAtIndex:indexPath.row];
        
        [self reloadThirdTableData:[FBCityData getSubCityWithProvinceId:aCity.cityId] provinceName:aCity.cityName provinceId:aCity.provinceId];
        
    }else if (tableView == thirdTable)
    {
        FBCity *aCity = [thirdArray objectAtIndex:indexPath.row];
        
        FBMayKnowFriendsController *addFriend = [[FBMayKnowFriendsController alloc]init];
        addFriend.navigationTitle = aCity.cityName;
        addFriend.isAreaFriend = YES;
        addFriend.provinceId = [NSString stringWithFormat:@"%d",aCity.provinceId];
        
        if (aCity.cityId != 0) {
            
            addFriend.cityId = [NSString stringWithFormat:@"%d",aCity.cityId];
        }else
        {
            addFriend.cityId = nil;
        }
        
        [self.navigationController pushViewController:addFriend animated:YES];
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

@end
