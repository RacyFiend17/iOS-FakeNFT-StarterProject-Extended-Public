//
//  AppIcon.swift
//  iOS-FakeNFT-Extended
//
//  Created by Алла on 02.05.2026.
//

import SwiftUI

enum AppIcon: Hashable {
    case system(String)
    case asset(String)
}

extension AppIcon {
    var image: Image {
        switch self {
        case .system(let name):
            return Image(systemName: name)
        case .asset(let name):
            return Image(name)
        }
    }
    
    var rawValue: String {
        switch self {
        case .system(let name):
            return "system:\(name)"
        case .asset(let name):
            return "asset:\(name)"
        }
    }
    
    // MARK: - Initialization
    
    init(rawValue: String) {
        if rawValue.hasPrefix("system:") {
            let name = rawValue.replacingOccurrences(of: "system:", with: "")
            self = .system(name)
        } else if rawValue.hasPrefix("asset:") {
            let name = rawValue.replacingOccurrences(of: "asset:", with: "")
            self = .asset(name)
        } else {
            self = .system("questionmark")
        }
    }
    
    // MARK: - SF Symbols
    
    static let chevronLeft = AppIcon.system("chevron.left")
    static let chevronRight = AppIcon.system("chevron.right")
    
    // MARK: - Assets: Icons

    static let addFoto = AppIcon.asset("addFotoYP")
    static let addButton = AppIcon.asset("addYP")
    static let basket = AppIcon.asset("basketYP")
    static let cartAdd = AppIcon.asset("cartAddYP")
    static let cartDelete = AppIcon.asset("cartDeleteYP")
    static let catalog = AppIcon.asset("catalogYP")
    static let close = AppIcon.asset("closeYP")
    static let done = AppIcon.asset("doneYP")
    static let edit = AppIcon.asset("editYP")
    static let like = AppIcon.asset("likeYP")
    static let loaderDark = AppIcon.asset("loaderDarkYP")
    static let loaderLight = AppIcon.asset("loaderLightYP")
    static let profile = AppIcon.asset("profileYP")
    static let sort = AppIcon.asset("sortYP")
    static let star = AppIcon.asset("starYP")
    static let statistics = AppIcon.asset("statistics")

    // MARK: - Assets: Images

    static let onboardingPageOne = AppIcon.asset("onboarding_1")
    static let onboardingPageTwo = AppIcon.asset("onboarding_2")
    static let onboardingPageThree = AppIcon.asset("onboarding_3")
    
    static let nftStub = AppIcon.asset("nftStubYP")
    static let successStub = AppIcon.asset("successStub")
    static let userFotoStub = AppIcon.asset("userFotoStubYP")
}
