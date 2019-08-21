Pod::Spec.new do |s|
  s.name             = 'Knot'
  s.version          = '1.1.0'
  s.summary          = 'Lightweight & Predictable state driven node extension library'

  s.description      = 'Knot is lightweight & predictable state driven node extension library for Texture(AsyncDisplayKit)'

  s.homepage         = 'https://github.com/Geektree0101/Knot'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Geektree0101' => 'h2s1880@gmail.com' }
  s.source           = { :git => 'https://github.com/Geektree0101/Knot.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.3'
  s.swift_versions = '5.0'
  s.source_files = 'Knot/Classes/**/*'
  
  s.dependency 'RxSwift', '~> 5.0'
  s.dependency 'RxCocoa', '~> 5.0'
  s.dependency 'Texture', '~> 2.8'
end
