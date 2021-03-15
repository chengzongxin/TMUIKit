# TMUIKit

[![CI Status](https://img.shields.io/travis/chengzongxin/TMUIKit.svg?style=flat)](https://travis-ci.org/chengzongxin/TMUIKit)
[![Version](https://img.shields.io/cocoapods/v/TMUIKit.svg?style=flat)](https://cocoapods.org/pods/TMUIKit)
[![License](https://img.shields.io/cocoapods/l/TMUIKit.svg?style=flat)](https://cocoapods.org/pods/TMUIKit)
[![Platform](https://img.shields.io/cocoapods/p/TMUIKit.svg?style=flat)](https://cocoapods.org/pods/TMUIKit)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

TMUIKit is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'TMUIKit'
```

## Author

chengzongxin, joe.cheng@corp.to8to.com

## License

TMUIKit is available under the MIT license. See the LICENSE file for more info.




## TMUIkit Architecture

#### TMUICore

- TMUICore提供基础的库功能、设备信息、宏、运行时工具等，作为TMUIKit库基本依赖

#### TMUIExtension

- TMUIKit主要核心功能、提供便捷、高效的`Category`，无需继承，即插即用。包含`UIKit`和`CoreFoundation`两大部分

#### TMUIWidgets

- TMUIKit基本控件，一般对应每一个UIKit中的基类，使用需要继承`TMUIWidgets`中的基类使用

#### TMUIComponents

- TMUIKit组件库，一般为项目中的常用组件收纳此处





## Usage

【功能列表】TMUIkit所有文件以及功能列表说明，具体使用代码参考`Example`工程示例

[MARKDOWN版（Files & FeatureList.md）](Files & FeatureList.md)

[PDF版 （Files & FeatureList.pdf）](Files & FeatureList.pdf)



## Reference

【腾讯文档】Category整理——UIKit&CoreFoundation
https://docs.qq.com/sheet/DWHFQalhsT2pHcENn


