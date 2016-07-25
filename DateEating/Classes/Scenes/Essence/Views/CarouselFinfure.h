//
//  CarouselFinfure.h
//  LOCarouselFingure
//
//  Created by lanou3g on 16/3/14.
//  Copyright © 2016年 lanou3g. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CarouselFinfure;
@protocol CarouseFinfureDelegate <NSObject>

@optional

// 轮播图正在轮播的时候，代理对象检测到点击事件执行的方法
- (void)carouseFinfureDidCarousel:(CarouselFinfure *)carouseFingure atIndex:(NSUInteger)currentIndex widthImageView:(UIImageView *)currentView;

@end
@interface CarouselFinfure : UIView
// 图片数组
@property(strong,nonatomic)NSArray *images;
// 播放间隙
@property(assign,nonatomic)CGFloat duration;
// 当前下标
@property(assign,nonatomic,readonly)NSUInteger currentIndex;
// 代理对象
@property(weak,nonatomic)id<CarouseFinfureDelegate> delegate;
@end
