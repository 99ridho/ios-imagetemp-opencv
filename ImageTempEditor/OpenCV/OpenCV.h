//
//  OpenCV.h
//  ImageTempEditor
//
//  Created by Ridho Kurniawan on 04/03/25.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OpenCV : NSObject

+ (NSString *) getOpenCVVersion;
+ (UIImage *)adjustTemperatureForImage:(UIImage *)image withValue:(float) temperature;

@end

NS_ASSUME_NONNULL_END
