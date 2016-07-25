//
//  UIView+XMGCategory.m
//  百思不得姐
//
//  Created by lanou3g on 16/5/7.
//  Copyright © 2016年 春晓. All rights reserved.
//

#import "UIView+XMGCategory.h"

@implementation UIView (XMGCategory)


// 手动实现setter getter方法
- (void)setSize:(CGSize)size{

    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
    
}

- (CGSize)size{

    return self.frame.size;
    
}



- (void)setWidth:(CGFloat)width{

    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
    
}

- (CGFloat)width{
    return self.frame.size.width;
}


- (void)setHeight:(CGFloat)height{
    
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
    
}

- (CGFloat)height{
    return self.frame.size.height;
}

- (void)setX:(CGFloat)x{
    
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
    
}

- (CGFloat)x{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y{
    
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
    
}

- (CGFloat)y{
    return self.frame.origin.y;
    
}

@end
