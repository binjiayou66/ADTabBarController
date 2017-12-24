//
//  ADTabBarController.m
//  ADTabBarController
//
//  Created by Andy on 2017/12/24.
//  Copyright © 2017年 naibin.liu. All rights reserved.
//

#import "ADTabBarController.h"
#import "ADTabBar.h"
#import "ADTabBarItem.h"
#import <objc/runtime.h>

@interface UIViewController (ADTabBarControllerItemInternal)

- (void)ad_setTabBarController:(ADTabBarController *)tabBarController;

@end

@interface ADTabBarController () <ADTabBarDelegate>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) ADTabBar *tabBar;

@end

@implementation ADTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.contentView];
    [self.view addSubview:self.tabBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setSelectedIndex:self.selectedIndex];
    [self setTabBarHidden:self.isTabBarHidden animated:NO];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self setTabBarHidden:self.isTabBarHidden animated:NO];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return self.selectedViewController.preferredStatusBarStyle;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return self.selectedViewController.preferredStatusBarUpdateAnimation;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    UIInterfaceOrientationMask orientationMask = UIInterfaceOrientationMaskAll;
    for (UIViewController *viewController in self.viewControllers) {
        if (![viewController respondsToSelector:@selector(supportedInterfaceOrientations)]) {
            return UIInterfaceOrientationMaskPortrait;
        }
        UIInterfaceOrientationMask supportedOrientations = [viewController supportedInterfaceOrientations];
        if (orientationMask > supportedOrientations) {
            orientationMask = supportedOrientations;
        }
    }
    return orientationMask;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    for (UIViewController *viewCotroller in self.viewControllers) {
        if (![viewCotroller respondsToSelector:@selector(shouldAutorotateToInterfaceOrientation:)] ||
            ![viewCotroller shouldAutorotateToInterfaceOrientation:toInterfaceOrientation]) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - ADTabBarDelegate

- (BOOL)ad_tabBar:(ADTabBar *)tabBar shouldSelectItemAtIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(ad_tabBarController:shouldSelectViewController:)]) {
        if (![self.delegate ad_tabBarController:self shouldSelectViewController:self.viewControllers[index]]) {
            return NO;
        }
    }
    
    if (self.selectedViewController == self.viewControllers[index]) {
        if ([self.selectedViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *selectedController = (UINavigationController *)self.selectedViewController;
            
            if ([selectedController topViewController] != [selectedController viewControllers][0]) {
                [selectedController popToRootViewControllerAnimated:YES];
            }
        }
        return NO;
    }
    
    return YES;
}

- (void)ad_tabBar:(ADTabBar *)tabBar didSelectItemAtIndex:(NSInteger)index {
    if (index < 0 || index >= self.viewControllers.count) {
        return;
    }
    
    [self setSelectedIndex:index];
    
    if ([self.delegate respondsToSelector:@selector(ad_tabBarController:didSelectViewController:)]) {
        [self.delegate ad_tabBarController:self didSelectViewController:self.viewControllers[index]];
    }
}

#pragma mark - getter and setter

- (UIViewController *)selectedViewController
{
    return [self.viewControllers objectAtIndex:self.selectedIndex];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    if (selectedIndex >= self.viewControllers.count) {
        return;
    }
    
    if (self.selectedViewController) {
        [self.selectedViewController willMoveToParentViewController:nil];
        [self.selectedViewController.view removeFromSuperview];
        [self.selectedViewController removeFromParentViewController];
    }
    
    _selectedIndex = selectedIndex;
    [self.tabBar setSelectedItem:self.tabBar.items[selectedIndex]];
    
    [self setSelectedViewController:[self.viewControllers objectAtIndex:selectedIndex]];
    [self addChildViewController:self.selectedViewController];
    [self.selectedViewController.view setFrame:self.contentView.bounds];
    [self.contentView addSubview:self.selectedViewController.view];
    [self.selectedViewController didMoveToParentViewController:self];
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)setViewControllers:(NSArray *)viewControllers
{
    if (_viewControllers && _viewControllers.count) {
        for (UIViewController *viewController in _viewControllers) {
            [viewController willMoveToParentViewController:nil];
            [viewController.view removeFromSuperview];
            [viewController removeFromParentViewController];
        }
    }
    
    if (viewControllers && [viewControllers isKindOfClass:[NSArray class]])
    {
        _viewControllers = [viewControllers copy];
        
        NSMutableArray *tabBarItems = [[NSMutableArray alloc] init];
        for (UIViewController *viewController in viewControllers) {
            ADTabBarItem *tabBarItem = [[ADTabBarItem alloc] init];
            [tabBarItem setTitle:viewController.title];
            [tabBarItems addObject:tabBarItem];
            [viewController ad_setTabBarController:self];
        }
        [self.tabBar setItems:tabBarItems];
    }
    else
    {
        for (UIViewController *viewController in _viewControllers) {
            [viewController ad_setTabBarController:nil];
        }
        _viewControllers = nil;
    }
}

- (NSInteger)indexForViewController:(UIViewController *)viewController
{
    UIViewController *searchedController = viewController;
    if (searchedController.navigationController) {
        searchedController = searchedController.navigationController;
    }
    return [self.viewControllers indexOfObject:searchedController];
}

- (ADTabBar *)tabBar {
    if (!_tabBar) {
        _tabBar = [[ADTabBar alloc] init];
        [_tabBar setBackgroundColor:[UIColor clearColor]];
        [_tabBar setAutoresizingMask:(UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleTopMargin| UIViewAutoresizingFlexibleLeftMargin| UIViewAutoresizingFlexibleRightMargin| UIViewAutoresizingFlexibleBottomMargin)];
        _tabBar.delegate = self;
    }
    return _tabBar;
}

- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        [_contentView setBackgroundColor:[UIColor whiteColor]];
        [_contentView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight)];
    }
    return _contentView;
}

- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated
{
    _tabBarHidden = hidden;
    
    __weak ADTabBarController *weakSelf = self;
    
    void (^block)(void) = ^{
        CGSize viewSize = weakSelf.view.bounds.size;
        CGFloat tabBarStartingY = viewSize.height;
        CGFloat contentViewHeight = viewSize.height;
        CGFloat tabBarHeight = CGRectGetHeight([[weakSelf tabBar] frame]);
        
        if (!tabBarHeight) {
            tabBarHeight = 49;
        }
        
        if (!weakSelf.tabBarHidden) {
            tabBarStartingY = viewSize.height - tabBarHeight;
            if (![[weakSelf tabBar] isTranslucent]) {
                contentViewHeight -= ([[weakSelf tabBar] minimumContentHeight] ?: tabBarHeight);
            }
            [[weakSelf tabBar] setHidden:NO];
        }
        
        [[weakSelf tabBar] setFrame:CGRectMake(0, tabBarStartingY, viewSize.width, tabBarHeight)];
        [[weakSelf contentView] setFrame:CGRectMake(0, 0, viewSize.width, contentViewHeight)];
    };
    
    void (^completion)(BOOL) = ^(BOOL finished){
        if (weakSelf.tabBarHidden) {
            [[weakSelf tabBar] setHidden:YES];
        }
    };
    
    if (animated) {
        [UIView animateWithDuration:0.24 animations:block completion:completion];
    } else {
        block();
        completion(YES);
    }
}

- (void)setTabBarHidden:(BOOL)hidden
{
    [self setTabBarHidden:hidden animated:NO];
}

@end

#pragma mark - UIViewController+ADTabBarControllerItemInternal

@implementation UIViewController (ADTabBarControllerItemInternal)

- (void)ad_setTabBarController:(ADTabBarController *)tabBarController {
    objc_setAssociatedObject(self, @selector(ad_tabBarController), tabBarController, OBJC_ASSOCIATION_ASSIGN);
}

@end

#pragma mark - UIViewController+ADTabBarControllerItem

@implementation UIViewController (ADTabBarControllerItem)

- (ADTabBarController *)ad_tabBarController {
    ADTabBarController *tabBarController = objc_getAssociatedObject(self, @selector(ad_tabBarController));
    
    if (!tabBarController && self.parentViewController) {
        tabBarController = [self.parentViewController ad_tabBarController];
    }
    
    return tabBarController;
}

- (ADTabBarItem *)ad_tabBarItem {
    ADTabBarController *tabBarController = [self ad_tabBarController];
    NSInteger index = [tabBarController indexForViewController:self];
    
    return [[[tabBarController tabBar] items] objectAtIndex:index];
}

- (void)ad_setTabBarItem:(ADTabBarItem *)tabBarItem {
    ADTabBarController *tabBarController = [self ad_tabBarController];
    if (!tabBarController) {
        return;
    }
    
    ADTabBar *tabBar = [tabBarController tabBar];
    NSInteger index = [tabBarController indexForViewController:self];
    
    NSMutableArray *tabBarItems = [[NSMutableArray alloc] initWithArray:[tabBar items]];
    [tabBarItems replaceObjectAtIndex:index withObject:tabBarItem];
    [tabBar setItems:tabBarItems];
}

@end

