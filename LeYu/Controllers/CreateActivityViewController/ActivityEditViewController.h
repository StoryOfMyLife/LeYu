//
//  ActivityEditViewController.h
//  LeYu
//
//  Created by 刘廷勇 on 15/10/20.
//  Copyright © 2015年 liuty. All rights reserved.
//

#import "LViewController.h"

typedef void(^Completion)(BOOL saved, NSString *text);

@interface ActivityEditViewController : LViewController

@property (nonatomic, strong) Completion completion;

@end
