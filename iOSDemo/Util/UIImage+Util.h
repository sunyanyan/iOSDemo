//
//  UIImage+Util.h
//  iOSDemo
//
//  Created by 孙同生 on 2020/6/23.
//  Copyright © 2020 孙同生. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Util)

/**
 使用CGGraphics 缩放图片 比用uikit缩放好
 */
-(UIImage*)resizeCG:(CGSize)toSize;

/**
 使用imageIO缩放图片 比用uikit缩放好
 */
-(UIImage*)resizeIO:(CGSize)toSize;

/**
 获取强制解压后的图片
 */
+(UIImage*)decodedImageWithImageData:(NSDate *)data;

/**
获取强制解压后的图片
*/
+(UIImage*)decodedImageWithImage:(UIImage*)image;


/**
 获取图片的metaData
 */
+(NSDictionary*)metaDataInfoIn:(UIImage*)originImg;


/**
 根据原图的方向 返回修复后的方向，使图片在解压后显示方向正确
 */
+(UIImageOrientation)fitOri:(UIImageOrientation)imgOri;
@end

NS_ASSUME_NONNULL_END
