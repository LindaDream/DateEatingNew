//
//  YConcreteTableViewCell.h
//  DateEating
//
//  Created by user on 16/7/14.
//  Copyright © 2016年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YConcreteTableViewCell;

@protocol passConcreteValue <NSObject>

- (void)passConcreteValue:(NSString *)concrete cell:(YConcreteTableViewCell *)cell;

@end

@interface YConcreteTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *meBtn;
@property(weak,nonatomic)id<passConcreteValue> delegate;
@property(assign,nonatomic)BOOL isSelect;
@end
