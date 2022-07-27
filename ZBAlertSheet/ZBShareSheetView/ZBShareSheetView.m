//
//  ZBShareSheetView.m
//  LLCRM
//
//  Created by ZB on 2020/7/14.
//  Copyright © 2020 Wuhan lingli. All rights reserved.
//

#import "ZBShareSheetView.h"

#define SHOWTIME 0.25 //显示时间
#define DISSMISSTIME 0.25 //消失时间
#define CORNER 8 //圆角大小

#define kSheetViewHeight 210
typedef void(^SheetBlock)(int clickType);

@interface ZBShareSheetView()

@property (strong, nonatomic) UIView *sheetView;
@property (copy, nonatomic) SheetBlock block;

@end


@implementation ZBShareSheetView

+ (void)showSheetViewComplete:(void (^)(int clickType))block{
    ZBShareSheetView *sheet = [[ZBShareSheetView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [sheet setupView]; //创建视图
    sheet.block = block;
    [sheet show];
}

- (void)setupView{
    self.sheetView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kSheetViewHeight)];
    self.sheetView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.sheetView];
    
    UIButton *cancleBtn = [[UIButton alloc] init];
    cancleBtn.frame = CGRectMake(10, kSheetViewHeight-80, kScreenWidth - 20, 60);
    [cancleBtn setTitle:@"取消" forState:(UIControlStateNormal)];
    [cancleBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    cancleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    cancleBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [cancleBtn setBackgroundColor:[UIColor whiteColor]];
    [cancleBtn addTarget:self action:@selector(dissmiss) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMinY(cancleBtn.frame) - 120 - 10, kScreenWidth - 20, 120)];
    contentView.backgroundColor = [UIColor whiteColor];
    
    
    
    UIImageView *imgView1 = [[UIImageView alloc]initWithFrame:CGRectMake(30, 15, (kScreenWidth-80)/2, 55)];
    imgView1.contentMode = UIViewContentModeScaleAspectFit;
    imgView1.userInteractionEnabled = YES;
    imgView1.image = [UIImage imageNamed:@"share_wx"];
    imgView1.tag = 1;
//    imgView1.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imgView2 = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imgView1.frame), 15, (kScreenWidth-80)/2, 55)];
    imgView2.contentMode = UIViewContentModeScaleAspectFit;
    imgView2.userInteractionEnabled = YES;
    imgView2.image = [UIImage imageNamed:@"share_pyq"];
    imgView2.tag = 2;
//    imgView2.backgroundColor = [UIColor greenColor];
    
    
    
    UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(imgView1.frame), CGRectGetMaxY(imgView1.frame), CGRectGetWidth(imgView1.frame), 40)];
    lab1.textAlignment = NSTextAlignmentCenter;
    lab1.text = @"微信";
//    lab1.backgroundColor = [UIColor greenColor];
    [contentView addSubview:lab1];
    
    UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(imgView2.frame), CGRectGetMaxY(imgView2.frame), CGRectGetWidth(imgView2.frame), 40)];
    lab2.textAlignment = NSTextAlignmentCenter;
    lab2.text = @"朋友圈";
//    lab2.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:lab2];
    
    
    
    UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:contentView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(CORNER, CORNER)];
    CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
    maskLayer1.frame = contentView.bounds;
    maskLayer1.path = maskPath1.CGPath;
    contentView.layer.mask = maskLayer1;
    
    UIBezierPath *maskPath2 = [UIBezierPath bezierPathWithRoundedRect:cancleBtn.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(CORNER, CORNER)];
    CAShapeLayer *maskLayer2 = [[CAShapeLayer alloc] init];
    maskLayer2.frame = cancleBtn.bounds;
    maskLayer2.path = maskPath2.CGPath;
    cancleBtn.layer.mask = maskLayer2;
    
    [contentView addSubview:imgView1];
    [contentView addSubview:imgView2];
    [self.sheetView addSubview:contentView];
    [self.sheetView addSubview:cancleBtn];
}

- (void)show{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [UIView animateWithDuration:SHOWTIME animations:^{
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        self.sheetView.frame = CGRectMake(0, kScreenHeight - kSheetViewHeight, kScreenWidth, kSheetViewHeight);
    }];
}

#pragma mark - dissmiss
- (void)dissmiss{
    [UIView animateWithDuration:DISSMISSTIME animations:^{
        self.alpha = 0;
        self.sheetView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kSheetViewHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

// 点击阴影部分是让视图消失
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[event allTouches] anyObject];
    if ([touch.view isKindOfClass:UIImageView.class]){
        UIImageView *imgView = (UIImageView *)touch.view;
        if (imgView.tag == 1) {//分享给朋友
            NSLog(@"分享给朋友");
        }else if (imgView.tag == 2){//分享到朋友圈
            NSLog(@"分享到朋友圈");
        }
        if (self.block) {
            self.block((int)imgView.tag);
        }
    }
    [self dissmiss];
}


@end
