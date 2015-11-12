//
//  ActivitiesViewController.m
//  LifeO2O
//
//  Created by jiecongwang on 5/28/15.
//  Copyright (c) 2015 Arsenal. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import "ShopActivities.h"
#import "OtherActivityCell.h"
#import "ActivityDetailCellItem.h"
#import "ActivityShopPreviewCellItem.h"
#import "ShopMapCellItem.h"

#import "ShopViewController.h"
#import "ActivityAcceptViewController.h"
#import "ImagePreviewViewController.h"
#import "LYLocationManager.h"

#import "LoginViewController.h"

#import "ActivityUserRelation.h"

#import <AFSoundManager/AFSoundManager.h>

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

@interface ActivityDetailViewController ()

@property (nonatomic, strong) ShopActivities *activities;
@property (nonatomic, strong) NSArray *imageFileIds; // of AVFile id
@property (nonatomic, strong) NSMutableDictionary *imagesDict;
@property (nonatomic, strong) UIImageView *cardImage;
@property (nonatomic, strong) UILabel *imageDescLabel;
@property (nonatomic, strong) UILabel *imageIndexLabel;

@property (nonatomic, strong) ActivityDetailCellItem *activityDetailItem;
@property (nonatomic, strong) ActivityShopPreviewCellItem *shopPreviewItem;
@property (nonatomic, strong) ShopMapCellItem *shopMapItem;

@property (nonatomic, strong) NSArray *otherActivities;

@property (nonatomic) NSInteger imageIndex;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *acceptButton;

@property (nonatomic, strong) UIImageView *shopIcon;

@property (nonatomic, strong) AFSoundPlayback *playBack;
@property (nonatomic, strong) AFSoundItem *soundItem;

@property (nonatomic, strong) UIProgressView *audioProgress;
@property (nonatomic, strong) RACSignal *timerSignal;
@property (nonatomic, strong) RACDisposable *timerDisposeable;

@property (nonatomic, strong) UILabel *durationLabel;
@property (nonatomic, assign) NSInteger duration;

@end

@implementation ActivityDetailViewController

- (instancetype)initWithActivities:(ShopActivities *)activities {
    if (self = [self init]) {
        self.activities = activities;
    }
    return self;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.playBack pause];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share)];
    self.navigationItem.rightBarButtonItem = shareItem;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setTitleView];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *tableHeaderView = [self tableHeaderView];
    tableHeaderView.height = [tableHeaderView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    self.tableView.tableHeaderView = tableHeaderView;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = RGBCOLOR_HEX(0xf7f7f7);
    
    self.imageIndex = 0;
    
    self.activityDetailItem = [[ActivityDetailCellItem alloc] init];
    self.activityDetailItem.activity = self.activities;
    
    self.shopPreviewItem = [[ActivityShopPreviewCellItem alloc] init];
    self.shopPreviewItem.shop = self.activities.shop;
    
    
    self.shopMapItem = [[ShopMapCellItem alloc] init];
    self.shopMapItem.shop = self.activities.shop;
    
    self.items = @[@[self.activityDetailItem, self.shopPreviewItem, self.shopMapItem]];
    
    [self convertFilesToImages:self.imageFileIds];
    
    self.refreshEnable = NO;
    
    weakSelf();
    self.shopPreviewItem.actionBlock = ^(UITableView *tableView, NSIndexPath *indexPath){
        [weakSelf gotoShop:YES];
    };
    
    self.shopMapItem.actionBlock = ^(UITableView *tableView, NSIndexPath *indexPath){
        [weakSelf gotoShop:YES];
    };

    self.updateBlock = ^{
        [weakSelf loadData];
    };
    
    [self.view addSubview:self.bottomView];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    
    [self.bottomView addSubview:self.acceptButton];
    
    [self.acceptButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bottomView);
    }];
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self checkAcceptance];
}

- (void)checkAcceptance
{
    if ([LYUser currentUser]) {
        AVQuery *relationQuery = [ActivityUserRelation query];
        [relationQuery whereKey:@"user" equalTo:[LYUser currentUser]];
        [relationQuery whereKey:@"activity" equalTo:self.activities];
        [relationQuery countObjectsInBackgroundWithBlock:^(NSInteger number, NSError *error) {
            if (number != 0) {
                [self didAccept];
            }
        }];
    }
}

- (void)setDuration:(NSInteger)duration
{
    if (_duration != duration) {
        _duration = duration;
        NSInteger minute = _duration / 60;
        NSInteger second = _duration - minute * 60;
        NSString *durationStr;
        if (minute > 0) {
            durationStr = [NSString stringWithFormat:@"%ld'%ld\"", (long)minute, (long)second];
        } else {
            durationStr = [NSString stringWithFormat:@"%ld\"", (long)second];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.durationLabel.text = durationStr;
        });
    }
}

- (void)setTitleView
{
    self.navigationItem.titleView = self.shopIcon;
    UIView *superview = [[UIView alloc] init];
    superview.backgroundColor = [UIColor clearColor];
    superview.size = CGSizeMake(50, 50);
    [superview addSubview:self.shopIcon];
    self.navigationItem.titleView = superview;
    
    [self.shopIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@(40));
        make.centerX.equalTo(superview);
        make.centerY.equalTo(superview).offset(-3);
    }];
    
    weakSelf();
    [self.activities.shop loadShopIcon:^(UIImage *image, NSError *error) {
        [UIView transitionWithView:weakSelf.shopIcon duration:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            weakSelf.shopIcon.image = image;
        } completion:nil];
    }];
}

#pragma mark -
#pragma mark methods

- (void)loadData
{
    AVQuery *query = [ShopActivities query];
    [query whereKey:@"shop" equalTo:self.activities.shop];
    [query orderByDescending:@"createdAt"];
    
    [query includeKey:@"shop"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *activities,NSError *error) {
        if (!error) {
            NSMutableArray *result = [NSMutableArray arrayWithArray:activities];
            [result removeObject:self.activities];
            
            //过滤掉已经接受的活动
            NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:0];
            [result enumerateObjectsUsingBlock:^(ShopActivities *obj, NSUInteger idx, BOOL *stop) {
                if (obj.style != OtherActivityStyleAccepted) {
                    [tmp addObject:obj];
                }
            }];
            self.otherActivities = tmp;
            
            for (ShopActivities *activity in self.otherActivities) {
                activity.style = OtherActivityStyleFavorite;
                
                [activity applyActionBlock:^(UITableView *tableView, NSIndexPath *indexPath) {
                    ShopActivities *activities = self.otherActivities[indexPath.row];
                    ActivityDetailViewController *activitiesViewController = [[ActivityDetailViewController alloc] initWithActivities:activities];
                    [self.navigationController pushViewController:activitiesViewController animated:YES];
                }];
                
                activity.handleBlock = ^(NSDictionary *info){
                    UIView *sender = info[@"sender"];
                    CGRect rect = [self.view convertRect:sender.frame fromView:sender.superview];
                    rect.origin.y += self.view.top;
                    
                    Shop *shop = info[@"shop"];
                    ShopViewController *shopViewController =[[ShopViewController alloc] initWithShop:shop];
                    shopViewController.presentedRect = rect;
                    
                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:shopViewController];
                    nav.transitioningDelegate = shopViewController;
                    nav.modalPresentationStyle = UIModalPresentationCustom;
                    [self presentViewController:nav animated:YES completion:nil];
                };
            }
            
            if ([self.otherActivities count] > 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self updateActivities:self.otherActivities];
                });
            }
        }
    }];
}

- (void)updateActivities:(NSArray *)activities
{
    NSMutableArray *mutableItems = [NSMutableArray array];
    
    [mutableItems addObject:@[self.activityDetailItem, self.shopPreviewItem, self.shopMapItem]];
    [mutableItems addObject:activities];
    [self _setItems:mutableItems];
    [self.tableView beginUpdates];
    [self.tableView insertSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView endUpdates];
    
    [self.tableView.header endRefreshing];
}

- (void)updateCardViewWithImage:(UIImage *)image desc:(NSString *)desc
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView transitionWithView:self.cardImage.superview duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            self.cardImage.image = image;
            self.imageDescLabel.text = desc;
            self.imageIndexLabel.text = [NSString stringWithFormat:@"%ld / %lu", (long)(self.imageIndex + 1), (unsigned long)self.imageFileIds.count];
        } completion:nil];
    });
}

- (void)convertFilesToImages:(NSArray *)imageIds
{
    for (NSString *imageId in imageIds) {
        [AVFile getFileWithObjectId:imageId withBlock:^(AVFile *file, NSError *error) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                NSString *imageDesc = [file.metaData valueForKey:@"desc"];
                if (imageDesc.length == 0) {
                    imageDesc = @"让我们更美的去生活。";
                }
                
                NSData *imageData = [file getData:nil];
                UIImage *image = [UIImage imageWithData:imageData];
                
                if (image) {
                    NSDictionary *imageDict = @{@"image" : image, @"desc" : imageDesc};
                    self.imagesDict[file.objectId] = imageDict;
                    if ([self.imagesDict count] == [self.imageFileIds count]) {
                        NSDictionary *dict = self.imagesDict[self.imageFileIds[0]];
                        UIImage *image = dict[@"image"];
                        NSString *desc = dict[@"desc"];
                        [self updateCardViewWithImage:image desc:desc];
                    }
                }
            });
        }];
    }
}

- (void)pressedAcceptButton:(UIButton *)button
{
    if (![LYUser currentUser]) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *loginViewController = [sb instantiateViewControllerWithIdentifier:@"LoginViewController"];
        
        UINavigationController *loginViewNavigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
        [self presentViewController:loginViewNavigationController animated:YES completion:nil];
        return;
    } else {
        ActivityAcceptViewController *vc = [[ActivityAcceptViewController alloc] init];
        vc.activity = self.activities;
        CGRect frame = CGRectMake(button.centerX - 50, button.top, 100, button.centerX + 50);
        CGRect rect = [self.view convertRect:frame fromView:self.bottomView];
        rect.origin.y += self.view.top;
        vc.presentedRect = rect;
        vc.transitioningDelegate = vc;
        vc.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:vc animated:YES completion:nil];
        
        vc.completion = ^(BOOL confirmed) {
            if (confirmed) {
                MBProgressHUD *hud = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, 0, 200, 150)];
                hud.mode = MBProgressHUDModeText;
                hud.removeFromSuperViewOnHide = YES;
                hud.detailsLabelText = @"报名成功，可以在我的足迹里查看";
                [self.view addSubview:hud];
                [hud show:YES];
                [hud hide:YES afterDelay:3];
                [self checkAcceptance];
            }
        };
    }
}

- (void)didAccept
{
    [self.acceptButton setTitle:@"已报名" forState:UIControlStateNormal];
    self.acceptButton.enabled = NO;
}

#pragma mark -
#pragma mark tableview datasource

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        UIView *view = [[UIView alloc] init];
        view.width = self.view.width;
        view.height = [self tableView:self.tableView heightForHeaderInSection:section];
        view.backgroundColor = self.tableView.backgroundColor;
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"其他活动";
        label.font = SystemFontWithSize(16);
        label.textColor = RGBCOLOR_HEX(0x969696);
        [view addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view);
            make.left.equalTo(view).offset(12);
        }];
        
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 1 ? 40 : 0;
}

#pragma mark -
#pragma mark setters and getters

- (AFSoundPlayback *)playBack
{
    if (!_playBack) {
        _playBack = [[AFSoundPlayback alloc] initWithItem:self.soundItem];
        [_playBack pause];
    }
    return _playBack;
}

- (AFSoundItem *)soundItem
{
    if (!_soundItem) {
        AVFile *audioFile = self.activities.activityDescVoice;
        _soundItem = [[AFSoundItem alloc] initWithStreamingURL:[NSURL URLWithString:audioFile.url]];
    }
    return _soundItem;
}

- (UIView *)cardView
{
    UIView *viewContainer = [[UIView alloc] init];
    viewContainer.layer.cornerRadius = 5;
    viewContainer.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.2].CGColor;
    viewContainer.layer.borderWidth = 0.5;
    viewContainer.backgroundColor = [UIColor whiteColor];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToPreview)];
    tap.numberOfTapsRequired = 1;
    
    [viewContainer addGestureRecognizer:swipeLeft];
    [viewContainer addGestureRecognizer:swipeRight];
    [viewContainer addGestureRecognizer:tap];
    
    UIImageView *cardImageView = [[UIImageView alloc] init];
    cardImageView.clipsToBounds = YES;
    cardImageView.contentMode = UIViewContentModeScaleAspectFill;
    [viewContainer addSubview:cardImageView];
    
    self.cardImage = cardImageView;
    
    [cardImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.equalTo(viewContainer);
        make.height.equalTo(cardImageView.mas_width).multipliedBy(3.0f / 4.0f);
    }];
    
    self.imageIndexLabel = [[UILabel alloc] init];
    self.imageIndexLabel.font = SystemFontWithSize(17);
    self.imageIndexLabel.textColor = [UIColor whiteColor];
    self.imageIndexLabel.shadowColor = [UIColor blackColor];
    self.imageIndexLabel.shadowOffset = CGSizeMake(0, 1);
    [self.cardImage addSubview:self.imageIndexLabel];
    
    [self.imageIndexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(cardImageView);
        make.bottom.equalTo(cardImageView).offset(-12);
    }];
    
    UIView *labelView = [[UIView alloc] init];
    [viewContainer addSubview:labelView];
    
    [labelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cardImageView.mas_bottom);
        make.left.and.right.and.bottom.equalTo(viewContainer);
        make.height.equalTo(@60);
    }];
    
    UILabel *imageDescription = [[UILabel alloc] init];
    imageDescription.lineBreakMode = NSLineBreakByWordWrapping;
    imageDescription.numberOfLines = 0;
    imageDescription.font = SystemFontWithSize(14);
    imageDescription.textColor = RGBCOLOR_HEX(0x646464);
    [labelView addSubview:imageDescription];
    
    self.imageDescLabel = imageDescription;
    
    [imageDescription mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(labelView);
        make.left.equalTo(labelView).offset(10);
        make.right.equalTo(labelView).offset(-10);
    }];
    
    return viewContainer;
}

- (NSArray *)imageFileIds
{
    if (!_imageFileIds) {
        _imageFileIds = self.activities.pics;
    }
    return _imageFileIds;
}

- (UIView *)tableHeaderView
{
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = RGBCOLOR_HEX(0xf7f7f7);
    
    UIView *titleView = [self titleView];
    [containerView addSubview:titleView];
    
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.equalTo(containerView);
    }];
    
    UIView *cardView = [self cardView];
    [containerView addSubview:cardView];
    
    [cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleView.mas_bottom);
        make.width.equalTo(@(SCREEN_WIDTH - 10 * 2));
        make.centerX.equalTo(containerView);
    }];
    
    if (self.activities.activityDescVoice) {
        UIView *voiceView = [self voiceView];
        [containerView addSubview:voiceView];
        
        [voiceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(cardView);
            make.top.equalTo(cardView.mas_bottom).offset(10);
            make.height.mas_equalTo(80);
            make.bottom.equalTo(containerView).offset(-10);
        }];
    } else {
        [cardView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(containerView).offset(-10);
        }];
    }
    
    return containerView;
}

- (UIProgressView *)audioProgress
{
    if (!_audioProgress) {
        _audioProgress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _audioProgress.trackTintColor = [UIColor clearColor];
        _audioProgress.progressTintColor = DefaultYellowColor;
    }
    return _audioProgress;
}

- (RACSignal *)timerSignal
{
    if (!_timerSignal) {
        _timerSignal = [RACSignal interval:0.01f onScheduler:[RACScheduler schedulerWithPriority:RACSchedulerPriorityBackground name:@"audioProgressTimer"]];
    }
    return _timerSignal;
}

- (UIView *)voiceView
{
    UIButton *viewContainer = [UIButton buttonWithType:UIButtonTypeSystem];
    viewContainer.clipsToBounds = YES;
    viewContainer.layer.cornerRadius = 5;
    viewContainer.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.2].CGColor;
    viewContainer.layer.borderWidth = 0.5;
    viewContainer.backgroundColor = [UIColor whiteColor];
    
    UIImageView *voiceImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"voice3"]];
    voiceImage.animationImages = @[[UIImage imageNamed:@"voice1"], [UIImage imageNamed:@"voice2"], [UIImage imageNamed:@"voice3"]];
    voiceImage.animationDuration = 1;
    [viewContainer addSubview:voiceImage];
    
    [voiceImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(viewContainer);
        make.left.equalTo(viewContainer).offset(50);
    }];
    
    [[viewContainer rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        switch (self.playBack.status) {
            case AFSoundStatusPlaying:
                [self.playBack pause];
                [self.timerDisposeable dispose];
                self.audioProgress.progress = 0;
                self.audioProgress.hidden = YES;
                [voiceImage stopAnimating];
                return;
                break;
            case AFSoundStatusNotStarted:
                [self.playBack play];
                self.audioProgress.hidden = NO;
                [voiceImage startAnimating];
                break;
            case AFSoundStatusFinished:
                [self.playBack restart];
                self.audioProgress.hidden = NO;
                [voiceImage startAnimating];
                break;
            case AFSoundStatusPaused:
                [self.playBack play];
                [self.playBack restart];
                self.audioProgress.hidden = NO;
                [voiceImage startAnimating];
                break;
            default:
                break;
        }
        
        [self.timerDisposeable dispose];
        NSDate *current = [NSDate date];
        self.audioProgress.progress = 0;
        
        @weakify(self);
        self.timerDisposeable = [self.timerSignal subscribeNext:^(NSDate *date) {
            @strongify(self);
            NSTimeInterval timeElapsed = [date timeIntervalSinceDate:current];
            float progress = (double)timeElapsed / (double)self.playBack.currentItem.duration;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.audioProgress setProgress:progress animated:YES];
            });
        }];
        
        [self.playBack listenFeedbackUpdatesWithBlock:nil andFinishedBlock:^{
            @strongify(self);
            [self.timerDisposeable dispose];
        }];
        
    }];
    
    [RACObserve(viewContainer, highlighted) subscribeNext:^(NSNumber *highlighted) {
        [UIView transitionWithView:viewContainer duration:.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            if (highlighted.boolValue) {
                viewContainer.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.5];
            } else {
                viewContainer.backgroundColor = [UIColor whiteColor];
            }
        } completion:nil];
    }];
    
    UILabel *titleLable = [[UILabel alloc] init];
    titleLable.font = SystemFontWithSize(15);
    titleLable.text = @"店家自白";
    [viewContainer addSubview:titleLable];
    
    [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(voiceImage.mas_right).offset(10);
        make.bottom.equalTo(viewContainer.mas_centerY).offset(-2);
    }];
    
    self.durationLabel = [[UILabel alloc] init];
    self.durationLabel.font = SystemFontWithSize(16);
    self.durationLabel.textColor = RGBCOLOR_HEX(0x646464);;
    [viewContainer addSubview:self.durationLabel];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [viewContainer addSubview:indicator];
    
    [[RACObserve(self.durationLabel, text) map:^id(NSString *value) {
        return @(value.length > 0);
    }] subscribeNext:^(NSNumber *value) {
        if ([value boolValue]) {
            [indicator stopAnimating];
        }
    }];
    
    [indicator startAnimating];
    [indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.durationLabel);
    }];
    
    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.font = SystemFontWithSize(13);
    descLabel.textColor = self.durationLabel.textColor;
    descLabel.text = [NSString stringWithFormat:@"来自 %@", self.activities.shop.shopname];
    [viewContainer addSubview:descLabel];
    
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLable);
        make.top.equalTo(viewContainer.mas_centerY).offset(2);
        make.right.lessThanOrEqualTo(self.durationLabel.mas_left).offset(10);
    }];
    
    viewContainer.userInteractionEnabled = NO;
    [AVFile getFileWithObjectId:self.activities.activityDescVoice.objectId withBlock:^(AVFile *file, NSError *error) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            self.activities.activityDescVoice = file;
            self.duration = self.playBack.currentItem.duration;
        });
    }];
    
    RAC(viewContainer, userInteractionEnabled) = [RACObserve(self, duration) map:^id(NSNumber *value) {
        return @([value integerValue] > 0);
    }];
    
    [self.durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(viewContainer);
        make.right.equalTo(viewContainer).offset(-40);
    }];
    
    [viewContainer addSubview:self.audioProgress];
    
    [self.audioProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(viewContainer);
    }];
    
    return viewContainer;
}

- (UIView *)titleView
{
    UIView *titleView = [[UIView alloc] init];
    titleView.backgroundColor = [UIColor clearColor];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = SystemBoldFontWithSize(20);
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = self.activities.title;
    [titleView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleView).offset(20);
        make.left.equalTo(titleView).offset(10);
        make.right.equalTo(titleView).offset(-10);
    }];
    
    UILabel *fromLabel = [[UILabel alloc] init];
    fromLabel.font = SystemFontWithSize(15);
    fromLabel.textColor = DefaultTitleColor;
    fromLabel.text = @"来自:";
    [titleView addSubview:fromLabel];
    
    [fromLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
        make.bottom.equalTo(titleView).offset(-20);
    }];
    
//    [titleView addSubview:self.shopIcon];
    
//    [self.shopIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.equalTo(@30);
//        make.centerY.equalTo(fromLabel);
//        make.left.equalTo(fromLabel.mas_right).offset(5);
//    }];
    
    UIButton *shopName = [UIButton buttonWithType:UIButtonTypeSystem];
    shopName.titleLabel.font = SystemFontWithSize(15);
    shopName.tintColor = DefaultYellowColor;
    [shopName setTitle:self.activities.shop.shopname forState:UIControlStateNormal];
    [shopName addTarget:self action:@selector(animateToShopView) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:shopName];
    
    [shopName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(fromLabel);
        make.left.equalTo(fromLabel.mas_right).offset(5);
    }];
    
    
//    UILabel *distanceLabel = [[UILabel alloc] init];
//    distanceLabel.font = SystemFontWithSize(12);
//    distanceLabel.textColor = [UIColor blackColor];
//    [titleView addSubview:distanceLabel];
//    
//    AVGeoPoint *geo = self.activities.shop.geolocation;
//    CLLocation *location = [[CLLocation alloc] initWithLatitude:geo.latitude longitude:geo.longitude];
//    [[LYLocationManager sharedManager] getCurrentLocation:^(BOOL success, CLLocation *currentLocation) {
//        if (success) {
//            CLLocationDistance distance = [currentLocation distanceFromLocation:location];
//            double distanceInKM = distance / 1000.0;
//            distanceLabel.text = [NSString stringWithFormat:@"%.1fkm", distanceInKM];
//        }
//    }];
//    
//    [distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(shopName);
//        make.right.equalTo(titleView).offset(-10);
//    }];
//    
//    UIImageView *locationView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Location"]];
//    [titleView addSubview:locationView];
//    
//    [locationView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(distanceLabel);
//        make.right.equalTo(distanceLabel.mas_left).offset(-4);
//    }];
    
    return titleView;
}

- (NSMutableDictionary *)imagesDict
{
    if (!_imagesDict) {
        _imagesDict = [NSMutableDictionary dictionary];
    }
    return _imagesDict;
}

- (void)setImageIndex:(NSInteger)imageIndex
{
    if (imageIndex < 0) {
        imageIndex = self.imageFileIds.count - 1;
    } else if (imageIndex >= self.imageFileIds.count) {
        imageIndex = 0;
    }
    _imageIndex = imageIndex;
    if (imageIndex < self.imageFileIds.count) {
        NSDictionary *dict = self.imagesDict[self.imageFileIds[imageIndex]];
        UIImage *image = dict[@"image"];
        NSString *desc = dict[@"desc"];
        [self updateCardViewWithImage:image desc:desc];
    }
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.clipsToBounds = YES;
        _bottomView.backgroundColor = DefaultYellowColor;
    }
    return _bottomView;
}

- (UIButton *)acceptButton
{
    if (!_acceptButton) {
        _acceptButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_acceptButton addTarget:self action:@selector(pressedAcceptButton:) forControlEvents:UIControlEventTouchUpInside];
        [_acceptButton setTitle:@"要去" forState:UIControlStateNormal];
        _acceptButton.titleLabel.font = SystemFontWithSize(16);
        _acceptButton.tintColor = [UIColor whiteColor];
        _acceptButton.backgroundColor = DefaultYellowColor;
        
//        _acceptButton.layer.borderColor = [UIColor colorWithWhite:1 alpha:.7].CGColor;
//        _acceptButton.layer.borderWidth = 1;
//        _acceptButton.layer.cornerRadius = 2;
    }
    return _acceptButton;
}

- (UIImageView *)shopIcon
{
    if (!_shopIcon) {
        _shopIcon = [[UIImageView alloc] init];
        _shopIcon.contentMode = UIViewContentModeScaleAspectFill;
        _shopIcon.clipsToBounds = YES;
        _shopIcon.userInteractionEnabled = YES;
        _shopIcon.layer.cornerRadius = 20;
        _shopIcon.layer.borderWidth = 0;
        _shopIcon.layer.borderColor = RGBCOLOR(238, 238, 238).CGColor;
        _shopIcon.image = [UIImage imageNamed:@"DefaultAvatar"];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(animateToShopView)];
        [_shopIcon addGestureRecognizer:tap];
    }
    return _shopIcon;
}

- (void)animateToShopView
{
    [self gotoShop:YES];
}

- (void)gotoShop:(BOOL)animated
{
    CGRect rect = [self.view convertRect:self.shopIcon.frame fromView:self.shopIcon.superview];
    rect.origin.y += self.view.top;
    
    ShopViewController *shopViewController =[[ShopViewController alloc] initWithShop:self.activities.shop];
    shopViewController.presentedRect = rect;
    
    if (animated) {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:shopViewController];
        nav.transitioningDelegate = shopViewController;
        nav.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:nav animated:YES completion:nil];
    } else {
        [self.navigationController pushViewController:shopViewController animated:YES];
    }
}

#pragma mark -
#pragma mark gesture

- (void)swipeLeft
{
    self.imageIndex++;
}

- (void)swipeRight
{
    self.imageIndex--;
}

- (void)tapToPreview
{
    if ([self.imagesDict count] < [self.imageFileIds count]) {
        return;//图片还没获取完成
    }
    ImagePreviewViewController *previewVC = [[ImagePreviewViewController alloc] init];
    previewVC.transitioningDelegate = previewVC;
    previewVC.modalPresentationStyle = UIModalPresentationCustom;
    
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:0];
    for (NSString *key in self.imageFileIds) {
        NSDictionary *dict = self.imagesDict[key];
        UIImage *image = dict[@"image"];
        [images addObject:image];
    }
    previewVC.images = images;
    previewVC.currentIndex = self.imageIndex;
    
    [self presentViewController:previewVC animated:YES completion:nil];
}

static const NSString *baseURL = @"http://www.iangus.cn/leyu-wap/activity/detail/";

- (void)share
{
    [AVFile getFileWithObjectId:self.activities.pics[0] withBlock:^(AVFile *file, NSError *error) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        
        NSString *url = [NSString stringWithFormat:@"%@%@", baseURL, self.activities.objectId];
        
        [shareParams SSDKSetupShareParamsByText:self.activities.title
                                         images:file.url
                                            url:[NSURL URLWithString:url]
                                          title:self.activities.title
                                           type:SSDKContentTypeAuto];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        SSUIShareActionSheetController *sheet = [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                                                         items:nil
                                                                   shareParams:shareParams
                                                           onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                                                               
                                                               switch (state) {
                                                                   case SSDKResponseStateSuccess:
                                                                   {
                                                                       UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                                                           message:nil
                                                                                                                          delegate:nil
                                                                                                                 cancelButtonTitle:@"确定"
                                                                                                                 otherButtonTitles:nil];
                                                                       [alertView show];
                                                                       break;
                                                                   }
                                                                   case SSDKResponseStateFail:
                                                                   {
                                                                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                                                                       message:[NSString stringWithFormat:@"%@",error]
                                                                                                                      delegate:nil
                                                                                                             cancelButtonTitle:@"OK"
                                                                                                             otherButtonTitles:nil, nil];
                                                                       [alert show];
                                                                       break;
                                                                   }
                                                                   default:
                                                                       break;
                                                               }
                                                               
                                                           }];
        [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeSinaWeibo)];
    }];
}

@end
