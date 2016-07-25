//
//  YPopView.m
//  DateEating
//
//  Created by lanou3g on 16/7/13.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YPopView.h"
#import "UIButton+YCategory.h"
#import "CategoryButton.h"

@implementation YPopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



- (instancetype)initWithStr:(NSString *)str{

    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(kWidth, 0, kWidth, kHeight);
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0.7;
        [self addViewWithStr:str];
        
    }
    return self;
    
}


- (void)addViewWithStr:(NSString *)str{

    self.actionView = [[UIView alloc] initWithFrame:CGRectMake((kWidth - 270) / 2, kWidth / 2, 270, 270)];
    
    self.actionView.backgroundColor = [UIColor lightGrayColor];
    
    self.disperseDistance = 40;
    
    self.actionView.layer.masksToBounds = YES;
    
    self.actionView.layer.cornerRadius = self.actionView.width / 2;
    
    [self addSubview:self.actionView];
    
    if ([str isEqualToString:@"美食"]) {
        
        UIImage *img1 = [UIImage imageNamed:@"lunch"];
        
        UIImage *img2 =[UIImage imageNamed:@"supper"];
        
        UIImage *img3 =[UIImage imageNamed:@"brunchr"];
        
        UIImage *img4 =[UIImage imageNamed:@"tea"];
        
        
        NSArray *arr = @[img1,img2,img3,img4,@"午餐",@"晚餐",@"早午餐",@"下午茶"];
        [self addBtnWithArr:arr];
        
        
    }else{
        
        UIImage *img1 = [UIImage imageNamed:@"fashion"];
        UIImage *img2 =[UIImage imageNamed:@"good_wine"];
        UIImage *img3 =[UIImage imageNamed:@"education"];
        UIImage *img4 =[UIImage imageNamed:@"other"];
        UIImage *img5 =[UIImage imageNamed:@"outdoor_travel"];
        UIImage *img6 =[UIImage imageNamed:@"art"];
        
        NSArray *arr = @[img1,img3,img6,img5,img2,img4,@"时尚生活",@"美酒佳肴",@"亲子家庭",@"文化艺术",@"户外探索",@"探索其他"];
        [self addBtnWithArr:arr];
        
    }
    
    
    
}


// 创建按钮并添加到self上设置位置
- (void)addBtnWithArr:(NSArray *)arr{

    // 主按钮
    self.mainBtn = [[CategoryButton alloc] initWithFrame:CGRectMake((self.actionView.width - 70) / 2, (self.actionView.height - 70) / 2, 70, 70)];
    // 设置主按钮的tag值为10000
    self.mainBtn.tag = 10000;
    // 改变主按钮上的图片文字位置
    self.mainBtn.myImageView.width = 40;
    self.mainBtn.myImageView.height = 40;
    self.mainBtn.myTitleLabel.width = 60;
    self.mainBtn.myTitleLabel.font = [UIFont systemFontOfSize:15];
    self.mainBtn.myImageView.center = CGPointMake(self.mainBtn.width / 2, 23.5);
    self.mainBtn.myTitleLabel.center = CGPointMake(self.mainBtn.width / 2, CGRectGetMaxY(self.mainBtn.myImageView.frame) + 10);
    self.mainBtn.myImageView.image = [UIImage imageNamed:@"strategy_allCategory"];
    self.mainBtn.myTitleLabel.text = @"全部选择";
    self.mainBtn.backgroundColor = [UIColor whiteColor];
    
    [self.mainBtn addTarget:self action:@selector(btnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.actionView addSubview:self.mainBtn];
    
    CGFloat angle = 2 * M_PI / (arr.count / 2);
    
    for (int i = 0; i < arr.count / 2; i++) {
        CategoryButton *btn = [[CategoryButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        btn.backgroundColor = [UIColor colorWithRed:255 green:80 blue:72 alpha:1];
        btn.center = CGPointMake(self.mainBtn.centerX + cos(angle * i) * (btn.width + self.disperseDistance), self.mainBtn.centerY + sin(angle * i) * (btn.height + self.disperseDistance));
        btn.tag = 10000 + i + 1;
        btn.myImageView.image = arr[i];
        btn.myTitleLabel.text = arr[i + arr.count / 2];
        [self.actionView addSubview:btn];
        
        
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:(UIControlEventTouchUpInside)];

    }
    
}


- (void)btnAction:(CategoryButton *)btn{

    _ba(btn.tag - 10000);
    
}





@end
