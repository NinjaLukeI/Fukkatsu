//
//  MangaListView.swift/Users/luke./Documents/projects/Fukkatsu/Fukkatsu/Views
//  Fukkatsu
//
//  Created by Luke . on 06/12/2022.
//

import SwiftUI

struct MangaListView: View {
    
    @StateObject private var mangaList = MangaListModel()
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        
    ]
    
    enum Option: String, CaseIterable, Identifiable{
        case All, ForYou
        var id: Self{ self }
    }
    
    @State private var selectedOption: Option = .All
    
    var body: some View {
        
        
        NavigationView{
            

            
            
            VStack{
                
                Picker("Option", selection: $selectedOption){
                    Text("All").tag(Option.All)
                    Text("For You").tag(Option.ForYou)
                }.padding(.horizontal).pickerStyle(.segmented)
                
                ScrollView{
                    
                    LazyVGrid(columns: columns, spacing: 10){
                        
                        ForEach(mangaList.items){ item in
                            MangaView(manga: item)
                        }
                    }
                    .padding(.horizontal)
                }
                .task{
                    await mangaList.populate()
                }
                .navigationBarTitleDisplayMode(.inline)
                
                .toolbar{
                    ToolbarItem(placement: .principal) {
                        
                        Text("Discovery").font(.title3).fontWeight(.regular)
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing){
                        Button {
                            
                        } label: {
                            Image(systemName: "magnifyingglass")
                                .tint(.blue)
                        }
                    }
                }
                
            }
                
           
            }
        
    }
    
}

struct MangaListView_Previews: PreviewProvider {
    static var previews: some View {
        MangaListView()
    }
}
