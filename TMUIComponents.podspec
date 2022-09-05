#
# Be sure to run `pod lib lint TMUIKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TMUIComponents'
  s.version          = '2.0.1'
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
  s.source           = { :git => './'}
  # s.source           = { :git => 'http://repo.we.com/tubroker/tmuikit.git', :tag => "v"+"#{s.version}" }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

#  s.ios.deployment_target = '9.0'
  s.platform     = :ios, "9.0" 
  s.requires_arc = true
  
  # s.resource_bundles = {
  #   'TMUIKit' => ['TMUIKit/Assets/*.png']
  # }

  #代码源文件地址，**/*表示Classes目录及其子目录下所有文件，如果有多个目录下则用逗号分开，如果需要在项目中分组显示，这里也要做相应的设置
  s.source_files = 'TMUIKit/TMUIComponents/**/*'
  s.public_header_files = 'TMUIKit/TMUIComponents/*.h'
  s.dependency 'TMUICore'
  s.dependency 'TMUIExtensions'
  s.dependency "Masonry"

  #TMUIWidgets 基类控件
  s.subspec 'TMUIWidgets' do |ss|
    #引入TMUIWidgets中所有资源文件
    ss.source_files = 'TMUIKit/TMUIComponents/TMUIWidgets/TMUIWidgets.h'
    # TMUIButton
    ss.subspec 'TMUIButton' do |sss|
      sss.source_files = 'TMUIKit/TMUIComponents/TMUIWidgets/TMUIButton'
    end
    # TMUILabel
    ss.subspec 'TMUILabel' do |sss|
      sss.source_files = 'TMUIKit/TMUIComponents/TMUIWidgets/TMUILabel'
    end
    # TMUITextField
    ss.subspec 'TMUITextField' do |sss|
      sss.source_files = 'TMUIKit/TMUIComponents/TMUIWidgets/TMUITextField'
    end
    # TMUITextView
    ss.subspec 'TMUITextView' do |sss|
      sss.source_files = 'TMUIKit/TMUIComponents/TMUIWidgets/TMUITextView'
    end
    # TMUISlider
    ss.subspec 'TMUISlider' do |sss|
      sss.source_files = 'TMUIKit/TMUIComponents/TMUIWidgets/TMUISlider'
    end
    # TMUISegmentedControl
    ss.subspec 'TMUISegmentedControl' do |sss|
      sss.source_files = 'TMUIKit/TMUIComponents/TMUIWidgets/TMUISegmentedControl'
    end
  end
  
  # TMUIMultipleDelegates
  s.subspec 'TMUIMultipleDelegates' do |ss|
    ss.source_files = 'TMUIKit/TMUIComponents/TMUIMultipleDelegates/*.{h,m}'
  end
  
  s.subspec 'TMContentAlert' do |ss|
    ss.source_files = 'TMUIKit/TMUIComponents/TMContentAlert/*.{h,m}'
  end
  
  s.subspec 'TMContentPicker' do |ss|
    ss.source_files = 'TMUIKit/TMUIComponents/TMContentPicker/*.{h,m}'
    ss.subspec 'TMNormalPicker' do |sss|
      sss.source_files = 'TMUIKit/TMUIComponents/TMContentPicker/TMNormalPicker'
    end
    ss.subspec 'TMDatePicker' do |sss|
      sss.source_files = 'TMUIKit/TMUIComponents/TMContentPicker/TMDatePicker'
    end
    ss.subspec 'TMMultiDataPicker' do |sss|
      sss.source_files = 'TMUIKit/TMUIComponents/TMContentPicker/TMMultiDataPicker'
    end
    ss.subspec 'TMCityPicker' do |sss|
      sss.source_files = 'TMUIKit/TMUIComponents/TMContentPicker/TMCityPicker'
    end
  end
  
  s.subspec 'TMActionSheet' do |ss|
    ss.source_files = 'TMUIKit/TMUIComponents/TMActionSheet/*.{h,m}'
  end
  
  s.subspec 'TMPopoverView' do |ss|
    ss.source_files = 'TMUIKit/TMUIComponents/TMPopoverView/*.{h,m}'
  end
  
  s.subspec 'TMUIMenuView' do |ss|
      ss.source_files = 'TMUIKit/TMUIComponents/TMUIMenuView/*.{h,m}'
  end  
  
  s.subspec 'TMSearchController' do |ss|
    ss.source_files = 'TMUIKit/TMUIComponents/TMSearchController/*.{h,m}'
    ss.subspec 'Private' do |sss|
      sss.private_header_files = 'TMUIKit/TMUIComponents/TMSearchController/Private/*.{h}'
      sss.source_files = 'TMUIKit/TMUIComponents/TMSearchController/Private/*.{h,m}'
    end
    ss.subspec 'Extensions' do |sss|
      sss.source_files = 'TMUIKit/TMUIComponents/TMSearchController/Extensions/*.{h,m}'
    end
    # TMSearchUIAssets 后续不要随便修改名字，pod库内相关图片数据读取的Bundle名是固定写死为TMSearchUIAssets.bundle
    ss.resource_bundles = {
      'TMSearchUIAssets' => ['TMUIKit/TMUIComponents/TMSearchController/Resource/*.png']
    }
  end
  
  # TMUICellHeightCache
  s.subspec 'TMUICellHeightCache' do |ss|
    ss.source_files = 'TMUIKit/TMUIComponents/TMUICellHeightCache/*.{h,m}'
  end
  
  # TMUIBadge
  s.subspec 'TMUIBadge' do |ss|
    ss.source_files = 'TMUIKit/TMUIComponents/TMUIBadge/*.{h,m}'
  end

  # TMUIPageViewController 项目中的 THKPageContentViewController封装抽取
  s.subspec 'TMUIPageViewController' do |ss|
    ss.source_files = 'TMUIKit/TMUIComponents/TMUIPageViewController/*.{h,m}'
  end

  s.subspec 'TMUIToast' do |ss|
    ss.source_files = 'TMUIKit/TMUIComponents/TMUIToast/*.{h,m}'
    # TMUIToastUIAssets 后续不要随便修改名字，pod库内相关图片数据读取的Bundle名是固定写死为TMUIToastUIAssets.bundle
    ss.resource_bundles = {
      'TMUIToastUIAssets' => ['TMUIKit/TMUIComponents/TMUIToast/Resource/*']
    }
  end

  s.subspec 'TMUIExpandLabel' do |ss|
    ss.source_files = 'TMUIKit/TMUIComponents/TMUIExpandLabel/*.{h,m}'
  end

  s.subspec 'TMUIFloatLayoutView' do |ss|
    ss.source_files = 'TMUIKit/TMUIComponents/TMUIFloatLayoutView/*.{h,m}'
  end

  s.subspec 'TMUIFloatImagesView' do |ss|
    ss.source_files = 'TMUIKit/TMUIComponents/TMUIFloatImagesView/*.{h,m}'
  end

  s.subspec 'TMUITimer' do |ss|
    ss.source_files = 'TMUIKit/TMUIComponents/TMUITimer/*.{h,m}'
  end

  s.subspec 'TMUICycleView' do |ss|
    ss.source_files = 'TMUIKit/TMUIComponents/TMUICycleView/*.{h,m}'
  end

  s.subspec 'TMUISegmentView' do |ss|
    ss.source_files = 'TMUIKit/TMUIComponents/TMUISegmentView/*.{h,m}'
  end

  s.subspec 'TMUISearchBar' do |ss|
    ss.source_files = 'TMUIKit/TMUIComponents/TMUISearchBar/*.{h,m}'
    ss.resource_bundles = {
      'TMUISearchBarUIAssets' => ['TMUIKit/TMUIComponents/TMUISearchBar/Resource/*']
    }
  end

  s.subspec 'TMUIFilterView' do |ss|
    ss.source_files = 'TMUIKit/TMUIComponents/TMUIFilterView/*.{h,m}'
  end

  s.subspec 'TMUIPickerView' do |ss|
    ss.source_files = 'TMUIKit/TMUIComponents/TMUIPickerView/*.{h,m}'
  end

  s.subspec 'TMUIAppearance' do |ss|
    ss.source_files = 'TMUIKit/TMUIComponents/TMUIAppearance/*.{h,m}'
  end

  s.subspec 'TMUIPopupContainerView' do |ss|
    ss.source_files = 'TMUIKit/TMUIComponents/TMUIPopupContainerView/*.{h,m}'
  end

  s.subspec 'TMUINavigationBar' do |ss|
    ss.source_files = 'TMUIKit/TMUIComponents/TMUINavigationBar/*.{h,m}'
    ss.resource_bundles = {
        'TMUINavigationBarUIAssets' => ['TMUIKit/TMUIComponents/TMUINavigationBar/Resource/*']
      }
  end

end
