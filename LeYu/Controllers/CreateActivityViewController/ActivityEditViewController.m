//
//  ActivityEditViewController.m
//  LeYu
//
//  Created by 刘廷勇 on 15/10/20.
//  Copyright © 2015年 liuty. All rights reserved.
//

#import "ActivityEditViewController.h"
#import "ImageAssetsManager.h"

@interface ActivityEditViewController ()

@property (weak, nonatomic) IBOutlet UITextField *placeholder;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ActivityEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self setupNavigationItems];
    
    @weakify(self);
    [[self.textView.rac_textSignal map:^id(NSString *text) {
        return @(text.length > 0);
    }] subscribeNext:^(NSNumber *hasText) {
        @strongify(self);
        self.placeholder.hidden = [hasText boolValue];
    }];
}

- (void)setupNavigationItems
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"完成" forState:UIControlStateNormal];
    [button sizeToFit];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.completion) {
        NSString *text = self.textView.text;
        if (text.length > 0) {
            if (self.completion) {
                if ([[ImageAssetsManager manager].activityDesc isEqualToString:text]) {
                    self.completion(YES, text);
                } else {
                    self.completion(NO, text);
                }
            }
        } else {
            if (self.completion) {
                self.completion(NO, text);
            }
        }
    }
}

- (void)done:(id)sender
{
    if ([self.textView.text length] > 0) {
        [ImageAssetsManager manager].activityDesc = self.textView.text;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
