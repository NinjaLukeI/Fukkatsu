//
//  readerOverlay.swift
//  Fukkatsu
//
//  Created by Luke Ibeachum on 07/09/2023.
//

import SwiftUI

struct readerOverlay: View {
    var body: some View {
        
        
        GeometryReader{ proxy in
            RoundedRectangle(cornerRadius: 15)
                .overlay(
                    HStack{
                        VStack(alignment: .leading){
                            Text("manga name").font(.headline).foregroundColor(.white)
                                
                            
                            Text("Chapter Name").font(.caption).foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        Text("Exit").foregroundColor(.red)
                    }.frame(width: proxy.size.width - 100)
                        
                        
                        
                ).padding(.horizontal, 30.0)
                .frame(width: proxy.size.width , height: 60)
            
                
                
        }
        
    }
}

struct readerOverlay_Previews: PreviewProvider {
    static var previews: some View {
        readerOverlay()
    }
}
