Pod::Spec.new do |s|
  s.name         = "AeroGear-Store"
  s.version      = "1.5.0"
  s.summary      = "Provides a lightweight set of utilities for communication, security, storage and more."
  s.homepage     = "https://github.com/corinnekrych/aerogear-store-ios"
  s.license      = 'Apache License, Version 2.0'
  s.author       = "Red Hat, Inc."
  s.source       = { :git => 'https://github.com/corinnekrych/aerogear-store-ios.git' }
  s.platform     = :ios, 7.0
  s.source_files = 'AeroGear-iOS/**/*.{h,m}'

  s.public_header_files = 'AeroGear-iOS/AeroGear-Store.h', 'AeroGear-iOS/config/AGConfig.h', 'AeroGear-iOS/datamanager/AGStore.h', 'AeroGear-iOS/datamanager/AGDataManager.h', 'AeroGear-iOS/datamanager/AGStoreConfig.h'

  s.requires_arc = true
  s.dependency 'FMDB', '2.1'
 
end
