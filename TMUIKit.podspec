#
# Be sure to run `pod lib lint TMUIKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TMUIKit'
  s.version          = '1.1.3'
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
      
      # TMUICellHeightCache
      ss.subspec 'TMUICellHeightCache' do |sss|
        sss.source_files = 'TMUIKit/TMUIComponents/TMUICellHeightCache/*.{h,m}'
      end
      
      # TMUIBadge
      ss.subspec 'TMUIBadge' do |sss|
        sss.source_files = 'TMUIKit/TMUIComponents/TMUIBadge/*.{h,m}'
      end
      
    ######################## begin 以下组件在项目中暂不使用，先屏蔽，只在Demo中打开 ########################

    #  # TMUITableView
    #  ss.subspec 'TMUITableView' do |sss|
    #    sss.source_files = 'TMUIKit/TMUIComponents/TMUITableView/*.{h,m}'
    #  end

    #  ss.subspec 'TMUIPageViewController' do |sss|
    #    sss.source_files = 'TMUIKit/TMUIComponents/TMUIPageViewController/*.{h,m}'
    #  end

    #  ss.subspec 'TMShowBigImageController' do |sss|
    #    sss.source_files = 'TMUIKit/TMUIComponents/TMShowBigImageController/*.{h,m}'
    #  end

    #  # TMUITheme
    #  ss.subspec 'TMUIModalPresentationViewController' do |sss|
    #    sss.source_files = 'TMUIKit/TMUIComponents/TMUIModalPresentationViewController/*.{h,m}'
    #  end

    #  # TMUITheme
    #  ss.subspec 'TMUITheme' do |sss|
    #    sss.source_files = 'TMUIKit/TMUIComponents/TMUITheme/*.{h,m}'
    #  end

    #  # TMUITheme
    #  ss.subspec 'TMUIAppearance' do |sss|
    #    sss.source_files = 'TMUIKit/TMUIComponents/TMUIAppearance/*.{h,m}'
    #  end



    #   #ChainUI
    #   ss.subspec 'ChainUI' do |sss|
    #     sss.public_header_files = 'TMUIKit/TMUIComponents/ChainUI/*.h'
    #     sss.source_files = 'TMUIKit/TMUIComponents/ChainUI/*.{h,m}'
    #     sss.frameworks = 'Foundation', 'UIKit', 'CoreGraphics'
    #     sss.subspec 'Private' do |ssss|
    #       ssss.source_files = 'TMUIKit/TMUIComponents/ChainUI/Private/*.{h,m}'
    #       ssss.public_header_files = "TMUIKit/TMUIComponents/ChainUI/Private/*.h"
    #     end
    #     sss.subspec 'Public' do |ssss|
    #       ssss.source_files = 'TMUIKit/TMUIComponents/ChainUI/Public/*.{h,m}'
    #       ssss.public_header_files = "TMUIKit/TMUIComponents/ChainUI/Public/*.h"
    #       ssss.dependency 'TMUIKit/TMUIComponents/ChainUI/Private'
    #     end
    #     sss.subspec 'Chainable' do |ssss|
    #       ssss.source_files = 'TMUIKit/TMUIComponents/ChainUI/Chainable/*.{h,m}'
    #       ssss.dependency 'TMUIKit/TMUIComponents/ChainUI/Public'
    #       ssss.dependency 'TMUIKit/TMUIComponents/ChainUI/Private'
    #     end
    #   end

      ########################  end 以上组件只在demo中打开  ########################


  end
  

  ######################## begin HouseKeeper项目中使用  ########################
  
  #tools
  s.subspec 'TMTools' do |ss|
    ss.subspec 'TMRsaTool' do |sss|
      sss.frameworks = 'Foundation'
      # 因集成百度地图SDK需要依赖openssl（百度地图SDK官网上写明openssl对应版本为1.0.2e,但提工单后相关开发人员回复地图SDK用的是1.1.1g版本。app引入时可用1.1.1g及之后的版本都可以 https://www.openssl.org/source/old/1.0.2/）,所以这里还原为openssl的引入，TMRsaTool的类代码逻辑会兼容openssl和openssl-universal两个库的api调用.
      #OpenSSL 与 OpenSSL-Universal 依赖库只能二选一进行引入，根据实际需要选择即可.
      #注意相关cocoapods版本，OpenSSL只能是pod版本1.5.3及以下，OpenSSL-Universal没有pod的版本限制.
      #sss.dependency 'OpenSSL-Universal', '~> 1.0.2.20' #openssl库的集成，涉及rsa加密功能, pod install 此库20多MB，下载稍慢，耐心等待一会即可
      #sss.dependency 'OpenSSL', '1.0.210' #历史各版本与百度地图里用的对不上
      #pod库暂无1.1.1g版本的openssl公开库可直接集成，所以需要自行手动编译对应版本的openssl库,注意podspec文件里需要写上 s.header_dir = 'openssl' 才能支持 <openssl/xxx.h> 标准库格式的头文件引用.
      
      sss.source_files = 'TMUIKit/TMTools/TMRsaTool/*.{h,m}'
      sss.subspec 'openssl' do |ssss|
            ssss.source_files = 'TMUIKit/TMTools/TMRsaTool/openssl/include/**/*.{h,m}'
            ssss.header_dir = 'openssl'
            ssss.vendored_libraries = 'TMUIKit/TMTools/TMRsaTool/openssl/lib/*.a'            
      end
    end
  end

  ######################## end HouseKeeper项目中使用  ########################
  
end
