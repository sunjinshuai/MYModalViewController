//
//  MYModalMacros.h
//  MYUtils
//
//  Created by sunjinshuai on 2017/8/23.
//  Copyright © 2017年 com.51fanxing. All rights reserved.
//

#ifndef MYModalMacros_h
#define MYModalMacros_h

/** 界面显示出来后的背景蒙板颜色 */
#define MY_ModalView_Background_Color [UIColor blackColor]
/** 界面显示出来后的背景蒙板透明度 */
#define MY_ModalView_Background_Alpha 0.6
/** 默认的显示比例 */
#define ModalView_ShowScale_Default 0.75
/** 界面显示跟隐藏的动画时间 */
#define MY_Animation_Show_Duration 0.3

/** 拖拽界面时,是否自动隐藏界面的拖拽距离比例 (这个比例系数是指拖拽的位移偏移量跟被拖拽的界面的宽度或高度的比例) 默认0.3 */
#define MY_ModalView_ShowHiddenAnimation_Scale 0.3

typedef NS_ENUM(NSInteger, MYModalContentViewShowDirection) {
    MYModalContentViewShowDirectionRight = 0 ,   // 默认从右边进入
    MYModalContentViewShowDirectionLeft,         // 新控制器从左边进入
    MYModalContentViewShowDirectionTop,          // 新控制器从顶部进入
    MYModalContentViewShowDirectionBottom        // 新控制器从底部进入
};

/** 界面隐藏完全后的回调block */
typedef void(^MYModalViewControllerHiddenCompletionBlock)(void);

/** 界面显示完成后的回调block */
typedef void(^MYModalViewControllerShowCompletionBlock)(void);

#endif /* MYModalMacros_h */
