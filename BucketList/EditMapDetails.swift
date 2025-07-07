//
//  EditMapDetails.swift
//  BucketList
//
//  Created by DEEPAK BEHERA on 05/07/25.
//
import SwiftUI

struct EditMapDetails: View {
    @Environment(\.dismiss) var dismiss
    var location: Location
    var onSave: (Location) -> Void
    @State private var name: String
    @State private var description: String
    @State private var pages = [Pages]()
    @State private var loadingState = LoadingState.loading
    init(location: Location, onSave: @escaping(Location) -> Void) {
        self.location = location
        self.onSave = onSave
        
        _name = State(initialValue: location.name)
        _description = State(initialValue: location.description)
    }
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section {
                        TextField("Place name", text: $name)
                        TextField("Description", text: $description)
                    }
                    Section("Near by ....") {
                        switch loadingState {
                        case .loaded:
                            ForEach(pages, id:\.pageid) { page in
                                Text(page.title)
                                    .font(.headline)
                                + Text(": ") +
                                Text(page.description)
                                    .italic()
                            }
                        case .loading:
                            Text("loading...")
                        case .failed:
                            Text("Please try again later")
                        }
                    }
                }
            }
            .navigationTitle("place detail")
            .toolbar {
                Button("Save") {
                    var newLocation = location
                    newLocation.name = name
                    newLocation.description = description
                    
                    onSave(newLocation)
                    dismiss()
                }
            }
            .task {
                await fetchNearByPlaces()
            }
        }
    }
    func fetchNearByPlaces() async {
        let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.latitude)%7C\(location.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
        guard let url = URL(string: urlString) else {
            print("invalid url")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedData = try JSONDecoder().decode(Result.self, from: data)
            pages = decodedData.query.pages.values.sorted()
            loadingState = .loaded
        }
        catch {
            loadingState = .failed
            print("failed to load")
            
        }

    }
}

#Preview {
    EditMapDetails(location: .example) { _ in }
}
