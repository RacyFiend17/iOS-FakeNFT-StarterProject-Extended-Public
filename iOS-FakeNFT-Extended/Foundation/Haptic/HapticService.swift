//
//  HapticService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Перчемиди on 24.05.2026.
//

import UIKit

final class HapticService {

    static let shared = HapticService()

    private init() {
    }

    func impact(_ feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle) {
        let impactGenerator = UIImpactFeedbackGenerator(style: feedbackStyle)
        impactGenerator.impactOccurred()
        impactGenerator.prepare()
    }
}
