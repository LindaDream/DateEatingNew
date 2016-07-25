//
//  ContentView.m
//  ShiYi
//
//  Created by lanou3g on 15/11/5.
//  Copyright © 2015年 TimeCollectorCompany. All rights reserved.
//

#import "ContentView.h"

@implementation ContentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview];
    }
    return self;
}

- (void)addSubview
{
    self.sayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWidth, 30)];
    self.sayLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.sayLabel];
    
    self.contentOneView = [[UILabel alloc] initWithFrame:CGRectMake((kWidth - 340 * kMyWidth) / 2, 30, 340  * kMyWidth, 100)];
    self.contentOneView.numberOfLines = 0;
    self.contentOneView.font = [UIFont systemFontOfSize:14];
    self.contentOneView.textColor = [UIColor blackColor];
    [self addSubview:self.contentOneView];
    
    self.image = [[UIImageView alloc] initWithFrame:CGRectMake((kUIScreenWidth - 340 * kMyWidth) / 2, self.contentOneView.frame.size.height + 30, 340 * kMyWidth, 200)];
    [self addSubview:self.image];
    
    self.contentTwoView = [[UILabel alloc] initWithFrame:CGRectMake((kUIScreenWidth - 340 * kMyWidth) / 2, self.image.frame.size.height + self.image.frame.origin.y + 30, 340 * kMyWidth, 100)];
    self.contentTwoView.font = [UIFont systemFontOfSize:14];
    self.contentTwoView.textColor = [UIColor blackColor];
    self.contentTwoView.numberOfLines = 0;
    [self addSubview:self.contentTwoView];
    
}

@end
