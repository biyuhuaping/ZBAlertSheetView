//
//  ZBCustomSheet.h
//  ZBCustomSheet
//
//  Created by ZB on 2019/6/24.
//  Copyright © 2019 ZB. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZBCustomSheet : UIView

/// 修改性别sheetView
/// @param sex 0:未知，1:男，2:女
/// @param selectedBlock 回调值0:未知，1:男，2:女
+ (void)showSheetViewWithSex:(NSInteger)sex SelectedBlock:(void (^)(NSInteger index))selectedBlock;

@end

NS_ASSUME_NONNULL_END
