//
//  ViewController.m
//  ZBCustomSheet
//
//  Created by ZB on 2019/6/24.
//  Copyright © 2019 ZB. All rights reserved.
//

#import "ViewController.h"
#import "ZBCustomSheet.h"
#import "ZBAlertView.h"
#import "ZBShareSheetView.h"

@interface ViewController ()

@property (assign, nonatomic) NSInteger sex;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//对话框
- (IBAction)alertBtnAction:(UIButton *)sender {
    NSArray *titleArray = @[@"按钮0",@"按钮1",@"按钮2",@"按钮3"];
    [ZBAlertView showAlertWithTitle:@"付款完成前请不要关闭此窗口，完成付款后请根据您的实际情况点击此按钮" message:nil verticalButtonTitles:titleArray selectedBlock:^(NSInteger index) {
        NSLog(@"点击了%ld",index);
        [sender setTitle:titleArray[index] forState:UIControlStateNormal];
    }];
}

//选择性别
- (IBAction)sheetBtnAction:(UIButton *)sender {
    [ZBCustomSheet showSheetViewWithSex:self.sex SelectedBlock:^(NSInteger index) {
        NSLog(@"------> index: %ld", index);
        self.sex = index;
        NSString *title = @"选择性别";
        if (index == 1) {
            title = @"男";
        }else if (index == 2){
            title = @"女";
        }
        [sender setTitle:title forState:UIControlStateNormal];
    }];
}

//分享
- (IBAction)sheetShareAction:(UIButton *)sender {
    [ZBShareSheetView showSheetViewComplete:^(int clickType) {
        NSLog(@"点击了：%d",clickType);
    }];
}

@end
