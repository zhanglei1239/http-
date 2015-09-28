//
//  ToastForIOS.m
//  促利汇_实体店
//
//  Created by zhanglei on 15/6/9.
//  Copyright (c) 2015年 lei.zhang. All rights reserved.
//
#define ToastHeight 40
#define UI_SCREEN_WIDTH                    ([[UIScreen mainScreen] bounds].size.width)
#define UI_SCREEN_HEIGHT                   ([[UIScreen mainScreen] bounds].size.height)
#import "ToastForIOS.h"
#import "SynthesizeSingleton.h"
@implementation ToastForIOS

SYNTHESIZE_SINGLETON_FOR_CLASS(ToastForIOS)

- (id) init
{
    self = [super init];
    
    if (self) {
        _toastList = [NSMutableArray array];
        _isShowing = NO;
    }
    
    return self;
}

-(UILabel *)initialToastWithMessage:(NSString *)msg{
    UILabel * messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,0, UI_SCREEN_WIDTH-40,ToastHeight)];
    
    messageLabel.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
    
    [_toastList addObject:messageLabel];
    
    messageLabel.center =CGPointMake(UI_SCREEN_WIDTH/2, UI_SCREEN_HEIGHT/2);
    
    messageLabel.numberOfLines =0;
    messageLabel.font = [UIFont systemFontOfSize:16];
    messageLabel.lineBreakMode =NSLineBreakByWordWrapping;
    messageLabel.textColor = [UIColor whiteColor];
    messageLabel.textAlignment =NSTextAlignmentCenter;
    messageLabel.backgroundColor = [UIColor blackColor];
    messageLabel.alpha =1.0;
    messageLabel.text = msg;
    return messageLabel;
}

-(void)showToast:(void(^)(void))finishBlock superView:(UIView *)sView{
    self.block = finishBlock;
    UILabel * toast = [_toastList firstObject];
    if (!_isShowing) {
        toast.alpha =0.0;
        [sView addSubview:toast];
        [UIView animateWithDuration:.5
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             toast.alpha =1.0;
                         } completion:^(BOOL finished) {
                             [UIView animateWithDuration:.2+.5
                                                   delay:2
                                                 options:UIViewAnimationOptionCurveEaseIn
                                              animations:^{
                                                  toast.alpha =0.0;
                                              }completion:^(BOOL finished) {
                                                  _isShowing = NO;
                                                  
                                                  [_toastList removeObject:toast]; //把当前的view在array里面移除
                                                  [toast removeFromSuperview];
                                                  if (_toastList.count == 0) {
                                                      if (self.block) {
                                                          self.block();
                                                      }
                                                  }else{
                                                      [self showToast:finishBlock superView:sView];
                                                  }
                                              }];
                         }];
    }
}
@end
