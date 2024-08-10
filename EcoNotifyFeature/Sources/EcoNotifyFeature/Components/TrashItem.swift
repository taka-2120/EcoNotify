//
//  TrashItem.swift
//  EcoNotify
//
//  Created by Yu Takahashi on 7/18/24.
//

import SwiftUI
import EcoNotifyEntity
import EcoNotifyCore

public struct TrashItem: View {
    
    @State private var isEditSheetShown = false
    private let trash: Trash
    
    public init(for trash: Trash) {
        self.trash = trash
    }
    
    public var body: some View {
        Button {
            isEditSheetShown.toggle()
        } label: {
            HStack {
                Image(trash.category.image)
                    .resizable()
                    .padding(8)
                    .frame(width: 80, height: 80)
                    .background(.regularMaterial)
                    .corner()
                
                VStack(alignment: .leading) {
                    Text(trash.name)
                        .font(.title3)
                        .bold()
                    Text("next: \(trash.next.relativeLabel())")
                    
                    Spacer()
                    
                    ForEach(Array(trash.date.sort().enumerated()), id: \.offset) { index, date in
                        Text("\(date.frequency.label) \(date.dayOfWeek.label)\(index != trash.date.count - 1 ? ", " : "")")
                            .foregroundStyle(Color(.secondaryLabel))
                            .font(.callout)
                    }
                }
                .padding([.vertical, .leading], 10)
            }
            .sheet(isPresented: $isEditSheetShown) {
                DetailsView(for: trash)
            }
            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                Button {
                    isEditSheetShown.toggle()
                } label: {
                    Label("edit", systemImage: "square.and.pencil")
                        .tint(.blue)
                }

            }
        }
        .foregroundStyle(Color(.label))
    }
}
