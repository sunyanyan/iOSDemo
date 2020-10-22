//
//  UIImage+Util.m
//  iOSDemo
//
//  Created by 孙同生 on 2020/6/23.
//  Copyright © 2020 孙同生. All rights reserved.
//

#import "UIImage+Util.h"
#import <ImageIO/ImageIO.h>
#import <CoreGraphics/CoreGraphics.h>


CGColorSpaceRef YYCGColorSpaceGetDeviceRGB() {
    static CGColorSpaceRef space;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        space = CGColorSpaceCreateDeviceRGB();
    });
    return space;
}



@implementation UIImage (Util)

//MARK: 图片缩放
/**
 使用CGGraphics 缩放图片 比用uikit缩放好
 */
-(UIImage*)resizeCG:(CGSize)toSize{
    
    CGContextRef cgcontext =  CGBitmapContextCreate(nil, toSize.width, toSize.height, CGImageGetBitsPerComponent(self.CGImage),  CGImageGetBytesPerRow(self.CGImage), CGImageGetColorSpace(self.CGImage),CGImageGetBitmapInfo(self.CGImage));
    
    CGContextSetInterpolationQuality(cgcontext, kCGInterpolationHigh);
    CGContextDrawImage(cgcontext, CGRectMake(0,0, toSize.width, toSize.height), self.CGImage);
    CGImageRef imgRef = CGBitmapContextCreateImage(cgcontext);
    UIImage *img = [UIImage imageWithCGImage:imgRef scale:self.scale orientation:self.imageOrientation];
    
    
    CGImageRelease(imgRef);
    CGContextRelease(cgcontext);
    
    return img;
}

/**
 使用imageIO缩放图片 比用uikit缩放好
 */
-(UIImage*)resizeIO:(CGSize)toSize{
    NSData* data = UIImagePNGRepresentation(self);
    int maxPixelSize = fmax(toSize.width, toSize.height);
    
    CGImageSourceRef myImageSource = CGImageSourceCreateWithData((CFDataRef)data, nil);
    
    CFDictionaryRef options = (__bridge CFDictionaryRef) @{
                                                           (__bridge id)kCGImageSourceCreateThumbnailFromImageAlways: (__bridge id)kCFBooleanTrue,
                                                           (__bridge id)kCGImageSourceThumbnailMaxPixelSize: [NSNumber numberWithFloat:maxPixelSize]
                                                           };
    
    CGImageRef imgRef = CGImageSourceCreateImageAtIndex(myImageSource,0,options);
    UIImage *img = [UIImage imageWithCGImage:imgRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imgRef);
    CFRelease(myImageSource);
    
    return img;
}

//MARK: 图片解压
/**
 获取强制解压后的图片
 */
+(UIImage*)decodedImageWithImageData:(NSDate *)data{
    if(data == nil) return nil;
    
    @autoreleasepool {
        CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFTypeRef)data, NULL);
        CGImageRef image = CGImageSourceCreateImageAtIndex(source, 0, (CFDictionaryRef)@{(id)kCGImageSourceShouldCache:@(NO)});
        CGImageRef decoded = YYCGImageCreateDecodedCopy(image, YES);
        UIImage* result = [[UIImage alloc] initWithCGImage:decoded];
        CFRelease(decoded);
        CFRelease(image);
        CFRelease(source);
        return result;
    }
    return nil;
}

/**
获取强制解压后的图片
*/
+(UIImage*)decodedImageWithImage:(UIImage*)image{
    
    if(image == nil) return nil;
    @autoreleasepool {
        // do not decode animated images
        if (image.images != nil) {
            return image;
        }
        CGImageRef imageref = YYCGImageCreateDecodedCopy(image.CGImage, YES);
        UIImage* image = [[UIImage alloc] initWithCGImage:imageref];
        CFRelease(imageref);
        return image;
    }
    return nil;
}

/**
 节选自yyimage
 */
CGImageRef YYCGImageCreateDecodedCopy(CGImageRef imageRef, BOOL decodeForDisplay) {
    if (!imageRef) return NULL;
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    if (width == 0 || height == 0) return NULL;
    
    if (decodeForDisplay) { //decode with redraw (may lose some precision)
        CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef) & kCGBitmapAlphaInfoMask;
        BOOL hasAlpha = NO;
        if (alphaInfo == kCGImageAlphaPremultipliedLast ||
            alphaInfo == kCGImageAlphaPremultipliedFirst ||
            alphaInfo == kCGImageAlphaLast ||
            alphaInfo == kCGImageAlphaFirst) {
            hasAlpha = YES;
        }
        // BGRA8888 (premultiplied) or BGRX8888
        // same as UIGraphicsBeginImageContext() and -[UIView drawRect:]
        CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Host;
        bitmapInfo |= hasAlpha ? kCGImageAlphaPremultipliedFirst : kCGImageAlphaNoneSkipFirst;
        CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, 0, YYCGColorSpaceGetDeviceRGB(), bitmapInfo);
        if (!context) return NULL;
        CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef); // decode
        CGImageRef newImage = CGBitmapContextCreateImage(context);
        CFRelease(context);
        return newImage;
        
    } else {
        CGColorSpaceRef space = CGImageGetColorSpace(imageRef);
        size_t bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
        size_t bitsPerPixel = CGImageGetBitsPerPixel(imageRef);
        size_t bytesPerRow = CGImageGetBytesPerRow(imageRef);
        CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
        if (bytesPerRow == 0 || width == 0 || height == 0) return NULL;
        
        CGDataProviderRef dataProvider = CGImageGetDataProvider(imageRef);
        if (!dataProvider) return NULL;
        CFDataRef data = CGDataProviderCopyData(dataProvider); // decode
        if (!data) return NULL;
        
        CGDataProviderRef newProvider = CGDataProviderCreateWithCFData(data);
        CFRelease(data);
        if (!newProvider) return NULL;
        
        CGImageRef newImage = CGImageCreate(width, height, bitsPerComponent, bitsPerPixel, bytesPerRow, space, bitmapInfo, newProvider, NULL, false, kCGRenderingIntentDefault);
        CFRelease(newProvider);
        return newImage;
    }
}

//MARK: 获取图片的metaData
/**
 获取图片的metaData
 
 {
     ColorModel = RGB;
     Depth = 8;
     Orientation = 1;
     PixelHeight = 1936;
     PixelWidth = 2592;
     "{Exif}" =     {
         ColorSpace = 1;
         PixelXDimension = 2592;
         PixelYDimension = 1936;
     };
     "{JFIF}" =     {
         DensityUnit = 0;
         JFIFVersion =         (
             1,
             1
         );
         XDensity = 1;
         YDensity = 1;
     };
     "{TIFF}" =     {
         Orientation = 1;
     };
 }
 */
+(NSDictionary*)metaDataInfoIn:(UIImage*)originImg{
    NSData* data = UIImageJPEGRepresentation(originImg, 1.0);;
    CGImageSourceRef myImageSource = CGImageSourceCreateWithData((CFDataRef)data, nil);
    CFDictionaryRef imageMetaData = CGImageSourceCopyPropertiesAtIndex(myImageSource, 0, NULL);
    NSDictionary *metaDataInfo    = CFBridgingRelease(imageMetaData);
    
    CFRelease(myImageSource);
    
    return metaDataInfo;
}

/**
 根据原图的方向 返回修复后的方向，使图片在解压后显示方向正确
 */
+(UIImageOrientation)fitOri:(UIImageOrientation)imgOri{
    
    if(imgOri == UIImageOrientationUp){
        return UIImageOrientationUp;
    }
    if(imgOri == UIImageOrientationDown){//√
        return UIImageOrientationUp;
    }
    if(imgOri == UIImageOrientationLeft){
        return UIImageOrientationRight;
    }
    if(imgOri == UIImageOrientationRight){
        return UIImageOrientationLeft;
    }
    if(imgOri == UIImageOrientationUpMirrored){
        return UIImageOrientationDown;
    }
    if(imgOri == UIImageOrientationDownMirrored){
        return UIImageOrientationUp;
    }
    if(imgOri == UIImageOrientationLeftMirrored){
        return UIImageOrientationRight;
    }
    if(imgOri == UIImageOrientationRightMirrored){
        return UIImageOrientationLeft;
    }

    
    return imgOri;
}


@end
