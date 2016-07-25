//
//  YEmojiView.m
//  DateEating
//
//  Created by lanou3g on 16/7/23.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YEmojiView.h"

@interface YEmojiView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) UICollectionView *scrollView;
@property (strong, nonatomic) UIPageControl *pageControlBottom;
@end

//将数字转为
#define EMOJI_CODE_TO_SYMBOL(x) ((((0x808080F0 | (x & 0x3F000) >> 4) | (x & 0xFC0) << 10) | (x & 0x1C0000) << 18) | (x & 0x3F) << 24);

@implementation YEmojiView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //[self getEmojiFace];
        self.dataArray = [self defaultEmoticons].mutableCopy;
        [self setView];
    }
    return self;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)setView {
    //为了摆放分页控制器，创建一个背景view
//    self = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200)];
    //分页控制器
    self.pageControlBottom = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 170, [UIScreen mainScreen].bounds.size.width, 20)];
    [self addSubview:self.pageControlBottom];
    //collectionView布局
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    //水平布局
    layout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    //设置每个表情按钮的大小为30*30
    layout.itemSize=CGSizeMake(30, 30);
    //计算每个分区的左右边距
    float xOffset = ([UIScreen mainScreen].bounds.size.width-7*30-10*6)/2;
    //设置分区的内容偏移
    layout.sectionInset=UIEdgeInsetsMake(10, xOffset, 10, xOffset);
    self.scrollView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 160) collectionViewLayout:layout];
    //打开分页效果
    self.scrollView.pagingEnabled = YES;
    //设置行列间距
    layout.minimumLineSpacing=10;
    layout.minimumInteritemSpacing=5;
    
    self.scrollView.delegate=self;
    self.scrollView.dataSource=self;
    self.scrollView.backgroundColor = self.backgroundColor;
    // 注册
    [self.scrollView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"biaoqing"];
    [self addSubview:self.scrollView];
}

// 获取emoji表情
- (void)getEmojiFace {
//    int emojiRangeArray[10] = {0xE001,0xE05A,0xE101,0xE15A,0xE201,0xE253,0xE401,0xE44C,0xE501,0xE537};
//    for (int j = 0 ; j<10 ; j+=2 ) {
//        
//        int startIndex = emojiRangeArray[j];
//        int endIndex = emojiRangeArray[j+1];
//        
//        for (int i = startIndex ; i<= endIndex ; i++ ) {
//            //添加到数据源数组
//            [self.dataArray addObject:[NSString stringWithFormat:@"%C", (unichar)i]];
//        }
//    }
}
- (NSArray *)defaultEmoticons {
    NSMutableArray *array = [NSMutableArray new];
    for (int i=0x1F600; i<=0x1F64F; i++) {
        if (i < 0x1F641 || i > 0x1F644) {
            int sym = EMOJI_CODE_TO_SYMBOL(i);
            NSString *emoT = [[NSString alloc] initWithBytes:&sym length:sizeof(sym) encoding:NSUTF8StringEncoding];
            [array addObject:emoT];
        }
    }
    return array;
}

#pragma mark -- 代理方法 --
//每页28个表情
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (((self.dataArray.count/28)+(self.dataArray.count%28==0?0:1))!=section+1) {
        return 28;
    }else{
        return self.dataArray.count-28*((self.dataArray.count/28)+(self.dataArray.count%28==0?0:1)-1);
    }
    
}
//返回页数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return (self.dataArray.count/28)+(self.dataArray.count%28==0?0:1);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"biaoqing" forIndexPath:indexPath];
    for (int i=cell.contentView.subviews.count; i>0; i--) {
        [cell.contentView.subviews[i-1] removeFromSuperview];
    }
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    label.font = [UIFont systemFontOfSize:25];
    label.text =self.dataArray[indexPath.row+indexPath.section*28] ;
    
    
    [cell.contentView addSubview:label];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString * str = self.dataArray[indexPath.section*28+indexPath.row];
    //这里手动将表情符号添加到textField上
    if (_delegate && [_delegate respondsToSelector:@selector(emojiFaceDidSelect:)]) {
        [_delegate emojiFaceDidSelect:str];
    }    
}
//翻页后对分页控制器进行更新
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat contenOffset = scrollView.contentOffset.x;
    int page = contenOffset/scrollView.frame.size.width+((int)contenOffset%(int)scrollView.frame.size.width==0?0:1);
    self.pageControlBottom.currentPage = page;
    
}

@end
