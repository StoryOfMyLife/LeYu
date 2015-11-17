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

@property (nonatomic, strong) UIWebView *webview;

@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@property (nonatomic, strong) NSURL *url;

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
        [self.webview loadRequest:[NSURLRequest requestWithURL:self.url]];
    }
}

- (UIActivityIndicatorView *)indicator
{
    if (!_indicator) {
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return _indicator;
}

- (UIWebView *)webview
{
    if (!_webview) {
        _webview = [[UIWebView alloc] init];
        _webview.scalesPageToFit = YES;
        _webview.delegate = self;
        _webview.backgroundColor = DefaultBackgroundColor;
        
        [self.view addSubview:_webview];
        [self.view addSubview:self.indicator];
        [_webview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        [self.indicator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
        }];
        self.title = @"正在加载...";
        [self.indicator startAnimating];
    }
    return _webview;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.indicator stopAnimating];
    self.title = @"";
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlString = request.URL.absoluteString;
    if ([urlString containsString:@"shop/jump"]) {
        [self jumpToShop];
    }
    return YES;
}

- (void)jumpToShop
{
    ShopViewController *shopVC = [[ShopViewController alloc] initWithShop:self.activity.shop];
    [self.navigationController pushViewController:shopVC animated:YES];
}

- (void)share
{
    [AVFile getFileWithObjectId:self.activity.pics[0] withBlock:^(AVFile *file, NSError *error) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        
        NSString *url = [NSString stringWithFormat:@"%@%@", baseURL, self.urlID];
        
        [shareParams SSDKSetupShareParamsByText:self.activity.activitiesDescription
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
