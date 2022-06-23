//
//  ZBAlertView.h
//  ZBCustomSheet
//
//  Created by ZB on 2022/6/22.
//  Copyright © 2022 ZB. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZBAlertView : UIView

/// 初始化方法 完整 带Color
/// @param title 标题
/// @param message 信息
/// @param cancelButtonTitle 取消按钮
/// @param cancelButtonTitleColor 取消按钮颜色
/// @param otherButtonTitle 其他按钮
/// @param otherButtonTitleColor 其他按钮颜色
- (instancetype)initWithTitle:(nonnull NSString *)title
                      message:(nullable NSString *)message
            cancelButtonTitle:(nullable NSString *)cancelButtonTitle
       cancelButtonTitleColor:(nullable UIColor *)cancelButtonTitleColor
             otherButtonTitle:(nullable NSString *)otherButtonTitle
        otherButtonTitleColor:(nullable UIColor *)otherButtonTitleColor;


/// 弹框初始化，超过2个按钮时，竖排展示
/// @param title 标题
/// @param message 信息
/// @param btnTitleArr @[按钮]
- (instancetype)initWithTitle:(nonnull NSString *)title message:(nullable NSString *)message buttonTitles:(nonnull NSArray<NSString *> *)btnTitleArr;

/// 弹框初始化，竖排按钮
/// @param title 标题
/// @param message 信息
/// @param btnTitleArr @[按钮集合]
- (instancetype)initWithTitle:(nonnull NSString *)title message:(nullable NSString *)message verticalButtonTitles:(nullable NSArray<NSString *> *)btnTitleArr;


/// 弹框初始化，竖排按钮
/// @param title 标题
/// @param message 信息
/// @param btnTitleArr @[按钮集合]
/// @param selectedBlock 点击回调返回index
+ (void)showAlertWithTitle:(nonnull NSString *)title message:(nullable NSString *)message verticalButtonTitles:(nullable NSArray<NSString *> *)btnTitleArr selectedBlock:(void (^)(NSInteger index))selectedBlock;

/// 显示弹框
- (void)show;

/// 隐藏弹框
- (void)dismiss;

/// 按钮点击回调Block index cancelButton: 0, otherButton: 1
@property (nonatomic, copy) void(^completionBlock)(NSInteger index);

/// 是否是强制弹框 默认YES
@property (nonatomic, assign) BOOL force;

/// 详细文本对齐方式 （默认居中）
@property(nonatomic) NSTextAlignment messageAlignment;

@end

NS_ASSUME_NONNULL_END
