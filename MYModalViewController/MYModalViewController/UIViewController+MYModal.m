//
//  UIViewController+MYModal.m
//  MYUtils
//
//  Created by sunjinshuai on 2017/8/23.
//  Copyright © 2017年 com.51fanxing. All rights reserved.
//

#import "UIViewController+MYModal.h"
#import "MYModalViewController.h"

@implementation UIViewController (MYModal)

- (void)showModalViewController:(UIViewController *)controller
                      showScale:(CGFloat)scale {
    [self showModalViewController:controller showScale:scale showDirection:MYModalContentViewShowDirectionRight showCompletionBlock:nil];
}

- (void)showModalViewController:(UIViewController *)controller
            showCompletionBlock:(MYModalViewControllerShowCompletionBlock)completionBlock {
    [self showModalViewController:controller showScale:1.0 showDirection:MYModalContentViewShowDirectionRight showCompletionBlock:completionBlock];
}

- (void)showModalViewController:(UIViewController *)controller
                      showScale:(CGFloat)scale
            showCompletionBlock:(MYModalViewControllerShowCompletionBlock)completionBlock {
    [self showModalViewController:controller showScale:scale showDirection:MYModalContentViewShowDirectionRight showCompletionBlock:completionBlock];
}

- (void)showModalViewController:(UIViewController *)controller
                      showScale:(CGFloat)scale
                  showDirection:(MYModalContentViewShowDirection)direction
            showCompletionBlock:(MYModalViewControllerShowCompletionBlock)completionBlock {
    
    MYModalViewController *modal = [MYModalViewController sharedModalViewController];
    [modal showModalViewWithController:controller showScale:scale showDirection:direction superViewController:self showCompletionBlock:completionBlock];
}

- (void)showModalViewControllerToWindow:(UIViewController *)controller
                              showScale:(CGFloat)scale {
    [self showModalViewControllerToWindow:controller showScale:scale showDirection:MYModalContentViewShowDirectionRight showCompletionBlock:nil];
}

- (void)showModalViewControllerToWindow:(UIViewController *)controller
                              showScale:(CGFloat)scale
                          showDirection:(MYModalContentViewShowDirection)direction
                    showCompletionBlock:(MYModalViewControllerShowCompletionBlock)completionBlock {
    MYModalViewController *modal = [MYModalViewController sharedModalViewController];
    [modal showModalViewWithController:controller showScale:scale showDirection:direction superViewController:modal showCompletionBlock:completionBlock];
    
}

- (void)hiddenModalViewControllerWithHiddenCompletionBlock:(MYModalViewControllerHiddenCompletionBlock)completionBlock {
    MYModalViewController *modal = [MYModalViewController sharedModalViewController];
    [modal hiddenModalViewController:self hiddenCompletionBlock:completionBlock];
}

- (void)hiddenModalViewController {
    [self hiddenModalViewControllerWithHiddenCompletionBlock:nil];
}

@end
