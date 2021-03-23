//
//  OneProgram.swift
//  GRPlayer
//
//  Created by Wolf McNally on 2/15/21.
//

import SwiftUI
import GR

let mainProgram = MyFirstPlayer()

struct OneProgram: View {
    var body: some View {
        ProgramView(mainProgram)
            .padding()
            .background(Color.init(red: 0.1, green: 0.1, blue: 0.1))
    }
}
