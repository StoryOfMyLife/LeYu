//
//  AppDelegate.m
//  LifeO2O
//
//  Created by jiecongwang on 5/28/15.
//  Copyright (c) 2015 Arsenal. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "UserContainerViewController.h"
#import "ActivityDetailViewController.h"
#import "DesignManager.h"
#import "ImageFactory.h"
#import "ShopActivities.h"
#import "Shop.h"
#import "ShopInfoDescription.h"

#import "ActivityViewController.h"
#import "HFCreateAvtivityViewController.h"
#import "LYUser.h"
#import "ActivityUserRelation.h"
#import "NewNotificationsViewController.h"
#import "UITabBarController+AddButton.h"

@interface AppDelegate ()
{
    UITabBarController *tabBarController;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self registerAVOSClasses];
    
    [AVOSCloud setApplicationId:@"w0uv3n92wrpmlhquonz9uyk6u7l8b3mplr5bv8f431bll4dx" clientKey:@"sx2r8o6eduw84oj0e9yf690p56xoqycfv63s9zywo9rbpgfp"];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    tabBarController = [[UITabBarController alloc] init];
    UINavigationController *homeNavigationController = [[UINavigationController alloc] initWithRootViewController:[[HomeViewController alloc] init]];
    
    homeNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"主页" image:[ImageFactory homeTabBarIcon] selectedImage:[ImageFactory homeTabBarIconSelected]];
    
    UINavigationController *userProfileNavigationController = [[UINavigationController alloc] initWithRootViewController:[[UserContainerViewController alloc] init]];
    
    userProfileNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"个人" image:[ImageFactory userProfilesTabBarIcon] selectedImage:[ImageFactory userProfilesTabBarIconSelected]];
    
    UINavigationController *activitiesViewController = [[UINavigationController alloc] initWithRootViewController:[[ActivityViewController alloc] init]];
    
    activitiesViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"活动" image:[ImageFactory activityTabBarIcon] selectedImage:[ImageFactory activityTabBarIconSelected]];
    
    UINavigationController *notificationViewController = [[UINavigationController alloc] initWithRootViewController:
                                                          [[NewNotificationsViewController alloc] init]];
    
    notificationViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"消息" image:[ImageFactory messageTabbarIcon] selectedImage:[ImageFactory messageTabbarIconSelected]];
    
    NSArray *tabbars = [NSArray arrayWithObjects:homeNavigationController,activitiesViewController,notificationViewController,userProfileNavigationController, nil];
    
    [tabBarController setViewControllers:tabbars];
    
    self.window.rootViewController = tabBarController;
    self.window.backgroundColor = [UIColor whiteColor];
    [DesignManager applyDesign];
    [self.window makeKeyAndVisible];
    [self registerNotification:application];
    
    [self checkAddButton];
    
    return YES;
}

- (void)checkAddButton
{
    LYUser *currentUser = [LYUser currentUser];
    if (currentUser.level == UserLevelShop) {
        [tabBarController showAddButton];
    } else {
        [tabBarController hideAddButton];
    }
}

- (void)registerNotification:(UIApplication *)application {
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert
                                            | UIUserNotificationTypeBadge
                                            | UIUserNotificationTypeSound
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    
    [self customUI];
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    AVInstallation *currentInstallation = [AVInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}


- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {

}

- (void)customUI
{
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor]}
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : DefaultYellowColor}
                                             forState:UIControlStateSelected];
    
    [[UITextField appearance] setTintColor:DefaultYellowColor];
    
    [[UIButton appearance] setTintColor:DefaultYellowColor];
}

- (void)registerAVOSClasses {
    [ShopActivities registerSubclass];
    [Shop registerSubclass];
    
    [ShopInfoDescription registerSubclass];
    [LYUser registerSubclass];
    [ActivityUserRelation registerSubclass];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // to-do
}

@end
