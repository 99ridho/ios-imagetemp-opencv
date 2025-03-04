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
    if (!image) return nil;  // Safety check

    cv::Mat mat;
    UIImageToMat(image, mat);

    // Ensure the image has 3 channels (RGB)
    if (mat.channels() < 3) return image;
    
    // Split channels
    std::vector<cv::Mat> channels(3);
    cv::split(mat, channels);

    // Normalize temperature to the range [0, 1] based on the temperature scale (-100 to 100)
    float scale = fabs(temperature) / 100.0;  // Normalize to [0, 1]

    if (temperature > 0) {
        // Warmer: Increase Red, Decrease Blue
        channels[0] += cv::Scalar(scale * 128, scale * 128, scale * 128); // Increase Red
        channels[2] -= cv::Scalar(scale * 128, scale * 128, scale * 128); // Decrease Blue
    } else {
        // Colder: Increase Blue, Decrease Red
        channels[2] += cv::Scalar(scale * 128, scale * 128, scale * 128); // Increase Blue
        channels[0] -= cv::Scalar(scale * 128, scale * 128, scale * 128); // Decrease Red
    }

    // Clip values to 0-255 to avoid overflow
    cv::threshold(channels[2], channels[2], 255, 255, cv::THRESH_TRUNC);
    cv::threshold(channels[0], channels[0], 255, 255, cv::THRESH_TRUNC);

    // Merge back channels
    cv::merge(channels, mat);
    
    UIImage* result = MatToUIImage(mat);
    
    // Release memory
    mat.release();
    channels[0].release();
    channels[1].release();
    channels[2].release();
    
    return result;
}

@end
