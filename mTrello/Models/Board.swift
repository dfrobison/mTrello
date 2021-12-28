//
//  Board.swift
//  mTrello
//
//  Created by Doug on 12/27/21.
//

import Foundation

class Board: ObservableObject, Identifiable {
    private(set) var id = UUID()
    
    @Published var name: String
    @Published var boardLists: [BoardList]
    
    enum CodingKeys: String, CodingKey {
        case id, boardLists, name
    }

    
    init(name: String, boardLists: [BoardList] = []) {
        self.name = name
        self.boardLists = boardLists
    }
    
    func move(card: Card, to boardList: BoardList, at index: Int) {
        guard let sourceBoardLIstIndex = boardListIndex(id: card.boardListId),
              let destinationBoardListIndex = boardListIndex(id: boardList.id),
              sourceBoardLIstIndex != destinationBoardListIndex,
              let sourceCardIndex = cardIndex(id: card.id, boardIndex: sourceBoardLIstIndex) else { return }
        
        boardList.cards.insert(card, at: index)
        card.moveToBoardList(boardList.id)
        boardLists[sourceBoardLIstIndex].cards.remove(at: sourceCardIndex)
    }
    
    func addNewBoardListWithName(_ name: String) {
        boardLists.append(BoardList(name: name, boardId: id))
    }
    
    func removeBoardList(_ boardList: BoardList) {
        guard let index = boardListIndex(id: boardList.id) else { return }
        boardLists.remove(at: index)
    }
    
    private func cardIndex(id: UUID, boardIndex: Int) -> Int? {
        boardLists[boardIndex].cardIndex(id: id)
    }
    
    private func boardListIndex(id: UUID) -> Int? {
        boardLists.firstIndex { $0.id == id }
    }
}
