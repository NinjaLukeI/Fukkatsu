//
//  SelectButton.swift
//  Fukkatsu
//
//  Created by Luke . on 09/12/2022.
//

import SwiftUI

struct SelectButton: View {
    @Binding var isSelected: Bool
    @State var color: Color
    @State var text: String
    
    
    
    var body: some View {
        ZStack{
            Rectangle()
                .frame(width: 80, height: 20)
                .foregroundColor(isSelected ? color : .gray)
            Text(text)
                .font(.callout)
                .fontWeight(.regular)
                .foregroundColor(.white)
                
        }
    }
}

struct SelectButton_Previews: PreviewProvider {
    static var previews: some View {
        SelectButton(isSelected: .constant(true), color: .green, text: "All")
    }
}
