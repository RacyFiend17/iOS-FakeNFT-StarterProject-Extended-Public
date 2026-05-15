//
//  CatalogState.swift
//  iOS-FakeNFT-Extended
//
//  Created by Дмитрий Перчемиди on 15.05.2026.
//

import Foundation

enum CatalogState {
    case loading
    case loaded([Collection])
    case empty
    case error(String)
}
