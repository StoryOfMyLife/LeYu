//
//  ActivityViewController.m
//  LifeO2O
//
//  Created by 刘廷勇 on 15/9/5.
//  Copyright (c) 2015年 Arsenal. All rights reserved.
//

#import "ActivityViewController.h"
#import "TTHorizontalCategoryBar.h"
#import "TTCollectionPageViewController.h"
#import "ActivitiesNearbyViewController.h"

@interface ActivityViewController () <TTCollectionPageViewControllerDelegate>

@property (nonatomic, strong) TTHorizontalCategoryBar *tabHeader;
@property (nonatomic, strong) TTCollectionPageViewController *pageViewController;

@property (nonatomic, strong) NSArray *viewControllers;

@end

@implementation ActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"活动";
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.tabHeader];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.tabHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.equalTo(@40);
    }];
}

#pragma mark -
#pragma mark Page View Controller Delegate

- (void)pageViewController:(TTCollectionPageViewController *)pageViewController pagingFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex completePercent:(CGFloat)percent
{
    [self.tabHeader updateInteractiveTransition:percent fromIndex:fromIndex toIndex:toIndex];
}

- (void)pageViewController:(TTCollectionPageViewController *)pageViewController didPagingToIndex:(NSInteger)toIndex
{
    self.tabHeader.selectedIndex = toIndex;
}

- (void)pageViewController:(TTCollectionPageViewController *)pageViewController willPagingToIndex:(NSInteger)toIndex
{
    [self.tabHeader scrollToIndex:toIndex];
}

#pragma mark -
#pragma mark - Getters and Setters

- (TTHorizontalCategoryBar *)tabHeader
{
    if (!_tabHeader) {
        _tabHeader = [[TTHorizontalCategoryBar alloc] initWithFrame:CGRectZero];
        _tabHeader.interitemSpacing = 100;
        _tabHeader.backgroundColor = [UIColor whiteColor];
        _tabHeader.bottomIndicatorColor = DefaultYellowColor;
        _tabHeader.categories = @[[[TTCategoryItem alloc] initWithTitle:@"附近"],
                                  [[TTCategoryItem alloc] initWithTitle:@"收藏"]];
        weakSelf();
        _tabHeader.didSelectCategory = ^(NSInteger index){
            [weakSelf.pageViewController setCurrentPage:index scrollToPage:YES];
        };
    }
    return _tabHeader;
}

- (TTCollectionPageViewController *)pageViewController
{
    if (!_pageViewController) {
        _pageViewController = [[TTCollectionPageViewController alloc] init];
        _pageViewController.view.frame = self.view.bounds;
        _pageViewController.delegate = self;
        [self.view addSubview:_pageViewController.view];
        
        NSMutableArray *models = [NSMutableArray arrayWithCapacity:self.viewControllers.count];
        for (int i = 0; i < self.viewControllers.count; i++) {
            ActivitiesNearbyViewController *vc = self.viewControllers[i];
            [_pageViewController addChildViewController:vc];
            if (i == 0) {
                [vc loadActivities:NO];
            } else {
                [vc loadActivities:NO];
            }
            TTCollectionPageCellItem *item = [[TTCollectionPageCellItem alloc] init];
            item.controller = vc;
            [models addObject:item];
        }
        _pageViewController.pageItems = models;
    }
    return _pageViewController;
}

- (NSArray *)viewControllers
{
    if (!_viewControllers) {
        _viewControllers = @[[[ActivitiesNearbyViewController alloc] init],
                             [[ActivitiesNearbyViewController alloc] init]];
    }
    return _viewControllers;
}

@end
