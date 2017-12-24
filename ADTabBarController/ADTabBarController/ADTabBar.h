//
//  ADTabBar.h
//  ADTabBarController
//
//  Created by Andy on 2017/12/24.
//  Copyright © 2017年 naibin.liu. All rights reserved.
//
//  Source file link https://github.com/binjiayou66/ADTabBarController.git
//  Reference link https://github.com/robbdimitrov/RDVTabBarController
//

#import <UIKit/UIKit.h>

@class ADTabBar, ADTabBarItem;

@protocol ADTabBarDelegate <NSObject>

/// 是否可选中参数下标项
- (BOOL)ad_tabBar:(ADTabBar *)tabBar shouldSelectItemAtIndex:(NSInteger)index;

/// 已经选中参数下标项
- (void)ad_tabBar:(ADTabBar *)tabBar didSelectItemAtIndex:(NSInteger)index;

@end

@interface ADTabBar : UIView

/// ADTabBarDelegate代理对象
@property (nonatomic, weak) id <ADTabBarDelegate> delegate;

/// TabBarItems数组
@property (nonatomic, copy) NSArray<ADTabBarItem *> *items;

/// 当前选中的TabBarItem
@property (nonatomic, weak) ADTabBarItem *selectedItem;

/// 背景视图
@property (nonatomic, readonly) UIView *backgroundView;

/// 内边距
@property UIEdgeInsets contentEdgeInsets;

/// TabBar高度
- (void)setHeight:(CGFloat)height;

/// TabBarItem最低高度
- (CGFloat)minimumContentHeight;

/// 设置TabBar是否可以半透明
@property (nonatomic, getter=isTranslucent) BOOL translucent;

@end
