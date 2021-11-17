# TMToast 1.0.0
> 去掉对TMUIkit库的依赖,将TMToast从TMUIKit库抽离出来以便独立的模块编译和二进制组件化

## 修改以下几点

- 去掉对`TMUI_DEBUG_Code`宏引用，添加相同功能`TMToast_DEBUG_Code`
- 去掉`UIFont()`宏引用，改为系统默认
- 去掉`tmui_safeAreaTopInset`内联函数，添加相同功能`toast_safeAreaBottomInset`


# TMToast 1.1.0
## 修改以下几点
- 引入TBasicLib 库
- 替换对`TMUI_DEBUG_Code`宏引用，替换为`DEBUG_Code`
- 替换`tmui_safeAreaTopInset`内联函数，添加相同功能`SafeAreaBottomInset`
- 移除对`TBasicLib`库依赖

