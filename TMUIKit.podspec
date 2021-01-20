#
# Be sure to run `pod lib lint TMUIKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TMUIKit'
  s.version          = '0.2.0'
  s.summary          = 'TMUIKit 是个UI库，包含UI，组件，宏，库工具等。'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  'TMUIKit 是个UI库，包含UI，组件，宏，库工具等。'
                       DESC

  s.homepage         = 'https://github.com/chengzongxin/TMUIKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'chengzongxin' => 'joe.cheng@corp.to8to.com' }
  s.source           = { :git => 'https://github.com/chengzongxin/TMUIKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'
  
  # s.resource_bundles = {
  #   'TMUIKit' => ['TMUIKit/Assets/*.png']
  # }

  #代码源文件地址，**/*表示Classes目录及其子目录下所有文件，如果有多个目录下则用逗号分开，如果需要在项目中分组显示，这里也要做相应的设置
  #头文件~TMUIKit.h 在最外层
  s.source_files = 'TMUIKit/Classes/TMUIKit.h'
  s.public_header_files = 'TMUIKit/Classes/TMUIKit.h'
  
  #TMUICore 内部方法
  s.subspec 'TMUICore' do |ss|
    #引入TMUICore中所有资源文件
    ss.source_files = 'TMUIKit/Classes/TMUICore/**/*'
    #公开TMUICore模块中的头文件
    ss.public_header_files = 'TMUIKit/Classes/TMUICore/*.h'
  end
  
  #TMUIDefines 宏定义
  s.subspec 'TMUIDefines' do |ss|
    #引入TMUIDefines中所有资源文件
    ss.source_files = 'TMUIKit/Classes/TMUIDefines/**/*'
    #公开TMUIDefines模块中的头文件
    ss.public_header_files = 'TMUIKit/Classes/TMUIDefines/*.h'
  end
  
  #TMUIWidgets 基类控件
  s.subspec 'TMUIWidgets' do |ss|
    #引入TMUIWidgets中所有资源文件
    ss.source_files = 'TMUIKit/Classes/TMUIWidgets/**/*'
    #公开TMUIWidgets模块中的头文件
    ss.public_header_files = 'TMUIKit/Classes/TMUIWidgets/*.h'
    #依赖的三方库，pod库或者可以是自身的subspec
    ss.dependency 'TMUIKit/TMUICore'
    ss.dependency 'TMUIKit/TMUIDefines'
    # TMButton
    ss.subspec 'TMButton' do |sss|
           sss.source_files = 'TMUIKit/Classes/TMUIWidgets/TMButton/**/*'
           sss.public_header_files = 'TMUIKit/Classes/TMUIWidgets/TMButton/*.h'
        end
  end
  
  #TMUIComponents 组件
  s.subspec 'TMUIComponents' do |ss|
    #引入TMUIComponents中所有资源文件
    ss.source_files = 'TMUIKit/Classes/TMUIComponents/**/*'
    #公开TMUIComponents模块中的头文件
    ss.public_header_files = 'TMUIKit/Classes/TMUIComponents/*.h'
    #依赖的三方库，pod库或者可以是自身的subspec
    ss.dependency 'TMUIKit/TMUICore'
    ss.dependency 'TMUIKit/TMUIDefines'
  end
  
  #TMUIExtensions 分类
  s.subspec 'TMUIExtensions' do |ss|
    #引入TMUIExtensions中所有资源文件
    ss.source_files = 'TMUIKit/Classes/TMUIExtensions/**/*'
    #公开TMUIExtensions模块中的头文件
    ss.public_header_files = 'TMUIKit/Classes/TMUIExtensions/*.h'
    #依赖的三方库，pod库或者可以是自身的subspec
    ss.dependency 'TMUIKit/TMUICore'
    ss.dependency 'TMUIKit/TMUIDefines'
  end
  
  s.dependency 'Masonry'
end
