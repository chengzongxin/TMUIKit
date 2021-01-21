#
# Be sure to run `pod lib lint TMUIKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TMUIKit'
  s.version          = '0.9.0'
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
    #依赖的三方库，pod库或者可以是自身的subspec
    ss.frameworks = 'Foundation', 'UIKit', 'CoreGraphics'
  end
  
  #TMUIDefines 宏定义
  s.subspec 'TMUIDefines' do |ss|
    #引入TMUIDefines中所有资源文件
    ss.source_files = 'TMUIKit/Classes/TMUIDefines/**/*'
    #公开TMUIDefines模块中的头文件
    ss.public_header_files = 'TMUIKit/Classes/TMUIDefines/*.h'
    #依赖的三方库，pod库或者可以是自身的subspec
    ss.frameworks = 'Foundation', 'UIKit', 'CoreGraphics'
    ss.dependency 'TMUIKit/TMUICore'
  end
  
  
  #TMUIExtensions 分类
  s.subspec 'TMUIExtensions' do |ss|
    #引入TMUIExtensions中所有资源文件
    ss.source_files = 'TMUIKit/Classes/TMUIExtensions/**/*'
    #公开TMUIExtensions模块中的头文件
    ss.public_header_files = 'TMUIKit/Classes/TMUIExtensions/*.h'
    #依赖的三方库，pod库或者可以是自身的subspec
    ss.frameworks = 'Foundation', 'UIKit', 'CoreGraphics'
    ss.dependency 'TMUIKit/TMUICore'
    ss.dependency 'TMUIKit/TMUIDefines'
  end
  
  #TMUIWidgets 基类控件
  s.subspec 'TMUIWidgets' do |ss|
    #引入TMUIWidgets中所有资源文件
    ss.source_files = 'TMUIKit/Classes/TMUIWidgets/TMUIWidgets.h'
    #公开TMUIWidgets模块中的头文件
    ss.public_header_files = 'TMUIKit/Classes/TMUIWidgets/*.h'
    #依赖的三方库，pod库或者可以是自身的subspec
    ss.dependency 'TMUIKit/TMUICore'
    ss.dependency 'TMUIKit/TMUIDefines'
    ss.dependency 'TMUIKit/TMUIExtensions'
    # TMButton
    ss.subspec 'TMButton' do |sss|
      sss.source_files = 'TMUIKit/Classes/TMUIWidgets/TMButton/'
    end
  end
  
  #TMUIComponents 组件
  s.subspec 'TMUIComponents' do |ss|
    #引入TMUIComponents中所有资源文件
#    ss.source_files = 'TMUIKit/Classes/TMUIComponents/**/*'
    ss.source_files = 'TMUIKit/Classes/TMUIComponents/TMUIComponents.h'
    #公开TMUIComponents模块中的头文件
#    ss.public_header_files = 'TMUIKit/Classes/TMUIComponents/*.h'
#    ss.public_header_files = 'TMUIKit/Classes/TMUIComponents/TMUIComponents.h'
    #依赖的三方库，pod库或者可以是自身的subspec
    ss.dependency 'TMUIKit/TMUICore'
    ss.dependency 'TMUIKit/TMUIDefines'
    ss.dependency 'TMUIKit/TMUIExtensions'
    
    ss.subspec 'TMContentAlert' do |sss|
      sss.source_files = 'TMUIKit/Classes/TMUIComponents/TMContentAlert/*.{h,m}'
    end
    
    ss.subspec 'TMContentPicker' do |sss|
      sss.source_files = 'TMUIKit/Classes/TMUIComponents/TMContentPicker/*.{h,m}'
      sss.subspec 'TMNormalPicker' do |ssss|
        ssss.source_files = 'TMUIKit/Classes/TMUIComponents/TMContentPicker/TMNormalPicker'
      end
      sss.subspec 'TMDatePicker' do |ssss|
        ssss.source_files = 'TMUIKit/Classes/TMUIComponents/TMContentPicker/TMDatePicker'
      end
      sss.subspec 'TMMultiDataPicker' do |ssss|
        ssss.source_files = 'TMUIKit/Classes/TMUIComponents/TMContentPicker/TMMultiDataPicker'
      end
      sss.subspec 'TMCityPicker' do |ssss|
        ssss.source_files = 'TMUIKit/Classes/TMUIComponents/TMContentPicker/TMCityPicker'
      end
    end
    
    ss.subspec 'TMActionSheet' do |sss|
      sss.source_files = 'TMUIKit/Classes/TMUIComponents/TMActionSheet/*.{h,m}'
    end
    
    ss.subspec 'TMToast' do |sss|
      sss.source_files = 'TMUIKit/Classes/TMUIComponents/TMToast/*.{h,m}'
      # TMToastAssets 后续不要随便修改名字，pod库内相关图片数据读取的Bundle名是固定写死为TMToastAssets.bundle
      sss.resource_bundles = {
        'TMToastAssets' => ['TMUIKit/Classes/TMUIComponents/TMToast/Resource/*.png']
      }
    end
    
    ss.subspec 'TMPopoverView' do |sss|
      sss.source_files = 'TMUIKit/Classes/TMUIComponents/TMPopoverView/*.{h,m}'
    end
    
    ss.subspec 'TMEmptyView' do |sss|
      sss.source_files = 'TMUIKit/Classes/TMUIComponents/TMEmptyView/*.{h,m}'
      sss.subspec 'Content' do |ssss|
        ssss.source_files = 'TMUIKit/Classes/TMUIComponents/TMEmptyView/Content/*.{h,m}'
      end
      # TMEmptyUIAssets 后续不要随便修改名字，pod库内相关图片数据读取的Bundle名是固定写死为TMEmptyUIAssets.bundle
      sss.resource_bundles = {
        'TMEmptyUIAssets' => ['TMUIKit/Classes/TMUIComponents/TMEmptyView/Resource/*.png']
      }
    end
    
    ss.subspec 'TMSearchController' do |sss|
      sss.source_files = 'TMUIKit/Classes/TMUIComponents/TMSearchController/*.{h,m}'
      sss.subspec 'Private' do |ssss|
        ssss.private_header_files = 'TMUIKit/Classes/TMUIComponents/TMSearchController/Private/*.{h}'
        ssss.source_files = 'TMUIKit/Classes/TMUIComponents/TMSearchController/Private/*.{h,m}'
      end
      sss.subspec 'Extensions' do |ssss|
        ssss.source_files = 'TMUIKit/Classes/TMUIComponents/TMSearchController/Extensions/*.{h,m}'
      end
      # TMSearchUIAssets 后续不要随便修改名字，pod库内相关图片数据读取的Bundle名是固定写死为TMSearchUIAssets.bundle
      sss.resource_bundles = {
        'TMSearchUIAssets' => ['TMUIKit/Classes/TMUIComponents/TMSearchController/Resource/*.png']
      }
    end
  end
  
  s.dependency "Masonry", "~> 1.1.0"
end
