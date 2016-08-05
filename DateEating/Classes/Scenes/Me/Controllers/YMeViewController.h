//
//  XMGMeViewController.h
//  DateEating
//
//  Created by user on 16/5/6.
//  Copyright © 2016年 春晓. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMeViewController : UIViewController
@property(assign,nonatomic)NSInteger unreadMessageCount;
@property(strong,nonatomic)NSString *userName;
@property(strong,nonatomic)UITableView *meTableView;
- (void)addHeadView;
@end
