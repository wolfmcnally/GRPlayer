//
//  ProgramHeader.swift
//  GRPlayer
//
//  Created by Wolf McNally on 1/29/21.
//

import SwiftUI
import GR

struct ProgramHeader: View {
    let programType: Program.Type
    
    var body: some View {
        VStack(alignment: .leading) {
            if let author = programType.author {
                Text(author)
                    .font(.subheadline).bold()
            }
            if let version = programType.version {
                Text(version)
                    .font(.caption)
            }
        }
    }
}

struct ProgramHeader_Previews: PreviewProvider {
    static var previews: some View {
        ProgramHeader(programType: EmptyProgram.self)
    }
}
