//
//  Programs.swift
//  GRPlayer
//
//  Created by Wolf McNally on 1/28/21.
//

import Foundation
import GR

struct ContentsItem: Identifiable {
    let id = UUID()
    let title: String?
    let subtitle: String?
    let number: Int?
    let program: Program.Type?
    let subItems: [ContentsItem]?

    init(title: String? = nil, subtitle: String? = nil, number: Int? = nil, program: Program.Type? = nil, subItems: [ContentsItem]? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.number = number
        self.program = program
        self.subItems = subItems
    }

    init(_ title: String) {
        self.init(title: title)
    }
    
    init(_ title: String, _ subItems: [ContentsItem]) {
        self.init(title: title, subItems: subItems)
    }
    
    init(_ title: String, _ subtitle: String, _ subItems: [ContentsItem]) {
        self.init(title: title, subtitle: subtitle, subItems: subItems)
    }

    init(_ program: Program.Type) {
        self.init(program: program)
    }
}

let contents: [ContentsItem] = [
    .init("Getting Started", [
        .init(EmptyProgram.self),
        .init(HelloPixel.self),
        .init(HelloCorners.self),
        .init(DotsAndLines.self),
        .init(Rectangles.self),
    ]),
    .init("Understanding Coordinates"),
    .init("Understanding Color", [
        .init(RGBColorMixer.self),
        .init(CMYColorMixer.self),
        .init(HSBColorMixer.self),
    ]),
    .init("Basic Animation", [
        .init(Pebbles.self),
        .init(Gravel.self),
        .init(HelloMovement.self),
        .init(RandomWalk.self),
        .init(BouncingBalls.self),
    ]),
    .init("Shapes and Sprites", [
        .init(Mushrooms.self),
        .init(RainingHearts.self),
    ]),
    .init("User Interaction", [
        .init(HelloPlayer.self),
    ]),
    .init("Grids", [
        .init(Chessboard.self),
    ]),
    .init("Toys", [
        .init(Sparkler.self),
    ]),
    .init("Sound Effects"),
    .init("Dazzlers", [
        .init(Mandala.self),
        .init(TheDrip.self),
        .init(DrawMaze.self),
        .init(Whirlwind.self),
    ]),
    .init("Vector Graphics", [
        .init(HelloVector.self),
        .init(HelloPath.self),
        .init(Stix.self),
        .init(MoreStix.self),
        .init(DancingLines.self),
    ]),
    .init("Turtle Graphics", [
        .init(HelloTurtle.self),
    ]),
    .init("Vector Games", [
        .init(SpaceRocks.self),
    ]),
]

let numberedContents: [ContentsItem] = {
    contents.enumerated().map { index, element in
        ContentsItem(title: element.title, subtitle: element.subtitle, number: index + 1, subItems: element.subItems)
    }
}()
