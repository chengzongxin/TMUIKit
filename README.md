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

- `TMUICore`提供基础的库功能、设备信息、宏、运行时工具等，作为TMUIKit库基本依赖

#### TMUIExtension

- `TMUIKit`主要对外接口部分，提供便捷、解耦、高效的`Category`。包含`UIKit`和`Foundation`两大部分

#### TMUIWidgets

- `TMUIKit`基本控件，一般对应每一个`UIKit`中的基类控件的二次封装，使用需要继承`TMUIWidgets`中的基类使用

#### TMUIComponents

- `TMUIKit`组件库，收集`HouseKeeper`项目中稳定的组件，以及第三方通用的组件





## Usage

【功能列表】TMUIkit所有文件以及功能列表说明，具体使用代码参考`Example`工程示例

[Feature List.md   (MARKDOWN版)](Feature List.md)

[Feature List.pdf （PDF版)](Feature List.pdf)



【类参考】TMUIKit库中所有类文件说明

[Class Reference.md   (MARKDOWN版)](Class Reference.md)

[Class Reference.pdf （PDF版)](Class Reference.pdf)



## Reference

【腾讯文档】Category整理——UIKit&Foundation
https://docs.qq.com/sheet/DWHFQalhsT2pHcENn


