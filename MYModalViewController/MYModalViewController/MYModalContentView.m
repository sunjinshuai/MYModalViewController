//
//  MYModalContentView.m
//  MYUtils
//
//  Created by sunjinshuai on 2017/8/23.
//  Copyright © 2017年 com.51fanxing. All rights reserved.
//

#import "MYModalContentView.h"
#import "UIViewController+MYModal.h"

@interface MYModalContentView ()

// 遮板
@property (nonatomic, strong) UIView *backgroundView;
// 要显示的view
@property (nonatomic, weak) UIView *visibleView;
// 要显示的view的显示比例
@property (nonatomic, assign) CGFloat scale;
// 要显示的view的入场方向
@property (nonatomic, assign) MYModalContentViewShowDirection direction;
// 动画进行标志位
@property (nonatomic, assign) BOOL animationOutFlag;
// 记录visbleView最初显示的真实center
@property (nonatomic, assign) CGPoint defalutCenter;

@end

@implementation MYModalContentView

- (instancetype)initWithVisibleView:(UIView *)visibleView
                              scale:(CGFloat)scale
                          direction:(MYModalContentViewShowDirection)direction {
    if (self = [super init]) {
        
        if (scale <= 0 || scale >1) {
            scale = ModalView_ShowScale_Default;
        }
        
        if (!visibleView) {
            return self;
        }
        
        self.backgroundView = [[UIView alloc] init];
        self.backgroundView.backgroundColor = MY_ModalView_Background_Color;
        self.backgroundView.alpha = MY_ModalView_Background_Alpha;
        
        [self addSubview:self.backgroundView];
        
        [self addSubview:visibleView];
        self.visibleView = visibleView;
        self.visibleView.hidden = YES;
        
        self.scale = scale;
        self.direction = direction;
        
        /** 初始化容器属性 */
        self.backgroundColor = [UIColor clearColor];
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.scrollEnabled = NO;
        
        /** 添加手势 */
        [self addMyRecognizerToBackgroundView];
        
        /** 设置KVO监听 */
        [self.visibleView addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
    
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    // 根据visbleView的center的变化来改变背景透明度
    if (object == self.visibleView && [keyPath isEqualToString:@"center"]) {
        NSValue *point = change[@"new"];
        
        CGFloat scale = 0.0f;
        
        switch (self.direction) {
            case MYModalContentViewShowDirectionLeft:
            case MYModalContentViewShowDirectionRight: {
                
                CGFloat newX = point.CGPointValue.x;
                CGFloat offsetX = newX - self.defalutCenter.x;
                scale = fabs(offsetX) / self.visibleView.bounds.size.width;
            }
                break;
                
            case MYModalContentViewShowDirectionTop:
            case MYModalContentViewShowDirectionBottom: {
                
                CGFloat newY = point.CGPointValue.y;
                CGFloat offsetY = newY - self.defalutCenter.y ;
                scale = fabs(offsetY) / self.visibleView.bounds.size.height;
            }
                break;
            default:
                break;
        }
        
        if (scale > 1.0) {
            scale = 1.0;
        }
        self.backgroundView.alpha = (1 - scale) * MY_ModalView_Background_Alpha;
    }
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    // 布局自身的frame属性
    [self layoutSelf];
    
    // 布局底层遮板
    [self layoutMyBackgroundView];
    
    // 如果正在动画 ,则这里不改变visibleView的frame
    if (!self.animationOutFlag) {
        // 布局visibleView
        [self layoutMyVisibleView];
    }
}

// 布局自身的frame属性
- (void)layoutSelf {
    self.frame = self.superview.bounds;
    self.contentSize = self.bounds.size;
}

// 布局底层遮板
- (void)layoutMyBackgroundView {
    self.backgroundView.frame = self.bounds;
}

// 布局visibleView
- (void)layoutMyVisibleView {
    
    /** 计算visibleView的size */
    CGSize size = CGSizeZero;
    
    /** 根据入场方向设置size */
    switch (self.direction) {
        case MYModalContentViewShowDirectionLeft:
        case MYModalContentViewShowDirectionRight: {
            
            CGFloat height = self.bounds.size.height;
            CGFloat width = self.bounds.size.width * self.scale;
            
            size = CGSizeMake(width, height);
        }
            break;
            
        case MYModalContentViewShowDirectionTop:
        case MYModalContentViewShowDirectionBottom: {
        
            CGFloat height = self.bounds.size.height * self.scale;
            CGFloat width = self.bounds.size.width ;
            
            size = CGSizeMake(width, height);
        }
            break;
            
        default:
            NSLog(@"[%s--第%d行]--[错误:进场方向参数传入错误!]",__func__,__LINE__);
            break;
    }
    
    
    /** 计算visibleView的位置 */
    CGPoint point = CGPointZero;
    
    /** 根据入场方向设置size */
    switch (self.direction) {
        case MYModalContentViewShowDirectionLeft:
        case MYModalContentViewShowDirectionTop: {
        
            CGFloat x = 0;
            CGFloat y = 0;
            
            point = CGPointMake(x, y);
        }
            break;
            
        case MYModalContentViewShowDirectionRight: {
        
            CGFloat x = self.bounds.size.width - size.width;
            CGFloat y = 0;
            
            point = CGPointMake(x, y);
        }
            break;
        case MYModalContentViewShowDirectionBottom: {
        
            CGFloat x = 0;
            CGFloat y = self.bounds.size.height - size.height;
            
            point = CGPointMake(x, y);
        }
            break;
            
        default:
            NSLog(@"[%s--第%d行]--[错误:进场方向参数传入错误!]",__func__,__LINE__);
            break;
    }
    
    
    /** 计算visibleView的frame */
    CGRect rect = CGRectMake(point.x, point.y, size.width, size.height);
    self.visibleView.frame = rect;
    self.defalutCenter = self.visibleView.center;
}

// 进场显示动画
- (void)showAnimationInWithCompletionBlock:(MYModalContentViewAnimationCompletionBlock)completionBlock {
    /** 设置visibleView的动画效果 : 进场 */
    [self setVisibleViewTransformForAnimationIn];
    
    self.backgroundView.alpha = 0.0;
    
    [UIView animateWithDuration:MY_Animation_Show_Duration animations:^{
        
        self.visibleView.hidden = NO;
        self.visibleView.alpha = 1.0;
        self.visibleView.transform = CGAffineTransformIdentity;
        self.userInteractionEnabled = NO;
        
        self.backgroundView.alpha = MY_ModalView_Background_Alpha;
    } completion:^(BOOL finished) {
        self.userInteractionEnabled = YES;
        if (completionBlock)
            completionBlock();
    }];
}

// 出场隐藏动画
- (void)showAnimationOutWithCompletionBlock:(MYModalContentViewAnimationCompletionBlock)completionBlock {
    self.animationOutFlag = YES;
    
    self.visibleView.transform = CGAffineTransformIdentity;
    
    [UIView animateWithDuration:MY_Animation_Show_Duration animations:^{
        
        self.userInteractionEnabled = NO;
        [self setVisibleViewTransformForAnimationOut];
        
        self.backgroundView.alpha = 0.0;
    } completion:^(BOOL finished) {
        
        self.visibleView.hidden = YES;
        self.animationOutFlag = NO;
        self.userInteractionEnabled = YES;
        
        if (completionBlock)
            completionBlock();
    }];
}

// 设置visibleView的动画效果 : 进场
- (void)setVisibleViewTransformForAnimationIn {
    switch (self.direction) {
        case MYModalContentViewShowDirectionRight:
            self.visibleView.transform = CGAffineTransformMakeTranslation(self.visibleView.bounds.size.width, 0);
            break;
            
        case MYModalContentViewShowDirectionLeft:
            self.visibleView.transform = CGAffineTransformMakeTranslation(0 - self.visibleView.bounds.size.width, 0);
            break;
            
        case MYModalContentViewShowDirectionTop:
            self.visibleView.transform = CGAffineTransformMakeTranslation(0, 0 - self.visibleView.bounds.size.height);
            break;
        case MYModalContentViewShowDirectionBottom:
            self.visibleView.transform = CGAffineTransformMakeTranslation(0, self.visibleView.bounds.size.height);
            break;
        default:
            break;
    }
}

// 设置visibleView的动画效果 : 出场
- (void)setVisibleViewTransformForAnimationOut {
    
    switch (self.direction) {
        case MYModalContentViewShowDirectionRight:
            
            self.visibleView.transform = CGAffineTransformMakeTranslation(self.visibleView.bounds.size.width , 0);
            break;
            
        case MYModalContentViewShowDirectionLeft:
            
            self.visibleView.transform = CGAffineTransformMakeTranslation(0 - self.visibleView.bounds.size.width, 0);
            break;
            
        case MYModalContentViewShowDirectionTop:
            
            self.visibleView.transform = CGAffineTransformMakeTranslation(0, 0 - self.visibleView.bounds.size.height);
            break;
            
        case MYModalContentViewShowDirectionBottom:
            
            self.visibleView.transform = CGAffineTransformMakeTranslation(0, self.visibleView.bounds.size.height);
            break;
        default:
            break;
    }
}

// 根据偏移量移动visbleView
- (void)moveVisbleViewWithOffset:(CGPoint)offset {
    
    switch (self.direction) {
        case MYModalContentViewShowDirectionLeft:
            if (CGRectGetMaxX(self.visibleView.frame) + offset.x >= self.visibleView.bounds.size.width)
                return;
            break;
            
        case MYModalContentViewShowDirectionRight:
            if (CGRectGetMaxX(self.visibleView.frame) + offset.x <= self.bounds.size.width)
                return;
            break;
            
        case MYModalContentViewShowDirectionTop:
            if (CGRectGetMaxY(self.visibleView.frame) + offset.y >= self.visibleView.bounds.size.height)
                return;
            break;
            
        case MYModalContentViewShowDirectionBottom:
            if (CGRectGetMaxY(self.visibleView.frame) + offset.y <= self.bounds.size.height)
                return;
            break;
            
        default:
            break;
    }
    
    
    switch (self.direction) {
        case MYModalContentViewShowDirectionLeft: {
        
            CGFloat x = self.defalutCenter.x + offset.x;
            x = x >= self.defalutCenter.x ? self.defalutCenter.x : x;
            self.visibleView.center = CGPointMake(x, self.visibleView.center.y);
        }
            break;
        case MYModalContentViewShowDirectionRight: {
        
            CGFloat x = self.defalutCenter.x + offset.x;
            x = x <= self.defalutCenter.x ? self.defalutCenter.x : x;
            self.visibleView.center = CGPointMake(x, self.visibleView.center.y);
        }
            break;
            
        case MYModalContentViewShowDirectionTop: {
        
            CGFloat y = self.defalutCenter.y + offset.y;
            y = y >= self.defalutCenter.y ? self.defalutCenter.y : y;
            self.visibleView.center = CGPointMake(self.visibleView.center.x , y);
        }
            break;
        case MYModalContentViewShowDirectionBottom: {
        
            CGFloat y = self.defalutCenter.y + offset.y;
            y = y <= self.defalutCenter.y ? self.defalutCenter.y : y;
            self.visibleView.center = CGPointMake(self.visibleView.center.x , y);
        }
            break;
            
        default:
            break;
    }
}

// 以动画形式隐藏或复位visbleView
- (void)showAinmationForVisbleViewWithOffset:(CGPoint)offset {
    
    CGFloat x = offset.x + self.visibleView.bounds.size.width * MY_ModalView_ShowHiddenAnimation_Scale;
    CGFloat y = offset.y + self.visibleView.bounds.size.height * MY_ModalView_ShowHiddenAnimation_Scale;
    /** 根据偏移量计算是否隐藏visbleView */
    if ((x < 0 && self.direction == MYModalContentViewShowDirectionLeft) ||
        (x > (self.visibleView.bounds.size.width * MY_ModalView_ShowHiddenAnimation_Scale * 2 )&& self.direction == MYModalContentViewShowDirectionRight) ||
        (y < 0 && self.direction == MYModalContentViewShowDirectionTop) ||
        (y > (self.visibleView.bounds.size.height * MY_ModalView_ShowHiddenAnimation_Scale * 2 ) && self.direction == MYModalContentViewShowDirectionBottom)
        ) {
        [self.visbleController hiddenModalViewController];
    } else {
        /** 在隐藏界面过程中 , 禁止用户交互 */
        [UIApplication sharedApplication].keyWindow.userInteractionEnabled = NO;
        
        [UIView animateWithDuration:0.5 animations:^{
            self.userInteractionEnabled = NO;
            self.visibleView.center = self.defalutCenter;
        } completion:^(BOOL finished) {
            self.userInteractionEnabled = YES;
            [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
        }];
    }
}

// 添加蒙板手势
- (void)addMyRecognizerToBackgroundView
{
    /** 添加蒙板点击手势 */
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] init];
    
    [self.backgroundView addGestureRecognizer:tapGR];
    
    [tapGR addTarget:self action:@selector(tapGestureRecognizerInBackgroundView:)];
}

// 蒙板点击手势跟拖拽手势的触发方法
- (void)tapGestureRecognizerInBackgroundView:(UIGestureRecognizer *)gestureRecognizer {
    
    [self.visbleController hiddenModalViewController];
}

- (void)dealloc {
    [self.visibleView removeObserver:self forKeyPath:@"center"];
}

@end
