//
//  EventView.m
//  ShiYi
//
//  Created by lanou3g on 15/11/5.
//  Copyright © 2015年 TimeCollectorCompany. All rights reserved.
//

#import "EventView.h"

@implementation EventView

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
        [self addSubviewWithFrame:frame];
    }
    return self;
}

- (void)addSubviewWithFrame:(CGRect)frame
{
    self.image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 200)];
    [self addSubview:self.image];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((kUIScreenWidth - 310) / 2, 210, 320, 40)];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.titleLabel];
    
    self.addtessLabel = [[UILabel alloc] initWithFrame:CGRectMake((kUIScreenWidth - 310) / 2, 245, 320, 30)];
    self.addtessLabel.font = [UIFont systemFontOfSize:13];
    self.addtessLabel.textColor = [UIColor grayColor];
    [self addSubview:self.addtessLabel];
    
    self.durationLabel = [[UILabel alloc] initWithFrame:CGRectMake((kUIScreenWidth - 310) / 2, 270, 320, 30)];
    self.durationLabel.font = [UIFont systemFontOfSize:13];
    self.durationLabel.textColor = [UIColor grayColor];
    [self addSubview:self.durationLabel];
}


@end
