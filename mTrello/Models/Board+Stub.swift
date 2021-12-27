//
//  Board+Stub.swift
//  mTrello
//
//  Created by Doug on 12/27/21.
//

import Foundation

extension Board {
    
    static var stub: Board {
        let board = Board(name: "mTrello")
        let backlogBoardList = BoardList(name: "Backlog", boardId: board.id)
        let backlogCards = [
            "Cloud Service",
            "Ingestion Engine",
            "Compression Engine",
            "DB Service",
            "Routing Engine",
            "Scheme Design",
            "Web Analytics Dashboard and CMS"
        ].map {Card(content: $0, boardListId: backlogBoardList.id)}
        
        backlogBoardList.cards = backlogCards
        
        let todoBoardList = BoardList(name: "ToDo", boardId: board.id)
        let todoCards = [
            "Text Search",
            "Error Handling",
        ].map {Card(content: $0, boardListId: todoBoardList.id)}
        
        todoBoardList.cards = todoCards
        
        let doneBoardList = BoardList(name: "Done", boardId: board.id)
        
        board.boardLists = [
        backlogBoardList,
        todoBoardList,
        doneBoardList]
        
        return board

    }
}
