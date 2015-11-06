//
//  TwoDimensionCodeViewController.m
//  app
//
//  Created by burring on 15/8/26.
//  Copyright (c) 2015年 Donler. All rights reserved.
//

#import "TwoDimensionCodeViewController.h"
#import "FMDBSQLiteManager.h"
#import "Person.h"
#import "Account.h"
#import "AccountTool.h"
#import "UIImageView+DLGetWebImage.h"
#define IS_IPHONE_4_SCREEN [[UIScreen mainScreen] bounds].size.height >= 480.0f && [[UIScreen mainScreen] bounds].size.height < 568.0f
@interface TwoDimensionCodeViewController ()

@end

@implementation TwoDimensionCodeViewController
// 用户邀请: http://www.55yali.com/signup?cid=xxx&uid=xxx
// 学校二维码邀请：www.55yali.com/signup?cid=xxxxxxxxx
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"二维码";
    if (IS_IPHONE_4_SCREEN) {
//        NSLog(@"===%f%f%f%f",self.WhiteSuperView.y,self.WhiteSuperView.x,self.WhiteSuperView.width,self.WhiteSuperView.height);
        self.WhiteSuperView.y = 66;
    } else {
        self.WhiteSuperView.y = 109;
    }
    Account *account = [AccountTool account];
    Person *p = [[FMDBSQLiteManager shareSQLiteManager] selectPersonWithUserId:account.ID];
    self.view.backgroundColor = RGBACOLOR(237, 237, 237, 1);
    // Do any additional setup after loading the view, typically from a nib.
    UIImage *qrcode = [self createNonInterpolatedUIImageFormCIImage:[self createQRForString:[NSString stringWithFormat:@"http://www.55yali.com/signup?cid=%@&uid=%@",account.ID,account.cid]] withSize:250.0f];
    UIImage *customQrcode = [self imageBlackToTransparent:qrcode withRed:60.0f andGreen:74.0f andBlue:89.0f];
    self.twoDismensionCodeImage.image = customQrcode;
    // set shadow
    self.twoDismensionCodeImage.layer.shadowOffset = CGSizeMake(0, 2);
    self.twoDismensionCodeImage.layer.shadowRadius = 2;
    self.twoDismensionCodeImage.layer.shadowColor = [UIColor blackColor].CGColor;
    self.twoDismensionCodeImage.layer.shadowOpacity = 0.5;
    [self buildInterfaceWithPerson:p];
}
- (void)buildInterfaceWithPerson:(Person *)p {
    self.colorView.backgroundColor = RGBACOLOR(255, 214, 0, 1);
    self.nameLabel.text = p.nickName;
    if (p.companyName.length != 0) {
        self.companyLabel.text = [p.companyName substringFromIndex:3];
    }
    self.photoImage.layer.masksToBounds = YES;
    self.photoImage.layer.cornerRadius = 25;
//    [self.photoImage dlGetRouteWebImageWithString:p.imageURL placeholderImage:nil];
    [self.photoImage dlGetRouteThumbnallWebImageWithString:p.imageURL placeholderImage:nil withSize:CGSizeMake(100, 100)];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - InterpolatedUIImage
// 将生成的CIImage 图片转换成UIImage
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // create a bitmap image that we'll draw into a bitmap context at the desired size;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // Create an image with the contents of our bitmap
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    // Cleanup
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

#pragma mark - QRCodeGenerator
// 传字符串 生成二维码
- (CIImage *)createQRForString:(NSString *)qrString {
    // Need to convert the string to a UTF-8 encoded NSData object
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    // Create the filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // Set the message content and error-correction level
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    // Send the image back
    return qrFilter.outputImage;
}

#pragma mark - imageToTransparent
// 对二维码进行颜色填充
void ProviderReleaseData (void *info, const void *data, size_t size){
    free((void*)data);
}
- (UIImage*)imageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue{
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    // create context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    // traverse pixe
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900){
            // change color
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red; //0~255
            ptr[2] = green;
            ptr[1] = blue;
        }else{
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
    // context to image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    // release
//    CGImageRelease(imageRef);
//    CGContextRelease(context);
//    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}


@end
