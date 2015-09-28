//
//  CDUploadProductImage.h
//  QHMarketShopping
//
//  Created by 李帅 on 14-7-14.
//  Copyright (c) 2014年 bjcdzx. All rights reserved.
//
#import <UIKit/UIKit.h>
typedef void (^didUpload)(NSString *url);
typedef void (^didCancel)(void);

#import <Foundation/Foundation.h>

@interface CDUploadProductImage : NSObject
{
    NSOperationQueue *operationQueue;
    
    didUpload uploadFinish;
    didCancel uploadCancel;
    NSString * uploadURL;
    NSMutableURLRequest * urlRequest;
    
    NSString *reUrl;
    
    NSTimer *timeoutTimer;
    
    //如果是否，不允许返回图片地址
    BOOL canReturn;
    
}

- (instancetype)initWithImage:(UIImage *)image;
- (instancetype)initWithImage:(UIImage *)image uploadUrl:(NSString *)URLString uploadfinish:(didUpload)uploadfinish uploadcancel:(didCancel)uploadcancel;
  
//自定义timer时间
@property (nonatomic) BOOL customTimer;
//timer间隔
@property (nonatomic) int timeInterval;

@property (nonatomic) BOOL showAlert;
@end
