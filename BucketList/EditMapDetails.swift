//
//  EditMapDetails.swift
//  BucketList
//
//  Created by DEEPAK BEHERA on 05/07/25.
//
import SwiftUI

struct EditMapDetails: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: ViewModel       // <-- single source of truth
    let location: Location                              // keep the original

    var onSave: (Location) -> Void

    init(location: Location, onSave: @escaping (Location) -> Void) {
        self.location = location
        self.onSave   = onSave
        _viewModel    = StateObject(wrappedValue: ViewModel(location: location))
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Place name", text: $viewModel.name)
                    TextField("Description", text: $viewModel.description)
                }

                Section("Nearby…") {
                    switch viewModel.loadingState {
                    case .loaded:
                        ForEach(viewModel.pages, id: \.pageid) { page in
                            VStack(alignment: .leading) {
                                Text(page.title).font(.headline)
                                Text(page.description).italic()
                            }
                        }

                    case .loading:
                        ProgressView()

                    case .failed:
                        Text("Please try again later")
                    }
                }
            }
            .navigationTitle("Place Details")
            .toolbar {
                Button("Save") {
                    var updated = location
                    updated.name        = viewModel.name
                    updated.description = viewModel.description
                    onSave(updated)
                    dismiss()
                }
            }
            .task { await viewModel.fetchNearbyPlaces() }
        }
    }
}

#Preview {
    EditMapDetails(location: .example) { _ in }
}
