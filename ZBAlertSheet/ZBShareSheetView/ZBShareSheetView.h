//
//  ZBShareSheetView.h
//  LLCRM
//
//  Created by ZB on 2020/7/14.
//  Copyright © 2020 Wuhan lingli. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kScreenWidth    CGRectGetWidth([UIScreen mainScreen].bounds)
#define kScreenHeight   CGRectGetHeight([UIScreen mainScreen].bounds)


NS_ASSUME_NONNULL_BEGIN

@interface ZBShareSheetView : UIView

/// 点击回调：1微信，2朋友圈
//@property (copy, nonatomic) void(^sheetBlock)(NSInteger clickType);

///显示actionSheet
- (void)show;

///视图消失
- (void)dissmiss;

+ (void)showSheetViewComplete:(void (^)(int clickType))block;

@end

NS_ASSUME_NONNULL_END
