//
//  Helper.swift
//  Fukkatsu
//
//  Created by Luke Ibeachum on 30/01/2023.
//

import Foundation
import SwiftUI

func optionalCheck(value: String?) -> String{
    if let data = value{
        return data
    }
    return ""
}

//check if a string is a double
extension String {
    var isDouble: Bool{
        return Double(self) != nil
    }
    
}

func removeDuplicateElements(manga: [Manga]) -> [Manga] {
    var uniqueManga = [Manga]()
    for item in manga {
        if !uniqueManga.contains(where: {$0.id == item.id }) {
            uniqueManga.append(item)
        }
    }
    return uniqueManga
}


struct NavigationStackModifier<Item, Destination: View>: ViewModifier {
    let item: Binding<Item?>
    let destination: (Item) -> Destination

    func body(content: Content) -> some View {
        content.background(NavigationLink(isActive: item.mappedToBool()) {
            if let item = item.wrappedValue {
                destination(item)
            } else {
                EmptyView()
            }
        } label: {
            EmptyView()
        })
    }
}

public extension View {
    func navigationDestination<Item, Destination: View>(
        for binding: Binding<Item?>,
        @ViewBuilder destination: @escaping (Item) -> Destination
    ) -> some View {
        self.modifier(NavigationStackModifier(item: binding, destination: destination))
    }
}

public extension Binding where Value == Bool {
    init<Wrapped>(bindingOptional: Binding<Wrapped?>) {
        self.init(
            get: {
                bindingOptional.wrappedValue != nil
            },
            set: { newValue in
                guard newValue == false else { return }

                /// We only handle `false` booleans to set our optional to `nil`
                /// as we can't handle `true` for restoring the previous value.
                bindingOptional.wrappedValue = nil
            }
        )
    }
}

extension Binding {
    public func mappedToBool<Wrapped>() -> Binding<Bool> where Value == Wrapped? {
        return Binding<Bool>(bindingOptional: self)
    }
}
