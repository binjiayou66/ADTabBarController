//
//  AppDelegate.m
//  ADTabBarController
//
//  Created by 123 on 2017/12/24.
//  Copyright © 2017年 naibin.liu. All rights reserved.
//

#import "AppDelegate.h"
#import "ADTabBarController.h"
#import "ViewControllerA.h"
#import "ViewControllerB.h"
#import "ViewControllerC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _window.backgroundColor = [UIColor whiteColor];
    [_window makeKeyAndVisible];
    
    ADTabBarController *tab = [[ADTabBarController alloc] init];
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    NSArray *arr = @[@"ViewControllerA", @"ViewControllerB", @"ViewControllerC"];
    NSArray *titleArr = @[@"首页", @"病人", @"我的"];
    NSArray *iconArr = @[@"tab_clinic", @"tab_patient", @"tab_me"];
    for (int i = 0; i < arr.count; i++) {
        Class cls = NSClassFromString(arr[i]);
        UIViewController *vc = [cls new];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [viewControllers addObject:nav];
    }
    tab.viewControllers = viewControllers;
    for (int i = 0; i < tab.viewControllers.count; i++) {
        ADTabBarItem *item = [[ADTabBarItem alloc] init];
        item.title = titleArr[i];
        item.unselectedImage = [UIImage imageNamed:iconArr[i]];
        item.selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected", iconArr[i]]];
        UIViewController *vc = tab.viewControllers[i];
        vc.ad_tabBarItem = item;
    }
    
    _window.rootViewController = tab;
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
