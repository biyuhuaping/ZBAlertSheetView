# ZBAlertView.h 、ZBCustomSheet
自定义AlertView、SheetView：点击透明背景层隐藏视图，根据需求自己定制View,
项目中经常用到自定义到弹出视图，自定义Alert样式、自定义Sheet，点击背景层隐藏视图。


## 1. 导入头文件：
``#import "ZBAlertView.h"``
``#import "ZBCustomSheet.h"``


## 2. 添加代码
alert弹窗
```
- (IBAction)alertBtnAction:(UIButton *)sender {
    NSArray *titleArray = @[@"按钮0",@"按钮1",@"按钮2",@"按钮3"];
    [ZBAlertView showAlertWithTitle:@"付款完成前请不要关闭此窗口，完成付款后请根据您的实际情况点击此按钮" message:nil verticalButtonTitles:titleArray selectedBlock:^(NSInteger index) {
        NSLog(@"点击了%ld",index);
        [sender setTitle:titleArray[index] forState:UIControlStateNormal];
    }];
}
```
sheet弹窗：
```
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
```

## 3. 展示效果：<br/>
![alertAndSheet](https://user-images.githubusercontent.com/5062917/175015024-26314b19-fb1f-4355-b403-99d82656ad7e.gif)

就这么简单就完成了。我这里只展示了一个选择性别的简单视图，提供一种实现方式，有需要的朋友可以根据产品需求修改UI样式实现自己想要的UI。
欢迎有更好实现方式的朋友一起交流，互相学习🙏

<br><br>
简书：https://www.jianshu.com/p/8e2c6a0f2772

CSDN：https://blog.csdn.net/biyuhuaping/article/details/93492001
