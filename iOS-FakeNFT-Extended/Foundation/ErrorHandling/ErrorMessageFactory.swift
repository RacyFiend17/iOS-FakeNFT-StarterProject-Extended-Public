//
//  ErrorMessageFactory.swift
//  iOS-FakeNFT-Extended
//
//  Created by Алла on 12.05.2026.
//

import Foundation

enum ErrorMessageFactory {
    static func message(from error: Error) -> String {
        guard let networkError = error as? NetworkClientError else {
            return Constants.defaultErrorMessage
        }
        
        switch networkError {
        case .httpStatusCode:
            return Constants.serverErrorMessage
            
        case .urlRequestError, .urlSessionError:
            return Constants.connectionErrorMessage
            
        case .parsingError:
            return Constants.parsingErrorMessage
            
        case .incorrectRequest:
            return Constants.requestErrorMessage
        }
    }
}

// MARK: - Constants

private extension ErrorMessageFactory {
    enum Constants {
        static let defaultErrorMessage = "Не удалось загрузить данные"
        static let serverErrorMessage = "Ошибка сервера. Попробуйте позже"
        static let connectionErrorMessage = "Проверьте подключение к интернету"
        static let parsingErrorMessage = "Не удалось обработать данные"
        static let requestErrorMessage = "Не удалось выполнить запрос"
    }
}
