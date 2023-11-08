//
//  Favourites.swift
//  Fukkatsu
//
//  Created by Luke Ibeachum on 01/11/2023.
//

import SwiftUI

struct FavouritesView: View {
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        
    ]
    
    @FetchRequest(sortDescriptors: []) var favourites: FetchedResults<Favourite>
    @StateObject private var FavouritesVM = FavouritesViewModel()
    
    @State var localFavourites: [Favourite] = []
    @State var tempID : String?
    
    
    var body: some View {
        
        NavigationView{
            
            
                    ScrollView{
                        
                        LazyVGrid(columns: columns, spacing: 10){
                            
                            
                            ForEach(favourites, id: \.self){ item in
                                
                                    
                                    Button(action: {tempID = item.id!}) {
                                            MangaView(id: item.id!)
                                            
                                    }
                                    .buttonStyle(.plain)
                                    .navigationDestination(for: $tempID){ id in
                                        FeedView(manga: MangaView(id: id))
                                            .navigationBarTitleDisplayMode(.inline)
                                    }
                                                                    
                            }
                        }
                        .padding(.horizontal)
                    }
                    .navigationBarTitle("Favourites")
                    .task{
                        if tempID == nil{
                            print("TEMP IS EMPTY")
                        }
                    }
                    
        }

    }
}

struct Favourites_Previews: PreviewProvider {
    static var previews: some View {
        FavouritesView()
    }
}
