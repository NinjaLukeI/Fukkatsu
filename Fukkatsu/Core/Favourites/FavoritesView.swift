//
//  FavoritesView.swift
//  Fukkatsu
//
//  Created by Luke Ibeachum on 07/11/2023.
//

import SwiftUI

struct FavoritesView: View {

    @ObservedObject var favoritesStore: FavoritesStore = .standard

    /// Store the favorite that has to be shown inside a detail view.
    @State var selectedFavorite: String?

    var body: some View {
        NavigationView {
            ForEach(favoritesStore.favorites, id: \.self) { favorite in
                Button(favorite) {

                    /// Update `selectedFavorite` on tap.
                    selectedFavorite = favorite
                }.tint(Color.primary)
            }.navigationTitle("My Favorites")

                /// Whenever `selectedFavorite` is set, a new `FavoriteDetailView` is pushed.
                .navigationDestination(for: .constant(selectedFavorite)) { favorite in
                    FavoriteDetailView(favorite: favorite)
                }
        }
    }
}

struct FavoriteDetailView: View {

    let favorite: String

    var body: some View {
        VStack {
            Text("Opened favorite:")
            Text(favorite)
            Button("Remove from favorites") {
                FavoritesStore.standard.remove(favorite)
            }
        }
    }
}

final class FavoritesStore: ObservableObject {
    static let standard = FavoritesStore()

    @Published var favorites: [String] = ["Swift", "SwiftUI", "UIKit"]

    func add(_ favorite: String) {
        favorites.append(favorite)
    }

    func remove(_ favorite: String) {
        favorites.removeAll(where: { $0 == favorite })
    }
}
