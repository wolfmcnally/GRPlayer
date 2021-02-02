//
//  ContentsMenu.swift
//  GRPlayer
//
//  Created by Wolf McNally on 1/28/21.
//

import SwiftUI
import GR

struct ContentsMenu: View {
    var body: some View {
        List(numberedContents, children: \.subItems) { row in
            VStack(alignment: .leading) {
                if let title = row.title {
                    HStack {
                        if let number = row.number {
                            Text("\(number).")
                        }
                        Text(title)
                    }
                    .font(.title2)
                }
                if let subtitle = row.subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                }
            }
            if let programType = row.program {
                programRow(programType)
            }
        }
        .navigationBarTitle("Programming with Pixels")
    }

    func programRow(_ programType: Program.Type) -> some View {
        NavigationLink(
            destination: ProgramView(programType) {
                ProgramHeader(programType: programType)
            }
            .navigationBarTitle(programType.title)
        ) {
            ProgramInfo(programType: programType)
        }
    }
}

struct ContentsMenu_Previews: PreviewProvider {
    static var previews: some View {
        ContentsMenu()
            .navigationViewStyle(StackNavigationViewStyle())
            .preferredColorScheme(.dark)
    }
}
