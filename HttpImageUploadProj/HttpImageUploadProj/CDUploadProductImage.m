//
//  CDUploadProductImage.m
//  QHMarketShopping
//
//  Created by 李帅 on 14-7-14.
//  Copyright (c) 2014年 bjcdzx. All rights reserved.
//
#define BOUNDARY                           @"cH2gL6ei4Ef1KM7cH2KM7ae0ei4gL6"
#import "CDUploadProductImage.h"

@implementation CDUploadProductImage
@synthesize showAlert;

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image
{
    self = [super init];
    if (self) {
        [self performSelector:@selector(uploadingPicture:) withObject:image afterDelay:0.1];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image uploadUrl:(NSString *)URLString uploadfinish:(didUpload)uploadfinish uploadcancel:(didCancel)uploadcancel{
    
    uploadFinish = uploadfinish;
    uploadCancel = uploadcancel;
    uploadURL = URLString;
    canReturn = YES;
    showAlert = YES;
    
    return [self initWithImage:image];
}

- (void)uploadingPicture:(UIImage *)aImage
{
    if (_customTimer) {
        timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:_timeInterval target:self selector:@selector(didTimeOut) userInfo:nil repeats:YES];
    }else{
        timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(didTimeOut) userInfo:nil repeats:YES];
    }
    
    NSMutableURLRequest *myRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:uploadURL]
                                                                  cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                              timeoutInterval:30];
    
    NSMutableData *body = [NSMutableData data];
    
    NSString *fileName = [self createUUID];
    
    NSString *param2 = [NSString stringWithFormat:@"--%@\r\n Content-Disposition: form-data; name=\"%@\" \r\n\r\n%@\r\n",BOUNDARY,@"fileType",@"1",nil];
    
    [body appendData:[param2 dataUsingEncoding:NSUTF8StringEncoding]];
    
     NSString *param3 = [NSString stringWithFormat:@"--%@\r\n Content-Disposition: form-data; name=\"%@\"; filename=\"%@\" \r\n Content-Type: image/pjpeg\r\n\r\n",BOUNDARY,@"file",fileName,nil];
    
    [body appendData:[param3 dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSData *imageData = nil;
    
    imageData = UIImageJPEGRepresentation(aImage, 1.0);
    
    [body appendData:imageData];
    
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *endString = [NSString stringWithFormat:@"--%@--",BOUNDARY];
    
    [body appendData:[endString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [myRequest setHTTPBody:body];
    
    [myRequest setHTTPMethod:@"POST"];
    
    [myRequest setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", BOUNDARY]
     forHTTPHeaderField:@"Content-Type"];
    
    [myRequest setValue:[NSString stringWithFormat:@"%d",body.length] forHTTPHeaderField:@"Content-Length"];
 
    NSOperation *otherOperation = [[NSOperation alloc]init];
    operationQueue = [[NSOperationQueue alloc] init];
    [operationQueue addOperation:otherOperation];
    
    [NSURLConnection sendAsynchronousRequest:myRequest queue:operationQueue completionHandler:^(NSURLResponse* response1, NSData* data1, NSError* connectionError1){
        if (nil != response1 && nil != data1) {
            NSData *returnData = data1;
            id jsonObj = [NSJSONSerialization JSONObjectWithData:returnData options:noErr error:nil];
            NSDictionary *dic = jsonObj;
            NSString *url = [dic objectForKey:@"fileUrl"];
            reUrl = url;
            
            if (canReturn) {
                showAlert = NO;
                uploadFinish(reUrl);
            }
        }else{
            
        }
        
    }];
}

- (NSString *) createUUID {
    CFUUIDRef uuidObject = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef uuidRef = CFUUIDCreateString(kCFAllocatorDefault, uuidObject);
    NSString *uuidStr = (__bridge NSString *)uuidRef;
    CFRelease(uuidObject);
    return [NSString stringWithFormat:@"%@",uuidStr];
}

- (void)didTimeOut{
    if (showAlert) {
        UIAlertController * controller = [UIAlertController alertControllerWithTitle:@"" message:@"网络环境不佳，图片上传缓慢，请您在wifi或者3g情况下上传图片，是否继续等待" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            canReturn = YES;
            showAlert = YES;
            
            if (nil != reUrl) {
                showAlert = NO;
                uploadFinish(reUrl);
                
                [self disconnect];
                [timeoutTimer invalidate];
            }
        }];
        UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self disconnect];
            uploadCancel();
            [timeoutTimer invalidate];
        }];
        [controller addAction:action1];
        [controller addAction:action2];
        canReturn = NO;
        showAlert = NO;
    }
}

- (void)disconnect{
    [operationQueue cancelAllOperations];
    operationQueue = nil;
}

- (NSString *)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData* imageData = UIImagePNGRepresentation(tempImage);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    // and then we write it out
    [imageData writeToFile:fullPathToFile atomically:NO];
    return fullPathToFile;
}
@end
