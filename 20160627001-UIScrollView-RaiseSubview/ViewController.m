//
//  ViewController.m
//  20160627001-UIScrollView-RaiseSubview
//
//  Created by Rainer on 16/6/27.
//  Copyright © 2016年 Rainer. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIScrollViewDelegate, UITableViewDataSource>

/** 主滚动视图 */
@property (nonatomic, weak) UIScrollView *mainScrollView;
/** 广告图片视图 */
@property (nonatomic, weak) UIImageView *adImageView;
/** 悬停视图 */
@property (nonatomic, weak) UIView *raiseView;
/** 热门商品标签 */
@property (nonatomic, weak) UILabel *hotProductLabel;
/** 内容视图 */
@property (nonatomic, weak) UITableView *contentTableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self mainScrollView];
    [self adImageView];
    [self raiseView];
    [self contentTableView];
    [self hotProductLabel];
}

- (UIScrollView *)mainScrollView {
    if (nil == _mainScrollView) {
        UIScrollView *mainScrollView = [[UIScrollView alloc] init];
        
        mainScrollView.frame = self.view.frame;
        mainScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 1000);
        mainScrollView.showsHorizontalScrollIndicator = NO;
        mainScrollView.showsVerticalScrollIndicator = NO;
        mainScrollView.delegate = self;
        
        _mainScrollView = mainScrollView;
        
        [self.view addSubview:_mainScrollView];
    }
    
    return _mainScrollView;
}

- (UIImageView *)adImageView {
    if (nil == _adImageView) {
        UIImageView *adImageView = [[UIImageView alloc] init];
        
        adImageView.image = [UIImage imageNamed:@"ad_00"];
        
        adImageView.frame = CGRectMake(0, 0, self.mainScrollView.bounds.size.width, 150);
        
        _adImageView = adImageView;
        
        [self.mainScrollView addSubview:_adImageView];
    }
    
    return _adImageView;
}

- (UIView *)raiseView {
    if (nil == _raiseView) {
        UIView *raiseView = [[UIView alloc] init];
        
        raiseView.backgroundColor = [UIColor greenColor];
        raiseView.frame = CGRectMake(0, CGRectGetMaxY(self.adImageView.frame), self.mainScrollView.bounds.size.width, 30);
        
        _raiseView = raiseView;
        
        [self.mainScrollView addSubview:_raiseView];
    }
    
    return _raiseView;
}

- (UILabel *)hotProductLabel {
    if (nil == _hotProductLabel) {
        UILabel *hotProductLabel = [[UILabel alloc] init];
        
        hotProductLabel.text = @"热门商品";
        hotProductLabel.frame = CGRectMake(10, 0, 100, 30);
        hotProductLabel.textColor = [UIColor orangeColor];
        
        _hotProductLabel = hotProductLabel;
        
        [self.raiseView addSubview:_hotProductLabel];
    }
    
    return _hotProductLabel;
}

- (UITableView *)contentTableView {
    if (nil == _contentTableView) {
        CGFloat contentViewH = self.mainScrollView.contentSize.height - CGRectGetMaxY(self.raiseView.frame);
        CGRect contentTabaleViewFrame = CGRectMake(0, CGRectGetMaxY(self.raiseView.frame), self.mainScrollView.bounds.size.width, contentViewH);
        
        UITableView *contentTableView = [[UITableView alloc] initWithFrame:contentTabaleViewFrame style:UITableViewStylePlain];
        
        contentTableView.dataSource = self;
        
        _contentTableView = contentTableView;
        
        [self.mainScrollView addSubview:_contentTableView];
    }
    
    return _contentTableView;
}

/**
 *  滚动视图代理方法
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 1.获取滚动视图的偏移量和图片视图的高度
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    CGFloat adImageViewH = self.adImageView.bounds.size.height;
    
    // 2.当滚动视图垂直方向的偏移量大于等于图片视图的高度时将悬停视图添加到控制器视图上实现悬停
    //   否则将悬停视图添加回滚动视图上让悬停视图可以继续滚动
    if (contentOffsetY >= adImageViewH) {
        CGRect raiseViewFrame = self.raiseView.frame;
        
        raiseViewFrame.origin.y = 20;
        self.raiseView.frame = raiseViewFrame;
        
        [self.view addSubview:self.raiseView];
    } else {
        CGRect raiseViewFrame = self.raiseView.frame;
        
        raiseViewFrame.origin.y = 150;
        self.raiseView.frame = raiseViewFrame;
        
        [scrollView addSubview:self.raiseView];
    }
    
//    if (contentOffsetY < 0) {
//        CGFloat scale = 1 - (contentOffsetY / 50);
//        
//        self.adImageView.transform = CGAffineTransformMakeScale(scale, scale);
//    }
    
    // 3.计算缩放比例，设置图片的缩放效果
    CGFloat scale = contentOffsetY < 0 ? 1 - (contentOffsetY / 50) : 1;
    
    self.adImageView.transform = CGAffineTransformMakeScale(scale, scale);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 13;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *tableViewCellIdentifier = @"tableViewCellIdentifier";
    
    UITableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:tableViewCellIdentifier];
    
    if (nil == tableViewCell) {
        tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableViewCellIdentifier];
    }
    
    tableViewCell.textLabel.text = [NSString stringWithFormat:@"数据-%ld", indexPath.row];
    
    return tableViewCell;
}

@end
