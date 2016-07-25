//
//  YReceiveImgViewCell.m
//  DateEating
//
//  Created by user on 16/7/22.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YReceiveImgViewCell.h"

@implementation YReceiveImgViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self drawView];
    }
    return self;
}
- (void)drawView{
    [self.contentView addSubview:self.headImgView];
    [self.contentView addSubview:self.messsageImgView];
}
-(void)setHeadImg:(UIImage *)headImg{
    if (_headImg != headImg) {
        _headImg = nil;
        _headImg = headImg;
    }
    _headImgView.image = _headImg;
}
-(UIImageView *)headImgView{
    if (!_headImgView) {
        _headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 38, 38)];
        _headImgView.layer.masksToBounds = YES;
        _headImgView.layer.cornerRadius = 19;
    }
    return _headImgView;
}
-(void)setReceiveImg:(UIImage *)receiveImg{
    if (_receiveImg != receiveImg) {
        _receiveImg = nil;
        _receiveImg = receiveImg;
    }
    _messsageImgView.image = receiveImg;
    [self.contentView insertSubview:self.backImgView belowSubview:self.messsageImgView];
}

-(UIImageView *)messsageImgView{
    if (!_messsageImgView) {
        _messsageImgView = [[UIImageView alloc] initWithFrame:CGRectMake(63, 20, 160, 160)];
        _messsageImgView.layer.masksToBounds = YES;
        _messsageImgView.layer.cornerRadius = 10;
    }
    return _messsageImgView;
}
-(UIImageView *)backImgView{
    if (!_backImgView) {
        _backImgView = [[UIImageView alloc] initWithFrame:CGRectMake(_headImgView.width + 10, 5, 188, 188)];
        _backImgView.image = [[UIImage imageNamed:@"ReceiverTextNodeBkg"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    }
    return _backImgView;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
