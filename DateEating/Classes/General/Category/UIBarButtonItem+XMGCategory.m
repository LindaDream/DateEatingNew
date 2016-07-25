//
//  UIBarButtonItem+XMGCategory.m
//  百思不得姐
//
//  Created by lanou3g on 16/5/7.
//  Copyright © 2016年 春晓. All rights reserved.
//

#import "UIBarButtonItem+XMGCategory.h"

@implementation UIBarButtonItem (XMGCategory)
// 设置导航栏左边的按钮
+ (instancetype)itemWithImage:(NSString *)image heightImage:(NSString *)heightImage target:(id)target action:(SEL)action{

    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:(UIControlStateNormal)];
    [button setBackgroundImage:[UIImage imageNamed:heightImage] forState:(UIControlStateHighlighted)];
    button.size = button.currentBackgroundImage.size;
    [button addTarget:target action:action forControlEvents:(UIControlEventTouchUpInside)];
    
    return [[self alloc] initWithCustomView:button];
}

@end
