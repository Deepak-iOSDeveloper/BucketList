//
//  EditMapDetails-ViewModel.swift
//  BucketList
//
//  Created by DEEPAK BEHERA on 07/07/25.
//
import SwiftUI

extension EditMapDetails {
    @MainActor
    final class ViewModel: ObservableObject {
        // Published properties drive the UI
        @Published var name: String
        @Published var description: String
        @Published var pages: [Pages]      = []
        @Published var loadingState       = LoadingState.loading
        
        let location: Location
        
        // MARK: - Init
        init(location: Location) {
            self.location     = location
            self.name         = location.name
            self.description  = location.description
        }
        
        // MARK: - Networking
        func fetchNearbyPlaces() async {
            let urlString =
            "https://en.wikipedia.org/w/api.php" +
            "?ggscoord=\(location.latitude)%7C\(location.longitude)" +
            "&action=query&prop=coordinates%7Cpageimages%7Cpageterms" +
            "&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50" +
            "&wbptterms=description&generator=geosearch" +
            "&ggsradius=10000&ggslimit=50&format=json"
            
            guard let url = URL(string: urlString) else {
                loadingState = .failed
                return
            }
            
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let decoded   = try JSONDecoder().decode(Result.self, from: data)
                pages         = decoded.query.pages.values.sorted()
                loadingState  = .loaded
            } catch {
                loadingState  = .failed
                print("Failed to load pages:", error.localizedDescription)
            }
        }
    }
}

