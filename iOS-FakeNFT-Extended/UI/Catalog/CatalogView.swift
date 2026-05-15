import SwiftUI

struct CatalogView: View {
    @Environment(ServicesAssembly.self) var servicesAssembly
    @State private var presentingNft = false

//    var body: some View {
//        Button {
//            showNft()
//        } label: {
//            Text(Constants.openNftTitle)
//                .tint(.blue)
//        }
//        .backgroundStyle(.background)
//        .sheet(isPresented: $presentingNft) {
//            NftDetailBridgeView()
//        }
//    }
//
//    func showNft() {
//        presentingNft = true
//    }
    
    var body: some View {
        List {
            Text("Hello, World!")
        }
        .task {
            do {
                let url = URL(string: "\(RequestConstants.baseURL)/api/v1/collections")!
                
                var request = URLRequest(url: url)
                request.addValue(
                    RequestConstants.token,
                    forHTTPHeaderField: "X-Practicum-Mobile-Token"
                )

                let (data, _) = try await URLSession.shared.data(for: request)

                print(String(decoding: data, as: UTF8.self))
            } catch {
                print(error)
            }
        }
    }
}

private enum Constants {
    static let openNftTitle = NSLocalizedString("Catalog.openNft", comment: "")
}
