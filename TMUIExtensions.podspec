#
# Be sure to run `pod lib lint TMUIKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TMUIExtensions'
  s.version          = '2.0.1'
  s.summary          = 'TMUIExtensions 是个分类库。'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  'TMUIKit iOS 是一个致力于提高项目 UI 开发效率的组件库，为工程提供一些通用的UI基础库及功能组件库以及一些通用的工具库。
  旨在帮助快速高效的构建工程的基础设计元素，以及统一维护基础元素的版本兼容性处理，助于提高开发效率和项目质量。'
                       DESC

  s.homepage         = 'https://github.com/chengzongxin/TMUIKit.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'chengzongxin' => 'joe.cheng@corp.to8to.com' }
  # s.source           = { :git => './'}
  s.source           = { :git => 'https://github.com/chengzongxin/TMUIKit.git', :tag => "v"+"#{s.version}" }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

#  s.ios.deployment_target = '9.0'
  s.platform     = :ios, "9.0" 
  s.requires_arc = true
  
  # s.resource_bundles = {
  #   'TMUIKit' => ['TMUIKit/Assets/*.png']
  # }

  #引入TMUIExtensions中所有资源文件
  s.source_files = 'TMUIExtensions/**/*'
  #公开TMUIExtensions模块中的头文件
  s.public_header_files = 'TMUIExtensions/*.h'
  #依赖的三方库，pod库或者可以是自身的subspec
  s.frameworks = 'Foundation', 'UIKit', 'CoreGraphics'

  s.subspec 'UIKit' do |ss|
    ss.source_files = 'TMUIExtensions/UIKit'
  end

  s.subspec 'Foundation' do |ss|
    ss.source_files = 'TMUIExtensions/Foundation'
  end

  s.dependency 'TMUICore'
end