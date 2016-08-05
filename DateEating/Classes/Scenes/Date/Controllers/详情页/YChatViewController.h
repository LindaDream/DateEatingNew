//
//  YChatViewController.h
//  DateEating
//
//  Created by user on 16/7/21.
//  Copyright © 2016年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YFriends.h"
@interface YChatViewController : UIViewController
@property(strong,nonatomic)NSString *toName;
@property (strong,nonatomic) YFriends *friends;
@property (strong,nonatomic) NSString *key;
@end
