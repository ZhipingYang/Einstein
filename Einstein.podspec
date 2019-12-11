Pod::Spec.new do |s|
  s.name = 'Einstein'
  s.version = '0.0.1'
  
  s.source = {
    :git => "https://github.com/ZhipingYang/#{s.name}.git",
    :tag => s.version.to_s
  }

  s.summary = 'Einstein integrates the project and UItest through AccessibilityIdentified, and It supports chain function to make test coding understand easier and more concise'
  s.description = <<-DESC
This library have two parts,
the one supports assign AccessibilityIdentified to the UIElements easier and concise, 
another one gets the elements by AccessibilityIdentified to writing uitest code in chain function way.
here we define EasyPredicate to avoid writing hard code when we use NSPredicate. 
in this way, EasyPredicate is more like OOP which we are familiar to use it.
                      DESC

  s.homepage = "https://github.com/ZhipingYang/#{s.name}"
  s.documentation_url = "https://zhipingyang.github.io/#{s.name}"
  s.social_media_url = 'https://github.com/ZhipingYang'
  s.screenshot  = 'https://user-images.githubusercontent.com/9360037/62184933-ecbe4380-b392-11e9-82dd-802b6b2e8b82.png'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.author = { 'Daniel Yang' => 'xcodeyang@gmail.com' }
  s.platform = :ios, :osx
  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.14'
  s.ios.framework = 'UIKit'
  s.osx.framework = 'AppKit'
  s.requires_arc = true
  s.swift_version = ['5.0', '5.1']
  s.default_subspecs = 'Identifier', 'UITest'

  s.subspec 'Identifier' do |iden|
      iden.source_files = 'class/identifier/*.swift'
  end

  s.subspec 'UITest' do |test|
      test.source_files = 'class/uitest/**/*.swift'
      test.ios.framework = 'XCTest'
      test.osx.framework = 'XCTest'
      test.pod_target_xcconfig = { 'ENABLE_BITCODE' => 'NO' }
      test.dependency 'Einstein/Identifier'
      test.dependency 'Then'
  end

end
