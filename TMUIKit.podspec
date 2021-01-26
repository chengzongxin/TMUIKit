#
# Be sure to run `pod lib lint TMUIKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TMUIKit'
  s.version          = '0.9.5'
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
  s.source_files = 'TMUIKit/TMUIKit.h'
  s.public_header_files = 'TMUIKit/TMUIKit.h'
  
  #TMUICore 内部方法
  s.subspec 'TMUICore' do |ss|
    #引入TMUICore中所有资源文件
    ss.source_files = 'TMUIKit/TMUICore/**/*'
    #公开TMUICore模块中的头文件
    ss.public_header_files = 'TMUIKit/TMUICore/*.h'
    #依赖的三方库，pod库或者可以是自身的subspec
    ss.frameworks = 'Foundation', 'UIKit', 'CoreGraphics'
    # TMUITextField
    ss.subspec 'TMUIMultipleDelegates' do |sss|
      sss.source_files = 'TMUIKit/TMUICore/TMUIMultipleDelegates'
    end
  end
  
  #TMUIDefines 宏定义
  s.subspec 'TMUIDefines' do |ss|
    #引入TMUIDefines中所有资源文件
    ss.source_files = 'TMUIKit/TMUIDefines/**/*'
    #公开TMUIDefines模块中的头文件
    ss.public_header_files = 'TMUIKit/TMUIDefines/*.h'
    #依赖的三方库，pod库或者可以是自身的subspec
    ss.frameworks = 'Foundation', 'UIKit', 'CoreGraphics'
    ss.dependency 'TMUIKit/TMUICore'
  end
  
  
  #TMUIExtensions 分类
  s.subspec 'TMUIExtensions' do |ss|
    #引入TMUIExtensions中所有资源文件
    ss.source_files = 'TMUIKit/TMUIExtensions/**/*'
    #公开TMUIExtensions模块中的头文件
    ss.public_header_files = 'TMUIKit/TMUIExtensions/*.h'
    #依赖的三方库，pod库或者可以是自身的subspec
    ss.frameworks = 'Foundation', 'UIKit', 'CoreGraphics'
    ss.dependency 'TMUIKit/TMUICore'
    ss.dependency 'TMUIKit/TMUIDefines'
  end
  
  #TMUIWidgets 基类控件
  s.subspec 'TMUIWidgets' do |ss|
    #引入TMUIWidgets中所有资源文件
    ss.source_files = 'TMUIKit/TMUIWidgets/TMUIWidgets.h'
    #公开TMUIWidgets模块中的头文件
    ss.public_header_files = 'TMUIKit/TMUIWidgets/*.h'
    #依赖的三方库，pod库或者可以是自身的subspec
    ss.dependency 'TMUIKit/TMUICore'
    ss.dependency 'TMUIKit/TMUIDefines'
    ss.dependency 'TMUIKit/TMUIExtensions'
    # TMUIButton
    ss.subspec 'TMUIButton' do |sss|
      sss.source_files = 'TMUIKit/TMUIWidgets/TMUIButton'
    end
    # TMUILabel
    ss.subspec 'TMUILabel' do |sss|
      sss.source_files = 'TMUIKit/TMUIWidgets/TMUILabel'
    end
    # TMUITextField
    ss.subspec 'TMUITextField' do |sss|
      sss.source_files = 'TMUIKit/TMUIWidgets/TMUITextField'
    end
    # TMUITextView
    ss.subspec 'TMUITextView' do |sss|
      sss.source_files = 'TMUIKit/TMUIWidgets/TMUITextView'
    end
  end
  
  #TMUIComponents 组件
  s.subspec 'TMUIComponents' do |ss|
      ss.dependency 'TMUIKit/TMUICore'
      ss.dependency 'TMUIKit/TMUIDefines'
      ss.dependency 'TMUIKit/TMUIExtensions'
      ss.source_files = 'TMUIKit/TMUIComponents/TMUIComponents.h'
      
      ss.subspec 'TMContentAlert' do |sss|
        sss.source_files = 'TMUIKit/TMUIComponents/TMContentAlert/*.{h,m}'
      end
      
      ss.subspec 'TMContentPicker' do |sss|
        sss.source_files = 'TMUIKit/TMUIComponents/TMContentPicker/*.{h,m}'
        sss.subspec 'TMNormalPicker' do |ssss|
          ssss.source_files = 'TMUIKit/TMUIComponents/TMContentPicker/TMNormalPicker'
        end
        sss.subspec 'TMDatePicker' do |ssss|
          ssss.source_files = 'TMUIKit/TMUIComponents/TMContentPicker/TMDatePicker'
        end
        sss.subspec 'TMMultiDataPicker' do |ssss|
          ssss.source_files = 'TMUIKit/TMUIComponents/TMContentPicker/TMMultiDataPicker'
        end
        sss.subspec 'TMCityPicker' do |ssss|
          ssss.source_files = 'TMUIKit/TMUIComponents/TMContentPicker/TMCityPicker'
        end
      end
      
      ss.subspec 'TMActionSheet' do |sss|
        sss.source_files = 'TMUIKit/TMUIComponents/TMActionSheet/*.{h,m}'
      end
      
      ss.subspec 'TMToast' do |sss|
        sss.source_files = 'TMUIKit/TMUIComponents/TMToast/*.{h,m}'
        # TMToastAssets 后续不要随便修改名字，pod库内相关图片数据读取的Bundle名是固定写死为TMToastAssets.bundle
        sss.resource_bundles = {
          'TMToastAssets' => ['TMUIKit/TMUIComponents/TMToast/Resource/*.png']
        }
      end
      
      ss.subspec 'TMPopoverView' do |sss|
        sss.source_files = 'TMUIKit/TMUIComponents/TMPopoverView/*.{h,m}'
      end
      
      ss.subspec 'TMEmptyView' do |sss|
        sss.source_files = 'TMUIKit/TMUIComponents/TMEmptyView/*.{h,m}'
        sss.subspec 'Content' do |ssss|
          ssss.source_files = 'TMUIKit/TMUIComponents/TMEmptyView/Content/*.{h,m}'
        end
        # TMEmptyUIAssets 后续不要随便修改名字，pod库内相关图片数据读取的Bundle名是固定写死为TMEmptyUIAssets.bundle
        sss.resource_bundles = {
          'TMEmptyUIAssets' => ['TMUIKit/TMUIComponents/TMEmptyView/Resource/*.png']
        }
      end
      
      ss.subspec 'TMSearchController' do |sss|
        sss.source_files = 'TMUIKit/TMUIComponents/TMSearchController/*.{h,m}'
        sss.subspec 'Private' do |ssss|
          ssss.private_header_files = 'TMUIKit/TMUIComponents/TMSearchController/Private/*.{h}'
          ssss.source_files = 'TMUIKit/TMUIComponents/TMSearchController/Private/*.{h,m}'
        end
        sss.subspec 'Extensions' do |ssss|
          ssss.source_files = 'TMUIKit/TMUIComponents/TMSearchController/Extensions/*.{h,m}'
        end
        # TMSearchUIAssets 后续不要随便修改名字，pod库内相关图片数据读取的Bundle名是固定写死为TMSearchUIAssets.bundle
        sss.resource_bundles = {
          'TMSearchUIAssets' => ['TMUIKit/TMUIComponents/TMSearchController/Resource/*.png']
        }
      end
  end
  
  s.dependency "Masonry", "~> 1.1.0"
end
