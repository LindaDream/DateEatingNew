//
//  YDescTableViewCell.m
//  DateEating
//
//  Created by lanou3g on 16/7/18.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YDescTableViewCell.h"

@interface YDescTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *desc;


@end

@implementation YDescTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellWithName:(NSString *)name desc:(NSString *)desc {
    _name.text = name;
    _desc.text = desc;
}

+ (CGFloat)getHeightForCellWithString:(NSString *)string {
    CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.width - 80, 10000);
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    CGRect rect = [string boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesDeviceMetrics|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    CGFloat height = rect.size.height +30;
    if (height > 50) {
        return height;
    } else {
        return 50;
    }
}

@end
