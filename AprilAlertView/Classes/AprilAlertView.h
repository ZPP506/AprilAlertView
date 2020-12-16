//
//  KKUpdategradeView.h
//  ZJNews
//
//  Created by admin on 2018/10/25.
//  Copyright © 2018 FXEYE. All rights reserved.
//


#import <UIKit/UIKit.h>



#define DefaultAlertBackGroundColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]

typedef enum : NSUInteger {
    /**其他方式*/
    AlertType_Other,
    /**从底部弹出*/
    AlertType_BottomToTop,
    /**由小变大*/
    AlertType_SmallToBig,
    /**帧动画 由小变大 抖一抖*/
    AlertType_KeyframeAnimation, //@[@0.9,@1.0,@1.1,@0.9,@1.05,@0.95,@1.02,@1.0];
    /**透明度渐变*/
    AlertType_alphaChange,// 透明度渐变
    /**从右侧推出*/
    AlertType_push, // 仿系统push
    
    /**由小变大显示之后向底部缩回*/
    AlertType_SmallToBottm,
    
    /**由小变大显示之后立即消失不展示消失动画*/
    AlertType_SmallToBig_dissMissNoAnimtion,
    
}  AlertType;

typedef enum : NSUInteger {
    
    AlertType_normal,
    
    AlertType_Height,
    
    AlertType_Tab,
    
}  AlertPriority;

#pragma mark - AprilViewAssociate
@interface UIView (AprilViewAssociate)

@property (nonatomic, assign) BOOL shouldTapToDismiss;

@end




#pragma mark - AprilAlertView
@interface AprilAlertView : UIView

+ (instancetype)shareManger;

/**显示警示框
 */
- (void)showAlert;

/**显示警示框
   backgroundColor: 允许为空 nil
 */
- (void)showAlertAlertType:(AlertType)alertType
           backGroundColor:(UIColor *)backgroundColor;

/**显示警示框
 alertType: 弹出框动画类型
 alertPriority: 弹出框优先级
 backgroundColor: 允许为空 nil
 */
- (void)showAlertAlertType:(AlertType)alertType
             alertPriority:(AlertPriority)alertPriority
           backGroundColor:(UIColor *)backgroundColor;

/**隐藏警示框
 */
- (void)disMiss;
- (void)disMissCompletion:(void(^)(void))completion;

/**点击背景是否消失 默认:不消失
 */
@property (nonatomic, assign) BOOL shouldTapDismiss NS_DEPRECATED(2_0, 2_0, 2_0, 2_0,"不再使用，使用UIView关联对象的shouldTapToDismiss属性设置") NS_UNAVAILABLE;


@end
