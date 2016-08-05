//
//  UITableView+YTableViewTop.m
//  DateEating
//
//  Created by lanou3g on 16/8/3.
//  Copyright © 2016年 user. All rights reserved.
//

#import "UITableView+YTableViewTop.h"

@implementation UITableView (YTableViewTop)

- (void)backToTop{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self scrollToRowAtIndexPath:indexPath atScrollPosition:(UITableViewScrollPositionTop) animated:YES];
}

@end
