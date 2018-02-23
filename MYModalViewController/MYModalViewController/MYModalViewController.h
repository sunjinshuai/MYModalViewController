//
//  MYModalViewController.h
//  MYUtils
//
//  Created by sunjinshuai on 2017/8/23.
//  Copyright © 2017年 com.51fanxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYModalMacros.h"

@interface MYModalViewController : UIViewController

+ (instancetype)sharedModalViewController;

/**
 *  弹出一个控制器在当前的控制器之上. [scale : 弹出的比例]-[direction : 弹出的方向]
 *
 *  @param controller 要显示的控制器
 *  @param scale      显示比例 , 取值范围 (0.0~1.0] ,超出范围的值会以默认值0.75的比例显示.
 *  @param direction  弹出方向 , 见枚举值TFModalViewControllerShowDirection
 *  @param superViewController  需要弹出界面的父级控制器
 *  @param completionBlock     界面显示完成后调用的block
 */
- (void)showModalViewWithController:(UIViewController *)controller
                          showScale:(CGFloat)scale
                      showDirection:(MYModalContentViewShowDirection)direction
                superViewController:(UIViewController *)superViewController
                showCompletionBlock:(MYModalViewControllerShowCompletionBlock)completionBlock;

/**
 隐藏弹出的控制器 , 当界面完全隐藏之后执行block内的代码

 @param controller 要隐藏的控制器
 @param completionBlock 界面隐藏完成后调用的block
 */
- (void)hiddenModalViewController:(UIViewController *)controller
            hiddenCompletionBlock:(MYModalViewControllerHiddenCompletionBlock)completionBlock;


@end
