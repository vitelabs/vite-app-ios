platform :ios, '11.0'
inhibit_all_warnings!
source 'https://github.com/CocoaPods/Specs.git'
require './vite_pod'

# Vite ViteOfficial ViteTest ViteDapp
target_name = 'ViteOfficial'


def vite_config(config, name)
    if name == 'Vite'
        if config.name.include?("Debug")
            config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)','DEBUG=1']
            config.build_settings['SWIFT_ACTIVE_COMPILATION_CONDITIONS'] = ['DEBUG']
            config.build_settings['OTHER_SWIFT_FLAGS'] = '$(inherited) -Xfrontend -debug-time-function-bodies'
        elsif config.name.include?("Release")
            config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)']
            config.build_settings['SWIFT_ACTIVE_COMPILATION_CONDITIONS'] = []
        end
    elsif name == 'ViteOfficial'
        if config.name.include?("Debug")
            config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)','DEBUG=1','OFFICIAL=1']
            config.build_settings['SWIFT_ACTIVE_COMPILATION_CONDITIONS'] = ['DEBUG','OFFICIAL']
            config.build_settings['OTHER_SWIFT_FLAGS'] = '$(inherited) -Xfrontend -debug-time-function-bodies'
        elsif config.name.include?("Release")
            config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)','OFFICIAL=1']
            config.build_settings['SWIFT_ACTIVE_COMPILATION_CONDITIONS'] = 'OFFICIAL'
        end
    elsif name == 'ViteTest'
        if config.name.include?("Debug")
            config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)','DEBUG=1','OFFICIAL=1','TEST=1']
            config.build_settings['SWIFT_ACTIVE_COMPILATION_CONDITIONS'] = ['DEBUG','OFFICIAL', 'TEST']
            config.build_settings['OTHER_SWIFT_FLAGS'] = '$(inherited) -Xfrontend -debug-time-function-bodies'
        elsif config.name.include?("Release")
            config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)','OFFICIAL=1','TEST=1']
            config.build_settings['SWIFT_ACTIVE_COMPILATION_CONDITIONS'] = ['OFFICIAL', 'TEST']
        end
    elsif name == 'ViteDapp'
        if config.name.include?("Debug")
            config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)','DEBUG=1','DAPP=1']
            config.build_settings['SWIFT_ACTIVE_COMPILATION_CONDITIONS'] = ['DEBUG','DAPP']
            config.build_settings['OTHER_SWIFT_FLAGS'] = '$(inherited) -Xfrontend -debug-time-function-bodies'
        elsif config.name.include?("Release")
            config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)','DAPP=1']
            config.build_settings['SWIFT_ACTIVE_COMPILATION_CONDITIONS'] = 'DAPP'
        end
    end
end

#app_project = Xcodeproj::Project.open(Dir.glob("*.xcodeproj")[0])
#app_project.native_targets.each do |target|
#    if target.name == 'Vite'
#        target.build_configurations.each do |config|
#            vite_config config, isOfficial
#        end
#    end
#end
#app_project.save



target target_name do
    use_frameworks!

    #vite kit

    vite_community_git = 'https://github.com/vitelabs/vite-community-ios.git'
    vite_business_git = 'https://github.com/vitelabs/vite-business-ios.git'
    vite_wallet_git = 'https://github.com/vitelabs/vite-swift-kit.git'
    vite_grin_git = 'https://github.com/vitelabs/vite-grin-wallet-ios.git'
    vite_bnb_git = 'https://github.com/vitelabs/SwiftBinanceChain.git'
    vite_hd_git = 'https://github.com/vitelabs/vite-hd-wallet-kit-ios.git'

    vite_community_commit = '9b2789c13c84ae1a4e909d34b09e989e7067fb59'
    vite_business_commit = 'ac142d7d010d2c6df449835a60dc7a03849540d3'
    vite_wallet_commit = '3de410124eb5a8966c7c15ebd39dbf301ea21e75'
    vite_grin_commit = '4f1141a131e223a5a41686d2e9efa636e3f1ee24'
    vite_bnb_commit = 'b71de4cbc632bba469d31ff87d5d434115c68dfb'
    vite_hd_commit = 'afffc6fb34690e49ae94f2fd796032e08f487c53'

    if target_name == 'ViteOfficial' || target_name == 'ViteTest'
        vite_pod 'ViteCommunity', :git => vite_community_git, :commit => vite_community_commit
    end
    vite_pod 'ViteBusiness', :git => vite_business_git, :commit => vite_business_commit
    vite_pod 'ViteWallet', :git => vite_wallet_git, :commit => vite_wallet_commit
    
    # pod_branch = 'pre-mainnet'
    # if isOfficial
    #     vite_pod 'ViteCommunity', :git => vite_community_git, :branch => pod_branch
    # end
    # vite_pod 'ViteBusiness', :git => vite_business_git, :branch => pod_branch
    # vite_pod 'ViteWallet', :git => vite_wallet_git, :branch => pod_branch


    vite_pod 'Vite_HDWalletKit', :git => vite_hd_git, :commit => vite_hd_commit
    vite_pod 'Vite_GrinWallet', :git => vite_grin_git, :commit => vite_grin_commit
    vite_pod 'BinanceChain', :git => vite_bnb_git, :commit => vite_bnb_commit

#    pod 'Charts', :git => 'https://github.com/danielgindi/Charts.git', :tag => 'v3.4.0'
    pod 'Charts', '3.5.0'

    pod 'HDWalletKit', '0.3.6'
    pod 'SnapKit', '~> 4.0.0'
    pod 'BigInt', '~> 4.0'
    pod 'R.swift', '5.0.0.alpha.3'
    pod 'JSONRPCKit', '~> 3.0.0'
    pod 'PromiseKit', '~> 6.8.4'
    pod 'APIKit'
    pod 'ObjectMapper'
    pod 'MBProgressHUD'
    pod 'KeychainSwift', '13.0.0'
    pod 'Moya'
    pod 'MJRefresh', '3.1.15.7'
    pod 'KMNavigationBarTransition'
    pod 'XCGLogger', '~> 7.0'
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
    pod 'Eureka', '~> 5.3.0'
#    pod 'Eureka', :git => 'https://github.com/xmartlabs/Eureka.git', :branch => 'xcode12'

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
    pod 'SwiftLint', '0.31.0'

    #crash
    pod 'Firebase/Core'
    pod 'Firebase/Analytics'
    pod 'Firebase/Performance'
    pod 'Firebase/RemoteConfig'

#    pod 'MLeaksFinder', :configurations => ['Debug']
#    pod 'LookinServer', :configurations => ['Debug']

    if target_name == 'ViteTest'
        pod 'Bagel', '~>  1.3.2'
        pod 'DoraemonKit/Core', '~> 3.0.1'
        pod 'DoraemonKit/WithGPS', '~> 3.0.1'
        pod 'DoraemonKit/WithLoad', '~> 3.0.1'
    else
        pod 'Bagel', '~>  1.3.2', :configurations => ['Debug']
        pod 'DoraemonKit/Core', '~> 3.0.1', :configurations => ['Debug']
        pod 'DoraemonKit/WithGPS', '~> 3.0.1', :configurations => ['Debug']
        pod 'DoraemonKit/WithLoad', '~> 3.0.1', :configurations => ['Debug']
    end
    
    pod 'FSPagerView'

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
            vite_config config, target_name
        end

        if ['RazzleDazzle', 'JSONRPCKit', 'APIKit'].include? target.name
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '4.0'
            end
        elsif ['web3.swift.pod'].include? target.name
            target.build_configurations.each do |config|
              config.build_settings['SWIFT_VERSION'] = '5.0'
            end
        else
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '4.2'
            end
        end

    end

    
end
