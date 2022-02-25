#
# Be sure to run `pod lib lint TMUIKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TMUIKit'
  s.version          = '1.1.13'
  s.summary          = 'TMUIKit 是个UI库，包含UI，组件，宏，库工具等。'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  'TMUIKit iOS 是一个致力于提高项目 UI 开发效率的组件库，为工程提供一些通用的UI基础库及功能组件库以及一些通用的工具库。
  旨在帮助快速高效的构建工程的基础设计元素，以及统一维护基础元素的版本兼容性处理，助于提高开发效率和项目质量。'
                       DESC

  s.homepage         = 'http://repo.we.com/tubroker/tmuikit.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'chengzongxin' => 'joe.cheng@corp.to8to.com' }
  # s.source           = { :git => './'}
  s.source           = { :git => 'http://repo.we.com/tubroker/tmuikit.git', :tag => "v"+"#{s.version}" }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

#  s.ios.deployment_target = '9.0'
  s.platform     = :ios, "9.0" 
  s.requires_arc = true
  
  # s.resource_bundles = {
  #   'TMUIKit' => ['TMUIKit/Assets/*.png']
  # }

  #代码源文件地址，**/*表示Classes目录及其子目录下所有文件，如果有多个目录下则用逗号分开，如果需要在项目中分组显示，这里也要做相应的设置
  #头文件~TMUIKit.h 在最外层
  s.source_files = 'TMUIKit/TMUIKit.h'
  s.public_header_files = 'TMUIKit/TMUIKit.h'
  s.dependency "Masonry", "~> 1.1.0"
  
  #TMUICore 内部方法
  s.subspec 'TMUICore' do |ss|
    #引入TMUICore中所有资源文件
    ss.source_files = 'TMUIKit/TMUICore/**/*'
    #公开TMUICore模块中的头文件
    ss.public_header_files = 'TMUIKit/TMUICore/*.h'
    #依赖的三方库，pod库或者可以是自身的subspec
    ss.frameworks = 'Foundation', 'UIKit', 'CoreGraphics'
  end

    # #TMUIDefines Core中依赖部分拆离出来，以便二进制
    # s.subspec 'TMUIDefines' do |ss|
    #   #引入TMUICore中所有资源文件
    #   ss.source_files = 'TMUIKit/TMUIDefines/**/*'
    #   #公开TMUICore模块中的头文件
    #   ss.public_header_files = 'TMUIKit/TMUIDefines/*.h'
    #   #依赖的三方库，pod库或者可以是自身的subspec
    #   ss.frameworks = 'Foundation', 'UIKit', 'CoreGraphics'
    #   ss.dependency 'TMUIKit/TMUICore'
    # end
  
  #TMUIExtensions 分类
  s.subspec 'TMUIExtensions' do |ss|
    #引入TMUIExtensions中所有资源文件
    ss.source_files = 'TMUIKit/TMUIExtensions/**/*'
    #公开TMUIExtensions模块中的头文件
    ss.public_header_files = 'TMUIKit/TMUIExtensions/*.h'
    #依赖的三方库，pod库或者可以是自身的subspec
    ss.frameworks = 'Foundation', 'UIKit', 'CoreGraphics'
    ss.dependency 'TMUIKit/TMUICore'

    #TMUIDefines Core中依赖部分拆离出来，以便二进制
    ss.subspec 'TMUIDefines' do |sss|
      #引入TMUICore中所有资源文件
      sss.source_files = 'TMUIKit/TMUIExtensions/TMUIDefines/**/*'
      # #公开TMUICore模块中的头文件
      # sss.public_header_files = 'TMUIKit/TMUIExtensions/TMUIDefines/*.h'
    end

    ss.subspec 'UIKit' do |sss|
      sss.source_files = 'TMUIKit/TMUIExtensions/UIKit'
    end

    ss.subspec 'Foundation' do |sss|
      sss.source_files = 'TMUIKit/TMUIExtensions/Foundation'
      # NSString
      sss.subspec 'NSString' do |ssss|
        ssss.source_files = 'TMUIKit/TMUIExtensions/Foundation/NSString'
      end
    end
  end
  
  #TMUIComponents 组件
  s.subspec 'TMUIComponents' do |ss|
      ss.dependency 'TMUIKit/TMUICore'
      ss.dependency 'TMUIKit/TMUIExtensions'
      # ss.dependency 'TMUIKit/TMUIWidgets'
      ss.source_files = 'TMUIKit/TMUIComponents/TMUIComponents.h'

      #TMUIWidgets 基类控件
      ss.subspec 'TMUIWidgets' do |sss|
        #引入TMUIWidgets中所有资源文件
        sss.source_files = 'TMUIKit/TMUIComponents/TMUIWidgets/TMUIWidgets.h'
        # #公开TMUIWidgets模块中的头文件
        # sss.public_header_files = 'TMUIKit/TMUIWidgets/*.h'
        # #依赖的三方库，pod库或者可以是自身的subspec
        # sss.dependency 'TMUIKit/TMUICore'
        # sss.dependency 'TMUIKit/TMUIExtensions'
        # TMUIButton
        sss.subspec 'TMUIButton' do |ssss|
          ssss.source_files = 'TMUIKit/TMUIComponents/TMUIWidgets/TMUIButton'
        end
        # TMUILabel
        sss.subspec 'TMUILabel' do |ssss|
          ssss.source_files = 'TMUIKit/TMUIComponents/TMUIWidgets/TMUILabel'
        end
        # TMUITextField
        sss.subspec 'TMUITextField' do |ssss|
          ssss.source_files = 'TMUIKit/TMUIComponents/TMUIWidgets/TMUITextField'
        end
        # TMUITextView
        sss.subspec 'TMUITextView' do |ssss|
          ssss.source_files = 'TMUIKit/TMUIComponents/TMUIWidgets/TMUITextView'
        end
        # TMUISlider
        sss.subspec 'TMUISlider' do |ssss|
          ssss.source_files = 'TMUIKit/TMUIComponents/TMUIWidgets/TMUISlider'
        end
        # TMUISegmentedControl
        sss.subspec 'TMUISegmentedControl' do |ssss|
          ssss.source_files = 'TMUIKit/TMUIComponents/TMUIWidgets/TMUISegmentedControl'
        end
      end
      
      # TMUIMultipleDelegates
      ss.subspec 'TMUIMultipleDelegates' do |sss|
        sss.source_files = 'TMUIKit/TMUIComponents/TMUIMultipleDelegates/*.{h,m}'
      end
      
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
      
      ss.subspec 'TMPopoverView' do |sss|
        sss.source_files = 'TMUIKit/TMUIComponents/TMPopoverView/*.{h,m}'
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
      
      # TMUICellHeightCache
      ss.subspec 'TMUICellHeightCache' do |sss|
        sss.source_files = 'TMUIKit/TMUIComponents/TMUICellHeightCache/*.{h,m}'
      end
      
      # TMUIBadge
      ss.subspec 'TMUIBadge' do |sss|
        sss.source_files = 'TMUIKit/TMUIComponents/TMUIBadge/*.{h,m}'
      end

      # TMUIPageViewController 项目中的 THKPageContentViewController封装抽取
      ss.subspec 'TMUIPageViewController' do |sss|
        sss.source_files = 'TMUIKit/TMUIComponents/TMUIPageViewController/*.{h,m}'
      end

      ss.subspec 'TMUIToast' do |sss|
        sss.source_files = 'TMUIKit/TMUIComponents/TMUIToast/*.{h,m}'
        # TMUIToastUIAssets 后续不要随便修改名字，pod库内相关图片数据读取的Bundle名是固定写死为TMUIToastUIAssets.bundle
        sss.resource_bundles = {
          'TMUIToastUIAssets' => ['TMUIKit/TMUIComponents/TMUIToast/Resource/*']
        }
      end

      ss.subspec 'TMUIExpandLabel' do |sss|
        sss.source_files = 'TMUIKit/TMUIComponents/TMUIExpandLabel/*.{h,m}'
      end

      ss.subspec 'TMUIFloatLayoutView' do |sss|
        sss.source_files = 'TMUIKit/TMUIComponents/TMUIFloatLayoutView/*.{h,m}'
      end

      ss.subspec 'TMUIFloatImagesView' do |sss|
        sss.source_files = 'TMUIKit/TMUIComponents/TMUIFloatImagesView/*.{h,m}'
      end

      ss.subspec 'TMUITimer' do |sss|
        sss.source_files = 'TMUIKit/TMUIComponents/TMUITimer/*.{h,m}'
      end

      ss.subspec 'TMUICycleView' do |sss|
        sss.source_files = 'TMUIKit/TMUIComponents/TMUICycleView/*.{h,m}'
      end

      ss.subspec 'TMUISegmentView' do |sss|
        sss.source_files = 'TMUIKit/TMUIComponents/TMUISegmentView/*.{h,m}'
      end

      ss.subspec 'TMUISearchView' do |sss|
        sss.source_files = 'TMUIKit/TMUIComponents/TMUISearchView/*.{h,m}'
      end
  end
end
