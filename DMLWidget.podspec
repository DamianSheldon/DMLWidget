#
# Be sure to run `pod lib lint DMLWidget.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'DMLWidget'
    s.version          = '0.5.0'
    s.summary          = 'A collection of custom UI elements.'

    # This description is used to generate tags and improve search results.
    #   * Think: What does it do? Why did you write it? What is the focus?
    #   * Try to keep it short, snappy and to the point.
    #   * Write the description between the DESC delimiters below.
    #   * Finally, don't worry about the indent, CocoaPods strips it!

    s.description      = <<-DESC
    DMLWidget is a repository collecte custom UI elements that common in development. Each element as a subspec, so it can be installed independent.
                       DESC

    s.homepage         = 'https://github.com/DamianSheldon/DMLWidget'
    # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'DamianSheldon' => 'dongmeilianghy@sina.com' }
    s.source           = { :git => 'https://github.com/DamianSheldon/DMLWidget.git', :tag => s.version.to_s }
    # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

    s.ios.deployment_target = '8.0'

    s.source_files = 'Classes/**/*'

    # s.resource_bundles = {
    #   'DMLWidget' => ['DMLWidget/Assets/*.png']
    # }

    s.public_header_files = 'Classes/**/*.h'
    # s.frameworks = 'UIKit', 'MapKit'
    # s.dependency 'AFNetworking', '~> 2.3'

    s.subspec 'DMLSegmentedControl' do |segmentedcontrol|
        segmentedcontrol.source_files = 'Classes/**/DMLSegmentedControl.{h,m}'
        segmentedcontrol.frameworks = 'UIKit'
    end

    s.subspec 'DMLSlider' do |slider|
        slider.source_files = 'Classes/**/DMLSlider.{h,m}'
        slider.frameworks = 'UIKit'
    end

    s.subspec 'DMLCamPreviewView' do |campreviewview|
        campreviewview.source_files = 'Classes/**/DMLCamPreviewView.{h,m}'
        campreviewview.frameworks = 'UIKit', 'AVFoundation'
    end

    s.subspec 'DMLCollectionViewCell' do |collectionviewcell|
        collectionviewcell.source_files = 'Classes/**/DMLCollectionViewCell.{h,m}'
        collectionviewcell.frameworks = 'UIKit'
    end

    s.subspec 'DMLCollectionHeaderView' do |collectionheaderview|
        collectionheaderview.source_files = 'Classes/**/DMLCollectionHeaderView.{h,m}'
        collectionheaderview.frameworks = 'UIKit'
    end
end
