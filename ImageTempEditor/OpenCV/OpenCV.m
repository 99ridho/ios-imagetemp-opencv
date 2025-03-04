//
//  OpenCV.m
//  ImageTempEditor
//
//  Created by Ridho Kurniawan on 04/03/25.
//

#import "OpenCV.h"
#import <opencv2/opencv2.h>
#import <opencv2/core/version.hpp>

@implementation OpenCV

+ (NSString *)getOpenCVVersion {
    return [NSString stringWithFormat:@"OpenCV Version : %s", CV_VERSION];
}

@end
