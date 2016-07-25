//
//  YHobbyTableViewCell.m
//  DateEating
//
//  Created by lanou3g on 16/7/18.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YHobbyTableViewCell.h"
#import "YHobby.h"
#import "YMovie.h"
#import "YTravel.h"

@implementation YHobbyTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDic:(NSDictionary *)dic {
    _dic = dic;
    _labelImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 30, 30)];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(60, 49, self.width - 80, 1)];
    view.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:view];
    [self addSubview:_labelImage];
    if ([dic.allKeys.firstObject isEqualToString:@"电影"]) {
        _labelImage.image = [UIImage imageNamed:@"mine_hobby_movie"];
        CGFloat width = 60;
        NSArray *array = dic[@"电影"];
        for (YMovie *movie in array) {
            CGFloat labelWidth = [self getWidthWithString:movie.name];
            width = width + labelWidth + 10;
            if (width + 20 >= self.width) {
                break;
            } else {
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(width - labelWidth, 10, labelWidth, 30)];
                label.textAlignment = NSTextAlignmentCenter;
                label.backgroundColor = YRGBColor(252, 204, 106);
                label.font = [UIFont systemFontOfSize:14.0f];
                label.text = movie.name;
                label.layer.cornerRadius = 4;
                label.layer.masksToBounds = YES;
                [self addSubview:label];
            }
        }
    } else if([dic.allKeys.firstObject isEqualToString:@"旅游"]) {
        _labelImage.image = [UIImage imageNamed:@"mine_hobby_travel"];
        CGFloat width = 60;
        NSArray *array = dic[@"旅游"];
        for (YTravel *movie in array) {
            CGFloat labelWidth = [self getWidthWithString:movie.name];
            width = width + labelWidth + 10;
            if (width + 20 >= self.width) {
                break;
            } else {
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(width - labelWidth, 10, labelWidth, 30)];
                label.textAlignment = NSTextAlignmentCenter;
                label.backgroundColor = YRGBColor(141, 159, 247);
                label.font = [UIFont systemFontOfSize:14.0f];
                label.text = movie.name;
                label.layer.cornerRadius = 4;
                label.layer.masksToBounds = YES;
                [self addSubview:label];
            }
        }
    } else {
        _labelImage.image = [UIImage imageNamed:@"mine_hobby_hobby"];
        CGFloat width = 60;
        NSArray *array = dic[@"爱好"];
        for (YHobby *movie in array) {
            CGFloat labelWidth = [self getWidthWithString:movie.name];
            width = width + labelWidth + 10;
            if (width + 20 >= self.width) {
                break;
            } else {
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(width - labelWidth, 10, labelWidth, 30)];
                label.textAlignment = NSTextAlignmentCenter;
                label.backgroundColor = YRGBColor(241, 124, 124);
                label.font = [UIFont systemFontOfSize:14.0f];
                label.text = movie.name;
                label.layer.cornerRadius = 4;
                label.layer.masksToBounds = YES;
                [self addSubview:label];
            }
        }
    }
}

- (CGFloat)getWidthWithString:(NSString *)string {
    CGSize size = CGSizeMake(10000, 20);
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]};
    CGRect rect = [string boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesDeviceMetrics|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return rect.size.width + 10;
}

@end
