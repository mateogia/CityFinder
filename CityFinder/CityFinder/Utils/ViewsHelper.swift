//
//  ViewsHelper.swift
//  CityFinder
//
//  Created by Mateo Giarrocco on 08/09/2025.
//

import SwiftUI

enum LoadingState<Value> {
    case idle
    case loading
    case success(Value)
    case failure(Error)
}

struct HighlightButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .overlay(
                Color.blue
                    .opacity(configuration.isPressed ? 0.3 : 0)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

extension View {
    func prewarmKeyboard() -> some View {
        self.modifier(PrewarmKeyboardModifier())
    }
}

struct PrewarmKeyboardModifier: ViewModifier {
    @FocusState private var isPrewarmFieldFocused: Bool
    @State private var hasPrewarmed = false
    
    func body(content: Content) -> some View {
        content
            .background(
                TextField("", text: .constant(""))
                    .focused($isPrewarmFieldFocused)
                    .allowsHitTesting(false)
                    .frame(width: 0, height: 0)
                    .opacity(0)
            )
            .onAppear {
                if !hasPrewarmed {
                    prewarmKeyboard()
                }
            }
    }
    
    private func prewarmKeyboard() {
        DispatchQueue.main.async {
            isPrewarmFieldFocused = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isPrewarmFieldFocused = false
                hasPrewarmed = true
            }
        }
    }
}
