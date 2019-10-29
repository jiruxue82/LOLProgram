#
# Be sure to run `pod lib lint ChinaFightJapan.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ChinaFightJapan'
  s.version          = '1.0.3'
  s.summary          = '第一次使用CocoaPods创建公有库'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  播放器： 1. 播放本地网络视频。 2.播放已下载本地文件。 3. 全屏不可切换竖屏播放。 3. 横竖屏，锁屏，进度拖动，网络重试，状态栏跟随，操作栏暗影效果，时间样式选择。 4.支持.mp4 .m4v 等正常格式， 现已支持.m3u8流媒体格式。
                       DESC

  s.homepage         = 'https://github.com/jiruxue82/LOLProgram.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '姬如雪' => 'jiruxue82@gmail.com' }
  s.source           = { :git => 'https://github.com/jiruxue82/LOLProgram.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'ChinaFightJapan/Classes/**/*'
  s.swift_version = '4.2'
  s.resource_bundles = {
    'ChinaFightJapan' => ['ChinaFightJapan/Assets/*.png']
    }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'SnapKit'
end
