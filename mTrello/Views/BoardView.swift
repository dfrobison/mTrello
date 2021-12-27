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
    @StateObject private var board: Board = Board.stub
    
    var body: some View {
        NavigationView {
            ScrollView(.horizontal) {
                LazyHStack(alignment: .top, spacing: 24) {
                    ForEach(board.boardLists) { boardList in
                        BoardListView(board: board, boardList: boardList)
                    }
                    
                    Button("+ Add list") {
                        
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(boardListBackgroundColor.opacity(0.8))
                    .frame(width: 300)
                    .cornerRadius(8)
                    .foregroundColor(.black)
                }
                .padding()
            }
            .background(mTrellBlueBackgroundColor)
            .navigationTitle(board.name)
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(.stack)
    }
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView()
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (12.9-inch) (5th generation"))
            .previewDisplayName("iPad Pro")
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
