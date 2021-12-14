# TMEmptyView 1.0.0
> 去掉对TMUIkit库的依赖,将TMEmptyView从TMUIKit库抽离出来以便独立的模块编译和二进制组件化

## 修改以下几点
- 引入TBasicLib 库
- 替换对`TMUI_DEBUG_Code`宏引用，替换为`BASIC_DEBUG_Code`
- 替换`UIFont()`宏引用，改为系统默认
- 替换`tmui_safeAreaTopInset`内联函数，添加相同功能`INSafeAreaBottomInset`
- 替换`tmui_PropertyLazyLoad`属性的懒加载宏，改为`Basic_PropertyLazyLoad`
