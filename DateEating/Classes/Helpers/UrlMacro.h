//
//  UrlMacro.h
//  ShiYi
//
//  Created by lanou3g on 15/10/27.
//  Copyright © 2015年 TimeCollectorCompany. All rights reserved.
//

#ifndef UrlMacro_h
#define UrlMacro_h

/*************** 分类单例字典的key ***************/
#define kPlayKey @"eventCategory"
#define kFoodKey @"mealCategory"
#define kStrategyKey @"guideCategory"




/*************** 城市和分类所用网址 ***************/
// 选择城市的URL
#define kCityIDUrl @"http://api.yhouse.com/m/city/dynmiclist"

// 选择分类的URL
#define kCategoryUrl @"http://api.yhouse.com/m/category/list/all"

/*************** 首页界面所用网址 ***************/
// 美食的链接拼接
#define kMealUrl(cityId,categoryId,page) [NSString stringWithFormat:@"http://api.yhouse.com/m/meal/list?cityId=%ld&categoryId=%@&page=%@&pageSize=20",cityId,categoryId,page]


// 玩乐链接拼接
#define kPlayUrl(page,cityId,categoryId) [NSString stringWithFormat:@"http://api.yhouse.com/m/event/list?page=%@&pageSize=20&cityId=%ld&categoryId=%@",page,cityId,categoryId]

// 玩乐链接拼接的中间部分
#define kPlayUrlTwo @"&pageSize=20&cityId="

// 玩乐链接凭借的后部分
#define kPlayUrlThree @"&categoryId="


// 美食链接的详情页面的前部分
#define kMealDetailsUrlOne @"http://m.yhouse.com/api/m/meal/item-v2.3/"

// 美食链接的详情页面的后面部分
#define kMealDetailsUrlTwo @"?from=h5"

// 玩乐链接的详情页面的前面部分
#define kPlayDetailsUrlOne @"http://m.yhouse.com/api/m/event/item-v2.3/"

// 玩乐链接的详情页面的后面部分
#define kPlayDetailsUrlTwo @"?from=h5"




#endif /* UrlMacro_h */
