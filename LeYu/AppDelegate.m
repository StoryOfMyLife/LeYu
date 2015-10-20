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
#import <MobClick.h>

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@interface AppDelegate ()
{
    UITabBarController *tabBarController;
}

@end

@implementation AppDelegate

- (void)setUMeng
{
    [MobClick startWithAppkey:@"5602aa9167e58e48c9000573" reportPolicy:BATCH channelId:nil];
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
}

- (void)setCrashlytics
{
    [Fabric with:@[[Crashlytics class]]];
}

- (void)setLeanCloud
{
    [AVOSCloud setApplicationId:@"w0uv3n92wrpmlhquonz9uyk6u7l8b3mplr5bv8f431bll4dx" clientKey:@"sx2r8o6eduw84oj0e9yf690p56xoqycfv63s9zywo9rbpgfp"];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setCrashlytics];
    [self setUMeng];
    [self setLeanCloud];
    [self registerAVOSClasses];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    tabBarController = [[UITabBarController alloc] init];
    UINavigationController *homeNavigationController = [[UINavigationController alloc] initWithRootViewController:[[HomeViewController alloc] init]];
    
    homeNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"主页" image:[ImageFactory homeTabBarIcon] selectedImage:[ImageFactory homeTabBarIconSelected]];
    
    UINavigationController *userProfileNavigationController = [[UINavigationController alloc] initWithRootViewController:[[UserContainerViewController alloc] init]];
    
    userProfileNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"个人" image:[ImageFactory userProfilesTabBarIcon] selectedImage:[ImageFactory userProfilesTabBarIconSelected]];
    
    UINavigationController *activitiesViewController = [[UINavigationController alloc] initWithRootViewController:[[ActivityViewController alloc] init]];
    
    activitiesViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"活动" image:[ImageFactory activityTabBarIcon] selectedImage:[ImageFactory activityTabBarIconSelected]];
    
    NewNotificationsViewController *newsVC = [[NewNotificationsViewController alloc] init];
    [newsVC view];
    UINavigationController *notificationViewController = [[UINavigationController alloc] initWithRootViewController:
                                                          newsVC];
    
    notificationViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"消息" image:[ImageFactory messageTabbarIcon] selectedImage:[ImageFactory messageTabbarIconSelected]];
    
    NSArray *tabbars = [NSArray arrayWithObjects:homeNavigationController,activitiesViewController,notificationViewController,userProfileNavigationController, nil];
    
    [tabBarController setViewControllers:tabbars];
    
    self.window.rootViewController = tabBarController;
    self.window.backgroundColor = [UIColor whiteColor];
    [DesignManager applyDesign];
    [self.window makeKeyAndVisible];
    
    [self registerNotification:application];
    
    [self customUI];
    
    [self checkAddButton];
    
    return YES;
}

- (void)checkAddButton
{
    LYUser *currentUser = [LYUser currentUser];
    if (currentUser) {
        if (currentUser.shop) {
            AVQuery *query = [Shop query];
            [query whereKey:@"objectId" equalTo:currentUser.shop.objectId];
            Shop *shop = (Shop *)[query getFirstObject];
            currentUser.shop = shop;
        } else {
            currentUser.level = UserLevelNormal;
        }
        [currentUser saveInBackground];
    }
    
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
    
    [[UIView appearance] setTintColor:DefaultYellowColor];
}

- (void)registerAVOSClasses
{
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
