//
//  UIBarButtonItem+XMGCategory.h
//  DateEating
//
//  Created by user on 16/5/7.
//  Copyright © 2016年 春晓. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (XMGCategory)

+ (instancetype)itemWithImage:(NSString *)image heightImage:(NSString *)heightImage target:(id)target action:(SEL)action;

@end
