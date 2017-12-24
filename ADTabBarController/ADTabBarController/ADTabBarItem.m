//
//  ADTabBarItem.m
//  ADTabBarController
//
//  Created by Andy on 2017/12/24.
//  Copyright © 2017年 naibin.liu. All rights reserved.
//

#import "ADTabBarItem.h"

@implementation ADTabBarItem

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
    [self setBackgroundColor:[UIColor clearColor]];
    
    _title = @"";
    _titlePositionAdjustment = UIOffsetZero;
    _unselectedTitleAttributes = @{
                                   NSFontAttributeName: [UIFont systemFontOfSize:12],
                                   NSForegroundColorAttributeName: [UIColor blackColor],
                                   };
    _selectedTitleAttributes = [_unselectedTitleAttributes copy];
    _badgeBackgroundColor = [UIColor redColor];
    _badgeTextColor = [UIColor whiteColor];
    _badgeTextFont = [UIFont systemFontOfSize:12];
    _badgePositionAdjustment = UIOffsetZero;
}

- (void)drawRect:(CGRect)rect {
    CGSize frameSize = self.frame.size;
    CGSize imageSize = CGSizeZero;
    CGSize titleSize = CGSizeZero;
    NSDictionary *titleAttributes = nil;
    UIImage *backgroundImage = nil;
    UIImage *image = nil;
    CGFloat imageStartingY = 0.0f;
    
    if ([self isSelected])
    {
        image = self.selectedImage;
        backgroundImage = self.selectedBackgroundImage;
        titleAttributes = self.selectedTitleAttributes;
        if (!titleAttributes) {
            titleAttributes = self.unselectedTitleAttributes;
        }
    }
    else
    {
        image = self.unselectedImage;
        backgroundImage = self.unselectedBackgroundImage;
        titleAttributes = self.unselectedTitleAttributes;
    }
    imageSize = [image size];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    [backgroundImage drawInRect:self.bounds];
    if (self.title.length <= 0) {
        [image drawInRect:CGRectMake(roundf(frameSize.width / 2 - imageSize.width / 2) + self.imagePositionAdjustment.horizontal, roundf(frameSize.height / 2 - imageSize.height / 2) + self.imagePositionAdjustment.vertical, imageSize.width, imageSize.height)];
    } else {
        titleSize = [self.title boundingRectWithSize:CGSizeMake(frameSize.width, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:titleAttributes context:nil].size;
        
        imageStartingY = roundf((frameSize.height - imageSize.height - titleSize.height) / 2);
        
        [image drawInRect:CGRectMake(roundf(frameSize.width / 2 - imageSize.width / 2) + self.imagePositionAdjustment.horizontal, imageStartingY + self.imagePositionAdjustment.vertical, imageSize.width, imageSize.height)];
        
        CGContextSetFillColorWithColor(context, [titleAttributes[NSForegroundColorAttributeName] CGColor]);
        
        [self.title drawInRect:CGRectMake(roundf(frameSize.width / 2 - titleSize.width / 2) + self.titlePositionAdjustment.horizontal, imageStartingY + imageSize.height + self.titlePositionAdjustment.vertical, titleSize.width, titleSize.height) withAttributes:titleAttributes];
    }
        
    if (self.badgeValue.integerValue != 0)
    {
        CGSize badgeSize = [self.badgeValue boundingRectWithSize:CGSizeMake(frameSize.width, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.badgeTextFont} context:nil].size;
        
        CGFloat textOffset = 2.0f;
        if (badgeSize.width < badgeSize.height) {
            badgeSize = CGSizeMake(badgeSize.height, badgeSize.height);
        }
        CGRect badgeBackgroundFrame = CGRectMake(roundf(frameSize.width / 2 + (image.size.width / 2) * 0.9) + self.badgePositionAdjustment.horizontal, textOffset + self.badgePositionAdjustment.vertical, badgeSize.width + 2 * textOffset, badgeSize.height + 2 * textOffset);
        
        if (self.badgeBackgroundColor)
        {
            CGContextSetFillColorWithColor(context, self.badgeBackgroundColor.CGColor);
            CGContextFillEllipseInRect(context, badgeBackgroundFrame);
        }
        else if (self.badgeBackgroundImage)
        {
            [self.badgeBackgroundImage drawInRect:badgeBackgroundFrame];
        }
        
        CGContextSetFillColorWithColor(context, self.badgeTextColor.CGColor);
        
        NSMutableParagraphStyle *badgeTextStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        [badgeTextStyle setLineBreakMode:NSLineBreakByWordWrapping];
        [badgeTextStyle setAlignment:NSTextAlignmentCenter];
        
        NSDictionary *badgeTextAttributes = @{NSFontAttributeName: self.badgeTextFont, NSForegroundColorAttributeName: self.badgeTextColor, NSParagraphStyleAttributeName: badgeTextStyle};
        
        [self.badgeValue drawInRect:CGRectMake(CGRectGetMinX(badgeBackgroundFrame) + textOffset, CGRectGetMinY(badgeBackgroundFrame) + textOffset, badgeSize.width, badgeSize.height) withAttributes:badgeTextAttributes];
    }
    
    CGContextRestoreGState(context);
}

#pragma mark - getter and setter

- (void)setBadgeValue:(NSString *)badgeValue
{
    _badgeValue = badgeValue;
    [self setNeedsDisplay];
}

@end
