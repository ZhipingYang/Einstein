Pod::Spec.new do |s|
  s.name             = 'UITestHelper'
  s.version          = '0.1.0'
  s.summary          = 'UITest helper'
  s.description      = <<-DESC
  UITest extension and solution
                       DESC

  s.homepage         = 'https://github.com/ZhipingYang/UITestHelper'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Daniel Yang' => 'xcodeyang@gmail.com' }
  s.platform         = :ios, '9.0'
  s.source           = { :git => 'https://github.com/ZhipingYang/UITestHelper.git', :tag => s.version.to_s }
  s.requires_arc     = true
  s.swift_version = '5.0'
  s.ios.deployment_target = '9.0'

  s.default_subspecs = 'Core', 'EXtension'
  s.dependency 'Then'

  s.subspec 'Core' do |c|
      c.source_files = 'class/core/*.swift'
      c.framework = "UIKit"
  end

  s.subspec 'EXtension' do |ex|
      ex.source_files = 'class/extension/*.swift'
      ex.ios.framework = "UIKit", "XCTest"
      ex.dependency 'UITestHelper/Core'
  end

end
