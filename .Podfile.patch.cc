# Podfile  非入侵式修改的自定义配置
# 执行pod install 非侵入式修改

###  cp .Podfile.patch.sample .Podfile.patch

pod 'ViteCommunity', :path =>'../vite-community-ios/ViteCommunity.podspec'
pod 'ViteBusiness', :path =>'../vite-business-ios/ViteBusiness.podspec'
pod 'ViteWallet', :path =>'../vite-wallet-ios/ViteWallet.podspec'