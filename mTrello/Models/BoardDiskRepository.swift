//
//  BoardDiskRepository.swift
//  mTrello
//
//  Created by Doug on 12/28/21.
//

import Foundation

struct BoardDiskRepository {
    private var savePathURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("board.trl")
    }
    
    func loadFromDisk() -> Board? {
        guard let data = try? Data(contentsOf: savePathURL) else { return nil}
        
        return try? JSONDecoder().decode(Board.self, from: data)
    }
    
    func saveToDisk(board:Board) {
        guard let data = try? JSONEncoder().encode(board) else { return }
        
        try? data.write(to: savePathURL, options: .atomic)
    }
}
