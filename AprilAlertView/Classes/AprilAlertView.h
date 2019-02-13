//
//  KKUpdategradeView.h
//  ZJNews
//
//  Created by admin on 2018/10/25.
//  Copyright © 2018 FXEYE. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    AlertTypeBottomToTop,
    AlertTypeSmallToBig,
    AlertTypeKeyframeAnimation //@[@0.9,@1.0,@1.1,@0.9,@1.05,@0.95,@1.02,@1.0];
}  AlertType;

@interface AprilAlertView : UIView

+ (instancetype)shareManger;

/**显示警示框*/
- (void)showAlert;
/**显示警示框*/
- (void)showAlertAlertType:(AlertType)alertType backGroundColor:(UIColor *)backgroundColor;
/**隐藏警示框*/
- (void)disMiss;

@end
