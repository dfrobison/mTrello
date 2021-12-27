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
}
