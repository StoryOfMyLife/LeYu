//
//  ActivityWebviewController.m
//  LeYu
//
//  Created by 刘廷勇 on 15/10/27.
//  Copyright © 2015年 liuty. All rights reserved.
//

static const NSString *baseURL = @"http://www.iangus.cn/leyu-wap/activity/detail/";

#import "ActivityWebviewController.h"

@interface ActivityWebviewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webview;

@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@end

@implementation ActivityWebviewController

- (void)viewDidLoad
{
    [super viewDidLoad];
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
        [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
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

@end
