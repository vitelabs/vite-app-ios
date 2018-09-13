platform :ios, '10.0'
inhibit_all_warnings!
source 'https://github.com/CocoaPods/Specs.git'

target 'Vite' do
  use_frameworks!

  #vite kit
  pod 'Vite-keystore', :path => '../vite-keystore-ios'

  pod 'SnapKit', '~> 4.0.0'
  pod 'BigInt', '~> 3.0'
  pod 'R.swift'
  pod 'JSONRPCKit' #, :git=> 'https://github.com/bricklife/JSONRPCKit.git'
  pod 'PromiseKit', '~> 6.0'
  pod 'APIKit'
  pod 'ObjectMapper'
  pod 'MBProgressHUD'
  pod 'KeychainSwift'
  pod 'Moya'
  pod 'MJRefresh'

  #table static form
  pod 'Eureka'

  #RX
  pod 'RxSwift', '~> 4.0'
  pod 'RxCocoa'
  pod 'RxDataSources', '~> 3.0'
  pod 'NSObject+Rx'
  pod 'RxGesture'
  pod 'Then'
  pod 'ReusableKit'

  #code review
  pod 'SwiftLint'


  target 'ViteTests' do
    inherit! :search_paths
  end

  target 'ViteUITests' do
    inherit! :search_paths
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    if ['JSONRPCKit'].include? target.name
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '3.0'
      end
    end
  end
end
