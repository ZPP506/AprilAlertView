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
    
    
    
    UIView * view1 = [UIView new];
    view1.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-200)/2.0, ([UIScreen mainScreen].bounds.size.height-200)/2.0, 200, 200);
    view1.backgroundColor = [UIColor redColor];
    view1.shouldTapToDismiss = YES;
    [[AprilAlertView shareManger] addSubview:view1];
    [[AprilAlertView shareManger] showAlertAlertType:(AlertType_BottomToTop) backGroundColor:nil];
    
    
    UIView * view2 = [UIView new];
    view2.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-200)/2.0, ([UIScreen mainScreen].bounds.size.height-200)/2.0, 200, 200);
    view2.backgroundColor = [UIColor redColor];
    view2.shouldTapToDismiss = YES;
    [[AprilAlertView shareManger] addSubview:view2];
    [[AprilAlertView shareManger] showAlertAlertType:(AlertType_SmallToBottm) backGroundColor:nil];
}
@end
