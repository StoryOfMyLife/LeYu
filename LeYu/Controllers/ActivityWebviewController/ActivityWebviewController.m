//
//  ActivityWebviewController.m
//  LeYu
//
//  Created by 刘廷勇 on 15/10/27.
//  Copyright © 2015年 liuty. All rights reserved.
//

static const NSString *baseURL = @"http://www.iangus.cn/leyu-wap/activity/detail/";

#import "ActivityWebviewController.h"

@interface ActivityWebviewController ()

@property (nonatomic, strong) UIWebView *webview;

@end

@implementation ActivityWebviewController

- (void)setUrlID:(NSString *)urlID
{
    if (_urlID != urlID) {
        _urlID = urlID;
        NSString *urlString = [NSString stringWithFormat:@"%@%@", baseURL, urlID];
        [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    }
}

- (UIWebView *)webview
{
    if (!_webview) {
        _webview = [[UIWebView alloc] init];
        _webview.scalesPageToFit = YES;
        [self.view addSubview:_webview];
        [_webview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _webview;
}

@end
