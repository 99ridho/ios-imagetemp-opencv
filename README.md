# Image Temperature Adjuster

This repository is intended to learn how to integrate the OpenCV library (which is written using C++) on Swift and have some fun creating UI layouts using SwiftUI.

## Technologies used

- SwiftUI
- Combine
- OpenCV


## How to Setup

This repository is already configured with OpenCV, so you only need to clone it (please be patient- because the OpenCV framework size is huge) and open it on Xcode. Then, it will be ready to run on your phone. Here's my approach to how to set the OpenCV

1. I'm using the latest version of the OpenCV. Firstly, download the framework from [here](https://github.com/opencv/opencv/releases/tag/4.11.0)
2. After the framework is downloaded, put the framework on our project
3. Add the `opencv2.framework` on the `Link Binary with Libraries`, along with Accelerate, CoreFoundation, AssetsLibrary, CoreGraphics, and CoreMedia frameworks
4. Create the Objective-C++ class, and then we need to set the bridging header and also the prefix header (see `ImageTempEditor/Headers`)
5. From the newly created Objective-C++ class (see `ImageTempEditor/OpenCV/OpenCV.mm`), we can add our implementation that we can expose to Swift using a bridging header
6. Enjoy :)

## Concepts

Image temperature adjustment increases/decreases the red and/or blue from RGB image colors. If we want to make our image warmer, we need to increase the Red and reduce the Blue, and the opposite to make our image colder.

When using OpenCV, we need to load the image first; then, we split the channels to be increased/decreased individually. Then, we must merge those channels and convert them to `UIImage`.

## Showcase

[video](https://github.com/user-attachments/assets/d0b35df2-6293-4bec-8a26-5f5e2a12659d)
