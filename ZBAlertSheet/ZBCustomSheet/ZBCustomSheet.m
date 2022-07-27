//
//  ZBCustomSheet.m
//  ZBCustomSheet
//
//  Created by ZB on 2019/6/24.
//  Copyright © 2019 ZB. All rights reserved.
//

#import "ZBCustomSheet.h"

#define KScreenW ([UIScreen mainScreen].bounds.size.width)
#define KScreenH ([UIScreen mainScreen].bounds.size.height)

@interface ZBCustomSheet()

@property (copy, nonatomic) void (^selectedBlock)(NSInteger index);
@property (weak, nonatomic) UIView *maskView;
@property (strong, nonatomic) UIButton *btn1;
@property (strong, nonatomic) UIButton *btn2;

@end

@implementation ZBCustomSheet

+ (void)showSheetViewWithSex:(NSInteger)sex SelectedBlock:(void (^)(NSInteger index))selectedBlock{
    ZBCustomSheet *actionSheet = [[ZBCustomSheet alloc]initWithSex:sex SelectedBlock:selectedBlock];
    actionSheet.selectedBlock = selectedBlock;
    [actionSheet show];
}

- (instancetype)initWithSex:(NSInteger)sex SelectedBlock:(void (^)(NSInteger index))selectedBlock {
    self = [super init];
    if (self) {
        //在keyWindow上添加一个带点透明黑色背景
        UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH)];
        maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        [maskView addGestureRecognizer:singleTap];
        [[UIApplication sharedApplication].keyWindow addSubview:maskView];
        self.maskView = maskView;
        
        //在keyWindow上底部添加一个背景的actionSheet
        self.frame = CGRectMake(0, KScreenH, KScreenW, 0);
        self.backgroundColor = [UIColor clearColor];
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        
        //在keyWindow上底部添加交互view
        UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(15, 0, KScreenW - 30, 180)];
        contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:contentView];
        //给view设置圆角
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:contentView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(12, 12)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = contentView.bounds;
        maskLayer.path = maskPath.CGPath;
        contentView.layer.mask = maskLayer;
        
        CGFloat height = CGRectGetMaxY(contentView.frame) + 0.5;
        CGRect frame = self.frame;
        frame.size.height = height + 54;
        self.frame = frame;
        
        
        //----------- 布局 -------------
        //在contentView上添加两个按钮
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        //        btn1.backgroundColor = [UIColor orangeColor];
        btn1.frame = CGRectMake(0, 0, CGRectGetWidth(contentView.frame)/2, 140);
        [btn1 setImage:[UIImage imageNamed:@"man_icon"] forState:UIControlStateNormal];
        [btn1 setImage:[UIImage imageNamed:@"man_icon_se"] forState:UIControlStateSelected];
        [btn1 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn1.tag = 1;
        [contentView addSubview:btn1];
        self.btn1 = btn1;
        
        UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        //        btn2.backgroundColor = [UIColor orangeColor];
        btn2.frame = CGRectMake(CGRectGetWidth(contentView.frame)/2, 0, CGRectGetWidth(contentView.frame)/2, 140);
        [btn2 setImage:[UIImage imageNamed:@"female_icon"] forState:UIControlStateNormal];
        [btn2 setImage:[UIImage imageNamed:@"female_icon_se"] forState:UIControlStateSelected];
        [btn2 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn2.tag = 2;
        [contentView addSubview:btn2];
        self.btn2 = btn2;
        
        
        UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(btn1.frame)-35, CGRectGetWidth(contentView.frame)/2, 20)];
        lab1.textAlignment = NSTextAlignmentCenter;
        lab1.font = [UIFont systemFontOfSize:13];
        lab1.textColor = [UIColor blackColor];
        lab1.text = @"男";
        [contentView addSubview:lab1];
        
        UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(contentView.frame)/2, CGRectGetMaxY(btn1.frame)-35, CGRectGetWidth(contentView.frame)/2, 20)];
        lab2.textAlignment = NSTextAlignmentCenter;
        lab2.font = [UIFont systemFontOfSize:13];
        lab2.textColor = [UIColor blackColor];
        lab2.text = @"女";
        [contentView addSubview:lab2];
        
        
        UIButton *btnDown = [UIButton buttonWithType:UIButtonTypeCustom];
        //        btnDown.backgroundColor = [UIColor orangeColor];
        btnDown.frame = CGRectMake(0, CGRectGetMaxY(contentView.frame), KScreenW, 50);
        [btnDown setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
        [btnDown addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnDown];
        
        if (sex == 1) {
            self.btn1.selected = YES;
        }else if (sex == 2){
            self.btn2.selected = YES;
        }
    }
    return self;
}

- (void)show {
    self.maskView.alpha = 0;
    [UIView animateWithDuration:0.2f animations:^{
        //在动画过程中禁止遮罩视图响应用户手势
        self.maskView.alpha = 1.0f;
        self.maskView.userInteractionEnabled = NO;
        
        CGRect frame = self.frame;
        frame.origin.y = KScreenH - self.frame.size.height;
        self.frame = frame;
    } completion:^(BOOL finished) {
        //在动画结束后允许遮罩视图响应用户手势
        self.maskView.userInteractionEnabled = YES;
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.2f animations:^{
        CGRect frame = self.frame;
        frame.origin.y = KScreenH;
        self.frame = frame;
        self.maskView.alpha = 0;
    } completion: ^(BOOL finished) {
        [self removeFromSuperview];
        [self.maskView removeFromSuperview];
    }];
}

#pragma mark - button actions
- (void)buttonClicked:(UIButton *)sender {
    self.btn1.selected = NO;
    self.btn2.selected = NO;
    sender.selected = YES;
    self.selectedBlock ? self.selectedBlock(sender.tag) : nil;
}


@end
