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
    let textFieldHeight = UIFont.preferredFont(forTextStyle: .body).lineHeight * 4 // This is a hacked to fix the height of the TextEdit field so that the list height can be calculated correctly
    @FocusState private var isFocused: Bool
    
    var body: some View {
        
        if !card.isFocused {
            HStack {
                Text(card.content)
                Spacer()
                Menu {
                    Button("Edit") { handleEditCard() }
                    Button("Delete", role: .destructive) { boardList.removeCard(card) }
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
        } else {
            TextEditor(text: Binding(
                get: {
                    return card.content
                },
                set: { value in
                    var newValue = value
                    if value.contains("\n") {
                        newValue = value.replacingOccurrences(of: "\n", with: "")
                        card.isFocused = newValue.isEmpty
                    }
                    card.content = newValue
                }
            ))
            .focused($isFocused)
            .onAppear(perform: {isFocused = true})
            .onChange(of: isFocused) { isFocused in
                card.isFocused = isFocused
                if !isFocused && card.content.isEmpty{
                    boardList.removeCard(card)
                } else {
                    card.isFocused = isFocused
                }
            }
            .frame(maxWidth: .infinity, minHeight: textFieldHeight , maxHeight: textFieldHeight, alignment: .leading)
            .cornerRadius(4)
            .shadow(radius: 1, y: 1)
        }
    }
    
    private func handleEditCard() {
        presentAlertTextField(title: "Edit Card", message: nil, defaultTextFieldText: card.content ) { text in
            guard let text = text, !text.isEmpty else {
                return
            }
            
            card.content = text
        }
        
    }
}

struct CardView_Previews: PreviewProvider {
    @StateObject static var boardList = Board.stub.boardList[0]
    
    static var previews: some View {
        CardView(boardList: boardList, card: boardList.cards[0])
            .previewLayout(.sizeThatFits)
            .frame(width: 300)
    }
}
