//
//  YSeekConditionViewController.h
//  DateEating
//
//  Created by lanou3g on 16/7/13.
//  Copyright © 2016年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YSeekConditionViewControllerDelegate <NSObject>

- (void)passSeekCondition;

@end

@interface YSeekConditionViewController : UIViewController

@property (assign, nonatomic) id<YSeekConditionViewControllerDelegate>delegate;

@end
