//
//  ActivityWebviewController.m
//  LeYu
//
//  Created by 刘廷勇 on 15/10/27.
//  Copyright © 2015年 liuty. All rights reserved.
//

static const NSString *baseURL = @"http://www.iangus.cn/leyu-wap/activity/detail/";

#import "ActivityWebviewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "ShopViewController.h"

@interface ActivityWebviewController () <UIWebViewDelegate>
{
    BOOL loadFinished;
}

@property (nonatomic, strong) UIWebView *webview;

@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@property (nonatomic, strong) NSURL *url;

@property (nonatomic, strong) UIImageView *shopIcon;

@end

@implementation ActivityWebviewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeSystem];
    shareButton.tintColor = [UIColor whiteColor];
    [shareButton setImage:[UIImage imageNamed:@"分享"] forState:UIControlStateNormal];
    shareButton.size = CGSizeMake(25, 25);
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    [shareButton addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = shareItem;
    [self setTitleView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)setUrlID:(NSString *)urlID
{
    if (_urlID != urlID) {
        _urlID = urlID;
        NSString *urlString = [NSString stringWithFormat:@"%@%@?from=app", baseURL, urlID];
        self.url = [NSURL URLWithString:urlString];
    }
}

- (void)setUrlString:(NSString *)urlString
{
    if (_urlString != urlString) {
        _urlString = urlString;
        self.url = [NSURL URLWithString:urlString];
    }
}

- (void)setUrl:(NSURL *)url
{
    if (_url != url) {
        _url = url;
        [self.webview loadRequest:[NSURLRequest requestWithURL:_url]];
    }
}

- (UIActivityIndicatorView *)indicator
{
    if (!_indicator) {
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return _indicator;
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

- (UIWebView *)webview
{
    if (!_webview) {
        _webview = [[UIWebView alloc] init];
        _webview.scalesPageToFit = YES;
        _webview.delegate = self;
        _webview.backgroundColor = [UIColor whiteColor];//DefaultBackgroundColor;
        
        [self.view addSubview:_webview];
        [self.view addSubview:self.indicator];
        [_webview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        [self.indicator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
        }];
        [self.indicator startAnimating];
    }
    return _webview;
}

- (void)setTitleView
{
    if (!self.activity.shop) {
        return;
    }
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
    [self.activity.shop loadShopIcon:^(UIImage *image, NSError *error) {
        [UIView transitionWithView:weakSelf.shopIcon duration:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            weakSelf.shopIcon.image = image;
        } completion:nil];
    }];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    loadFinished = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.indicator stopAnimating];
    loadFinished = YES;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlString = request.URL.absoluteString;
    if ([urlString containsString:@"shop/jump"]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (loadFinished) {
                [self animateToShopView];
            }
        });
        return NO;
    }
    return YES;
}

- (void)animateToShopView
{
    [self gotoShop:YES];
}

- (void)gotoShop:(BOOL)animated
{
    CGRect rect = [self.view convertRect:self.shopIcon.frame fromView:self.shopIcon.superview];
    rect.origin.y += self.view.top;
    
    ShopViewController *shopViewController =[[ShopViewController alloc] initWithShop:self.activity.shop];
    shopViewController.presentedRect = rect;
    
    if (animated) {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:shopViewController];
        nav.transitioningDelegate = shopViewController;
        nav.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:nav animated:YES completion:^{
        }];
    } else {
        [self.navigationController pushViewController:shopViewController animated:YES];
    }
}

- (void)share
{
    [AVFile getFileWithObjectId:self.activity.pics[0] withBlock:^(AVFile *file, NSError *error) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        
        NSString *url = [NSString stringWithFormat:@"%@%@", baseURL, self.urlID];
        
        NSString *desc = self.activity.activitiesDescription;
        if (desc.length > 140) {
            desc = [desc substringToIndex:135];
            desc = [desc stringByAppendingString:@"..."];
        }
        
        [shareParams SSDKSetupShareParamsByText:desc
                                         images:file.url
                                            url:[NSURL URLWithString:url]
                                          title:self.activity.title
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
