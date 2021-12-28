//
//  Board.swift
//  mTrello
//
//  Created by Doug on 12/27/21.
//

import Foundation

class Board: ObservableObject, Identifiable, Codable {
    private(set) var id = UUID()
    
    @Published var name: String
    @Published var boardList: [BoardList]
    
    enum CodingKeys: String, CodingKey {
        case id, boardList, name
    }

    
    init(name: String, boardList: [BoardList] = []) {
        self.name = name
        self.boardList = boardList
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(UUID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.boardList = try container.decode([BoardList].self, forKey: .boardList)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(boardList, forKey: .boardList)
    }
    
    func move(card: Card, to boardList: BoardList, at index: Int) {
        guard let sourceBoardLIstIndex = boardListIndex(id: card.boardListId),
              let destinationBoardListIndex = boardListIndex(id: boardList.id),
              sourceBoardLIstIndex != destinationBoardListIndex,
              let sourceCardIndex = cardIndex(id: card.id, boardIndex: sourceBoardLIstIndex) else { return }
        
        boardList.cards.insert(card, at: index)
        card.moveToBoardList(boardList.id)
        self.boardList[sourceBoardLIstIndex].cards.remove(at: sourceCardIndex)
    }
    
    func addNewBoardListWithName(_ name: String) {
        boardList.append(BoardList(name: name, boardId: id))
    }
    
    func removeBoardList(_ boardList: BoardList) {
        guard let index = boardListIndex(id: boardList.id) else { return }
        self.boardList.remove(at: index)
    }
    
    private func cardIndex(id: UUID, boardIndex: Int) -> Int? {
        boardList[boardIndex].cardIndex(id: id)
    }
    
    private func boardListIndex(id: UUID) -> Int? {
        boardList.firstIndex { $0.id == id }
    }
}
