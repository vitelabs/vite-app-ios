platform :ios, '10.0'
inhibit_all_warnings!
source 'https://github.com/CocoaPods/Specs.git'
require './vite_pod'

isOfficial = true

def vite_config(config, official)
    if official
        if config.name.include?("Debug")
            config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)','DEBUG=1','OFFICIAL=1']
            config.build_settings['SWIFT_ACTIVE_COMPILATION_CONDITIONS'] = ['DEBUG','OFFICIAL']
        elsif config.name.include?("Test")
            config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)','TEST=1','OFFICIAL=1']
            config.build_settings['SWIFT_ACTIVE_COMPILATION_CONDITIONS'] = ['TEST','OFFICIAL']
        elsif config.name.include?("Release")
            config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)','OFFICIAL=1']
            config.build_settings['SWIFT_ACTIVE_COMPILATION_CONDITIONS'] = 'OFFICIAL'
        end
    else
        if config.name.include?("Debug")
            config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)','DEBUG=1']
            config.build_settings['SWIFT_ACTIVE_COMPILATION_CONDITIONS'] = ['DEBUG']
        elsif config.name.include?("Test")
            config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)']
            config.build_settings['SWIFT_ACTIVE_COMPILATION_CONDITIONS'] = []
        elsif config.name.include?("Release")
            config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)']
            config.build_settings['SWIFT_ACTIVE_COMPILATION_CONDITIONS'] = []
        end
    end
end

app_project = Xcodeproj::Project.open(Dir.glob("*.xcodeproj")[0])
app_project.native_targets.each do |target|
    if target.name == 'Vite'
        target.build_configurations.each do |config|
            vite_config config, isOfficial
        end
    end
end
app_project.save



target 'Vite' do
    use_frameworks!

    #vite kit

    vite_community_git = 'https://github.com/vitelabs/vite-community-ios.git'
    vite_business_git = 'https://github.com/vitelabs/vite-business-ios.git'
    vite_wallet_git = 'https://github.com/vitelabs/vite-wallet-ios.git'
    vite_ethereum_git = 'https://github.com/vitelabs/vite-ethereum-ios.git'
    vite_grin_git = 'https://github.com/vitelabs/Vite_GrinWallet.git'
    vite_hd_git = 'https://github.com/vitelabs/vite-keystore-ios.git'

    vite_community_commit = 'f7c287c354bb651c88e196cc29cf206842dded54'
    vite_business_commit = 'f97928b5170f3a0f56abcdc633c563604b9beec8'
    vite_wallet_commit = '3ca56e4384d7e11023bfe35dd828934412e91674'
    vite_ethereum_commit = 'c763dfc0f0a0bfc4734c287412eb49e2ae907e2a'
    vite_grin_commit = '486abe32b4ac7566ddd0d4f89ff5c67802609865'
    vite_hd_commit = 'bfba916f8e33d01ea818ea4f19695f53b736d251'

    # if isOfficial
    #     vite_pod 'ViteCommunity', :git => vite_community_git, :commit => vite_community_commit
    # end
    # vite_pod 'ViteBusiness', :git => vite_business_git, :commit => vite_business_commit
    # vite_pod 'ViteWallet', :git => vite_wallet_git, :commit => vite_wallet_commit
    pod_branch = 'pre-mainnet'

    if isOfficial
        vite_pod 'ViteCommunity', :git => vite_community_git, :branch => pod_branch
    end
    vite_pod 'ViteBusiness', :git => vite_business_git, :branch => pod_branch
    vite_pod 'ViteWallet', :git => vite_wallet_git, :branch => pod_branch


    vite_pod 'ViteEthereum', :git => vite_ethereum_git, :commit => vite_ethereum_commit
    vite_pod 'Vite_HDWalletKit', :git => vite_hd_git, :commit => vite_hd_commit
    vite_pod 'Vite_GrinWallet', :git => vite_grin_git, :commit => vite_grin_commit

    pod 'SnapKit', '~> 4.0.0'
    pod 'BigInt', '~> 3.0'
    pod 'R.swift', '5.0.0.alpha.3'
    pod 'JSONRPCKit', '~> 3.0.0'
    pod 'PromiseKit', '~> 6.8.4'
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
    pod 'Bagel', '~>  1.3.2', :configurations => ['Debug', 'Test']
    
    pod 'FSPagerView'
    pod 'DNSPageView'

    target 'ViteTests' do
        inherit! :search_paths
    end
end

post_install do |installer|

    installer.pods_project.targets.each do |target|

        target.build_configurations.each do |config|
            config.build_settings['ENABLE_BITCODE'] = 'NO'
            if config.name.include?("Debug")
                config.build_settings['ONLY_ACTIVE_ARCH'] = 'YES'
            else 
                config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
            end
            vite_config config, isOfficial
        end

        if ['RazzleDazzle', 'JSONRPCKit', 'APIKit'].include? target.name
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '4.0'
            end
        end

        if ['web3swift'].include? target.name
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '5.0'
            end
        end
    end

    
end
