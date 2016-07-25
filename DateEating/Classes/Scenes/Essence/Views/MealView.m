//
//  MealView.m
//  ShiYi
//
//  Created by lanou3g on 15/11/2.
//  Copyright © 2015年 TimeCollectorCompany. All rights reserved.
//

#import "MealView.h"

@implementation MealView

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
        [self addSubView];
    }
    return self;
}

- (void)addSubView
{
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((kUIScreenWidth - 320) / 2, 0, 340, 40)];
    [self addSubview:self.titleLabel];
    
    self.tagLable = [[UILabel alloc] initWithFrame:CGRectMake((kUIScreenWidth - 320) / 2, 35, 320, 30)];
    self.tagLable.font = [UIFont systemFontOfSize:13];
    self.tagLable.textColor = [UIColor grayColor];
    [self addSubview:self.tagLable];
    
    self.hostNameLabel = [[UILabel alloc] initWithFrame:CGRectMake((kUIScreenWidth - 320) / 2, 65, 320, 30)];
    self.hostNameLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.hostNameLabel];
    
    self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake((kUIScreenWidth - 320) / 2, 130, 340, 30)];
    self.addressLabel.numberOfLines = 0;
    self.addressLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.addressLabel];
    
    self.contactNumber = [[UILabel alloc] initWithFrame:CGRectMake((kUIScreenWidth - 320) / 2, 95, 320, 30)];
    self.contactNumber.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.contactNumber];
    
    self.showLabel = [[UILabel alloc] initWithFrame:CGRectMake((kUIScreenWidth - 320) / 2, 160, 340, 50)];
    [self.showLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    [self addSubview:self.showLabel];
    
    
    self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake((kUIScreenWidth - 320) / 2, 130, 320, 300)];
    self.descriptionLabel.numberOfLines = 0;
    self.descriptionLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:self.descriptionLabel];
    
}


@end
