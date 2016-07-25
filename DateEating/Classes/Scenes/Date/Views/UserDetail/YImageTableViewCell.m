//
//  YImageTableViewCell.m
//  DateEating
//
//  Created by lanou3g on 16/7/18.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YImageTableViewCell.h"

@implementation YImageTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#define KWidth ([UIScreen mainScreen].bounds.size.width - 30)/4.0
- (void)setImageArray:(NSArray *)imageArray {
    _imageArray = imageArray;
    for (int i = 0; i <= imageArray.count/5 ; i++) {
        for (int j = 0; j < imageArray.count - 4*i; j++) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(6*(j+1)+KWidth*j, 6*(i+1)+KWidth*i, KWidth, KWidth)];
            imageView.userInteractionEnabled = YES;
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageArray[j + 4 *i]] placeholderImage:[UIImage imageNamed:@"DefaultAvatar"]];
            [self addSubview:imageView];
        }
    }
}

+ (CGFloat)getHeightForCell:(NSInteger)count {
    if (count > 4) {
        return KWidth *2 + 18;
    } else {
        return KWidth + 12;
    }
}

@end
