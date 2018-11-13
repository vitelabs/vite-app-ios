platform :ios, '10.0'
inhibit_all_warnings!
source 'https://github.com/CocoaPods/Specs.git'

targetArray = ['Vite', 'Vite-test', 'Vite-enterprise']

targetArray.each do |t|
    target t do
        use_frameworks!

        #vite kit
        pod 'Vite_HDWalletKit', '~> 1.1.0'

        pod 'SnapKit', '~> 4.0.0'
        pod 'BigInt', '~> 3.0'
        pod 'R.swift'
        pod 'JSONRPCKit'
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

        #request
        pod 'SwiftyJSON'

        #statistics
        pod 'BaiduMobStat'

        #UI Control
        pod 'ActionSheetPicker-3.0'
        pod 'MBProgressHUD'
        pod 'Toast-Swift', '~> 3.0.1'
        pod 'ChameleonFramework/Swift', :git => 'https://github.com/ViccAlexander/Chameleon.git'

        #table static form
        pod 'Eureka', '~> 4.2.0'

        #RX
        pod 'RxSwift', '~> 4.0'
        pod 'RxCocoa'
        pod 'RxDataSources', '~> 3.0'
        pod 'NSObject+Rx'
        pod 'RxOptional'
        pod 'RxGesture'
        pod 'Then'
        pod 'Action'
        pod 'ReusableKit'
        pod 'ReactorKit'

        #code review
        pod 'SwiftLint'
    end
end

target 'ViteTests' do
    inherit! :search_paths
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        if ['JSONRPCKit'].include? target.name
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '3.0'
            end
        end
        if ['ChameleonFramework/Swift'].include? target.name
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '3.0'
            end
        end
    end
end
