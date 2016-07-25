//
//  YPublishPartyViewController.h
//  DateEating
//
//  Created by user on 16/7/14.
//  Copyright © 2016年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YPublishPartyViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *partyTableView;
@property(strong,nonatomic)NSString *addressStr;
@property(strong,nonatomic)NSString *businessID;
@end
