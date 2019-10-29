#
# Be sure to run `pod lib lint GYComponents.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'GYComponents'
  s.version          = '0.1.8'
  s.summary          = 'A useful collection of tiny components.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  A useful collection of tiny components. Include Foundation extensions and UIKit extensions.
                       DESC

  s.homepage         = 'https://github.com/goyaya/GYComponents'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'goyaya' => 'goyaya@yeah.net' }
  s.source           = { :git => 'https://github.com/goyaya/GYComponents.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'
  
  s.requires_arc = true
  
  s.subspec 'Dependence' do |d|
    d.source_files = 'GYComponents/Dependence/**/*'
    d.frameworks   = "Foundation"
  end
  
  s.subspec 'Foundation' do |f|
    f.source_files = 'GYComponents/Foundation/**/*'
    f.frameworks   = "Foundation"
    f.dependency 'GYComponents/Dependence'
  end
  
  s.subspec 'UI' do |u|
      u.source_files = 'GYComponents/UI/**/*'
      u.frameworks   = "UIKit"
      u.dependency 'GYComponents/Dependence'
  end
  
  s.subspec 'Media' do |u|
      u.source_files = 'GYComponents/Media/**/*'
      u.frameworks   = "AVFoundation"
  end
  
  
  # s.resource_bundles = {
  #   'GYComponents' => ['GYComponents/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
