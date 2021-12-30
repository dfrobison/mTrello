//
//  BoardDropDelegate.swift
//  mTrello
//
//  Created by Doug on 12/28/21.
//

import Foundation
import SwiftUI

struct BoardDropDelegate: DropDelegate {
    let board: Board
    let boardList: BoardList
    
    @Binding var dragDestinationBoardList: [BoardList]
    @Binding var currentDragBoardList: BoardList?
    
    private func boardListItemProviders(info: DropInfo) -> [NSItemProvider] {
        info.itemProviders(for: [BoardList.typeIdentifier])
    }
    
    private func cardItemProviders(info: DropInfo) -> [NSItemProvider] {
        info.itemProviders(for: [Card.typeIdentifier])
    }
    
    func dropEntered(info: DropInfo) {
        guard !boardListItemProviders(info: info).isEmpty,
              let current = currentDragBoardList,
              boardList != current,
              let fromIndex = dragDestinationBoardList.firstIndex(of: current),
              let toIndex = dragDestinationBoardList.firstIndex(of: boardList)
        else { return }
        
        dragDestinationBoardList.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: toIndex > fromIndex ? toIndex + 1 : toIndex)
    }
    
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        if !cardItemProviders(info: info).isEmpty {
            return DropProposal(operation: .move)
        } else if !boardListItemProviders(info: info).isEmpty {
            return DropProposal(operation: .move)
        }
        
        return nil
    }
    
    func performDrop(info: DropInfo) -> Bool {
        let cardItemProviders = cardItemProviders(info: info)
        for cardItemProvider in cardItemProviders {
            cardItemProvider.loadObject(ofClass: Card.self) { item, _ in
                guard let card = item as? Card, card.boardListId != boardList.id else { return }
                DispatchQueue.main.async {
                    board.move(card: card, to: boardList, at: 0)
                }
                
            }
        }
        currentDragBoardList = nil
        return true
    }
}
