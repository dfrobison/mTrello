//
//  BoardListView.swift
//  mTrello
//
//  Created by Doug on 12/27/21.
//

import SwiftUI
import Introspect

struct BoardListView: View {
    @ObservedObject var board: Board
    @StateObject var boardList: BoardList
    @State var listHeight: CGFloat = 0
    @State var cardAdded = false
    @State var shoudScroll = false
    @State var cardContent: String = ""
    @FocusState private var isFocused: Bool
    let textFieldHeight = UIFont.preferredFont(forTextStyle: .body).lineHeight * 4 // This is a hacked to fix the height of the TextEdit field so that the list height can be calculated correctly
    
    var body: some View {
        ScrollViewReader { proxy in
            VStack(alignment: .leading, spacing: 16) {
                headerView
                listView
                    .listStyle(.plain)
                    .frame(maxHeight: listHeight)
                
                if cardAdded {
                    TextEditor(text: Binding(
                        get: {
                            return cardContent
                        },
                        set: { value in
                            var newValue = value
                            if value.contains("\n") {
                                newValue = value.replacingOccurrences(of: "\n", with: "")
                                cardContent = newValue
                                if !cardContent.isEmpty {
                                    boardList.addNewCardWithContent(cardContent)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    proxy.scrollTo(boardList.cards.last!.id)
                                    }
                                } else {
                                    cardAdded = false
                                }
                    
                                newValue = ""
                            }
                            cardContent = newValue
                        }
                    ))
                    .focused($isFocused)
                    .onAppear(perform: {
                        print("OnAppear: Boardlist = \(boardList.name) Focus = \(isFocused)")
                        DispatchQueue.main.async {
                            isFocused = true
                        }
                        
                        
                    })
                    .onChange(of: isFocused) { isFocused in
                        print("OnChange: Boardlist = \(boardList.name) Focus = \(isFocused)")
                        if !isFocused && !cardContent.isEmpty {
                            boardList.addNewCardWithContent(cardContent)
                            cardContent = ""
                        }
                        
                        if !isFocused {
                            cardAdded = false
                        }
                    }
                    .frame(maxWidth: .infinity, minHeight: textFieldHeight , maxHeight: textFieldHeight, alignment: .leading)
                    .cornerRadius(4)
                    .shadow(radius: 1, y: 1)

                }
                
                
                HStack {
                Button("+ Add Card") {
                  //  handleAddCard()
                    cardAdded = true
                    isFocused = true
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                      //  isFocused = true
                    }
                    
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .center)
                    
                    Spacer()
                    
                    Button("Last") {
                        
                        proxy.scrollTo(boardList.cards.last!.id, anchor: .bottom)
                    }
                }
            }
            .padding(.vertical)
            .background(boardListBackgroundColor)
            .frame(width: 300)
            .cornerRadius(8)
            .foregroundColor(.black)
        }
    }
    
    private var listView: some View {
        List {
            ForEach(boardList.cards) { card in
                CardView(boardList: boardList, card: card)
                    .onDrag {
                        NSItemProvider(object: card)
                    }
            }
            .onInsert(of: [Card.typeIdentifier], perform: handleOnInsertCard(index:itemProviders:))
            .onMove(perform: boardList.moveCards(fromOffsets:toOffset:))
            .listRowSeparator(.hidden)
            .listRowInsets(.init(top: 4, leading: 8, bottom: 4, trailing: 8))
            .listRowBackground(Color.clear)
            .introspectTableView { listHeight = $0.contentSize.height }
        }
    }
    
    private func handleOnInsertCard(index: Int, itemProviders: [NSItemProvider]) {
        for itemProvider in itemProviders {
            itemProvider.loadObject(ofClass: Card.self) { item, _ in
                guard let card = item as? Card else { return }
                DispatchQueue.main.async {
                    board.move(card: card, to: boardList, at: index)
                }
            }
        }
    }
    
    private func handleBoardListRename() {
        presentAlertTextField(title: "Rename list", message: nil, defaultTextFieldText: boardList.name ) { text in
            guard let text = text, !text.isEmpty else {
                return
            }
            
            boardList.name = text
        }
    }
    
    private var headerView: some View {
        HStack(alignment: .top) {
            Text(boardList.name)
                .font(.headline)
                .lineLimit(2)
            Spacer()
            Menu {
                Button("Rename") {
                    handleBoardListRename()
                }
                
                Button("Delete", role: .destructive) {
                    board.removeBoardList(boardList)
                }
                
            } label: {
                Image(systemName: "ellipsis.circle")
                    .imageScale(.large)
            }
        }
        .padding(.horizontal)
    }
    
    private func handleAddCard() -> UUID {
        board.resetFocus()
        return boardList.addNewCard()
    }
}

struct BoardListView_Previews: PreviewProvider {
    @StateObject static var board = Board.stub
    static var previews: some View {
        BoardListView(board: board, boardList: board.boardList[0], listHeight: 512, cardContent: "help")
            .previewLayout(.sizeThatFits)
            .frame(width: 300, height: 512)
    }
}
