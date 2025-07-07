//
//  ContentView-ViewModel.swift
//  BucketList
//
//  Created by DEEPAK BEHERA on 07/07/25.
//
import SwiftUI
import CoreLocation
import LocalAuthentication

extension ContentView {
    @Observable
    @MainActor
    class ViewModel {
        private(set) var locations: [Location]
        var selectedLocation: Location?
        var unLocked = false
        
        func addLocation(at point: CLLocationCoordinate2D) {
            let newLocation = Location(id: UUID(), name: "new Location", description: "", latitude: point.latitude, longitude: point.longitude)
            locations.append(newLocation)
            save()
        }
        
        func updateLocation(location: Location) {
            guard let index = locations.firstIndex(where: { $0.id == location.id }) else { return }
            locations[index] = location
            save()
            selectedLocation = nil
        }

        
        let savedUrl = URL.documentsDirectory.appending(path: "SavedPlaces")
        init() {
            do {
                let (data) = try Data(contentsOf: savedUrl)
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                locations = []
            }
        }
        
        func save() {
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savedUrl, options: [.atomic, .completeFileProtection])
            } catch {
                print("Error while saving data")
            }
        }
        func authentication() {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Please authenticate yourself to unlock your favorite locations"
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationFailure in
                    if success {
                        Task { @MainActor in
                            self.unLocked = true
                        }
                        
                    } else {
                        //
                    }
                }
            } else {
                // no biometrics
            }
        }
    }
}
