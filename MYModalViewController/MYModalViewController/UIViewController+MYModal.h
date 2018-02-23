//
//  UIViewController+MYModal.h
//  MYUtils
//
//  Created by sunjinshuai on 2017/8/23.
//  Copyright © 2017年 com.51fanxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYModalMacros.h"

@interface UIViewController (MYModal)

/**
 弹出一个控制器在当前的控制器之上. (默认从右侧动画形式进入 , 显示的view的size为调用者view同等size)

 @param controller 界面显示的控制器
 @param scale 显示比例 , 取值范围 (0.0~1.0] ,超出范围的值会以默认值0.75的比例显示.
 */
- (void)showModalViewController:(UIViewController *)controller
                      showScale:(CGFloat)scale;

/**
 弹出一个控制器在当前的控制器之上. (默认从右侧动画形式进入 , 显示的view的size为调用者view同等size)

 @param controller 界面显示的控制器
 @param completionBlock 界面显示完成后调用的block
 */
- (void)showModalViewController:(UIViewController *)controller
            showCompletionBlock:(MYModalViewControllerShowCompletionBlock)completionBlock;


/**
 *  弹出一个控制器在当前的控制器之上. (默认从右侧动画形式进入 , 显示的view的宽度为调用者view的宽度 * scale参数) [scale取值为0~1]
 *
 *  @param controller 要显示的控制器
 *  @param scale      显示比例 , 取值范围 (0.0~1.0] ,超出范围的值会以默认值0.75的比例显示.
 *  @param completionBlock     界面显示完成后调用的block
 */
- (void)showModalViewController:(UIViewController *)controller
                      showScale:(CGFloat)scale
            showCompletionBlock:(MYModalViewControllerShowCompletionBlock)completionBlock;

/**
 *  弹出一个控制器在当前的控制器之上. [scale : 弹出的比例]-[direction : 弹出的方向]
 *
 *  @param controller 要显示的控制器
 *  @param scale      显示比例 , 取值范围 (0.0~1.0] ,超出范围的值会以默认值0.75的比例显示.
 *  @param direction  弹出方向 , 见枚举值TFModalViewControllerShowDirection
 *  @param completionBlock     界面显示完成后调用的block
 */
- (void)showModalViewController:(UIViewController *)controller
                      showScale:(CGFloat)scale
                  showDirection:(MYModalContentViewShowDirection)direction
            showCompletionBlock:(MYModalViewControllerShowCompletionBlock)completionBlock;

/**
 *  弹出一个控制器在最上层的window之上. [scale : 弹出的比例]-[direction : 弹出的方向]

 @param controller 要显示的控制器
 @param scale 显示比例 , 取值范围 (0.0~1.0] ,超出范围的值会以默认值0.75的比例显示.
 */
- (void)showModalViewControllerToWindow:(UIViewController *)controller
                              showScale:(CGFloat)scale;

/**
 *  弹出一个控制器在最上层的window之上. [scale : 弹出的比例]-[direction : 弹出的方向]
 *
 *  @param controller 要显示的控制器
 *  @param scale      显示比例 , 取值范围 (0.0~1.0] ,超出范围的值会以默认值0.75的比例显示.
 *  @param direction  弹出方向 , 见枚举值TFModalViewControllerShowDirection
 *  @param completionBlock     界面显示完成后调用的block
 */
- (void)showModalViewControllerToWindow:(UIViewController *)controller
                              showScale:(CGFloat)scale
                          showDirection:(MYModalContentViewShowDirection)direction
                    showCompletionBlock:(MYModalViewControllerShowCompletionBlock)completionBlock;

/**
 隐藏弹出的控制器 , 当界面完全隐藏之后执行block内的代码
 
 @param completionBlock 界面完全隐藏调用的block
 */
- (void)hiddenModalViewControllerWithHiddenCompletionBlock:(MYModalViewControllerHiddenCompletionBlock)completionBlock;

/**
 隐藏弹出的控制器
 */
- (void)hiddenModalViewController;

@end
