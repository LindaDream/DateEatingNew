//
//  PlayDetailsViewControllerViewController.h
//  ShiYi
//
//  Created by user on 15/11/5.
//  Copyright © 2015年 TimeCollectorCompany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayDetailsViewController : UIViewController

@property (nonatomic, strong)NSString *ID;
@property (nonatomic, assign)BOOL isWhat;
// 是否收藏
@property (strong,nonatomic) NSString *isCollection;
@end
