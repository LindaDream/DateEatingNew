//
//  YFaceView.h
//  DateEating
//
//  Created by user on 16/7/25.
//  Copyright © 2016年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YFaceViewDelegate <NSObject>

- (void)changeKeyBoardBtnDidSelect;

- (void)collectionViewCellDidSelected:(NSString *)face;

- (void)deleteBtnDidSelected;

@end

@interface YFaceView : UIView

@property (assign, nonatomic) id<YFaceViewDelegate>delegate;

@end
