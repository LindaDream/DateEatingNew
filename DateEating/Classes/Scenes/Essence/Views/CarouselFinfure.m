//
//  CarouselFinfure.m
//  LOCarouselFingure
//
//  Created by lanou3g on 16/3/14.
//  Copyright © 2016年 lanou3g. All rights reserved.
//

#import "CarouselFinfure.h"
// 当前视图的宽和高
#define kWidth self.bounds.size.width
#define kHeight self.bounds.size.height
@interface CarouselFinfure()<UIScrollViewDelegate>

@property(strong,nonatomic)UIScrollView *scrollView;
@property(strong,nonatomic)UIPageControl *pageControl;
@property(strong,nonatomic)NSTimer *timer;

@end
@implementation CarouselFinfure
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 设置默认播放间隔
        _duration = 2.0;
        _timer = [NSTimer new];
        // 在外界没有提供图片的情况下，没有必要绘制任何内容
        // [self drawView];
    }
    return self;
}
// 绘图方法
- (void)drawView{
    [self addSubview:self.scrollView];
    [self addSubview:self.pageControl];
}
// 当外界开始对图片数组赋值的时候，才有必要启动timer
- (void)setImages:(NSArray *)images{
    // 赋值之前先让timer失效，避免外界重复使用赋值方法
    [_timer invalidate];
    _timer = nil;
    // 重写setter赋值过程
    if (_images != images) {
        _images =  nil;
        _images = images;
    }
    // 外界赋值完图片数组时开始启用绘图方法
    [self drawView];
    // 完成赋值过程后启动timer
    _timer = [NSTimer scheduledTimerWithTimeInterval:_duration target:self selector:@selector(handleMovePage) userInfo:nil repeats:YES];
    
}

-(void)setDuration:(CGFloat)duration{
    [_timer invalidate];
    _timer = nil;
    // assign直接赋值
    _duration = duration;
     _timer = [NSTimer scheduledTimerWithTimeInterval:_duration target:self selector:@selector(handleMovePage) userInfo:nil repeats:YES];
}

NSUInteger count = 0;
#pragma mark --Timer驱动的轮播事件--
- (void)handleMovePage{
    // 使用中间变量来获取当前下标
    count = self.pageControl.currentPage;
    // 每次timer触发事件的时候，pageControl的下标增加
    count++;
    // 防止超出表示范围溢出导致的错误
    if (count == self.images.count) {
        count = 0;
    }
    self.pageControl.currentPage = count;
    // 根据pageControl的下标来触发scrollView的偏移量
    self.scrollView.contentOffset = CGPointMake(kWidth * self.pageControl.currentPage, 0);
}

#pragma mark --lazing loaing--
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(kWidth * self.images.count,kHeight);
        _scrollView.delegate = self;
        for (int i = 0; i < self.images.count; i++) {
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth * i, 0, kWidth, kHeight)];
            imgView.userInteractionEnabled = YES;
            // 创建手势
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
            [imgView addGestureRecognizer:tap];
            imgView.image = self.images[i];
            imgView.contentMode = UIViewContentModeScaleToFill;
            [_scrollView addSubview:imgView];
        }
    }
    return _scrollView;
}
#pragma mark --Tap手势--
- (void)tapAction:(UITapGestureRecognizer *)tap{
    
    if (_delegate && [_delegate respondsToSelector:@selector(carouseFinfureDidCarousel:atIndex:widthImageView:)]) {
        // 获取当前视图
        UIImageView *imgView = (UIImageView *)tap.view;
        // 获取当前视图的图片所在的数组下标
        NSUInteger index = [self.images indexOfObject:imgView.image];
        [_delegate carouseFinfureDidCarousel:self atIndex:index widthImageView:imgView];
    }
}

-(UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, self.images.count * 10, 20)];
        [_pageControl setCenter:CGPointMake(kWidth/2, kHeight - 15)];
        _pageControl.numberOfPages = self.images.count;
        _pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
        _pageControl.pageIndicatorTintColor = [UIColor yellowColor];
    }
    return _pageControl;
}

-(NSUInteger)currentIndex{
    return self.pageControl.currentPage;
}

// 开始拖拽视图时触发
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    // 在人为拖拽视图的时候，停止timer的事件
    [self.timer invalidate];
    self.timer = nil;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    // 根据scrollView的偏移量来调整pageControl的下标
    self.pageControl.currentPage = self.scrollView.contentOffset.x / kWidth;
    count = self.pageControl.currentPage;
    // 启动timer
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(handleMovePage) userInfo:nil repeats:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
