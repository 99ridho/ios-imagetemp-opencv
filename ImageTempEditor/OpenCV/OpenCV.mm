//
//  OpenCV.m
//  ImageTempEditor
//
//  Created by Ridho Kurniawan on 04/03/25.
//

#import "OpenCV.h"
#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>
#import <UIKit/UIKit.h>

@implementation OpenCV

+ (NSString *)getOpenCVVersion {
    return [NSString stringWithFormat:@"OpenCV Version : %s", CV_VERSION];
}

+ (UIImage *)adjustTemperatureForImage:(UIImage *)image withValue:(float) temperature {
    cv::Mat mat;
    UIImageToMat(image, mat);
    
    // Split channels
    std::vector<cv::Mat> channels(3);
    cv::split(mat, channels);

    // Modify blue and red channels based on temperature
    if (temperature > 0) {
        // Warmer: Increase red, decrease blue
        channels[2] = channels[2] + cv::Scalar(temperature, temperature, temperature);  // Red channel
        channels[0] = channels[0] - cv::Scalar(temperature, temperature, temperature);  // Blue channel
    } else {
        // Colder: Increase blue, decrease red
        channels[2] = channels[2] - cv::Scalar(-temperature, -temperature, -temperature);  // Red channel
        channels[0] = channels[0] + cv::Scalar(-temperature, -temperature, -temperature);  // Blue channel
    }

    // Merge back channels
    cv::merge(channels, mat);

    // Convert back to UIImage
    UIImage *resultImage = MatToUIImage(mat);
    return resultImage;
}

@end
