//
//  ADTabBarController.h
//  ADTabBarController
//
//  Created by Andy on 2017/12/24.
//  Copyright © 2017年 naibin.liu. All rights reserved.
//
//  Source file link https://github.com/binjiayou66/ADTabBarController.git
//  Reference link https://github.com/robbdimitrov/RDVTabBarController
//

#import <UIKit/UIKit.h>
#import "ADTabBar.h"
#import "ADTabBarItem.h"

@protocol ADTabBarControllerDelegate;

@interface ADTabBarController : UIViewController

/// ADTabBarControllerDelegate代理对象
@property (nonatomic, weak) id<ADTabBarControllerDelegate> delegate;

@property (nonatomic, strong) NSString * kkk;
/// 子视图控制器数组
@property (nonatomic, copy) NSArray<__kindof UIViewController *> *viewControllers;

/// ADTabBar对象
@property (nonatomic, readonly) ADTabBar *tabBar;

/// 当前选中的视图控制器
@property (nonatomic, weak) UIViewController *selectedViewController;

/// 当前选中的视图控制器下标
@property (nonatomic, assign) NSUInteger selectedIndex;

/// 隐藏TabBar
@property (nonatomic, getter=isTabBarHidden) BOOL tabBarHidden;

/// 隐藏TabBar，可选动画
- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated;

@end

@protocol ADTabBarControllerDelegate <NSObject>
@optional

/// 是否可选中参数视图控制器
- (BOOL)ad_tabBarController:(ADTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController;

/// 已经选中参数视图控制器
- (void)ad_tabBarController:(ADTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;

@end

@interface UIViewController (ADTabBarControllerItem)

/// 视图控制器TabBarItem
@property(nonatomic, setter = ad_setTabBarItem:) ADTabBarItem *ad_tabBarItem;

/// 视图控制器获取TabBarController对象
@property(nonatomic, readonly) ADTabBarController *ad_tabBarController;

@end
