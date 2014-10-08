//
//  CarSourceCell.h
//  FBAuto
//
//  Created by lichaowei on 14-7-16.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CarSourceClass;

@interface CarSourceCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *carNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *paramsLabel;
@property (strong, nonatomic) IBOutlet UILabel *userAndAddressLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

- (void)setCellDataWithModel:(CarSourceClass *)aCar;

@end
