//
//  File.swift
//  Your2DWorld
//
//  Created by heri hermawan on 22/04/22.
//

import SwiftUI

struct Toast<Presenting, Content>: View where Presenting: View, Content: View {
    @Binding var isPresented: Bool
    let presenter: () -> Presenting
    let content: () -> Content
    let delay: TimeInterval = 1.5

    var body: some View {
        if self.isPresented {
            DispatchQueue.main.asyncAfter(deadline: .now() + self.delay) {
                withAnimation {
                    self.isPresented = false
                }
            }
        }

        return GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                self.presenter()

                ZStack {
                    Capsule()
                        .fill(Color.gray)

                    self.content()
                } //ZStack (inner)
                .frame(width: geometry.size.width / 2, height: geometry.size.height / 20)
                .opacity(self.isPresented ? 1 : 0)
            } //ZStack (outer)
//            .padding(.bottom)
        } //GeometryReader
    } //body
} //Toast
