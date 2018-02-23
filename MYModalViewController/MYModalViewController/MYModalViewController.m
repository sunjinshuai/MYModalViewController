//
//  MYModalViewController.m
//  MYUtils
//
//  Created by sunjinshuai on 2017/8/23.
//  Copyright © 2017年 com.51fanxing. All rights reserved.
//

#import "MYModalViewController.h"
#import "MYModalContentView.h"
#import "objc/runtime.h"

@interface MYModalViewController ()

@end

@implementation MYModalViewController

static NSString * const MYModalViewKey = @"MYModalView_Key";

static MYModalViewController * _instance;

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)sharedModalViewController {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}


- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}

- (instancetype)init {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super init];
        
        if (_instance) {
            _instance.view.backgroundColor = [UIColor clearColor];
        }
    });
    
    return _instance;
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)showModalViewWithController:(UIViewController *)controller
                          showScale:(CGFloat)scale
                      showDirection:(MYModalContentViewShowDirection)direction
                superViewController:(UIViewController *)superViewController
                showCompletionBlock:(MYModalViewControllerShowCompletionBlock)completionBlock {
    
    /** 参数边界值判断 */
    if (scale <=0 || scale > 1 )
        scale = ModalView_ShowScale_Default;
    
    /** 判断传入的控制器 */
    if (controller == nil || !([controller isKindOfClass:[UIViewController class]])) {
        NSLog(@"[%s--第%d行]--[错误:传入的控制器不能为空或不是控制器类型!]",__func__,__LINE__);
        return;
    }
    
    /** 判断传入的控制器是否是之前经过本方法弹出的未被收回的控制器 */
    MYModalContentView *lastModalView = objc_getAssociatedObject(controller, (__bridge const void *)(MYModalViewKey));
    if (lastModalView) {
        NSLog(@"[%s--第%d行]--[错误:方法使用错误>>请不要将同一个控制器show两次!在第二次show之前先hidden第一次的弹出.]",__func__,__LINE__);
        return;
    }
    
    /** 创建容器view 并将要show的控制器的view加到上面 */
    MYModalContentView *modalView = [[MYModalContentView alloc]
                                    initWithVisibleView:controller.view
                                     scale:scale
                                     direction:direction];
    
    /** 自己添加的这个属性 */
    /** 给要show的控制器添加容器view这个属性 */
    objc_setAssociatedObject(controller, (__bridge const void *)(MYModalViewKey), modalView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    modalView.visbleController = controller;
    
    /** 如果要添加到window上 , 则做这一步判断 */
    if (superViewController == self) {
        UIWindow *lastWindow = [[UIApplication sharedApplication] keyWindow];
        [lastWindow addSubview:self.view];
        self.view.frame = lastWindow.bounds;
    }
    
    /** 将show的控制器添加到其主控制器上 */
    [superViewController addChildViewController:controller];
    [superViewController.view addSubview:modalView];
    /** 设置frame跟主控制一样 */
    modalView.frame = superViewController.view.bounds;
    /** 在show的过程中 , 禁止用户界面交互 */
    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = NO;
    /** 开始动画showView */
    [modalView showAnimationInWithCompletionBlock:^{
        [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
        if (completionBlock)
            completionBlock();
    }];
}

- (void)hiddenModalViewController:(UIViewController *)controller
            hiddenCompletionBlock:(MYModalViewControllerHiddenCompletionBlock)completionBlock {
    UIViewController *willRemoveVC = controller;
    
    MYModalContentView *modalContentView = objc_getAssociatedObject(willRemoveVC, (__bridge const void *)(MYModalViewKey));
    
    if (!modalContentView) {
        modalContentView = objc_getAssociatedObject(willRemoveVC.navigationController, (__bridge const void *)(MYModalViewKey));
        
        if (modalContentView) {
            NSInteger vcCount = willRemoveVC.navigationController.viewControllers.count;
            
            if (vcCount > 1) {
                [willRemoveVC.navigationController popViewControllerAnimated:YES];
                return;
            } else {
                willRemoveVC = willRemoveVC.navigationController;
            }
        }
    }
    
    if (!modalContentView) {
        NSLog(@"[%s--第%d行]--[警告:该控制器不是经过[self showTFModalView...]系列方法弹出的 , 无法用该方法隐藏!]",__func__,__LINE__);
        
        UINavigationController *nvc = (UINavigationController *)([controller isKindOfClass:[UINavigationController class]] ? controller : controller.navigationController);
        
        NSInteger vcCount = nvc.viewControllers.count;
        
        if (vcCount > 1) {
            [nvc popViewControllerAnimated:YES];
        } else {
            [controller dismissViewControllerAnimated:YES completion:nil];
        }
        return;
    }
    
    /** 在隐藏界面过程中 , 禁止用户交互 */
    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = NO;
    [modalContentView showAnimationOutWithCompletionBlock:^{
        [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
        
        if (completionBlock) {
            completionBlock();
        }
        
        /** 移除添加的属性 */
        objc_removeAssociatedObjects(willRemoveVC);
        
        /** 如果这个view是添加到window上的 , 则需要做这一步判断处理 */
        if (modalContentView.superview == self.view && self.childViewControllers.count <= 1) {
            [self.view removeFromSuperview];
        }
        
        /** 销毁弹出的控制器 */
        [modalContentView removeFromSuperview];
        [willRemoveVC removeFromParentViewController];
    }];
}

@end
