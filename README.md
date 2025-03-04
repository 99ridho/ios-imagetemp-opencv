# Image Temperature Adjuster

This repository is intended to learn on how integrate OpenCV library (which is written using C++) on Swift, and doing some fun creating UI layout using SwiftUI.

## Technologies used

- SwiftUI
- Combine
- OpenCV

## How to Setup

This repository already configured with OpenCV, so you only need to clone (please be patience -- because the OpenCV framework size is huge) and open on Xcode then ready to be ran on your phone. Here's my approach on how to setup the OpenCV

1. I'm using the latest version of the OpenCV. Firstly, download the framework from [here](https://github.com/opencv/opencv/releases/tag/4.11.0)
2. After the framework downloaded, put the framework on our project
3. Add the `opencv2.framework` on the `Link Binary with Libraries`, along with Accelerate, CoreFoundation, AssetsLibrary, CoreGraphics, and CoreMedia frameworks
4. Create the Objective-C++ class, and then we need to set bridging header and also the prefix header (see `ImageTempEditor/Headers`)
5. From newly created Objective-C++ class (see `ImageTempEditor/OpenCV/OpenCV.mm`), we can add our implementation that we can expose to the Swift using bridging header
6. Enjoy :)

## Concepts

Image temperature adjustment is actually increasing/decreasing the Red and/or Blue from RGB image colors. If we want to make our image warmer, you need to increasing the Red and decreasing the Blue, and the opposite to make our image colder.

When using OpenCV, we need to load the image first, then we split the channels to be increased/decreased individually. Then, we need to merge back those channels, and convert to the `UIImage`.

## Showcase

TBA