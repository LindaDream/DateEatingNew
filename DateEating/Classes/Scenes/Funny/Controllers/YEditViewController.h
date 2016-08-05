//
//  YEditViewController.h
//  DateEating
//
//  Created by lanou3g on 16/7/19.
//  Copyright © 2016年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YEditViewController;

typedef void(^passUrlArr)(AVObject *obj);
typedef void(^passVC)(YEditViewController *eVC);

@protocol YEditViewControllerDelegate <NSObject>

- (void)sendFinalWithState:(NSString *)isSuccess;

@end

@interface YEditViewController : UIViewController

@property (copy,nonatomic) passUrlArr passBlock;
@property (copy,nonatomic) passVC passVCBlock;

@property (weak,nonatomic) id<YEditViewControllerDelegate> delegate;

@end
