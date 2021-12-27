//
//  CardView.swift
//  mTrello
//
//  Created by Doug on 12/27/21.
//

import SwiftUI

struct CardView: View {
    @ObservedObject var boardList: BoardList
    @StateObject var card: Card
    
    var body: some View {
        HStack {
            Text(card.content).lineLimit(3)
            Spacer()
            Menu {
                Button("Rename") {}
                Button("Delete", role: .destructive) {}
            } label: {
                Image(systemName: "ellipsis.rectangle")
                    .imageScale(.small)
                
            }
        }
        .padding(8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .cornerRadius(4)
        .shadow(radius: 1, y: 1)
    }
}

struct CardView_Previews: PreviewProvider {
    @StateObject static var boardList = Board.stub.boardLists[0]
    
    static var previews: some View {
        CardView(boardList: boardList, card: boardList.cards[0])
            .previewLayout(.sizeThatFits)
            .frame(width: 300)
    }
}
