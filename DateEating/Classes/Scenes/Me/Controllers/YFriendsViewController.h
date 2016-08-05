//
//  YFriendsViewController.h
//  DateEating
//
//  Created by user on 16/7/22.
//  Copyright © 2016年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^passUnreadCount)(NSNumber *count,NSMutableDictionary *dict);

@interface YFriendsViewController : UIViewController
@property(strong,nonatomic)NSMutableDictionary *conversationDict;
@property(copy,nonatomic)passUnreadCount passValueBlock;
@property(assign,nonatomic)NSInteger unreadCount;

@end
