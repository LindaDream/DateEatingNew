//
//  OtherEventView.m
//  DateEating
//
//  Created by user on 15/11/5.
//  Copyright © 2015年 TimeCollectorCompany. All rights reserved.
//

#import "OtherEventView.h"

@implementation OtherEventView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubViewWithFrame:frame];
    }
    return self;
}

- (void)addSubViewWithFrame:(CGRect)frame
{
    UILabel *headView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 30)];
    headView.text = @"- 精品推荐 -";
    headView.textAlignment = NSTextAlignmentCenter;
    headView.textColor = [UIColor blackColor];
    headView.backgroundColor = [UIColor grayColor];
    [self addSubview:headView];
    
    for (int i = 0; i < 3; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((kUIScreenWidth - 340 * kMyWidth) / 2, 35 + i * 80, 340 * kMyWidth, 70)];
        button.tag = 2500 + i;
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 90 * kMyWidth, 70)];
        image.tag = 2600 + i;
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((kUIScreenWidth - 250 * kMyWidth) / 2 + 40, 0, 250 * kMyWidth, 30)];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.numberOfLines = 0;
        titleLabel.tag = 2700 + i;
        titleLabel.textColor = [UIColor blackColor];
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake((kUIScreenWidth - 200 * kMyWidth) / 2 + 30, 40, 200 * kMyWidth, 30)];
        priceLabel.tag = 2800 + i;
        priceLabel.font = [UIFont systemFontOfSize:13];
        priceLabel.numberOfLines = 0;
        priceLabel.textColor = [UIColor blackColor];
        [button addSubview:image];
        [button addSubview:titleLabel];
        [button addSubview:priceLabel];
        [self addSubview:button];
    }
    self.buttonOne = (UIButton *)[self viewWithTag:2500];
    self.buttonTwo = (UIButton *)[self viewWithTag:2501];
    self.buttonThree = (UIButton *)[self viewWithTag:2502];
    
    self.imageOne = (UIImageView *)[self viewWithTag:2600];
    self.imageTwo = (UIImageView *)[self viewWithTag:2601];
    self.imageThree = (UIImageView *)[self viewWithTag:2602];
    
    self.labelOne = (UILabel *)[self viewWithTag:2700];
    self.labelTwo = (UILabel *)[self viewWithTag:2701];
    self.labelThree = (UILabel *)[self viewWithTag:2702];
    
    self.priceLabelOne = (UILabel *)[self viewWithTag:2800];
    self.priceLabelTwo = (UILabel *)[self viewWithTag:2801];
    self.priceLabelThree = (UILabel *)[self viewWithTag:2802];
    
}


@end
