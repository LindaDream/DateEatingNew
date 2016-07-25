//
//  YEmojiView.h
//  DateEating
//
//  Created by lanou3g on 16/7/23.
//  Copyright © 2016年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YEmojiViewDelegate <NSObject>

- (void)emojiFaceDidSelect:(NSString *)emoji;

@end

@interface YEmojiView : UIView

@property (assign, nonatomic) id<YEmojiViewDelegate>delegate;

@end
