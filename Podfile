platform :ios, '10.0'
inhibit_all_warnings!
source 'https://github.com/CocoaPods/Specs.git'
require './vite_pod'

targetArray = ['Vite', 'Vite-test', 'Vite-enterprise']

targetArray.each do |t|
    target t do
        use_frameworks!
        #vite kit
        vite_pod 'Vite_HDWalletKit', '1.2.0'

        communityPath =  File.dirname(File.dirname(__FILE__))  + '/vite-community-ios'
        utilsPath = File.dirname(File.dirname(__FILE__)) + '/vite-utils-ios'
        if File.exist?(communityPath) and File.exist?(utilsPath) then
            pod 'ViteCommunity', :path => communityPath
            pod 'ViteUtils', :path => utilsPath
        else
            pod 'ViteCommunity', :git => 'git@github.com:vitelabs/vite-community-ios.git'
            pod 'ViteUtils', :git => 'git@github.com:vitelabs/vite-utils-ios.git'
        end

        pod 'SnapKit', '~> 4.0.0'
        pod 'BigInt', '~> 3.0'
        pod 'R.swift', '5.0.0.alpha.3'
        pod 'JSONRPCKit', '~> 3.0.0'
        pod 'PromiseKit', '~> 6.0'
        pod 'APIKit'
        pod 'ObjectMapper'
        pod 'MBProgressHUD'
        pod 'KeychainSwift'
        pod 'Moya'
        pod 'MJRefresh'
        pod 'KMNavigationBarTransition'
        pod 'XCGLogger', '~> 6.1.0'
        pod 'pop', '~> 1.0'
        pod 'DACircularProgress', '2.3.1'
        pod 'Kingfisher', '~> 4.0'
        pod 'NYXImagesKit', '2.3'

        #request
        pod 'SwiftyJSON'

        #statistics
        pod 'BaiduMobStat'

        #UI Control
        pod 'ActionSheetPicker-3.0'
        pod 'MBProgressHUD'
        pod 'Toast-Swift', '~> 4.0.1'
        pod 'RazzleDazzle'
        pod 'CHIPageControl'

        #table static form
        pod 'Eureka', '~> 4.3.0'

        #RX
        pod 'RxSwift', '~> 4.0'
        pod 'RxCocoa'
        pod 'RxDataSources', '~> 3.0'
        pod 'NSObject+Rx'
        pod 'RxOptional'
        pod 'RxGesture'
        pod 'Then'
        pod 'Action'
        pod 'ReusableKit', '~> 2.1.0'
        pod 'ReactorKit'

        #code review
        pod 'SwiftLint'

        #crash
        pod 'Fabric'
        pod 'Crashlytics'

        pod 'MLeaksFinder', :configurations => ['Debug']
    end
end

target 'ViteTests' do
    inherit! :search_paths
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        if ['RazzleDazzle', 'JSONRPCKit', 'APIKit'].include? target.name
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '4.0'
            end
        end
    end
end
