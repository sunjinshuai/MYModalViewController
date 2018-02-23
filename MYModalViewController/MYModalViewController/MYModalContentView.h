//
//  MYModalContentView.h
//  MYUtils
//
//  Created by sunjinshuai on 2017/8/23.
//  Copyright © 2017年 com.51fanxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYModalMacros.h"

typedef void(^MYModalContentViewAnimationCompletionBlock)(void);

@interface MYModalContentView : UIScrollView

// 在其上展示的控制器
@property (nonatomic, weak) UIViewController *visbleController;

// 初始化方法
- (instancetype)initWithVisibleView:(UIView *)visibleView
                              scale:(CGFloat)scale
                          direction:(MYModalContentViewShowDirection)direction;

// 进场显示动画
- (void)showAnimationInWithCompletionBlock:(MYModalContentViewAnimationCompletionBlock)completionBlock;

// 出场隐藏动画
- (void)showAnimationOutWithCompletionBlock:(MYModalContentViewAnimationCompletionBlock)completionBlock;

@end
