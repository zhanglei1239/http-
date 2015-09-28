//
//  ViewController.m
//  HttpImageUploadProj
//
//  Created by zhanglei on 15/9/28.
//  Copyright © 2015年 lei.zhang. All rights reserved.
//
// 上传地址 自己自定义
#define TEMPUPLOAD @"http://xxxx"

#define UI_SCREEN_WIDTH                    ([[UIScreen mainScreen] bounds].size.width)
#define UI_SCREEN_HEIGHT                   ([[UIScreen mainScreen] bounds].size.height)
#define UI_DeviceSystemVersion             [[UIDevice currentDevice].systemVersion intValue]

#import "ViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "CDUploadProductImage.h"
#import "Toast+UIView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 60)];
    [view setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:view];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, UI_SCREEN_WIDTH, 40)];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setText:@"Http上传图片"];
    [view addSubview:label];
    
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 70, UI_SCREEN_WIDTH-40, 40)];
    [btn setTitle:@"上传" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn addTarget:self action:@selector(upload:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)upload:(id)sender{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"请选择一寸照片" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action1) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *pick = [[UIImagePickerController alloc]init];
            
            pick.sourceType =  UIImagePickerControllerSourceTypeCamera;
            pick.delegate = self;
            pick.allowsEditing = NO;
            
            pick.mediaTypes = [NSArray arrayWithObjects:(NSString*)kUTTypeImage, (NSString*)kUTTypeMovie, nil];
            
            [self presentViewController:pick animated:YES completion:nil];
        }else{
            [self.view makeToast:@"没有摄像头" duration:1 position:@"center" image:nil withTextColor:[UIColor whiteColor] withValue:@""];
        }
    }];
    UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action2) {
 
        UIImagePickerController *pick = [[UIImagePickerController alloc]init];
        
        pick.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
        pick.delegate = self;
        pick.allowsEditing = NO;
        
        pick.mediaTypes = [NSArray arrayWithObjects:(NSString*)kUTTypeImage, (NSString*)kUTTypeMovie, nil];
        
        [self presentViewController:pick animated:YES completion:nil];
    }];
    UIAlertAction * action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action3) {
        [alertController removeFromParentViewController];
    }];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController addAction:action3];
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
}

#pragma mark ImagePick delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    UIImage *originalImage;
    
    if ([mediaType isEqualToString:@"public.image"]){
        
        originalImage = (UIImage *) [info objectForKey:
                                     UIImagePickerControllerOriginalImage];
        
        [self dismissViewControllerAnimated: YES completion:nil];
        
        NSData *mData = nil;
        mData =UIImageJPEGRepresentation(originalImage, 0.05);
        UIImage *needImage = nil;
        
        needImage = [UIImage imageWithData:mData];
        
        CGSize size = needImage.size;
        
        float height = 160 * size.height/size.width;
        
        needImage = [self imageWithImageSimple:needImage scaledToSize:CGSizeMake(160, height)];
        
        //定义两个uiimage 分别对应 身份证正面和背面
        [self.view setUserInteractionEnabled:NO];
        //上传身份证图片
        CDUploadProductImage *uploadimage = [[CDUploadProductImage alloc] initWithImage:needImage uploadUrl:TEMPUPLOAD uploadfinish:^(NSString *url){
            if ([url isEqualToString:@""]||!url) {
                [self.view makeToast:@"文件上传失败！请重试..." duration:1 position:@"center"
                               image:nil withTextColor:[UIColor whiteColor] withValue:@""];
                [self.view setUserInteractionEnabled:YES];
                return ;
            }
            //上传成功之后的处理
            
            [self.view setUserInteractionEnabled:YES];
            [self performSelectorOnMainThread:@selector(showUPloadSuccess) withObject:nil waitUntilDone:NO];
            
        } uploadcancel:^{
        }];
        
    }
}

-(void)showUPloadSuccess{
    [self.view makeToast:@"上传成功" duration:1 position:@"center"
                   image:nil withTextColor:[UIColor whiteColor] withValue:@""];
}

- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
