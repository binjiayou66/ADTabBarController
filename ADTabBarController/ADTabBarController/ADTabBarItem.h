//
//  ADTabBarItem.h
//  ADTabBarController
//
//  Created by Andy on 2017/12/24.
//  Copyright © 2017年 naibin.liu. All rights reserved.
//
//  Reference link https://github.com/robbdimitrov/RDVTabBarController
//

#import <UIKit/UIKit.h>

@interface ADTabBarItem : UIControl

/// 高度
@property CGFloat itemHeight;

/// 标题
@property (nonatomic, copy) NSString *title;

/// 标题偏移量
@property (nonatomic) UIOffset titlePositionAdjustment;

/**
 * 文本属性详情可参考以下链接
 * https://developer.apple.com/library/ios/documentation/uikit/reference/NSString_UIKit_Additions/Reference/Reference.html
 */

/// 未选中标题文本属性
@property (copy) NSDictionary *unselectedTitleAttributes;

/// 选中标题文本属性
@property (copy) NSDictionary *selectedTitleAttributes;

/// 图片偏移量
@property (nonatomic) UIOffset imagePositionAdjustment;

/// 选中状态图片
@property (nonatomic, strong) UIImage * selectedImage;

/// 未选中状态图片
@property (nonatomic, strong) UIImage * unselectedImage;

/// 选中状态背景图片
@property (nonatomic, strong) UIImage * selectedBackgroundImage;

/// 未选中状态背景图片
@property (nonatomic, strong) UIImage * unselectedBackgroundImage;

/// 角标值
@property (nonatomic, copy) NSString *badgeValue;

/// 角标文字颜色
@property (strong) UIColor *badgeTextColor;

/// 角标字体大小
@property (nonatomic) UIFont *badgeTextFont;

/// 角标背景颜色
@property (strong) UIColor *badgeBackgroundColor;

/// 角标背景图片
@property (strong) UIImage *badgeBackgroundImage;

/// 角标偏移量
@property (nonatomic) UIOffset badgePositionAdjustment;

@end
