# TMUIKit

## 介绍说明

想了解此UI库的具体功能，可查看Demo文件目录里的TMUIKitDemo工程，内部集成事例更新不一定即时，具体UI组件的demo也可到对应组件文件夹下查看对应的Example工程。

【注意】：此库尽量收录通用的UI组件及类别、宏等代码，业务紧耦合的切忌不要收录！

## 更新、维护说明
* 相关文件命名以TM为前缀，通用组件按实际功能进行相关命名，【注意】：不要以业务功能名来命名组件
* 相关新增组件或扩展，需要先确定功能模块，将相关源代码分发到对应实体目录，若为组件类型，则需要同步增加相关使用Example工程，具体工程可直接从ExampleTemplate文件夹下copy模版工程到对应目录下，对podfile配置进行简单的相对路径调整后进行调试开发。
* 每新增代码文件后，涉及podspec配置文件调整的要同步更新其内部项，具体可参考现有的TMUIKit.podspec文件里的内容结构


## Requirements

iOS, 8.2

## Installation

TMUIKit is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'TMUIKit'
```

## Author

nigel.ning, nigel.ning@corp.to8to.com

## License

TMUIKit is available under the MIT license. See the LICENSE file for more info.
