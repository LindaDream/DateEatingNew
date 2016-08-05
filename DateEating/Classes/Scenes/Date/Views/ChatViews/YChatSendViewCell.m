//
//  YChatSendViewCell.m
//  DateEating
//
//  Created by user on 16/7/23.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YChatSendViewCell.h"

@implementation YChatSendViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self drawView];
    }
    return self;
}
- (void)drawView{
    [self.contentView addSubview:self.headImgView];
    [self.contentView addSubview:self.messageLabel];
}
-(void)setHeadImg:(UIImage *)headImg{
    if (_headImg != headImg) {
        _headImg = nil;
        _headImg = headImg;
    }
    if (nil != _headImg) {
        _headImgView.image = _headImg;
    }else{
        _headImgView.image = [UIImage imageNamed:@"head_img"];
    }
}
-(UIImageView *)headImgView{
    if (!_headImgView) {
        _headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth - 40, 0, 38, 38)];
        _headImgView.layer.masksToBounds = YES;
        _headImgView.layer.cornerRadius = 19;
    }
    return _headImgView;
}
-(void)setMessage:(NSString *)message{
    if (_message != message) {
        _message = nil;
        _message = message;
    }
    _messageLabel.text = _message;
    CGRect rect = _messageLabel.frame;
    CGFloat height = [[self class] heightForMessage:_message];
    rect.size.height = height;
    _messageLabel.frame = rect;
    [self.contentView insertSubview:self.backImgView belowSubview:self.messageLabel];
}
-(UILabel *)messageLabel{
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_headImgView.frame) - 185, 0, 165, 0)];
        _messageLabel.font = [UIFont systemFontOfSize:16.0];
        _messageLabel.textAlignment = NSTextAlignmentRight;
        CGPoint centerPoint = _messageLabel.center;
        centerPoint.y = self.contentView.center.y - 10;
        _messageLabel.center = centerPoint;
        _messageLabel.numberOfLines = 0;
    }
    return _messageLabel;
}
-(UIImageView *)backImgView{
    if (!_backImgView) {
        if (_messageLabel.text.length * 16 <= _messageLabel.width) {
            _backImgView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth - (_headImgView.width + _messageLabel.text.length * 16 + 30), 5, self.messageLabel.text.length * 16 + 22, _messageLabel.height + 20)];
            CGPoint point = _backImgView.center;
            point.y = self.contentView.center.y;
            _backImgView.center = point;
        }else{
            _backImgView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth - (165 + _headImgView.width + 30), 5, 190, _messageLabel.height + 20)];
            CGPoint point = _backImgView.center;
            point.y = self.contentView.center.y;
            _backImgView.center = point;
        }
        _backImgView.image = [[UIImage imageNamed:@"SenderTextNodeBkg"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    }
    return _backImgView;
}
+ (CGFloat)heightForMessage:(NSString *)message{
    CGRect rect = [message boundingRectWithSize:CGSizeMake(165, 500) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0]} context:nil];
    return rect.size.height;
}
+ (CGFloat)heightForCellWithMessage:(NSString *)message{
    return [self heightForMessage:message] + 25;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
