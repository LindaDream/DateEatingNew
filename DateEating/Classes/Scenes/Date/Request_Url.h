//
//  Request_Url.h
//  DateEating
//
//  Created by lanou3g on 16/7/14.
//  Copyright © 2016年 user. All rights reserved.
//

#ifndef Request_Url_h
#define Request_Url_h

#define array0 @[@"不限",@"18-22",@"23-26",@"27-35",@"35以上"]
#define array1 @[@"不限",@"白羊座",@"金牛座",@"双子座",@"巨蟹座",@"狮子座",@"处女座",@"天秤座",@"天蝎座",@"射手座",@"摩羯座",@"水瓶座",@"双鱼座"]
#define array2 @[@"不限",@"计算机/互联网/通信",@"生产/工艺/制造",@"商业/服务业/个体经营",@"金融/银行/投资/保险",@"文化/广播/传媒",@"娱乐/艺术/表演",@"医护/制药",@"律师/法务",@"教育/培训",@"公务员/事业单位",@"学生"]

#define HotRequest_Url(city,multi,gender,time,age,constellation,occupation,start) [NSString stringWithFormat:@"http://api.qingchifan.com/api/event/city.json?access_token=6916a7ab1f71e43ac4eadf40a51b4ab1852B741AEA05B5BD79985DAF42DA3E32&basicCheck=0&city=%@&multi=%ld&gender=%ld&time=%ld&age=%ld&constellation=%ld&occupation=%ld&start=%ld&size=20&apiVersion=2.9.0",city,multi,gender,time,age,constellation,occupation,start]

#define NearByRequest_Url(multi,gender,time,age,constellation,occupation,start) [NSString stringWithFormat:@"http://api.qingchifan.com/api/event/nearby.json?access_token=6916a7ab1f71e43ac4eadf40a51b4ab1852B741AEA05B5BD79985DAF42DA3E32&basicCheck=0&lat=40.030482&lon=116.343562&multi=%ld&gender=%ld&time=%ld&age=%ld&constellation=%ld&occupation=%ld&start=%ld&size=20&apiVersion=2.9.0",multi,gender,time,age,constellation,occupation,start]

// 评论信息的链接
#define ChatMessageRequest_Url(eventId,start) [NSString stringWithFormat:@"http://api.qingchifan.com/api/event/comments.json?access_token=6916a7ab1f71e43ac4eadf40a51b4ab1852B741AEA05B5BD79985DAF42DA3E32&basicCheck=0&eventId=%ld&start=%ld&size=50",eventId,start]

// 餐厅详情链接(参数需要进行处理)
#define CaterDetailRequest_Url(businessId) [NSString stringWithFormat:@"http://api.qingchifan.com/api/shop/findCaterShop.json?access_token=6916a7ab1f71e43ac4eadf40a51b4ab1852B741AEA05B5BD79985DAF42DA3E32&businessId=%@&eventId=0&platform=1",businessId]
// 餐厅地点列表连接
#define RestaurantList_URL(city) [NSString stringWithFormat:@"http://api.qingchifan.com/api/shop/getHotCaterShop.json?access_token=6916a7ab1f71e43ac4eadf40a51b4ab1852B741AEA05B5BD79985DAF42DA3E32&city=%@&regions=",city]
// 餐厅详情界面连接
#define RestaurantDetail_URL(eventId) [NSString stringWithFormat:@"http://api.qingchifan.com/api/shop/findCaterShop.json?access_token=6916a7ab1f71e43ac4eadf40a51b4ab1852B741AEA05B5BD79985DAF42DA3E32&eventId=%ld",eventId]
// 餐厅列表界面的城市列表链接
#define CityList_URL @"http://api.lanrenzhoumo.com/district/list/allcity?session_id=00004016b3e14bbea40c1aa1a14c2273a35352"


// 个人信息详情链接
#define UserDetailRequest_Url(userId) [NSString stringWithFormat:@"http://api.qingchifan.com/api/user/v2/getUserBusinessInfo.json?access_token=6916a7ab1f71e43ac4eadf40a51b4ab1852B741AEA05B5BD79985DAF42DA3E32&visitUserId=%ld",userId]


// 关注餐厅的人的列表连接
#define AttentionList_URL(businessID) [NSString stringWithFormat:@"http://api.qingchifan.com/api/shop/getShopLikeUser.json?access_token=6916a7ab1f71e43ac4eadf40a51b4ab1852B741AEA05B5BD79985DAF42DA3E32&businessId=%@&platform=1&start=0&size=25",businessID]

#endif /* Request_Url_h */
