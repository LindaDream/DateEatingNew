//
//  YCaterTableViewCell.m
//  DateEating
//
//  Created by lanou3g on 16/7/16.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YCaterTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface YCaterTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageItem;

@property (weak, nonatomic) IBOutlet UILabel *labelItem;

@end

@implementation YCaterTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellWithImage:(NSString *)imageName title:(NSString *)title {
    _imageItem.image = [UIImage imageNamed:imageName];
    _labelItem.text = title;
}

+ (CGFloat)getHeightForCellWithString:(NSString *)string {
    CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width - 100 ,100000);
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]};
    
    CGRect rect = [string boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesDeviceMetrics|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    CGFloat height = rect.size.height + 20;
    if (height < 40) {
        return 40;
    } else {
        return height + 1;
    }
}



@end
