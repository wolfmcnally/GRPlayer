//
//  ContentView.swift
//  GRPlayer
//
//  Created by Wolf McNally on 11/14/20.
//

import SwiftUI
import GR

struct ContentView: View {
    var body: some View {
        VStack {
            ProgramView(program: HelloPixelProgram())
//            ProgramView(program: HelloCornersProgram())
//            ProgramView(program: DotsAndLinesProgram())
//            ProgramView(program: RectanglesProgram())
//            ProgramView(program: PebblesProgram())
//            ProgramView(program: GravelProgram())
//            ProgramView(program: MoveProgram())
//            ProgramView(program: MandalaProgram())
//            ProgramView(program: MushroomProgram())
//            ProgramView(program: BallProgram())
//            ProgramView(program: RainingHeartsProgram())
//            ProgramView(program: DripProgram())
//            ProgramView(program: SparklerProgram())
//            ProgramView(program: WhirlwindProgram())
//            ProgramView(program: SargonChessboardProgram())
//            ProgramView(program: HelloVectorProgram())
//            ProgramView(program: StixProgram())
//            ProgramView(program: MoreStixProgram())
//            ProgramView(program: DancingLineProgram())
//            ProgramView(program: HelloTurtleProgram())
//            ProgramView(program: HelloPathProgram())
//            ProgramView(program: SpaceRocksProgram())
        }
        .statusBar(hidden: true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
