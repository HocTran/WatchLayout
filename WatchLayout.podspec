Pod::Spec.new do |s|
  s.name             = 'WatchLayout'
  s.version          = '1.1.0'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.summary          = 'A bubble watch-like like out for UICollectionView'
  s.homepage         = 'https://github.com/HocTran/WatchLayout'
  s.author           = { 'Hoc Tran' => 'tranhoc78@gmail.com' }
  s.source           = { :git => 'https://github.com/HocTran/WatchLayout.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'

  s.source_files = 'Source/*.swift'
  
  s.swift_versions = ['5']
  
end
