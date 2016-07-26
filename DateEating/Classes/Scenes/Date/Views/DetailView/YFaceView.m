//
//  YFaceView.m
//  DateEating
//
//  Created by lanou3g on 16/7/25.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YFaceView.h"

@interface YFaceView ()
<
    UICollectionViewDataSource,
    UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout
>

@property (strong, nonatomic) NSMutableDictionary *faceDict;
@property (strong, nonatomic) NSMutableArray *keyArray;
@property (strong, nonatomic) UIView *barView;
@property (strong, nonatomic) UIButton *changeKeyBoard;
@property (strong, nonatomic) UISegmentedControl *typeSegment;
@property (strong, nonatomic) UIButton *deleteBtn;
@property (strong, nonatomic) UILabel *title;

@property (strong, nonatomic) UICollectionView *collectionView;

@end

@implementation YFaceView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 获取plist文件
        NSString *path = [[NSBundle mainBundle]pathForResource:@"EmojisList" ofType:@"plist"];
        NSDictionary *dic = [[NSDictionary alloc]initWithContentsOfFile:path];
        self.keyArray = dic.allKeys.mutableCopy;
        for (NSString *key in self.keyArray) {
            NSMutableArray *array = [NSMutableArray array];
            array = dic[key];
            [self.faceDict setObject:array forKey:key];
        }
        [self setView];
    }
    return self;
}

- (NSMutableDictionary *)faceDict {
    if (!_faceDict) {
        _faceDict = [NSMutableDictionary dictionary];
    } return _faceDict;
}

// 构造视图
- (void)setView {
    // 工具栏视图
    UIView *barView = [[UIView alloc]initWithFrame:CGRectMake(0, 160, kWidth, 30)];
    self.barView = barView;
    [self addSubview:barView];
    
    // 切换键盘按钮
    UIButton *changeKeyBoard = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 30, 30)];
    self.changeKeyBoard = changeKeyBoard;
    [changeKeyBoard setTitle:@"键盘" forState:UIControlStateNormal];
    [changeKeyBoard setImage:[UIImage imageNamed:@"keyBoard"] forState:UIControlStateNormal];
    [changeKeyBoard setImage:[UIImage imageNamed:@"keyBoard_h"] forState:UIControlStateHighlighted];
    [changeKeyBoard addTarget:self action:@selector(changeKeyBoardAction:) forControlEvents:UIControlEventTouchUpInside];
    [barView addSubview:changeKeyBoard];
    
    // 表情类型
    UISegmentedControl *typeSegment = [[UISegmentedControl alloc]initWithItems:@[@"表情",@"地点",@"人物",@"自然"]];
    self.typeSegment = typeSegment;
    typeSegment.frame = CGRectMake(50, 0, 200, 30);
    [typeSegment addTarget:self action:@selector(typeSegmentAction:) forControlEvents:UIControlEventValueChanged];
    typeSegment.selectedSegmentIndex = 0;
    
    [barView addSubview:typeSegment];
    
    // 删除按钮
    UIButton *deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(kWidth - 40, 0, 30, 30)];
    self.deleteBtn = deleteBtn;
    //[deleteBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [deleteBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [deleteBtn setImage:[UIImage imageNamed:@"back_h"] forState:UIControlStateHighlighted];
    [deleteBtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [barView addSubview:deleteBtn];
    
    // 集合视图显示表情
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(7, 5, kWidth-14, 150) collectionViewLayout:flowLayout];
    collectionView.backgroundColor = self.backgroundColor;
    self.collectionView = collectionView;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self addSubview:collectionView];
    // 注册
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    collectionView.pagingEnabled = YES;
    
}

// 点击切换键盘按钮
- (void)changeKeyBoardAction:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(changeKeyBoardBtnDidSelect)]) {
        [_delegate changeKeyBoardBtnDidSelect];
    }
}

// 点击segment
- (void)typeSegmentAction:(UISegmentedControl *)segment {
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:segment.selectedSegmentIndex] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}

// 点击删除按钮
- (void)deleteBtnAction:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(deleteBtnDidSelected)]) {
        [_delegate deleteBtnDidSelected];
    }
}

#pragma mark -- layout布局 --
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(30, 30);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    CGFloat aa = (kWidth-14 - 300) / 10.0/2.0;
    return UIEdgeInsetsMake(0, aa, 0, aa);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return (kWidth-14 - 300) / 10.0;
}

#pragma mark -- 集合视图代理 --
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *array = self.faceDict[self.keyArray[section]];
    return array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    for (NSInteger i=cell.contentView.subviews.count; i>0; i--) {
        [cell.contentView.subviews[i-1] removeFromSuperview];
    }
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    label.font = [UIFont systemFontOfSize:25];
    NSArray *array = self.faceDict[self.keyArray[indexPath.section]];
    label.text =array[indexPath.item];
    [cell.contentView addSubview:label];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *array = self.faceDict[self.keyArray[indexPath.section]];
    if (_delegate && [_delegate respondsToSelector:@selector(collectionViewCellDidSelected:)]) {
        [_delegate collectionViewCellDidSelected:array[indexPath.item]];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSArray *array = [self.collectionView indexPathsForVisibleItems];
    NSIndexPath *indexPath = array.firstObject;
    self.typeSegment.selectedSegmentIndex = indexPath.section;
}

@end
