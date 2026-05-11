import Foundation

extension NumberFormatter {
    static let eth: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return formatter
    }()
}

extension Double {
    var ethFormatted: String {
        let value = NumberFormatter.eth.string(from: NSNumber(value: self)) ?? "\(self)"
        return "\(value) ETH"
    }
}
