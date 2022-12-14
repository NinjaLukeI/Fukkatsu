//
//  MangaListView.swift/Users/luke./Documents/projects/Fukkatsu/Fukkatsu/Views
//  Fukkatsu
//
//  Created by Luke . on 06/12/2022.
//

import SwiftUI

struct MangaListView: View {
    
    @StateObject private var vm = MangaListModel()
    
    
    
    var body: some View {
        VStack{
            Image("op")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 97.0, height: 183.0)
                .shadow(radius: 2)
                //.clipped()
            
            HStack(alignment: .lastTextBaseline){
                Text("Manga Name")
                    .fontWeight(.medium)
                    .padding(.bottom, 2.0)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.caption)
                    .lineLimit(2)
                    	
                
                    
//                Will eventually fix placement of button
//                Menu {
//                    Button {
//                        print("")
//                    } label: {
//                        Text("Add to list")
//                    }
//
//                } label: {
//                    Label {
//                    } icon: {
//                        Image(systemName: "ellipsis")
//                            .rotationEffect(.degrees(90))
//                            .foregroundColor(.black)
//
//
//
//                    }
//
//                }
//
            }
            
            Text("Manga Author")
                .font(.caption2)
                .frame(maxWidth: .infinity, alignment: .leading)
                .allowsTightening(true)
                .offset(y: -8)
        }
        .frame(width: 115, height: 248)
        //.background(Color.gray)
        //.border(.black, width: 0.3)
        //.cornerRadius(4)
        
        
        
        
    }
}

struct MangaListView_Previews: PreviewProvider {
    static var previews: some View {
        MangaListView()
    }
}
