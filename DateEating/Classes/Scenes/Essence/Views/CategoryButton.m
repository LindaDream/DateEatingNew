//
//  CategoryButton.m
//  DateEating
//
//  Created by user on 15/11/9.
//  Copyright © 2015年 TimeCollectorCompany. All rights reserved.
//

#import "CategoryButton.h"

@implementation CategoryButton

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
    self.myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width * 3 / 5, self.width * 3 / 5)];
    self.myImageView.center = CGPointMake(self.centerX, self.width * 1.5 / 5);
    [self addSubview:self.myImageView];
    
    self.myTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.width * 3 / 5 + 3, self.width, 12)];
    self.myTitleLabel.font = [UIFont systemFontOfSize:11];
    self.myTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.myTitleLabel];
    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = YES;
}


@end
