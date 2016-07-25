//
//  YEditViewController.h
//  DateEating
//
//  Created by lanou3g on 16/7/19.
//  Copyright © 2016年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^passUrlArr)(AVObject *obj);

@interface YEditViewController : UIViewController

@property (copy,nonatomic) passUrlArr passBlock;

@end
