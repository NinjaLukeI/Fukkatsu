//
//  readerOverlay.swift
//  Fukkatsu
//
//  Created by Luke Ibeachum on 07/09/2023.
//

import SwiftUI

struct readerOverlay: View {
    var body: some View {
        
        VStack{
            
            //the proxy inherits the size of the parent view which in this case is just the screen
            GeometryReader{ proxy in
                RoundedRectangle(cornerRadius: 15)
                    .overlay(
                        HStack{
                            VStack(alignment: .leading){
                                Text("manga name").font(.headline).foregroundColor(.white)
                                    .lineLimit(1)
                                    
                                    
                                Text("Chapter Name").font(.caption).foregroundColor(.white)
                                    .lineLimit(1)
                            }
                            
                            Spacer()
                            
                            Text("Exit").foregroundColor(.red)
                        }.frame(width: proxy.size.width - 100)
                            
                            
                            
                    ).padding(.horizontal, 30.0)
                    .frame(width: proxy.size.width , height: 60)
                    
            }
            
            HStack{
                Button {
                    
                } label: {
                    Image(systemName: "highlighter")
                        .frame(width: 28, height: 28)
                        .background(.black)
                        .cornerRadius(15)
                        .foregroundColor(.white)
                        
                }
                
                Button {
                    
                } label: {
                    Image(systemName: "highlighter")
                        .frame(width: 28, height: 28)
                        .background(.black)
                        .cornerRadius(15)
                        .foregroundColor(.white)
                        
                }

            }
            
        }
        
        
    }
}

struct readerOverlay_Previews: PreviewProvider {
    static var previews: some View {
        readerOverlay()
    }
}
