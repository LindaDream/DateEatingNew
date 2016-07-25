//
//  YCompleteViewController.h
//  DateEating
//
//  Created by user on 16/7/18.
//  Copyright © 2016年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YCompleteViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *ageTF;
@property (weak, nonatomic) IBOutlet UIButton *boyBtn;
@property (weak, nonatomic) IBOutlet UIButton *girlBtn;
@property (weak, nonatomic) IBOutlet UITextField *constellationTF;
@property (weak, nonatomic) IBOutlet UITableView *constellationTableView;

@end
