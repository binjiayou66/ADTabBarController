//
//  ADTabBar.m
//  ADTabBarController
//
//  Created by Andy on 2017/12/24.
//  Copyright © 2017年 naibin.liu. All rights reserved.
//

#import "ADTabBar.h"
#import "ADTabBarItem.h"

@interface ADTabBar ()

@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, strong) UIView *backgroundView;

@end

@implementation ADTabBar

- (id)init
{
    return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInitialization];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInitialization];
    }
    return self;
}

- (void)commonInitialization
{
    _backgroundView = [[UIView alloc] init];
    [self addSubview:_backgroundView];
    [self setTranslucent:NO];
}

- (void)layoutSubviews
{
    CGSize frameSize = self.frame.size;
    CGFloat minimumContentHeight = self.minimumContentHeight;
    
    [self.backgroundView setFrame:CGRectMake(0, frameSize.height - minimumContentHeight, frameSize.width, frameSize.height)];
    
    self.itemWidth = roundf((frameSize.width - [self contentEdgeInsets].left - [self contentEdgeInsets].right) / [[self items] count]);
    NSInteger index = 0;
    for (ADTabBarItem *item in self.items) {
        CGFloat itemHeight = item.itemHeight;
        if (!itemHeight) {
            itemHeight = frameSize.height;
        }
        if (index == 0) {
            item.showRedPoint = YES;
        }
        item.badgeValue = [NSString stringWithFormat:@"%ld", index];
        item.imagePositionAdjustment = UIOffsetMake(0, 8);
        item.titlePositionAdjustment = UIOffsetMake(0, 10);
        item.frame = CGRectMake(self.contentEdgeInsets.left + (index * self.itemWidth), roundf(frameSize.height - itemHeight) - self.contentEdgeInsets.top, self.itemWidth, itemHeight - self.contentEdgeInsets.bottom);
        [item setNeedsDisplay];
        
        index++;
    }
}

#pragma mark - Item selection

- (void)tabBarItemWasSelected:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(ad_tabBar:shouldSelectItemAtIndex:)]) {
        NSInteger index = [self.items indexOfObject:sender];
        if (![self.delegate ad_tabBar:self shouldSelectItemAtIndex:index]) {
            return;
        }
    }
    [self setSelectedItem:sender];
    
    if ([self.delegate respondsToSelector:@selector(ad_tabBar:didSelectItemAtIndex:)]) {
        NSInteger index = [self.items indexOfObject:self.selectedItem];
        [self.delegate ad_tabBar:self didSelectItemAtIndex:index];
    }
}

- (void)setSelectedItem:(ADTabBarItem *)selectedItem
{
    if (selectedItem == _selectedItem) {
        return;
    }
    [_selectedItem setSelected:NO];
    
    _selectedItem = selectedItem;
    [_selectedItem setSelected:YES];
}

#pragma mark - getter and setter

- (void)setItemWidth:(CGFloat)itemWidth
{
    if (itemWidth > 0) {
        _itemWidth = itemWidth;
    }
}

- (void)setItems:(NSArray *)items
{
    for (ADTabBarItem *item in _items) {
        [item removeFromSuperview];
    }
    _items = [items copy];
    for (ADTabBarItem *item in _items) {
        [item addTarget:self action:@selector(tabBarItemWasSelected:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:item];
    }
}

- (void)setHeight:(CGFloat)height
{
    [self setFrame:CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), height)];
}

- (CGFloat)minimumContentHeight
{
    CGFloat minimumTabBarContentHeight = CGRectGetHeight(self.frame);
    
    for (ADTabBarItem *item in self.items) {
        CGFloat itemHeight = item.itemHeight;
        if (itemHeight && (itemHeight < minimumTabBarContentHeight)) {
            minimumTabBarContentHeight = itemHeight;
        }
    }
    
    return minimumTabBarContentHeight;
}

- (void)setTranslucent:(BOOL)translucent
{
    _translucent = translucent;
    CGFloat alpha = (translucent ? 0.9 : 1.0);
    
    [_backgroundView setBackgroundColor:[UIColor colorWithRed:245/255.0
                                                        green:245/255.0
                                                         blue:245/255.0
                                                        alpha:alpha]];
}

@end
