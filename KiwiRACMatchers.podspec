#
# Be sure to run `pod lib lint KiwiRACMatchers.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "KiwiRACMatchers"
  s.version          = "0.1.1"
  s.summary          = "Adds RAC Matchers to Kiwi framework"

  s.description      = <<-DESC
    Small pod that adds ReactiveCocoa matchers to the Kiwi testing library        
                       DESC

  s.homepage         = "https://github.com/PaulTaykalo/KiwiRACMatchers"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Paul Taykalo" => "tt.kilew@gmail.com" }
  s.source           = { :git => "https://github.com/PaulTaykalo/KiwiRACMatchers.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/TT_Kilew'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'KiwiRACMatchers' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'XCTest'
  s.dependency 'Kiwi', '~> 2.0'
  s.dependency 'ReactiveCocoa', '~> 2.5'
end
