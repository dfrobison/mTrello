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
    
    private func cardItemProviders(info: DropInfo) -> [NSItemProvider] {
        info.itemProviders(for: [Card.typeIdentifier])
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        if !cardItemProviders(info: info).isEmpty {
            DropProposal(operation: .copy)
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
        
        return true
    }
}
