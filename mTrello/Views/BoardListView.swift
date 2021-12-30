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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            headerView
            listView
                .listStyle(.plain)
                .frame(maxHeight: listHeight)
            
            Button("+ Add Card") {
                handleAddCard()
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(.vertical)
        .background(boardListBackgroundColor)
        .frame(width: 300)
        .cornerRadius(8)
        .foregroundColor(.black)
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
    
    private func handleAddCard() {
        board.resetFocus()
        boardList.addNewCard()
    }
}

struct BoardListView_Previews: PreviewProvider {
    @StateObject static var board = Board.stub
    static var previews: some View {
        BoardListView(board: board, boardList: board.boardList[0], listHeight: 512)
            .previewLayout(.sizeThatFits)
            .frame(width: 300, height: 512)
    }
}
