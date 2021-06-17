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
  s.author           = { "cmb" => "jutewei@qq.com" }
  s.license          = {
    :type => 'Copyright',
    :text => <<-LICENSE
    © 2021-2021 pingan. All rights reserved.
    LICENSE
  }
  s.platform         = :ios, '9.0'
  s.requires_arc     = true
  s.source           = { :git => "https://github.com/jutewei/JuPhotoBrowser.git" , :tag => s.version}
  
  s.dependency  'JuLayout/LayoutObjC'

  s.requires_arc = true
  s.static_framework = true
  #自己的framework 后面是路径
  #s.vendored_frameworks = ['Module/Vendors/*.framework']
  #系统的framework
  #s.frameworks = ['UIKit', 'MapKit']
  #自己的.a 后面是路径
  #s.vendored_library = 'Module/Classes/SDK/*.a'
  #系统的.a
  #s.libraries = ['xml2.2','sqlite3.0']
  #s.pod_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'SECOND_MODULE=1'}
  
  s.subspec 'Resources' do |ss|
      ss.resource_bundle = {'JuPhotoResource'=>'Source/Resources/*'}
  end
  
 
# s.source_files = 'Source/*.{h,m}'
 
 #s.dependency  'JuPhoto/Module'
 s.subspec 'JuPicker' do |n|
    n.source_files = 'Source/*.{h,m}'
    n.dependency  'JuPhoto/JuHint'
    n.dependency  'JuPhoto/JuDocument'
    n.dependency  'JuPhoto/JuPhotos'
    n.dependency  'JuPhoto/JuDeal'
    n.dependency  'JuPhoto/JuZoomImage'
  end
  
       s.subspec 'JuDeal' do |n|
          n.source_files = 'Source/Deal/*.{h,m}'
          n.dependency  'JuPhoto/JuHint'
        end
       
    
       s.subspec 'JuHint' do |n|
          n.source_files = 'Source/Hint/*.{h,m}'
        end
       
       s.subspec 'JuDocument' do |n|
          n.source_files = 'Source/JuDocument/*.{h,m}'
        end
       
       s.subspec 'JuPhotos' do |n|
          n.source_files = 'Source/JuPhotos/*.{h,m}'
          n.dependency  'JuPhoto/JuDeal'
          n.dependency  'JuPhoto/JuHint'
      end
       
       s.subspec 'JuZoomImage' do |n|
          n.source_files = 'Source/JuZoomImage/*.{h,m}'
          n.dependency  'JuPhoto/JuDeal'
      end
       
    

  
end
