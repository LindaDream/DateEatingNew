//
//  YContentTableViewCell.m
//  DateEating
//
//  Created by lanou3g on 16/7/21.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YContentTableViewCell.h"

#define kContentLabelWith kWidth - 32

@implementation YContentTableViewCell

- (void)awakeFromNib {
    
}

- (void)setContent:(YContent *)content{

    _content = content;
    self.fromToLabel.text = [NSString stringWithFormat:@"%@",content.fromName];
    self.contentLabel.text = content.contents;
    
    self.timeLabel.text = [self calculateTime];
    
    [YContent getContentAvatarWithUserName:content.fromName SuccessRequest:^(id dict) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.contentAvatarImageView sd_setImageWithURL:[NSURL URLWithString:dict]];
        });
    } failurRequest:^(NSError *error) {
        NSLog(@"%ld",error.code);
    }];
    [self.fromToLabel sizeToFit];
    
    CGRect frame = self.contentLabel.frame;
    frame.size.height = [[self class] textHeightFromModel:content];
    self.contentLabel.frame = frame;
    
}


- (NSString *)calculateTime{
    
    NSDictionary *createTime = [self analysisTimeWithTime:_content.contentTime];
    NSLog(@"_content.contents = %@,_content.contentTime = %@",_content.contents,_content.contentTime);
    NSLog(@"%@",createTime);
    // 获取当前系统时间
    NSString* date;
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    date = [formatter stringFromDate:[NSDate date]];
    NSLog(@"date = %@",date);
    NSDictionary *nowTime = [self analysisTimeWithTime:date];
    NSLog(@"%@",nowTime);
    
    if (((NSString *)nowTime[@"year"]).integerValue > ((NSString *)createTime[@"year"]).integerValue) {
        
        NSInteger year = ((NSString *)nowTime[@"year"]).integerValue - ((NSString *)createTime[@"year"]).integerValue;
        return [NSString stringWithFormat:@"%ld年前",year];
        
    }else if (((NSString *)nowTime[@"mouth"]).integerValue > ((NSString *)createTime[@"mouth"]).integerValue) {
        
        NSInteger year = ((NSString *)nowTime[@"mouth"]).integerValue - ((NSString *)createTime[@"mouth"]).integerValue;
        return [NSString stringWithFormat:@"%ld月前",year];
        
    }else if (((NSString *)nowTime[@"day"]).integerValue > ((NSString *)createTime[@"day"]).integerValue) {
        
        NSInteger year = ((NSString *)nowTime[@"day"]).integerValue - ((NSString *)createTime[@"day"]).integerValue;
        return [NSString stringWithFormat:@"%ld天前",year];
        
    }else if (((NSString *)nowTime[@"hour"]).integerValue > ((NSString *)createTime[@"hour"]).integerValue) {
        
        NSInteger year = ((NSString *)nowTime[@"hour"]).integerValue - ((NSString *)createTime[@"hour"]).integerValue;
        return [NSString stringWithFormat:@"%ld小时前",year];
        
    }else if (((NSString *)nowTime[@"minute"]).integerValue > ((NSString *)createTime[@"minute"]).integerValue) {
        
        NSInteger year = ((NSString *)nowTime[@"minute"]).integerValue - ((NSString *)createTime[@"minute"]).integerValue;
        return [NSString stringWithFormat:@"%ld分钟前",year];
        
    }else {
        return @"1分钟前";
    }
    
}

- (NSDictionary *)analysisTimeWithTime:(NSString *)time{

    NSMutableDictionary *timeDict = [NSMutableDictionary dictionary];
    NSString *year = [time substringWithRange:NSMakeRange(0,4)];
    NSString *mouth = [time substringWithRange:NSMakeRange(5,2)];
    NSString *day = [time substringWithRange:NSMakeRange(8,2)];
    NSString *hour = [time substringWithRange:NSMakeRange(11,2)];
    NSString *minute = [time substringWithRange:NSMakeRange(14,2)];
    
    [timeDict setValue:year forKey:@"year"];
    [timeDict setValue:mouth forKey:@"mouth"];
    [timeDict setValue:day forKey:@"day"];
    [timeDict setValue:hour forKey:@"hour"];
    [timeDict setValue:minute forKey:@"minute"];
    
    return timeDict;
}

// 计算有图片cell整体的高度
+ (CGFloat)cellHeight:(YContent *)content{
    
    // cell固定部分的高度（呆滞实际开发当中不要自适应，有固定高度的控件和间隙所共同战友的高度总和）
    CGFloat staticHeight = 56;
    
    // cell 不固定部分的高度（需要自适应，因内容er变换的空间高度）
    CGFloat dynamicHeight = [self textHeightFromModel:content];
    
    // cell的高度等于固定值 + 变化部分
    return staticHeight + dynamicHeight;
    
}


// 计算文本高度
+ (CGFloat)textHeightFromModel:(YContent *)content{
    
    CGRect rect = [content.contents boundingRectWithSize:CGSizeMake(kContentLabelWith, 500) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0]} context:nil];
    
    return rect.size.height;
    
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
