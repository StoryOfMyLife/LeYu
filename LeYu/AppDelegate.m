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


#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"


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
    [self setupShareSDK];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    tabBarController = [[UITabBarController alloc] init];
    UINavigationController *homeNavigationController = [[UINavigationController alloc] initWithRootViewController:[[HomeViewController alloc] init]];
    
    homeNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"精选" image:[ImageFactory homeTabBarIcon] selectedImage:[ImageFactory homeTabBarIconSelected]];
    
    UINavigationController *userProfileNavigationController = [[UINavigationController alloc] initWithRootViewController:[[UserContainerViewController alloc] init]];
    
    userProfileNavigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:[ImageFactory userProfilesTabBarIcon] selectedImage:[ImageFactory userProfilesTabBarIconSelected]];
    
    UINavigationController *activitiesViewController = [[UINavigationController alloc] initWithRootViewController:[[ActivityViewController alloc] init]];
    
    activitiesViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"发现" image:[ImageFactory activityTabBarIcon] selectedImage:[ImageFactory activityTabBarIconSelected]];
    
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

- (void)setupShareSDK
{
//     [ShareSDK registerApp:@"bd9aea5c6e18"];//字符串api20为您的ShareSDK的AppKey
//
//     //添加新浪微博应用 注册网址 http://open.weibo.com
//     [ShareSDK connectSinaWeiboWithAppKey:@"568898243"
//                                appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
//                              redirectUri:@"http://www.sharesdk.cn"];
//     //当使用新浪微博客户端分享的时候需要按照下面的方法来初始化新浪的平台
//     [ShareSDK  connectSinaWeiboWithAppKey:@"568898243"
//                                 appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
//                               redirectUri:@"http://www.sharesdk.cn"
//                               weiboSDKCls:[WeiboSDK class]];
//    
//    //微信登陆的时候需要初始化
//    [ShareSDK connectWeChatWithAppId:@"wx4868b35061f87885"
//                           appSecret:@"64020361b8ec4c99936c0e3999a9f249"
//                           wechatCls:[WXApi class]];
    
    [ShareSDK registerApp:@"bd9aea5c6e18"
     
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"568898243"
                                           appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                                         redirectUri:@"http://www.sharesdk.cn"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wxe1c771211c369252"
                                       appSecret:@"d4624c36b6795d1d99dcf0547af5443d"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"100371282"
                                      appKey:@"aed9b0303e3ed1e27bae87c33761161d"
                                    authType:SSDKAuthTypeBoth];
                 break;
             
             default:
                 break;
         }
     }];
}

@end
