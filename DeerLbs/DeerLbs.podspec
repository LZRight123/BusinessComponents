Pod::Spec.new do |s|
    # 框架的名称
    s.name         = "DeerLbs"
    # 框架的版本号
    s.version      = "1.0.0"
    # 框架的简单介绍
    s.summary      = "定位组件."
    # 框架的详细描述(详细介绍，要比简介长)
    s.description  = <<-DESC
                  DeerLbs组件
                  DESC
    # 框架的主页
    s.homepage     = "https://github.com/LZRight123/BusinessComponents"
    # 证书类型
    s.license      = { :type => "MIT", :file => "LICENSE" }
    # 作者
    s.author             = { "梁泽" => "350442340@qq.com" }
    # 社交网址
    s.social_media_url = 'https://github.com/LZRight123'
    # 框架支持的平台和版本
    s.platform     = :ios, "10.0"

    # GitHub下载地址和版本
    s.source       = {
       :git => "https://github.com/LZRight123/BusinessComponents",
       :tag => s.version.to_s,
       :submodules => true
      }

    s.swift_version = '5.0'
    s.frameworks='Foundation','UIKit'
    s.dependency 'SwiftComponents'
    s.dependency 'AMapLocation-NO-IDFA' #高德定位
    s.dependency 'AMap3DMap-NO-IDFA' #高德定位 -NO-IDFA
    s.dependency 'AMapSearch-NO-IDFA'

    


    # 框架要求ARC环境下使用
    s.requires_arc = true
    # 每次都参与编译方便修改
    s.static_framework = true
    s.source_files  = "**/*.{h,m,mm,hpp,cpp,c,swift}"
    s.resources    = "**/*.{xib,storyboard,bundle,xcassets,aac,plist,xml,json,strings,html,css,js,png,jpg}"


  end
