//
//  KKUpdategradeView.h
//  ZJNews
//
//  Created by admin on 2018/10/25.
//  Copyright © 2018 FXEYE. All rights reserved.
//

#import "AprilAlertView.h"
#define DefaultColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]
#define DefaultKeyFrame @[@1.0,@1.1,@0.9,@1.05,@0.95,@1.02,@1.0]
@interface AprilAlertView ()
@property (strong , nonatomic) UIWindow * keyWindow;
@property (assign , nonatomic) AlertType alertType;
@property (strong , nonatomic) UIColor * currentBackgroundColor;
@end
@implementation AprilAlertView


static AprilAlertView * AlertManager = nil;
static dispatch_once_t onceToken;

+ (instancetype)shareManger
{
    if (AlertManager == nil) {
        
        dispatch_once(&onceToken, ^{
            AlertManager = [[AprilAlertView alloc]init];
            AlertManager.frame = [UIScreen mainScreen].bounds;
        });
    }
    return AlertManager;
}
- (void)showAlertAlertType:(AlertType)alertType backGroundColor:(UIColor *)backgroundColor{
    if (backgroundColor == nil) {
        backgroundColor = DefaultColor;
    }
    _alertType = alertType;

    [[AprilAlertView currentViewController].view endEditing:YES];
    if (!_currentBackgroundColor) {
        AlertManager.backgroundColor = backgroundColor;
        _currentBackgroundColor = backgroundColor;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        
        /**获取第一个弹框视图*/
        UIView * subView =  [AlertManager.subviews firstObject];
        if ( subView.tag == 1028) {
            return ;
        }
        /**标记为已弹*/
        subView.tag = 1028;
        subView.hidden = NO;
        [AlertManager layoutIfNeeded];
        CGRect tempCgrect = subView.frame;
        /**弹窗动画*/
        if (alertType == AlertTypeBottomToTop) {
            subView.frame = CGRectMake(tempCgrect.origin.x, [UIScreen mainScreen].bounds.size.height, tempCgrect.size.width, tempCgrect.size.height);
            [UIView animateWithDuration:0.25 delay:0 options:(UIViewAnimationOptionLayoutSubviews) animations:^{
                  subView.frame = tempCgrect;
            } completion:^(BOOL finished) {
                
            }];
        }else if(alertType == AlertTypeSmallToBig){
             subView.transform = CGAffineTransformMakeScale(0.5, 0.5);
         
            [UIView animateWithDuration:0.25 delay:0 options:(UIViewAnimationOptionLayoutSubviews) animations:^{
             subView.transform = CGAffineTransformMakeScale(1, 1);
            } completion:^(BOOL finished) {
            }];
        }else if(alertType == AlertTypeKeyframeAnimation){
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
            animation.keyPath = @"transform.scale";
            animation.values = DefaultKeyFrame;
            animation.duration = 1;
            animation.calculationMode = kCAAnimationCubic;
            [subView.layer addAnimation:animation forKey:nil];
        }
        if ([[self topCofoolViewController] isKindOfClass:[UINavigationController class]] && [self topCofoolViewController].childViewControllers.count > 1) {
            [[self topCofoolViewController].navigationController.view addSubview:AlertManager];
        }else{
            [self.keyWindow addSubview:AlertManager];
        }
    });
}
- (void)showAlert
{
    [self showAlertAlertType:(AlertTypeSmallToBig) backGroundColor: DefaultColor];
}
- (void)addSubview:(UIView *)view
{
    [super addSubview:view];
    /**暂时隐藏添加上的子视图*/
    view.hidden = YES;
}

/**关闭弹框*/
- (void)disMiss{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView * subView =  [AlertManager.subviews firstObject];
        CGRect tempCgrect = subView.frame;
        
        if (self.alertType == AlertTypeBottomToTop) {
            [UIView animateWithDuration:0.25 delay:0 options:(UIViewAnimationOptionLayoutSubviews) animations:^{
               subView.frame = CGRectMake(tempCgrect.origin.x, [UIScreen mainScreen].bounds.size.height, tempCgrect.size.width, tempCgrect.size.height);
            } completion:^(BOOL finished) {
            }];
        }else{
           subView.transform = CGAffineTransformMakeScale(1, 1);
            [UIView animateWithDuration:0.25 delay:0 options:(UIViewAnimationOptionLayoutSubviews) animations:^{
                subView.transform = CGAffineTransformMakeScale(0.5, 0.5);
                subView.alpha = 0.01;
            } completion:^(BOOL finished) {
                if(finished){
                    subView.hidden = YES;
                }
            }];
        }
        
        
    });
    /**判断本单利弹框中是否还有未展示视图弹框*/
    if (AlertManager.subviews.count > 1) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[AlertManager.subviews firstObject] removeFromSuperview];
            [self showAlertAlertType:self.alertType backGroundColor:self.currentBackgroundColor];
        });
        return;
    }
    
    /**所有弹框弹出完毕 - */
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //从顶部开始移除
        for (UIView * subView in AlertManager.subviews) {
            [subView removeFromSuperview];
        }
        AlertManager.hidden = YES;
        [AlertManager removeFromSuperview];
        AlertManager = nil;
        self.currentBackgroundColor = nil;
        onceToken = 0;
    });
}

#pragma mark - 懒加载
- (UIWindow *)keyWindow
{
    if (_keyWindow == nil) {
        
        self.keyWindow = [UIApplication sharedApplication].keyWindow;
        
    }
    return _keyWindow;
}

// 当前顶部控制器
- (UIViewController *)topCofoolViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    }else {
        return vc;
    }
    return nil;
}
//获取Window当前显示的ViewController
+ (UIViewController*)currentViewController{
    //获得当前活动窗口的根视图
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (1)
    {
        //根据不同的页面切换方式，逐步取得最上层的viewController
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
    }
    return vc;
}
@end

