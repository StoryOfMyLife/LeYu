//
//  UserProfileLoginView.h
//  LifeO2O
//
//  Created by jiecongwang on 7/4/15.
//  Copyright (c) 2015 Arsenal. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserProfileLoginDelegate <NSObject>

- (void)navigateToLoginPage;

@end

@interface UserProfileLoginView : UIView

@property (nonatomic, weak) id<UserProfileLoginDelegate> delegate;

@end
