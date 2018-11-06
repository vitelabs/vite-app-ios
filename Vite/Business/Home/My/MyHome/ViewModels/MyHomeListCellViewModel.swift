//
//  MyHomeListCellViewModel.swift
//  Vite
//
//  Created by Stone on 2018/11/6.
//  Copyright © 2018 vite labs. All rights reserved.
//

import UIKit
import ObjectMapper

class MyHomeListCellViewModel: Mappable {

    enum ViewModelType: String {
        case settings
        case about
        case custom
    }

    fileprivate var type: ViewModelType = .custom
    fileprivate var title: StringWrapper = StringWrapper(string: "")
    fileprivate var icon: String = ""
    fileprivate var url: String = ""

    fileprivate(set) var name: StringWrapper = StringWrapper(string: "")
    fileprivate(set) var image: ImageWrapper?

    required init?(map: Map) {
        guard let type = map.JSON["type"] as? String, let _ = ViewModelType(rawValue: type) else {
            return nil
        }
    }

    func mapping(map: Map) {
        type <- map["type"]
        title <- map["title"]
        icon <- map["icon"]
        url <- map["url"]

        switch type {
        case .settings:
            name = StringWrapper(string: R.string.localizable.myPageSystemCellTitle.key.localized())
            image = ImageWrapper.image(image: R.image.icon_setting()!)
        case .about:
            name = StringWrapper(string: R.string.localizable.myPageAboutUsCellTitle.key.localized())
            image = ImageWrapper.image(image: R.image.icon_token_vite()!)
        case .custom:
            name = title
            image = ImageWrapper.url(url: URL(string: icon)!)
        }
    }

    func clicked(viewController: UIViewController) {
        switch type {
        case .settings:
            let vc = SystemViewController()
            viewController.navigationController?.pushViewController(vc, animated: true)
        case .about:
            let vc = AboutUsViewController()
            viewController.navigationController?.pushViewController(vc, animated: true)
        case .custom:
            guard let url = URL(string: url) else { return }
            WebHandler.open(url)
        }
    }
}
