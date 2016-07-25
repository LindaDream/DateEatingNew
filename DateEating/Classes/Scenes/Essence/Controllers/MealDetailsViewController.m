//
//  MealDetailsViewController.m
//  ShiYi
//
//  Created by lanou3g on 15/11/1.
//  Copyright © 2015年 TimeCollectorCompany. All rights reserved.
//

#import "MealDetailsViewController.h"
#import "YMealDetailsModel.h"
#import "MealView.h"
#import "YMealModel.h"
//#import "UserInfoViewController.h"
#import "ContentView.h"
#import "OtherEventView.h"
#import "DDIndicator.h"
#import <UMSocialData.h>
#import <UMSocialSnsService.h>
#import <UMSocialControllerService.h>
#import "UMSocial.h"

@interface MealDetailsViewController ()<SDCycleScrollViewDelegate, UIScrollViewDelegate, UIWebViewDelegate, UMSocialUIDelegate>

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;

@property (nonatomic, strong)NSURLSessionDataTask *myTask;
@property (nonatomic, strong)UIScrollView *BGScrollView;
@property (nonatomic, strong)MealView *mealView;
@property (nonatomic, strong)NSMutableArray *highlightArray;
@property (nonatomic, strong)NSMutableArray *menuArray;
@property (nonatomic, assign)BOOL isCover;
@property (nonatomic, strong)NSString *wordOne;
@property (nonatomic, strong)NSString *wordTwo;
@property (nonatomic, strong)NSMutableArray *wordArray;
@property (nonatomic, strong)NSMutableArray *imageArray;
@property (nonatomic, strong)ContentView *contentView;
@property (nonatomic, strong)OtherEventView *otherView;
@property (nonatomic, assign)CGFloat hight;
@property (nonatomic, strong)UILabel *muenLabel;
@property (nonatomic, strong)DDIndicator *loadingView;
@property (nonatomic, strong)UIView *BGView;
@property (nonatomic, assign)BOOL isOnce;
@property (nonatomic, assign)BOOL isBuild;

// 是否已收藏
@property (assign,nonatomic) BOOL isCollection;
@property (strong,nonatomic) NSString *objId;


@end

@implementation MealDetailsViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.myTask) {
        [self.myTask cancel];
        self.myTask = nil;
        NSLog(@"yes");
    } else {
        NSLog(@"no");
    }
}

-(void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.highlightArray = [NSMutableArray array];
    self.menuArray = [NSMutableArray array];
    [self addSubView];
    [self setUpData];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStateChange) name:kReachabilityChangedNotification object:nil];
    //self.navigationController.navigationBar.translucent = NO;
    [self setNavigationStyle];
    self.isCollection = YES;
    self.isOnce = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpData
{
    dispatch_queue_t myQueue = dispatch_queue_create("com.MealDetails.queue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(myQueue, ^{
        
        NSString *urlString = [[kMealDetailsUrlOne stringByAppendingString:self.ID] stringByAppendingString:kMealDetailsUrlTwo];
        NSLog(@"%@",urlString);
        NSURL *newUrl = [NSURL URLWithString:urlString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:newUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
        [request setHTTPMethod:@"GET"];
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
        self.myTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (data != nil) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                self.BGView.hidden = NO;
                [self.loadingView startAnimating];
                self.model = [[YMealDetailsModel alloc] init];
                [self.model setValuesForKeysWithDictionary:[dic valueForKey:@"data"]];
                self.model.recommendAutomatic = [NSMutableArray arrayWithArray:[dic valueForKey:@"recommendAutomatic"]];
                [self changeModel];
                self.highlightArray = [NSMutableArray arrayWithArray:[self getContectString:self.model.highlight]];
                self.menuArray = [NSMutableArray arrayWithArray:[self getContectString:self.model.menu]];
                [self getArray:self.highlightArray];
//                [self changeFrame];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self addShufflingFigure];
                    self.myTask = nil;
//                    self.BGView.hidden = YES;
                    self.navigationItem.title = self.model.title;
                    NSThread *aThread = [[NSThread alloc] initWithTarget:self selector:@selector(changeFrame) object:nil];
                    [aThread start];
                    aThread = nil;
                    
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.myTask = nil;
                    [self.loadingView stopAnimating];
                    self.BGView.hidden = YES;
                    
                    self.isBuild = NO;
                [self showAlertViewWithMessage:@"你的网络状态较差,请检查网络!"];
                });
            }
            
            
        }];
        [self.myTask resume];
    });
}

#pragma mark - 加载轮播图
- (void)addShufflingFigure {
    
    // 用网络图片实现
    NSArray *imageURLString = self.model.headPics; // 解析数据时得到的轮播图数组
    
    // 创建代标题的轮播图
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kWidth, 200) imageURLStringsGroup:nil];
    
    // 设置代理
    _cycleScrollView.delegate = self;
    // 设置小圆点的位置
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    // 设置小圆点动画效果
    _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    // 小圆点颜色
    _cycleScrollView.pageDotColor = [UIColor whiteColor];
    
    // 把图片数组赋值给每个图片
    _cycleScrollView.imageURLStringsGroup = imageURLString;
    
    // 几秒钟换图片
    _cycleScrollView.autoScrollTimeInterval = 3;
    [self.BGScrollView addSubview:_cycleScrollView];
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    
}

- (void)addSubView
{
    self.BGScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    self.BGScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.BGScrollView];
    self.BGScrollView.bounces = NO;
    self.BGScrollView.delegate = self;
    [self.BGScrollView addSubview:self.cycleScrollView];
    

    self.mealView = [[MealView alloc] initWithFrame:CGRectMake(0, 200, kWidth, 200)];
    [self.BGScrollView addSubview:self.mealView];
    
    self.contentView = [[ContentView alloc] initWithFrame:CGRectMake(0, self.mealView.frame.origin.y + self.mealView.frame.size.height, kWidth, 200)];
    [self.BGScrollView addSubview:self.contentView];
    
    self.muenLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.contentView.frame.origin.y + 210, kWidth, 200)];
    self.muenLabel.textAlignment = NSTextAlignmentCenter;
    self.muenLabel.numberOfLines = 0;
    self.muenLabel.font = [UIFont systemFontOfSize:16];
    [self.BGScrollView addSubview:self.muenLabel];
    
    self.otherView = [[OtherEventView alloc] initWithFrame:CGRectMake(0, self.muenLabel.frame.size.height + self.muenLabel.frame.origin.y + 10, kWidth, 270)];
    [self.BGScrollView addSubview:self.otherView];
    self.BGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    self.BGView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.BGView];
    
    _loadingView = [[DDIndicator alloc] initWithFrame:CGRectMake((kWidth - 40)/ 2, (self.BGView.height - 100)/ 2, 40, 40)];
    [self.BGView addSubview:_loadingView];
    
}

- (void)changeModel
{
    self.model.guideline = [self removePTagString:self.model.guideline];
    self.model.highlight = [self removePTagString:self.model.highlight];
    self.model.menu = [self removePTagString:self.model.menu];
    self.model.Description = [self removePTagString:self.model.Description];
}

- (NSString *)removePTagString:(NSString *)string
{
    string = [string  stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    string = [string  stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    int numOne = 0;
    int numTwo = 0;
    for (int i = 0; i < [string length]; i++) {
        NSRange  range = {i, 1};
        if ([[string substringWithRange:range] isEqualToString:@"<"]) {
            numOne = i;
            for (int j = i; j < [string length]; j++) {
                NSRange  otherrange = {j, 1};
                if ([[string substringWithRange:otherrange] isEqualToString:@">"]) {
                    numTwo = j;
                    NSRange newRange = {i, (j - i + 1)};
                    NSString *str = [string substringWithRange:newRange];
                    if ([str rangeOfString:@"<img src="].location != NSNotFound) {
                        
                    } else {
                        string = [string stringByReplacingOccurrencesOfString:str withString:@""];
                        i = 0;
                        break;
                    }
                }
            }
        }
    }
    string = [string  stringByReplacingOccurrencesOfString:@"alt=style=text-align:justify;/>" withString:@""];
    string = [string  stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    string = [string  stringByReplacingOccurrencesOfString:@"YHOUSE悦会客服专线：4008-215-270" withString:@""];
    string = [string  stringByReplacingOccurrencesOfString:@"如有疑问，请联系 YHOUSE 客服" withString:@""];
    string = [string  stringByReplacingOccurrencesOfString:@"客服电话：4008215270" withString:@""];
    [string  stringByReplacingOccurrencesOfString:@"YHOUSE悦会客服专线：4008-215-270" withString:@""];
    [string  stringByReplacingOccurrencesOfString:@"。电话：4008215270" withString:@""];
    return string;
}

- (NSMutableArray *)getContectString:(NSString *)string
{
    NSArray *array = [string componentsSeparatedByString:@"\n"];
    NSMutableArray *returnArray = [NSMutableArray arrayWithArray:array];
    for (int i = 0; i < [returnArray count]; i++) {
        
        if (![returnArray[i] isEqualToString:@""]) {
            
            if ([returnArray[i] rangeOfString:@".jpg"].location !=NSNotFound) {
                NSArray *myArray2 = [returnArray[i] componentsSeparatedByString:@".jpg"];
                returnArray[i] = myArray2[0];
                returnArray[i] = [returnArray[i] stringByReplacingOccurrencesOfString:@"<img src=" withString:@""];
                returnArray[i] = [returnArray[i] stringByAppendingString:@".jpg"];
                returnArray[i] = [returnArray[i] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            }
            if ([returnArray[i] rangeOfString:@".png"].location !=NSNotFound) {
                NSArray *myArray2 = [returnArray[i] componentsSeparatedByString:@".png"];
                returnArray[i] = myArray2[0];
                returnArray[i] = [returnArray[i] stringByReplacingOccurrencesOfString:@"<img src=" withString:@""];
                returnArray[i] = [returnArray[i] stringByAppendingString:@".png"];
                returnArray[i] = [returnArray[i] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            }
            if ([returnArray[i] isEqualToString:@"YHOUSE悦会客服专线：4008-215-270"]) {
                [returnArray removeObject:@"YHOUSE悦会客服专线：4008-215-270"];
            }
        } else {
            
        }
    }
    return returnArray;
}

- (CGFloat)hightForLabelWithString:(NSString *)string
{
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:16] forKey:NSFontAttributeName];
    CGRect newFrame = [string boundingRectWithSize:CGSizeMake(300, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return newFrame.size.height;
}


- (void)actionTurnToOther:(UIButton *)button
{
    NSInteger number = button.tag % 2500;
    NSDictionary *dic = [self.model.recommendAutomatic[number] valueForKey:@"data"];
    YMealModel *model = [[YMealModel alloc] init];
    [model setValuesForKeysWithDictionary:dic];
    //    NSLog(@"%ld", number);
    MealDetailsViewController *mealVC = [[MealDetailsViewController alloc] init];
    mealVC.ID = [NSString stringWithFormat:@"%ld", model.ID];
    [self.navigationController pushViewController:mealVC animated:YES];
}

- (void)getArray:(NSMutableArray *)array
{
    self.imageArray = [NSMutableArray array];
    self.wordArray = [NSMutableArray array];
    for (int i = 0; i < [array count]; i++) {
        if ([array[i] hasSuffix:@"jpg"] || [array[i] hasSuffix:@"png"] || [array[i] hasSuffix:@"jpg "]) {
            if ([array[i] hasSuffix:@"jpg "]) {
                array[i] = [array[i] stringByReplacingOccurrencesOfString:@" " withString:@""];
            }
            array[i] = [array[i] stringByReplacingOccurrencesOfString:@" " withString:@""];
            array[i] = [array[i] stringByReplacingOccurrencesOfString:@" http" withString:@"http"];
            [self.imageArray addObject:array[i]];
        } else {
            [self.wordArray addObject:array[i]];
        }
    }
    self.wordOne = @"";
    self.wordTwo = @"";
    for (int i = 0; i < [self.wordArray count]; i++) {
        if (i < [self.wordArray count] / 2) {
            self.wordOne = [self.wordOne stringByAppendingString:self.wordArray[i]];
        } else {
            self.wordTwo = [self.wordTwo stringByAppendingString:self.wordArray[i]];
            
        }
    }
}

//- (void)networkStateChange
//{
//    Reachability *conn = [Reachability reachabilityForInternetConnection];
//    if ([conn currentReachabilityStatus] != NotReachable) {
//        
//            if (self.isBuild == YES) {
//                
//            } else {
//                [self setUpData];
//            }
//        
//     
//    } else {
//        
//    }
//}

- (void)actionCollection:(UIBarButtonItem *)button
{
    
    AVObject *object = [AVObject objectWithClassName:@"MyMealCollection"];
    if (self.isCollection) {
        
        // 保存当前用户名
        [object setObject:[AVUser currentUser].username forKey:@"userName"];
        
        // 保存ID
        [object setObject:self.ID forKey:@"ID"];
        
        // 保存title
        [object setObject:self.model.title forKey:@"title"];
        
        AVQuery *query = [AVQuery queryWithClassName:@"MyMealCollection"];
        [query whereKey:@"ID" equalTo:self.ID];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (objects.count == 0) {
                [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        [self showAlertViewWithMessage:(@"收藏成功")];
                        [[NSUserDefaults standardUserDefaults] setObject:object.objectId forKey:self.ID];
                    }
                }];
            }else{
                [self showAlertViewWithMessage:(@"您已收藏,不可重复收藏,如果想取消收藏，请再次点击")];
            }
        }];
        self.isCollection = NO;
    }else{
        
        // 删除收藏的数据
        // 执行 CQL 语句实现删除一个 MyAttention 对象
        self.objId = [[NSUserDefaults standardUserDefaults] objectForKey:self.ID];
        NSLog(@"%@",self.objId);
        [AVQuery doCloudQueryInBackgroundWithCQL:[NSString stringWithFormat:@"delete from MyMealCollection where objectId='%@'",self.objId] callback:^(AVCloudQueryResult *result, NSError *error) {
            [self showAlertViewWithMessage:(@"取消收藏成功")];
        }];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:self.ID];
        self.isCollection = YES;
    }
}

- (BOOL)isHave
{
    AVUser *currentUser = [AVUser currentUser];
    NSArray *ID = [[currentUser objectForKey:@"meal"] valueForKey:@"ID"];
    for (int i = 0; i < [ID count]; i++) {
        if (self.model.ID == ID[i]) {
            return YES;
        }
    }
    return NO;
}

- (void)actionUserLogin:(NSNotification *)notification
{

    
//    Reachability *conn = [Reachability reachabilityForInternetConnection];
//    if ([conn currentReachabilityStatus] != NotReachable) {
//        //        NSLog(@攻略:有网络");
//        AVUser *currentUser = [AVUser currentUser];
//        if (currentUser != nil) {
//            if ([self isHave]) {
//                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您已经收藏过了" preferredStyle:UIAlertControllerStyleAlert];
//                [self presentViewController:alertController animated:YES completion:nil];
//                [self performSelector:@selector(dismiss:) withObject:alertController afterDelay:0.5];
//            } else {
//                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.model.ID, @"ID", self.model.title, @"title", nil];
//                [currentUser addObject:dic forKey:@"meal"];
//                [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//                    NSLog(@"%@", [currentUser objectForKey:@"meal"]);
//                    [currentUser saveInBackground];
//                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"收藏成功" preferredStyle:UIAlertControllerStyleAlert];
//                    [self presentViewController:alertController animated:YES completion:nil];
//                    [self performSelector:@selector(dismiss:) withObject:alertController afterDelay:5];
//                }];
//            }
//        } else {
//            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"LoginAndRegister" bundle:nil];
//            UIViewController *loginVC = [storyBoard instantiateInitialViewController];
//            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionUserLogin:) name:@"USERISLOGIN" object:nil];
//            [self presentViewController:loginVC animated:YES completion:nil];
//        }
//        
//    } else {
//        //        NSLog(@"没有网络");
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"收藏失败 请您检查是否为网络原因" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *say = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
//        [alertController addAction:say];
//        [self presentViewController:alertController animated:YES completion:nil];
//        //        [self performSelector:@selector(dismiss:) withObject:alertController afterDelay:0.5];
//        
//    }

}

- (void)dismiss:(UIAlertController *)alert
{
    [alert dismissViewControllerAnimated:YES completion:nil];
}

- (void)setNavigationStyle
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = self.model.title;
    
    // 分享
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStylePlain target:self action:@selector(actionShareButton:)];
    
    // 收藏
    UIBarButtonItem *shouCangButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"favorite"] style:UIBarButtonItemStylePlain target:self action:@selector(actionCollection:)];
    
    shouCangButton.imageInsets = UIEdgeInsetsMake(0, 0, 0, -30);
    self.navigationItem.rightBarButtonItems = @[shareButton, shouCangButton];
    
    
}

- (void)actionShareButton:(UIBarButtonItem *)button
{
    self.model.shareUrl = [NSString stringWithFormat:@"http://m.yhouse.com/meal/%@", self.ID];
    // 分享字符串
    NSString *shareString = [NSString stringWithFormat:@"【%@，%@！】%@ 简单的生活，纷繁的世界 #约起来#带你到别人的世界走走", self.model.title, self.model.viceTitle, self.model.shareUrl];
    // 分享图片
    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:self.model.picUrl];
    
    [UMSocialData defaultData].extConfig.title = shareString;
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"578c9832e0f55a30cb003483"
                                      shareText:shareString
                                     shareImage:nil
                                shareToSnsNames:@[UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToDouban,UMShareToEmail,UMShareToSms]
                                       delegate:self];
    
}

- (NSString *)getTag
{
    NSString *tag = @"";
    for (int i = 0; i < [self.model.tags count]; i++) {
        if (i == [self.model.tags count] - 1) {
            tag = [tag stringByAppendingString:self.model.tags[i]];
        } else {
            tag = [[tag stringByAppendingString:self.model.tags[i]] stringByAppendingString:@"~"];
        }
    }
    return tag;
}

- (void)changeFrame
{
    _cycleScrollView.imageURLStringsGroup = self.model.headPics;
    self.mealView.titleLabel.text = self.model.title;
    self.mealView.hostNameLabel.text = [@"铺店: " stringByAppendingString:self.model.hostName];
    self.mealView.addressLabel.text = [@"地址: " stringByAppendingString:self.model.address];
    self.mealView.tagLable.text = [self getTag];
    self.mealView.descriptionLabel.text = self.model.Description;
    self.mealView.contactNumber.text = [@"电话: " stringByAppendingString:self.model.contactNumber];
    self.mealView.showLabel.text = @"-- 简介 --";
    self.contentView.sayLabel.text = @"-----------  正文 -----------";

    CGRect newAddressLabelFrame = self.mealView.addressLabel.frame;
    newAddressLabelFrame.size.height = [self hightForLabelWithString:self.model.address];
    self.mealView.addressLabel.frame = newAddressLabelFrame;
    
    CGRect newLabelFrame = self.mealView.showLabel.frame;
    newLabelFrame.origin.y = self.mealView.addressLabel.frame.origin.y + self.mealView.addressLabel.frame.size.height + 10;
    self.mealView.showLabel.frame = newLabelFrame;
    
    CGRect newFrame = self.mealView.descriptionLabel.frame;
    newFrame.origin.y = self.mealView.showLabel.frame.origin.y + newLabelFrame.size.height + 10;
    newFrame.size.height = [self hightForLabelWithString:self.model.Description];
    self.mealView.descriptionLabel.frame = newFrame;
    
    
    CGRect newMealViewFrame = self.mealView.frame;
    newMealViewFrame.size.height = self.mealView.descriptionLabel.frame.size.height + self.mealView.descriptionLabel.frame.origin.y;
    self.mealView.frame = newMealViewFrame;
    
    self.contentView.contentOneView.text = [@"    " stringByAppendingString:self.wordOne];
    CGRect newcontentOneView = self.contentView.contentOneView.frame;
    newcontentOneView.size.height = [self hightForLabelWithString:self.wordOne];
    self.contentView.contentOneView.frame = newcontentOneView;
    
    
    if ([self.imageArray count] == 0) {
        CGRect newImage = self.contentView.image.frame;
        newImage.origin.y = self.contentView.contentOneView.frame.size.height;
        newImage.size = CGSizeMake(0, 0);
        self.contentView.image.frame = newImage;
    } else {
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageArray[0]]]];
        CGFloat scale = 0.55;
        while (image.size.width * scale > kWidth - 10) {
            scale = scale - 0.05;
        }
        CGRect newImage = self.contentView.image.frame;
        newImage.origin.y = self.contentView.contentOneView.frame.size.height + 10;
        newImage.origin.x = (kWidth - image.size.width * scale) / 2;
        newImage.size = CGSizeMake(image.size.width * scale, image.size.height * scale);
        self.contentView.image.frame = newImage;
        [self.contentView.image sd_setImageWithURL:[NSURL URLWithString:self.imageArray[0]]];
    }
    self.contentView.contentTwoView.text = [@"    " stringByAppendingString:self.wordTwo];
    CGRect newcontentTwoView = self.contentView.contentTwoView.frame;
    newcontentTwoView.origin = CGPointMake((kWidth - 340) / 2, self.contentView.image.frame.origin.y + self.contentView.image.frame.size.height);
    newcontentTwoView.size.height = [self hightForLabelWithString:self.wordTwo];
    self.contentView.contentTwoView.frame = newcontentTwoView;
    
    self.hight = self.contentView.contentTwoView.frame.origin.y + self.contentView.frame.size.height + 300;
    
    CGRect newContentView = self.contentView.frame;
    newContentView.origin.y = self.mealView.frame.size.height + self.mealView.frame.origin.y + 10;
    newContentView.size.height = self.contentView.contentTwoView.frame.origin.y + self.contentView.contentTwoView.frame.size.height;
    self.contentView.frame = newContentView;
    
    self.muenLabel.text = [self removeChar];
    self.muenLabel.font = [UIFont systemFontOfSize:16];
    NSLog(@"%@", self.model.menu);
    self.muenLabel.textColor = [UIColor blackColor];
    self.muenLabel.textAlignment = NSTextAlignmentCenter;
    CGRect newMuenFrame = self.muenLabel.frame;
    newMuenFrame.size.height = [self hightForLabelWithString:self.model.menu];
    newMuenFrame.origin.y = self.contentView.frame.origin.y + self.contentView.frame.size.height;
    self.muenLabel.frame = newMuenFrame;
    
    
    CGRect newOtherView = self.otherView.frame;
    newOtherView.origin.y = self.muenLabel.frame.origin.y + self.muenLabel.frame.size.height + 20;
    self.otherView.frame = newOtherView;
    self.hight = self.otherView.frame.origin.y + 270;
    if ([self.model.recommendAutomatic count] >= 3) {
        for (int i = 0; i < 3; i++) {
            YMealModel *model = [[YMealModel alloc] init];
            [model setValuesForKeysWithDictionary: [self.model.recommendAutomatic[i] valueForKey:@"data"]];
            UIImageView *image = (UIImageView *)[self.otherView viewWithTag:2600 + i];
            UILabel *labelOne = (UILabel *)[self.otherView viewWithTag:2700 + i];
            UILabel *labelTwo = (UILabel *)[self.otherView viewWithTag:2800 + i];
            UIButton *button = (UIButton *)[self.otherView viewWithTag:2500 + i];
            [image sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:nil];
            labelOne.text = model.title;
            labelTwo.text = model.priceStr;
            [button addTarget:self action:@selector(actionTurnToOther:) forControlEvents:UIControlEventTouchUpInside];
        }
    } else if ([self.model.recommendAutomatic count] == 2) {
        for (int i = 0; i < 2; i++) {
            YMealModel *model = [[YMealModel alloc] init];
            [model setValuesForKeysWithDictionary: [self.model.recommendAutomatic[i] valueForKey:@"data"]];
            UIImageView *image = (UIImageView *)[self.otherView viewWithTag:2600 + i];
            UILabel *labelOne = (UILabel *)[self.otherView viewWithTag:2700 + i];
            UILabel *labelTwo = (UILabel *)[self.otherView viewWithTag:2800 + i];
            UIButton *button = (UIButton *)[self.otherView viewWithTag:2500 + i];
            [image sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:nil];
            labelOne.text = model.title;
            labelTwo.text = model.priceStr;
            [button addTarget:self action:@selector(actionTurnToOther:) forControlEvents:UIControlEventTouchUpInside];
        }
        
    } else if ([self.model.recommendAutomatic count] == 1) {
        for (int i = 0; i < 1; i++) {
            YMealModel *model = [[YMealModel alloc] init];
            [model setValuesForKeysWithDictionary: [self.model.recommendAutomatic[i] valueForKey:@"data"]];
            UIImageView *image = (UIImageView *)[self.otherView viewWithTag:2600 + i];
            UILabel *labelOne = (UILabel *)[self.otherView viewWithTag:2700 + i];
            UILabel *labelTwo = (UILabel *)[self.otherView viewWithTag:2800 + i];
            UIButton *button = (UIButton *)[self.otherView viewWithTag:2500 + i];
            [image sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:nil];
            labelOne.text = model.title;
            labelTwo.text = model.priceStr;
            [button addTarget:self action:@selector(actionTurnToOther:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    self.BGScrollView.contentSize = CGSizeMake(0, self.hight + 130);
    self.BGView.hidden = YES;
    [self.loadingView stopAnimating];
    self.isBuild = YES;
}

- (NSString *)removeChar
{
    NSMutableArray *meunArray = [self getContectString:self.model.menu];

    NSString *string = @"";
    for (int i = 0; i < [meunArray count]; i++) {
        string = [string stringByAppendingString:[meunArray[i] stringByAppendingString:@"\n"]];
    }
    return string;
}

- (void)actionLeftButton
{
    if (self.isOnce == NO) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        self.isOnce = YES;
    }
}

- (void)showAlertViewWithMessage:(NSString *)message
{
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // 1秒后回收
    [self performSelector:@selector(dismissAlertView:) withObject:alertView afterDelay:1.5];
    [self presentViewController:alertView animated:YES completion:nil];
}
- (void)dismissAlertView:(UIAlertController *)alertView
{
    [alertView dismissViewControllerAnimated:YES completion:nil];
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
