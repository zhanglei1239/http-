//
//  ToastForIOS.h
//  促利汇_实体店
//
//  Created by zhanglei on 15/6/9.
//  Copyright (c) 2015年 lei.zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ToastForIOS : NSObject
{
    NSMutableArray * _toastList;
    BOOL _isShowing;
}
typedef void(^MyBlock)(void);
@property (nonatomic,copy)MyBlock block;
+(ToastForIOS *) sharedToastForIOS;
-(void)showToast:(void(^)(void))finishBlock superView:(UIView *)sView;
-(UILabel *)initialToastWithMessage:(NSString *)msg;
@end
