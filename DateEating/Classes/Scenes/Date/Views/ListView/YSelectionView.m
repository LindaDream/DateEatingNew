//
//  YSelectionView.m
//  DateEating
//
//  Created by lanou3g on 16/7/15.
//  Copyright © 2016年 user. All rights reserved.
//

#import "YSelectionView.h"
#import "YSelectionTableViewCell.h"

@interface YSelectionView ()
<
    UITableViewDataSource,
    UITableViewDelegate
>

@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) UIView *contentView;

@end

@implementation YSelectionView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 设置self属性
        self.backgroundColor = [UIColor clearColor];
        UIView *backgroundView = [[UIView alloc]init];
        backgroundView.frame = self.bounds;
        backgroundView.backgroundColor = [UIColor blackColor];
        backgroundView.alpha = 0.5;
        [backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)]];
        [self addSubview:backgroundView];
        // 容器view
        self.contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width - 160, 50)];
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
        // 标题label
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 90, 30)];
        title.text = @"请选择";
        title.font = [UIFont systemFontOfSize:16];
        title.textColor = YRGBColor(248, 89, 64);
        title.textAlignment = NSTextAlignmentCenter;
        title.center = CGPointMake(self.contentView.width/2.0, 20);
        [self.contentView addSubview:title];
        // 横线
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(10, 40, self.contentView.width - 20, 2)];
        line.backgroundColor = YRGBColor(248, 89, 64);
        [self.contentView addSubview:line];
        
        
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 42, self.contentView.width - 20, 40)];
        [self.contentView addSubview:_tableView];
        _tableView.bounces = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        // 注册cell
        [self.tableView registerNib:[UINib nibWithNibName:@"YSelectionTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:YSelectionTableViewCell_Indentify];
    }
    return self;
}

- (void)tapAction {
    [self removeFromSuperview];
}

#pragma mark -- tableview代理方法 --
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    CGFloat height = self.array.count * 40 + 50;
    if (height >= self.height - 200) {
        self.contentView.height = self.height - 200;
        self.tableView.height = self.height - 200 - 50;
    } else {
        self.contentView.height = height;
        self.tableView.height = height - 50;
    }
    _contentView.center = self.center;
    return self.array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YSelectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:YSelectionTableViewCell_Indentify];
    cell.condition.text = self.array[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.choiceBlock(self.array[indexPath.row],indexPath.row);
    [self removeFromSuperview];
}

@end
