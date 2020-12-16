//
//  KKUpdategradeView.h
//  ZJNews
//
//  Created by admin on 2018/10/25.
//  Copyright © 2018 FXEYE. All rights reserved.
//

#import "AprilAlertView.h"
#define DefaultTag 1028
#import <objc/runtime.h>

#pragma mark - AprilViewAssociate
@interface UIView (AprilViewAssociate)

@property (nonatomic, assign) NSInteger alertTag;

@property (nonatomic, assign) CGFloat alertOriginAlpha;

@property (nonatomic) CGAffineTransform alertTransform;
@end

@implementation UIView (AprilViewAssociate)
/**保存原始Transform
 */
- (void)setAlertTransform:(CGAffineTransform)alertTransform {
    
    objc_setAssociatedObject(self, @selector(alertTransform), [NSValue valueWithCGAffineTransform:alertTransform], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CGAffineTransform)alertTransform {
    NSValue * value = objc_getAssociatedObject(self, @selector(alertTransform));
    return [value CGAffineTransformValue];
}
/**保存原始Alpha值
 */
- (void)setAlertOriginAlpha:(CGFloat)alertOriginAlpha {
    
    objc_setAssociatedObject(self, @selector(alertOriginAlpha), @(alertOriginAlpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CGFloat)alertOriginAlpha {
    NSNumber * number = objc_getAssociatedObject(self, @selector(alertOriginAlpha));
    if ([number isKindOfClass:[NSNumber class]]) {
        return [number floatValue];
    }
    return 1;
}

/**是否弹出标志
*/
- (void)setAlertTag:(NSInteger)alertTag {
    objc_setAssociatedObject(self, @selector(alertTag), @(alertTag), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)alertTag {
    NSNumber * number = objc_getAssociatedObject(self, @selector(alertTag));
    if ([number isKindOfClass:[NSNumber class]]) {
        return [number integerValue];
    }
    return -1;
}
/**点击空白处是否消失
 */
- (void)setShouldTapToDismiss:(BOOL)shouldTapToDismiss {
    objc_setAssociatedObject(self, @selector(shouldTapToDismiss), @(shouldTapToDismiss), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)shouldTapToDismiss {
    return [objc_getAssociatedObject(self, @selector(shouldTapToDismiss)) boolValue];
}
/**弹出的动画类型
 */
- (void)setAlertType:(AlertType)aletyType {
    objc_setAssociatedObject(self, @selector(alertType), @(aletyType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (AlertType)alertType {
    return [objc_getAssociatedObject(self, @selector(alertType)) intValue];
}
@end

#pragma mark - AprilAlertView
@interface AprilAlertView ()<UIGestureRecognizerDelegate>

@property (strong , nonatomic) UIColor * currentBackgroundColor;

@end
@implementation AprilAlertView
static AprilAlertView * alertBackGroundView = nil;
static dispatch_once_t onceToken;
+ (instancetype)shareManger
{
    if (alertBackGroundView == nil) {
        dispatch_once(&onceToken, ^{
            alertBackGroundView = [[AprilAlertView alloc]init];
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:alertBackGroundView action:@selector(tapBackGrpundViewDissmiss)];
            [alertBackGroundView addGestureRecognizer:tap];
            tap.delegate = alertBackGroundView;
            alertBackGroundView.frame = [UIScreen mainScreen].bounds;
        });
    }
    return alertBackGroundView;
}
- (void)showAlert
{
    [self showAlertAlertType:(AlertType_SmallToBig) backGroundColor: DefaultAlertBackGroundColor];
}
- (void)showAlertAlertType:(AlertType)alertType backGroundColor:(UIColor *)backgroundColor{
    
    [self showAlertAlertType:alertType alertPriority:AlertType_normal backGroundColor:backgroundColor];
}
- (void)showAlertAlertType:(AlertType)alertType
  alertPriority:(AlertPriority)alertPriority
           backGroundColor:(UIColor *)backgroundColor{
    
    if (backgroundColor == nil) {
        backgroundColor = DefaultAlertBackGroundColor;
    }
    [[AprilAlertView ap_currentViewController].view endEditing:YES];
    if (!_currentBackgroundColor) {
        alertBackGroundView.backgroundColor = backgroundColor;
        _currentBackgroundColor = backgroundColor;
    }
    UIView * lastView =  [alertBackGroundView.subviews lastObject];
    if (alertType != AlertType_Other) {
        lastView.alertType = alertType;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        /**获取弹框视图*/
        UIView * subView =  [alertBackGroundView.subviews firstObject];
        if ( subView.alertTag == DefaultTag) {
            return ;
        }
        subView.alertTag = DefaultTag;
        subView.hidden = NO;
        [alertBackGroundView layoutIfNeeded];
        /**弹窗动画*/
        [self showAlertAnimation:subView.alertType subbView:subView];
        /**将背景弹框添加到window或者TopViewController上*/
        [self showAlertBackGroundViewPresentView:alertBackGroundView alertPriority:alertPriority];
    });
}
- (void)showAlertBackGroundViewPresentView:(UIView *)alertBackgroundTempView alertPriority:(AlertPriority)alertPriority {
    if (alertPriority == AlertType_Tab) {
        UIViewController *resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
        UITabBarController *tabVC = [resultVC tabBarController];
        [tabVC.view addSubview:alertBackgroundTempView];
        return;
    }
    
    UIViewController * controller = [self topCofoolViewController];
    if (alertPriority == AlertType_Height) {
         [[UIApplication sharedApplication].keyWindow addSubview:alertBackgroundTempView];
        return;
    }
    
    if (![controller isKindOfClass:[UITabBarController class]] && controller.tabBarController.childViewControllers.count > 1)
    {
        controller = controller.tabBarController;
    }
    if ([controller isKindOfClass:[UITabBarController class]] && controller.childViewControllers.count > 1) {
        [[self topCofoolViewController].tabBarController.view addSubview:alertBackgroundTempView];
    }else{
        [[UIApplication sharedApplication].keyWindow addSubview:alertBackgroundTempView];
    }
    
}
- (void)showAlertAnimation:(AlertType)alertType subbView:(UIView *)subView{
    CGRect originRect = subView.frame;
    if (alertType == AlertType_BottomToTop) {
        [self showAlertAnimation_BottomToTopWithView:subView originRect:originRect];
    }else if(alertType == AlertType_SmallToBig){
        [self showAlertAnimation_SmallToBigWithView:subView originRect:originRect];
    }else if(alertType == AlertType_KeyframeAnimation){
        [self showAlertAnimation_KeyframeAnimationWithView:subView];
    }else if (alertType == AlertType_alphaChange){
        // 透明度渐变
        [self showAlertAnimation_AlphaChangeWithView:subView];
    }else if (alertType == AlertType_push){
        // push
        [self showAlertAnimation_PushWithView:subView originRect:originRect];
    }else if (alertType == AlertType_SmallToBottm){
        [self showAlertAnimation_SmallToBigWithView:subView originRect:originRect];
    }else if (alertType == AlertType_SmallToBig_dissMissNoAnimtion){
        [self showAlertAnimation_SmallToBigWithView:subView originRect:originRect];
    }
    
    
    
}
- (void)addSubview:(UIView *)view
{
    [super addSubview:view];
    
   
    //记录原始值
    view.alertTransform = view.transform;
    view.alertOriginAlpha = view.alpha;
    
    /**暂时隐藏添加上的子视图*/
    view.hidden = YES;
}
#pragma mark - 显示动画
- (void)showAlertAnimation_BottomToTopWithView:(UIView *)subView originRect:(CGRect)originRect{
    subView.frame = CGRectMake(originRect.origin.x, [UIScreen mainScreen].bounds.size.height, originRect.size.width, originRect.size.height);
    [UIView animateWithDuration:0.25 delay:0 options:(UIViewAnimationOptionLayoutSubviews) animations:^{
        subView.frame = originRect;
    } completion:^(BOOL finished) {
    }];
}
- (void)showAlertAnimation_SmallToBigWithView:(UIView *)subView originRect:(CGRect)originRect{
    subView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    CGFloat originAlpha = subView.alpha;
    subView.alpha = 0;
    
    [UIView animateWithDuration:0.25 delay:0 options:(UIViewAnimationOptionLayoutSubviews) animations:^{
        subView.alpha = originAlpha;
        subView.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
    }];
}
- (void)showAlertAnimation_KeyframeAnimationWithView:(UIView *)subView{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"transform.scale";
    animation.values = @[@1.0,@1.1,@0.9,@1.05,@0.95,@1.02,@1.0];
    animation.duration = 1;
    animation.calculationMode = kCAAnimationCubic;
    [subView.layer addAnimation:animation forKey:nil];
}
- (void)showAlertAnimation_AlphaChangeWithView:(UIView *)subView{
    subView.transform = CGAffineTransformMakeScale(1,1);
    [UIView animateWithDuration:0.25 delay:0 options:(UIViewAnimationOptionLayoutSubviews) animations:^{
        subView.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
    }];
}
- (void)showAlertAnimation_PushWithView:(UIView *)subView originRect:(CGRect)originRect{
    subView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, originRect.origin.y, originRect.size.width, originRect.size.height);
    [UIView animateWithDuration:0.25 delay:0 options:(UIViewAnimationOptionLayoutSubviews) animations:^{
        subView.frame = originRect;
    } completion:^(BOOL finished) {
    }];
}
#pragma mark - 关闭弹框
- (void)disMiss{
    
    [self disMissCompletion:nil];
   
}
- (void)disMissCompletion:(void (^)(void))completion{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView * subView =  [alertBackGroundView.subviews firstObject];
        CGRect originRect = subView.frame;
        subView.alertTag = -1;
        AlertType alertType = subView.alertType;
        if (alertType == AlertType_BottomToTop) {
            [self disMissAnimation_BottomToTopWithView:subView originRect:originRect];
        }else if (alertType == AlertType_SmallToBottm) {
            [self disMissAnimation_SamellBottomWithView:subView originRect:originRect];
        }else if (alertType == AlertType_alphaChange){
            [self disMissAnimation_AlphaChangeWithView:subView];
        }else if (alertType == AlertType_push){
            [self disMissAnimation_PushWithView:subView originRect:originRect];
        }else if (alertType == AlertType_SmallToBig_dissMissNoAnimtion){
            [self disMissNoAnimation_DefalutWithView:subView];
        }else{
            [self disMissAnimation_DefalutWithView:subView];
        }
    });
    /**判断本单利弹框中是否还有未展示视图弹框*/
    if (alertBackGroundView.subviews.count > 1) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self shouldShowOtherView];
        });
        return;
    }
    /**所有弹框弹出完毕 - */
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self clearsAllComplete:completion];
    });
    
}
- (void)disMissAnimation_BottomToTopWithView:(UIView *)subView originRect:(CGRect)originRect{
    [UIView animateWithDuration:0.25 delay:0 options:(UIViewAnimationOptionLayoutSubviews) animations:^{
        subView.frame = CGRectMake(originRect.origin.x, [UIScreen mainScreen].bounds.size.height, originRect.size.width, originRect.size.height);
    } completion:^(BOOL finished) {
        
    }];
}
- (void)disMissAnimation_SamellBottomWithView:(UIView *)subView originRect:(CGRect)originRect{
    [UIView animateWithDuration:0.25 delay:0 options:(UIViewAnimationOptionLayoutSubviews) animations:^{
        subView.frame = CGRectMake(originRect.origin.x, [UIScreen mainScreen].bounds.size.height, originRect.size.width, originRect.size.height);
        subView.transform = CGAffineTransformMakeScale(0.2, 0.2);
        subView.alpha = 0.01;
    } completion:^(BOOL finished) {
        
    }];
}
- (void)disMissNoAnimation_DefalutWithView:(UIView *)subView{
    subView.hidden = YES;
}
- (void)disMissAnimation_DefalutWithView:(UIView *)subView{
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
- (void)disMissAnimation_AlphaChangeWithView:(UIView *)subView{
    subView.transform = CGAffineTransformMakeScale(1, 1);
    [UIView animateWithDuration:0.25 delay:0 options:(UIViewAnimationOptionLayoutSubviews) animations:^{
        subView.transform = CGAffineTransformMakeScale(1, 1);
        subView.alpha = 0.01;
    } completion:^(BOOL finished) {
        if(finished){
            subView.hidden = YES;
        }
    }];
}
- (void)disMissAnimation_PushWithView:(UIView *)subView originRect:(CGRect)originRect{
    [UIView animateWithDuration:0.25 delay:0 options:(UIViewAnimationOptionLayoutSubviews) animations:^{
        subView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width,originRect.origin.y, originRect.size.width, originRect.size.height);
    } completion:^(BOOL finished) {
        
    }];
}
- (void)shouldShowOtherView{
    UIView * view = [alertBackGroundView.subviews firstObject];
    [view removeFromSuperview];
    view.alpha = view.alertOriginAlpha;
    view.transform = view.alertTransform;
 
    [self showAlertAlertType:AlertType_Other backGroundColor:self.currentBackgroundColor];
    
}
- (void)clearsAllComplete:(void(^)(void))complete {
    
    UIView *subView = [alertBackGroundView.subviews firstObject];
    [UIView animateWithDuration:0.25 delay:0 options:(UIViewAnimationOptionLayoutSubviews) animations:^{
        subView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        subView.alpha = 0.01;
        alertBackGroundView.alpha = 0.f;
    } completion:^(BOOL finished) {
        for (UIView * subView in alertBackGroundView.subviews) {
            [subView removeFromSuperview];
        }
        subView.alpha = subView.alertOriginAlpha;
        subView.transform = subView.alertTransform;
        alertBackGroundView.hidden = YES;
        [alertBackGroundView removeFromSuperview];
        alertBackGroundView = nil;
        self.currentBackgroundColor = nil;
        onceToken = 0;
        if (complete) complete();
    }];
}
#pragma mark - 获取顶部控制器
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
#pragma mark - UITapGestureRecognizer
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if (touch.view != alertBackGroundView) {
        return NO;
    }
    return YES;
}
- (void)tapBackGrpundViewDissmiss{
    UIView *currentShowView = [alertBackGroundView.subviews firstObject];
    if (currentShowView.shouldTapToDismiss) {
        [self disMiss];
    }
}
+ (UIViewController *)ap_currentViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    return resultVC;
}
+ (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    }else{
        return vc;
    }
    return nil;
}
@end

