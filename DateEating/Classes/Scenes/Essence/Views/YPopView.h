//
//  YPopView.h
//  DateEating
//
//  Created by lanou3g on 16/7/13.
//  Copyright © 2016年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CategoryButton;

typedef void(^BtnAction)(NSInteger tag);

@interface YPopView : UIView

@property (strong,nonatomic) CategoryButton *mainBtn;

@property (assign,nonatomic) NSInteger disperseDistance;

@property (copy,nonatomic) BtnAction ba;

@property (strong,nonatomic) UIView *actionView;

- (instancetype)initWithStr:(NSString *)str;


@end
