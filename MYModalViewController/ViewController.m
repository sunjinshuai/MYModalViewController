//
//  ViewController.m
//  MYModalViewController
//
//  Created by sunjinshuai on 2018/2/23.
//  Copyright © 2018年 MYModalViewController. All rights reserved.
//

#import "ViewController.h"
#import "MYModalMacros.h"
#import "UIViewController+MYModal.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    UIButton *topButton = [UIButton buttonWithType:UIButtonTypeCustom];
    topButton.frame = CGRectMake((width - 100)/2, 200, 100, 50);
    topButton.backgroundColor = [UIColor redColor];
    [topButton setTitle:@"上" forState:UIControlStateNormal];
    [topButton addTarget:self action:@selector(topButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:topButton];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(30, CGRectGetMaxY(topButton.frame) + 50, 100, 50);
    leftButton.backgroundColor = [UIColor blueColor];
    [leftButton setTitle:@"左" forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(width - 30 - 100, CGRectGetMaxY(topButton.frame) + 50, 100, 50);
    rightButton.backgroundColor = [UIColor brownColor];
    [rightButton setTitle:@"右" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightButton];
    
    UIButton *bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bottomButton.frame = CGRectMake((width - 100)/2, CGRectGetMaxY(leftButton.frame) + 50, 100, 50);
    bottomButton.backgroundColor = [UIColor greenColor];
    [bottomButton setTitle:@"下" forState:UIControlStateNormal];
    [bottomButton addTarget:self action:@selector(bottomButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomButton];
}

- (void)topButtonClick {
    
    UIViewController *test = [UIViewController new];
    test.view.backgroundColor = [UIColor blueColor];
    [self showModalViewController:test showScale:0.78 showDirection:MYModalContentViewShowDirectionTop showCompletionBlock:nil];
}

- (void)leftButtonClick {
    UIViewController *test = [UIViewController new];
    test.view.backgroundColor = [UIColor blueColor];
    [self showModalViewController:test showScale:0.78 showDirection:MYModalContentViewShowDirectionLeft showCompletionBlock:nil];
}

- (void)rightButtonClick {
    UIViewController *test = [UIViewController new];
    test.view.backgroundColor = [UIColor blueColor];
    [self showModalViewController:test showScale:0.78 showDirection:MYModalContentViewShowDirectionRight showCompletionBlock:nil];
}

- (void)bottomButtonClick {
    UIViewController *test = [UIViewController new];
    test.view.backgroundColor = [UIColor blueColor];
    [self showModalViewController:test showScale:0.78 showDirection:MYModalContentViewShowDirectionBottom showCompletionBlock:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
