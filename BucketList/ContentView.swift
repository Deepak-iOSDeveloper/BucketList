//
//  ContentView.swift
//  BucketList
//
//  Created by DEEPAK BEHERA on 03/07/25.
//

import SwiftUI
import MapKit
import LocalAuthentication

struct ContentView: View {
    @State private var viewModel = ViewModel()
    let position = MapCameraPosition.region(
        MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 28.540954827961826, longitude: 76.994553445291), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
    )
    var body: some View {
        VStack {
            if viewModel.unLocked {
                MapReader { proxy in
                    Map(initialPosition: position) {
                        ForEach(viewModel.locations, id: \.id) { location in
                            Annotation(location.name, coordinate: location.coordinates) {
                                Button {
                                    viewModel.selectedLocation = location
                                } label: {
                                    Image(systemName: "star.circle")
                                        .resizable()
                                        .foregroundStyle(.red)
                                        .frame(width: 44, height: 44)
                                        .background(.white)
                                        .clipShape(Circle())
                                    Text(location.name.isEmpty ? "New place" : location.name)
                                        .font(.headline)
                                        .padding()
                                        .foregroundStyle(.white)

                                }
                                
                            }
                        }
                    }
                    .mapStyle(.hybrid)
                    .onTapGesture { position in
                        if let coordinates = proxy.convert(position, from: .local) {
                            viewModel.addLocation(at: coordinates)
                        }
                    }
                }
                .sheet(item: $viewModel.selectedLocation) { place in
                    EditMapDetails(location: place) {
                        viewModel.updateLocation(location: $0)
                    }
                }
            } else {
                Button("Unlock", action: viewModel.authentication)
                    .padding()
                    .background(.blue)
                    .foregroundStyle(.white)
                    .clipShape(.capsule)
            }
        }
    }
}


#Preview {
    ContentView()
}
