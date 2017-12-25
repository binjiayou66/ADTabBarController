//
//  ViewControllerB.m
//  ADTabBarController
//
//  Created by 123 on 2017/12/24.
//  Copyright © 2017年 naibin.liu. All rights reserved.
//

#import "ViewControllerB.h"
#import "ADTabBarController.h"

@interface ViewControllerB ()

@end

@implementation ViewControllerB

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    ADTabBarController *ad = (id)[[UIApplication sharedApplication] keyWindow].rootViewController;
    [ad setTabBarHidden:NO animated:YES];
}

@end
