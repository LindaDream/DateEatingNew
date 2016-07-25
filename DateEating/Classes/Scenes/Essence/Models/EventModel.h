//
//  EventModel.h
//  ShiYi
//
//  Created by lanou3g on 15/11/5.
//  Copyright © 2015年 TimeCollectorCompany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventModel : NSObject

@property (nonatomic, strong)NSString *address;
@property (nonatomic, strong)NSString *cityName;
@property (nonatomic, strong)NSString *content;
@property (nonatomic, strong)NSString *duration;
@property (nonatomic, strong)NSString *ID;
@property (nonatomic, strong)NSString *mPicUrl;
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSMutableArray *recommendAutomatic;
@property (nonatomic, strong)NSString *openUrl;

@end
