//
//  Card.swift
//  mTrello
//
//  Created by Doug on 12/27/21.
//

import Foundation

class Card: NSObject, ObservableObject, Identifiable, Codable {
    private(set) var id = UUID()
    private(set) var boardListId: UUID
    
    @Published var isFocused: Bool
    @Published var content: String
    
    enum CodingKeys: String, CodingKey {
        case id, boardListId, content
    }
    
    init(content: String, boardListId: UUID) {
        self.content = content
        self.boardListId = boardListId
        self.isFocused = false
        super.init()
    }
    
    init(boardListId: UUID) {
        self.isFocused = true
        self.content = ""
        self.boardListId = boardListId
        super.init()
    }

    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(UUID.self, forKey: .id)
        self.boardListId = try container.decode(UUID.self, forKey: .boardListId)
        self.content = try container.decode(String.self, forKey: .content)
        self.isFocused = false
        super.init()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(boardListId, forKey: .boardListId)
        try container.encode(content, forKey: .content)
    }
    
    func moveToBoardList(_ id: UUID) {
        boardListId = id
    }
}

extension Card: NSItemProviderWriting {
    
    static let typeIdentifier = "com.robisonsoftwaredevelopment.mTrello.Card"
    
    static var writableTypeIdentifiersForItemProvider: [String] {
        [typeIdentifier]
    }
    
    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            completionHandler(try encoder.encode(self), nil)
        } catch {
            completionHandler(nil, error)
        }
        
        return nil
    }
}

extension Card: NSItemProviderReading {
    static var readableTypeIdentifiersForItemProvider: [String] {
        [typeIdentifier]
    }
    
    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Self {
        try JSONDecoder().decode(Self.self, from: data)
    }
}
