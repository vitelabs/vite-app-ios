platform :ios, '13.0'
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

    vite_community_git = 'git@github.com:vitelabs/vite-community-ios.git'
    vite_business_git = 'https://github.com/vitelabs/vite-business-ios.git'
    vite_wallet_git = 'https://github.com/vitelabs/vite-swift-kit.git'
    vite_hd_git = 'https://github.com/vitelabs/vite-hd-wallet-kit-ios.git'
    HDWalletKit_git = 'https://github.com/vitelabs/HDWallet.git'
    web3_git = 'https://github.com/vitelabs/web3swift.git'

    vite_community_commit = '895cf9b347d536f582b458532c0c043489fab061'
    vite_business_commit = '1199686369e8d1024d33d1929ed074e4494307a1'
    vite_wallet_commit = '981a92d5012a0dcae0324b29e8657e78bced55ed'
    vite_hd_commit = 'db67644220ab1582459d08d47119ed26dcba8d47'
    HDWalletKit_commit = '26df860a4ce7cb26e299aa4f3e0338e8e7041b26'
    web3_commit = 'd2507cce4faa17916efa14fd84922a3e6b411634'

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
    vite_pod 'HDWalletKit', :git => HDWalletKit_git, :commit => HDWalletKit_commit
    vite_pod 'web3swift', :git => web3_git, :commit => web3_commit

    pod 'Charts', :git => 'https://github.com/danielgindi/Charts.git', :tag => 'v4.1.0'

#    pod 'HDWalletKit', '0.3.6'
    pod 'SnapKit', '~> 4.0.0'
    pod 'BigInt', '~> 5.0'
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
    pod 'SwiftProtobuf', '1.17.0'

    #request
    pod 'SwiftyJSON'

    #UI Control
    pod 'ActionSheetPicker-3.0'
    pod 'MBProgressHUD'
    pod 'Toast-Swift', '~> 4.0.1'
    pod 'RazzleDazzle', :git => 'https://github.com/mazhigbee-pb/RazzleDazzle.git', :branch => 'xcode-13-beta-fixes'
    pod 'CHIPageControl'

    #table static form
    pod 'Eureka', '~> 5.3.0'
#    pod 'Eureka', :git => 'https://github.com/xmartlabs/Eureka.git', :branch => 'xcode12'

    #RX
    pod 'RxSwift', '~> 6.0'
    pod 'RxCocoa', '~> 6.0'
    pod 'RxDataSources', '~> 5.0'
    pod 'NSObject+Rx', '~> 5.2.2'
    pod 'RxOptional', '~> 5.0'
    pod 'RxGesture', '~> 4.0.4'
    pod 'Then'
    pod 'Action', '~> 4.0'
    pod 'ReusableKit', '~> 4.0'
    pod 'ReactorKit', '~> 3.2.0'

    #code review
    pod 'SwiftLint', '0.31.0'

    #crash
#    pod 'Firebase/Core'
#    pod 'Firebase/Analytics'
#    pod 'Firebase/Performance'
#    pod 'Firebase/RemoteConfig'

#    pod 'MLeaksFinder', :configurations => ['Debug']
#    pod 'LookinServer', :configurations => ['Debug']

    if target_name == 'ViteTest'
        pod 'Bagel', '~>  1.3.2'
    else
        pod 'Bagel', '~>  1.3.2', :configurations => ['Debug']
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
            config.build_settings["DEVELOPMENT_TEAM"] = "5SR42372L5"
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
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
        elsif ['web3.swift.pod', 'Charts'].include? target.name
            target.build_configurations.each do |config|
              config.build_settings['SWIFT_VERSION'] = '5.0'
            end
        elsif ['RxSwift', 'RxCocoa', 'RxDataSources', 'NSObject+Rx', 'RxOptional', 'RxGesture', 'Then', 'Action', 'ReusableKit', 'ReactorKit'].include? target.name
            target.build_configurations.each do |config|
              config.build_settings['SWIFT_VERSION'] = '4.2'
            end
        else
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '4.2'
            end
        end
    
    end

    
end
