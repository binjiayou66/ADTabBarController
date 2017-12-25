//
//  ViewControllerA.m
//  ADTabBarController
//
//  Created by 123 on 2017/12/24.
//  Copyright © 2017年 naibin.liu. All rights reserved.
//

#import "ViewControllerA.h"
#import "ViewControllerD.h"
#import "ADTabBarController.h"

@interface ViewControllerA ()

@end

@implementation ViewControllerA

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    ADTabBarController *ad = (id)[[UIApplication sharedApplication] keyWindow].rootViewController;
    [ad setTabBarHidden:NO animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    ViewControllerD *vcd = [[ViewControllerD alloc] init];
    ADTabBarController *ad = (id)[[UIApplication sharedApplication] keyWindow].rootViewController;
    [ad setTabBarHidden:YES animated:YES];
    [self.navigationController pushViewController:vcd animated:YES];
}

@end
