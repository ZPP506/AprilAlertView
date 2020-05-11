//
//  AprilViewController.m
//  AprilAlertView
//
//  Created by ZPP506 on 12/27/2018.
//  Copyright (c) 2018 ZPP506. All rights reserved.
//

#import "AprilViewController.h"
#import "AprilAlertView.h"

@interface AprilViewController ()

@end

@implementation AprilViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UIView * view = [UIView new];
    view.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-200)/2.0, ([UIScreen mainScreen].bounds.size.height-200)/2.0, 200, 200);
    view.backgroundColor = [UIColor redColor];
    view.shouldTapToDismiss = YES;
    [[AprilAlertView shareManger] addSubview:view];
    [[AprilAlertView shareManger] showAlertAlertType:(AlertType_KeyframeAnimation) backGroundColor:nil];
}
@end
