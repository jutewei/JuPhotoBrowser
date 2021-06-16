#
# Be sure to run `pod lib lint JuPhoto.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "JuPhoto"
  s.version          = "1.0"
  s.summary          = "通用JuPhoto SDK"
  s.homepage         = " https://github.com/jutewei/JuPhotoBrowser"
  s.author           = { "cmb" => "zhutianwei224@pingan.com.cn" }
  s.license          = {
    :type => 'Copyright',
    :text => <<-LICENSE
    © 2021-2021 pingan. All rights reserved.
    LICENSE
  }
  s.platform         = :ios, '9.0'
  s.requires_arc     = true
  s.source           = { :git => "https://github.com/jutewei/JuPhotoBrowser.git" }
#  s.dependency  'JuLayout', :git=> 'https://github.com/jutewei/JuLayout.git', :branch => 'master', :subspecs => ['LayoutObjC']

  
  s.resource_bundle = {'JuPhotoResource'=>'Source/Resources/*'}
  s.requires_arc = true
  
  s.subspec 'Core' do |ss|
       ss.source_files = 'Source/*.{h,m}'
       
       ss.subspec 'Deal' do |n|
          n.source_files = 'Source/Deal/*.{h,m}'
          end

       ss.subspec 'JuDocument' do |n|
          n.source_files = 'Source/JuDocument/*.{h,m}'
          end
       ss.subspec 'JuPhotos' do |n|
          n.source_files = 'Source/JuPhotos/*.{h,m}'
          end
       ss.subspec 'JuZoomImage' do |n|
          n.source_files = 'Source/JuZoomImage/*.{h,m}'
          end
       
  end
  

  
end
