#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'VastClient-NPO'
  s.version          = '0.4.0'
  s.summary          = 'Swift Vast Client'
  s.description      = 'iOS Vast Client is a Swift Framework which implements the VAST 4.0 spec and is backwards compatible with VAST 3.0.'
  s.homepage         = 'https://github.com/egeniq-forks/ios-vast-client'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { "John G. Gainfort, Jr." => "john@realeyes.com" }
  s.source           = { :git => "https://github.com/egeniq-forks/ios-vast-client", :branch => "master", :tag => s.version }

  s.ios.deployment_target = '9.0'
  s.tvos.deployment_target = '10.0'
  s.swift_version = '4.2'
  s.requires_arc = true

  s.source_files = ['VastClient/VastClient/**/*.{swift,h,m}', 'VastClient/VastClient.xcodeproj']
end
