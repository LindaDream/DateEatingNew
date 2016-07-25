//
//  YObjectTableViewCell.h
//  DateEating
//
//  Created by user on 16/7/14.
//  Copyright © 2016年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YObjectTableViewCell;

@protocol passObjectValue <NSObject>

- (void)passObject:(NSString *)dateObj cell:(YObjectTableViewCell *)cell;

@end

@interface YObjectTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *girlBtn;
@property (weak, nonatomic) IBOutlet UIButton *manBtn;
@property (weak, nonatomic) IBOutlet UIButton *anyBtn;
@property(weak,nonatomic)id<passObjectValue> objDelegate;
@property(assign,nonatomic)BOOL isSelected;
@end
