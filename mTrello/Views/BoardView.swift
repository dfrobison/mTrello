//
//  BoardView.swift
//  mTrello
//
//  Created by Doug on 12/27/21.
//
import SwiftUI

let boardListBackgroundColor = Color(uiColor: UIColor(red: 0.92, green: 0.92, blue: 0.94, alpha: 1))
let mTrellBlueBackgroundColor = Color(uiColor: UIColor(red: 0.2, green: 0.47, blue: 0.73, alpha: 1))

struct BoardView: View {
    @StateObject private var board: Board = BoardDiskRepository().loadFromDisk() ?? Board.stub
    @State private var dragging: BoardList?
    
    var body: some View {
        NavigationView {
            ScrollView(.horizontal) {
                LazyHStack(alignment: .top, spacing: 24) {
                    ForEach(board.boardList) { boardList in
                        BoardListView(board: board, boardList: boardList)
                            .onDrag({
                                self.dragging = boardList
                                return NSItemProvider(object: boardList)
                            })
                            .onDrop(of: [Card.typeIdentifier, BoardList.typeIdentifier],
                                    delegate: BoardDropDelegate(board: board, boardList: boardList,
                                                                dragDestinationBoardList: $board.boardList,
                                                               currentDragBoardList: $dragging))
                    }
                    
                    Button("+ Add list") {
                        handleOnAddList()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(boardListBackgroundColor.opacity(0.8))
                    .frame(width: 300)
                    .cornerRadius(8)
                    .foregroundColor(.black)
                }
                .padding()
                .animation(.default, value: board.boardList)
            }
            .background(mTrellBlueBackgroundColor.opacity(0.7))
            .navigationTitle(board.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Rename") {
                    handleRenameBoard()
                }
            }
        }
        .navigationViewStyle(.stack)
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            BoardDiskRepository().saveToDisk(board: board)
        }
    }
    
    private func handleRenameBoard() {
        presentAlertTextField(title: "Rename board", defaultTextFieldText: board.name) { text in
            guard let text = text, !text.isEmpty else { return }
            
            board.name = text
        }
    }
    
    private func handleOnAddList() {
        presentAlertTextField(title: "Add list") { text in
            guard let text = text, !text.isEmpty else { return }
            
            board.addNewBoardListWithName(text)
        }
    }
}

struct BoardView_Previews: PreviewProvider {
    @StateObject static var board = Board.stub
    static var previews: some View {
        BoardView()
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (12.9-inch) (5th generation"))
            .previewDisplayName("iPad Pro")
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
