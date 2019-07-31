Pod::Spec.new do |s|
  s.name             = 'Einstein'
  s.version          = '0.1.0'
  s.summary          = 'UITest helper'
  s.description      = <<-DESC
  Einstein integrates the business logic across the Project and UITest through AccessibilityIdentified. And on UITest, useing EasyPredict and Extensions to better support test code writing.
                       DESC

  s.homepage         = 'https://github.com/ZhipingYang/Einstein'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Daniel Yang' => 'xcodeyang@gmail.com' }
  s.platform         = :ios, '9.0'
  s.source           = { :git => 'https://github.com/ZhipingYang/Einstein.git', :tag => s.version.to_s }
  s.requires_arc     = true
  s.swift_version = '5.0'
  s.ios.deployment_target = '9.0'

  s.default_subspecs = 'Share', 'UITest'
  s.dependency 'Then'

  s.subspec 'Share' do |sh|
      sh.source_files = 'class/share/*.swift'
      sh.framework = "UIKit"
  end

  s.subspec 'UITest' do |t|
      t.source_files = 'class/uitest/**/*.swift'
      t.ios.framework = "UIKit", "XCTest"
  end

end
