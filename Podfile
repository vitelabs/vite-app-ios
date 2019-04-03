platform :ios, '10.0'
inhibit_all_warnings!
source 'https://github.com/CocoaPods/Specs.git'
require './vite_pod'

targetArray = ['Vite']

targetArray.each do |t|
    target t do
        use_frameworks!

        #vite kit

        vite_community_git = 'https://github.com/vitelabs/vite-community-ios.git'
        vite_business_git = 'https://github.com/vitelabs/vite-business-ios.git'
        vite_wallet_git = 'https://github.com/vitelabs/vite-wallet-ios.git'
        vite_ethereum_git = 'https://github.com/vitelabs/vite-ethereum-ios.git'

        vite_community_commit = 'c7ac7fc2e71a3a8bd29f8f14dd76a9bb28cef88a'
        vite_business_commit = '63c38be7de302073a138659408842b28bbc328cd'
        vite_wallet_commit = 'c361cfd46f9ffeb39fd480561422784e8b726630'

        vite_pod 'ViteCommunity', :git => vite_community_git, :commit => vite_community_commit
        vite_pod 'ViteBusiness', :git => vite_business_git, :commit => vite_business_commit

        vite_pod 'ViteEthereum', :git => 'https://github.com/vitelabs/vite-ethereum-ios.git', :commit => 'cb3d0a8fe3cbe278470e18ea57734bf8efa94d07'
        vite_pod 'ViteWallet', :git => vite_wallet_git, :commit => vite_wallet_commit
        vite_pod 'Vite_HDWalletKit', '1.3.0'

        pod 'Vite_GrinWallet', :git => 'https://github.com/vitelabs/Vite_GrinWallet.git', :commit => '5a93ddc9040a6ca0e8513c873fcb62309840c0ab'

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
        pod 'Fabric', '~> 1.9.0'
        pod 'Crashlytics', '~> 3.12.0'
        pod 'Firebase/Core'

        pod 'MLeaksFinder', :configurations => ['Debug']

        pod 'FSPagerView'
        pod 'DNSPageView'

        if t == 'Vite'
            target 'ViteTests' do
                inherit! :search_paths
            end
        end

    end
end


post_install do |installer|
    installer.pods_project.targets.each do |target|

        target.build_configurations.each do |config|

            config.build_settings['ENABLE_BITCODE'] = 'NO'

            #debug
            if config.name.include?("Debug")

                config.build_settings['ONLY_ACTIVE_ARCH'] = 'YES'
                config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)','DEBUG=1','OFFICIAL=1']
                config.build_settings['SWIFT_ACTIVE_COMPILATION_CONDITIONS'] = ['DEBUG','OFFICIAL']
            end

            #Internal
            if config.name.include?("Internal")

                config.build_settings['ONLY_ACTIVE_ARCH'] = 'YES'
                config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)']
            end
            #test
            if config.name.include?("Test")

                config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
                config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)','TEST=1']
                config.build_settings['SWIFT_ACTIVE_COMPILATION_CONDITIONS'] = 'TEST'
            end
            #Release
            if config.name.include?("Release")

                config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
                config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)','OFFICIAL=1']
                config.build_settings['SWIFT_ACTIVE_COMPILATION_CONDITIONS'] = 'OFFICIAL'
            end
        end

        if ['RazzleDazzle', 'JSONRPCKit', 'APIKit'].include? target.name
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '4.0'
            end
        end
    end
end
