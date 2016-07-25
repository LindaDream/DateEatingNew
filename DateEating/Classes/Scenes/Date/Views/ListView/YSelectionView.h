//
//  YSelectionView.h
//  DateEating
//
//  Created by lanou3g on 16/7/15.
//  Copyright © 2016年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ChoiceBlock)(NSString *,NSInteger);
@interface YSelectionView : UIView

@property (copy, nonatomic) ChoiceBlock choiceBlock;
@property (strong,nonatomic) NSMutableArray *array;

@end
