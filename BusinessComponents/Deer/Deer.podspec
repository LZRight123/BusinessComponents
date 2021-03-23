Pod::Spec.new do |s|
    # 框架的名称
    s.name         = "Deer"
    # 框架的版本号
    s.version      = "1.0.0"
    # 框架的简单介绍
    s.summary      = "关于iOS的一些业务组件."
    # 框架的详细描述(详细介绍，要比简介长)
    s.description  = <<-DESC
                  主要写一些关于Deer业务的通用型组件
                  DESC
    # 框架的主页
    s.homepage     = "https://github.com/LZRight123/BusinessComponents/tree/master/BusinessComponents/Deer"
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
       :git => "https://github.com/LZRight123/BusinessComponents/tree/master/BusinessComponents/Deer", 
       :tag => s.version.to_s,
       :submodules => true
      }
    
    s.swift_version = '5.0'
    s.frameworks='Foundation','UIKit'
    s.dependency 'SwiftComponents'
    # s.dependency 'SwiftComponents', :git => 'https://github.com/LZRight123/SwiftComponents.git'
    # 框架要求ARC环境下使用
    s.requires_arc = true
    # 设置 podspec 的默认 subspec
    # s.default_subspecs = 'Empty'
    # 每次都参与编译方便修改
    s.static_framework = true
    # 本地框架源文件的位置（包含所有文件）
    s.source_files  = "./**/*.swift"
    s.resources  = './**/*.{xib,png}'
    
    end
   
  end
  