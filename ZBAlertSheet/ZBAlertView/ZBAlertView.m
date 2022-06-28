//
//  ZBAlertView.m
//  ZBCustomSheet
//
//  Created by ZB on 2022/6/22.
//  Copyright © 2022 ZB. All rights reserved.
//

#import "ZBAlertView.h"
//字体定义
#define FontTypePingFangMe @"PingFangSC-Medium"
#define FontTypePingFangRe @"PingFangSC-Regular"

//快捷设置颜色
#define ColorFromHex(hexValue)  [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]


// 按钮高度
#define BUTTON_HEIGHT 50.0f
// 屏幕尺寸
#define SCREEN_SIZE [UIScreen mainScreen].bounds.size

//弹出框宽
#define CUSTOM_WIDTH ([UIScreen mainScreen].bounds.size.width-106)

#define BUTTON_TAG 1000

@interface ZBAlertView ()

@property (copy, nonatomic) void (^selectedBlock)(NSInteger index);

// 半透明蒙层
@property (nonatomic, strong) UIView *darkView;

@property (nonatomic, strong) UIView *alertView;

@property (nonatomic, strong) UIWindow *backWindow;

@property (nonatomic, strong) UILabel *messageLabel;

@end


@implementation ZBAlertView

/// 弹框初始化，超过2个按钮时，竖排展示
/// @param title 标题
/// @param message 信息
/// @param btnTitleArr @[按钮]
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSArray<NSString *> *)btnTitleArr {
    if (btnTitleArr.count == 0) {
        return nil;
    }else if (btnTitleArr.count == 1){
        return [self initWithTitle:title message:message cancelButtonTitle:nil cancelButtonTitleColor:ColorFromHex(0x292933) otherButtonTitle:btnTitleArr[0] otherButtonTitleColor:ColorFromHex(0x00B377)];
    }else if (btnTitleArr.count == 2){
        return [self initWithTitle:title message:message cancelButtonTitle:btnTitleArr[0] cancelButtonTitleColor:ColorFromHex(0x292933) otherButtonTitle:btnTitleArr[1] otherButtonTitleColor:ColorFromHex(0x00B377)];
    }else {//超过2个按钮时，竖排展示
        return [self initWithTitle:title message:message verticalButtonTitles:btnTitleArr];
    }
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle cancelButtonTitleColor:(UIColor *)cancelButtonTitleColor otherButtonTitle:(NSString *)otherButtonTitle otherButtonTitleColor:(UIColor *)otherButtonTitleColor {
    if (self = [super init]) {
        [self addSubview:self.darkView];
        [self addSubview:self.alertView];
        
        CGFloat y = 20;
        // 如果标题为空 信息不为空 就把标题和信息调换一下
        if (title.length == 0 && message) {
            NSString *temp = title;
            title = message;
            message = temp;
        }
        
        if (title.length > 0) {
            // 顶部标题
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, y, CUSTOM_WIDTH-32, 20)];
            titleLabel.font = [UIFont fontWithName:FontTypePingFangMe size:17];
            titleLabel.numberOfLines = 0;
            titleLabel.text = title;
            [titleLabel sizeToFit];
            titleLabel.frame = CGRectMake(16, y, CUSTOM_WIDTH-32, titleLabel.frame.size.height);
            titleLabel.textColor = ColorFromHex(0x292933);
            titleLabel.textAlignment = NSTextAlignmentCenter;
            [self.alertView addSubview:titleLabel];
            y = CGRectGetMaxY(titleLabel.frame) + 10;
        }
        
        if (message.length > 0) {
            UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, y, CUSTOM_WIDTH-32, 20)];
            messageLabel.font = [UIFont fontWithName:FontTypePingFangRe size:14];
            messageLabel.numberOfLines = 0;
            messageLabel.text = message;
            [messageLabel sizeToFit];
            messageLabel.frame = CGRectMake(16, y, CUSTOM_WIDTH-32, messageLabel.frame.size.height);
            messageLabel.textColor = ColorFromHex(0x676773);
            messageLabel.textAlignment = NSTextAlignmentCenter;
            [self.alertView addSubview:messageLabel];
            self.messageLabel = messageLabel;
            y = CGRectGetMaxY(messageLabel.frame) + 10;
        }
        
        if (title.length == 0 && message.length == 0){
            y = 0;
        }else{
            // 按钮中间分隔线
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, y, CUSTOM_WIDTH, 0.5)];
            line.backgroundColor = ColorFromHex(0xDDDDDE);
            [self.alertView addSubview:line];
            y += 0.5;
        }
        
        // 取消按钮
        if (cancelButtonTitle.length > 0) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.titleLabel.font = [UIFont systemFontOfSize:17];
            btn.tag = BUTTON_TAG;
            [btn setTitle:cancelButtonTitle forState:UIControlStateNormal];
            [btn setTitleColor:cancelButtonTitleColor forState:UIControlStateNormal];
            if (otherButtonTitle.length > 0) {
                btn.frame = CGRectMake(0, y, CUSTOM_WIDTH/2, BUTTON_HEIGHT);
            } else {
                btn.frame = CGRectMake(0, y, CUSTOM_WIDTH, BUTTON_HEIGHT);
            }
            [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.alertView addSubview:btn];
        }
        
        // 确认按钮
        if (otherButtonTitle.length > 0) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.titleLabel.font = [UIFont fontWithName:FontTypePingFangMe size:17.f];
            btn.tag = BUTTON_TAG+1;
            [btn setTitle:otherButtonTitle forState:UIControlStateNormal];
            [btn setTitleColor:otherButtonTitleColor forState:UIControlStateNormal];
            if (cancelButtonTitle.length > 0) {
                btn.frame = CGRectMake(CUSTOM_WIDTH/2, y, CUSTOM_WIDTH/2, BUTTON_HEIGHT);
            } else {
                btn.frame = CGRectMake(0, y, CUSTOM_WIDTH, BUTTON_HEIGHT);
            }
            [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.alertView addSubview:btn];
        }
        
        if (cancelButtonTitle.length > 0 && otherButtonTitle.length > 0) {
            UIView *centerLine = [[UIView alloc] initWithFrame:CGRectMake(CUSTOM_WIDTH/2, y, 0.5, BUTTON_HEIGHT)];
            centerLine.backgroundColor = ColorFromHex(0xDDDDDE);
            [_alertView addSubview:centerLine];
        }
        
        CGFloat height = y + BUTTON_HEIGHT;
        [self setFrame:(CGRect){0, 0, SCREEN_SIZE}];
        [self.alertView setFrame:CGRectMake((SCREEN_SIZE.width-CUSTOM_WIDTH)/2, self.center.y-height/2, CUSTOM_WIDTH, height)];
        [self.backWindow addSubview:self];
        self.backWindow.hidden = YES;
    }
    return self;
}

/// 弹框初始化，竖排按钮
/// @param title title
/// @param message message
/// @param btnTitleArr @[按钮]
- (instancetype)initWithTitle:(nonnull NSString *)title message:(nullable NSString *)message verticalButtonTitles:(nullable NSArray<NSString *> *)btnTitleArr {
    if (btnTitleArr.count == 0) {
        return nil;
    }
    if (self = [super init]) {
        [self addSubview:self.darkView];
        [self addSubview:self.alertView];
        
        CGFloat y = 20;
        // 如果标题为空 信息不为空 就把标题和信息调换一下
        if (title.length == 0 && message) {
            NSString *temp = title;
            title = message;
            message = temp;
        }
        
        if (title.length > 0) {
            // 顶部标题
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, y, CUSTOM_WIDTH-32, 20)];
            titleLabel.font = [UIFont fontWithName:FontTypePingFangMe size:17];
            titleLabel.numberOfLines = 0;
            titleLabel.text = title;
            [titleLabel sizeToFit];
            titleLabel.frame = CGRectMake(16, y, CUSTOM_WIDTH-32, titleLabel.frame.size.height);
            titleLabel.textColor = ColorFromHex(0x292933);
            titleLabel.textAlignment = NSTextAlignmentCenter;
            [self.alertView addSubview:titleLabel];
            y = CGRectGetMaxY(titleLabel.frame) + 10;
        }
        
        if (message.length > 0) {
            UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, y, CUSTOM_WIDTH-32, 20)];
            messageLabel.font = [UIFont fontWithName:FontTypePingFangRe size:14];
            messageLabel.numberOfLines = 0;
            messageLabel.text = message;
            [messageLabel sizeToFit];
            messageLabel.frame = CGRectMake(16, y, CUSTOM_WIDTH-32, messageLabel.frame.size.height);
            messageLabel.textColor = ColorFromHex(0x676773);
            messageLabel.textAlignment = NSTextAlignmentCenter;
            [self.alertView addSubview:messageLabel];
            self.messageLabel = messageLabel;
            y = CGRectGetMaxY(messageLabel.frame) + 10;
        }
        
        if (title.length == 0 && message.length == 0){
            y = 0;
        }
        
        for (int i = 0; i < btnTitleArr.count; i ++) {
            // 按钮中间分隔线
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, y, CUSTOM_WIDTH, 0.5)];
            line.backgroundColor = ColorFromHex(0xDDDDDE);
            [_alertView addSubview:line];
            y += 0.5;
            
            // 按钮
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, y, CUSTOM_WIDTH, BUTTON_HEIGHT);
            btn.tag = BUTTON_TAG + i;
            [btn setTitle:btnTitleArr[i] forState:UIControlStateNormal];
            if (i != btnTitleArr.count - 1) {
                btn.titleLabel.font = [UIFont systemFontOfSize:17];
                [btn setTitleColor:ColorFromHex(0x292933) forState:UIControlStateNormal];
            }else{//最后一个为绿色
                [btn setTitleColor:ColorFromHex(0x00B377) forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont fontWithName:FontTypePingFangMe size:17.f];
            }
            [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.alertView addSubview:btn];
            y = CGRectGetMaxY(btn.frame);
        }
        
        CGFloat height = y;//最后一个按钮的MaxY，就是弹框的高度
        [self setFrame:(CGRect){0, 0, SCREEN_SIZE}];
        [self.alertView setFrame:CGRectMake((SCREEN_SIZE.width-CUSTOM_WIDTH)/2, self.center.y-height/2, CUSTOM_WIDTH, height)];
        [self.backWindow addSubview:self];
        self.backWindow.hidden = YES;
    }
    return self;
}

/// 弹框初始化，竖排按钮
/// @param title 标题
/// @param message 信息
/// @param btnTitleArr @[按钮集合]
/// @param selectedBlock 点击回调返回index
+ (void)showAlertWithTitle:(nonnull NSString *)title message:(nullable NSString *)message verticalButtonTitles:(nullable NSArray<NSString *> *)btnTitleArr selectedBlock:(void (^)(NSInteger index))selectedBlock{
    ZBAlertView *alert = [[ZBAlertView alloc]initWithTitle:title message:message buttonTitles:btnTitleArr];
    alert.selectedBlock = selectedBlock;
    [alert show];
}

#pragma mark - action
- (void)show {
    _backWindow.hidden = NO;
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animation];
    bounceAnimation.duration = 0.3;
    bounceAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    bounceAnimation.values = [NSArray arrayWithObjects:
                              [NSNumber numberWithFloat:0.8],
                              [NSNumber numberWithFloat:1.05],
                              [NSNumber numberWithFloat:0.98],
                              [NSNumber numberWithFloat:1.0],
                              nil];
    
    [self.alertView.layer addAnimation:bounceAnimation forKey:@"transform.scale"];
    [UIView animateWithDuration:0.25 animations:^{
        self.darkView.alpha = 0.5;
        //        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.darkView.alpha = 0;
        [self removeFromSuperview];
    } completion:^(BOOL finished) {
        self.backWindow.hidden = YES;
        [self.darkView removeFromSuperview];
    }];
}

- (void)buttonAction:(UIButton *)btn {
    [self dismiss];
    if (self.completionBlock) {
        self.completionBlock(btn.tag-BUTTON_TAG);
    }
    if (self.selectedBlock) {
        self.selectedBlock(btn.tag-BUTTON_TAG);
    }
}

#pragma mark - set
- (void)setForce:(BOOL)force {
    _force = force;
    if (force) {
        for (UIGestureRecognizer *ges in self.darkView.gestureRecognizers) {
            [self.darkView removeGestureRecognizer:ges];
        }
    } else {
        // 点击灰色背景取消弹框
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [self.darkView addGestureRecognizer:tap];
    }
}

- (void)setMessageAlignment:(NSTextAlignment)messageAlignment {
    _messageAlignment = messageAlignment;
    if (self.messageLabel) {
        self.messageLabel.textAlignment = messageAlignment;
    }
}

#pragma mark - lazy
- (UIWindow *)backWindow {
    if (!_backWindow) {
        UIWindow *window = [[UIWindow alloc] initWithFrame: [UIScreen mainScreen].bounds];
        window.windowLevel = UIWindowLevelStatusBar;
        window.backgroundColor = [UIColor clearColor];
        window.hidden = NO;
        _backWindow = window;
    }
    return _backWindow;
}

- (UIView *)darkView {
    if (!_darkView) {
        UIView *view = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        view.alpha = 0;
        view.userInteractionEnabled = NO;
        [view setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
        _darkView = view;
    }
    return _darkView;
}

- (UIView *)alertView {
    if (!_alertView) {
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 4.f;
        view.layer.masksToBounds = YES;
        //        view.backgroundColor = UIColor.redColor;
        _alertView = view;
    }
    return _alertView;
}


@end
