//
//  ProgramInfo.swift
//  GRPlayer
//
//  Created by Wolf McNally on 1/28/21.
//

import SwiftUI
import GR

struct ProgramInfo: View {
    let programType: Program.Type
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(programType.title)
                    .font(.headline)
                if let subtitle = programType.subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                }
            }
            Spacer()
            VStack(alignment: .trailing) {
                if let author = programType.author {
                    Text(author)
                        .font(.caption)
                }
                if let version = programType.version {
                    Text(version)
                        .font(.caption2)
                }
            }
        }
    }
}

struct ProgramInfo_Previews: PreviewProvider {
    static var previews: some View {
        ProgramInfo(programType: EmptyProgram.self)
            .padding()
            .preferredColorScheme(.dark)
    }
}
