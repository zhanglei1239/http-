//
//  ToastDisplay.h

// 这个class就是直接在屏幕中央打印游戏信息 (内容提示，错误提示）
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ToastDisplay :NSObject
{
    NSMutableArray *_displays;
    BOOL _isShowing;
}

+(ToastDisplay *) sharedToastDisplay;
// 0 = 白色； 1 = 红色
+ (void)showToast:(NSString *)message withColorType:(int)colorType superView:(UIView*)sView;

@end