#
#  Be sure to run `pod spec lint TMUIKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "TMUIKit"
  s.version      = "0.0.1"
  s.summary      = "致力于提高项目UI开发效率的组件库"
  s.description  = <<-DESC
                   TMUIKit iOS 是一个致力于提高项目 UI 开发效率的组件库，为工程提供一些通用的UI基础库及功能组件库以及一些通用的工具库。
                   旨在帮助快速高效的构建工程的基础设计元素，以及统一维护基础元素的版本兼容性处理，助于提高开发效率和项目质量。
                   DESC
  s.homepage     = "http://repo.we.com/tubroker/tmuikit.git"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "nigel.ning" => "nigel.ning@corp.to8to.com" }


  s.platform     = :ios, "8.2"
  s.requires_arc = true
  #  When using multiple platforms
  # s.ios.deployment_target = "5.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"
  s.frameworks       = 'Foundation', 'UIKit', 'CoreGraphics'
  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"
  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"
  s.source       = { :git => "http://repo.we.com/tubroker/tmuikit.git" }
  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"
  s.source_files  = "TMUIKit/TMUIKit.h"
  
  s.subspec 'TMUICore' do |ss|
    ss.source_files = 'TMUIKit/TMUIKit.h', 'TMUIKit/TMUICore/*.{h,m}', 'TMUIKit/UIKitExtensions/*.{h,m}'    
  end

  s.subspec 'TMUIComponents' do |ss|
    ss.dependency 'TMUIKit/TMUICore'
    
    ss.subspec 'TMContentAlert' do |sss|
      sss.source_files = 'TMUIKit/TMUIComponents/TMContentAlert/*.{h,m}'
    end    
  end


  

  



  

end
