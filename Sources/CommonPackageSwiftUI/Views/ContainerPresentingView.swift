//
//  ContainerPresentingView.swift
//  wisnet
//
//  Created by Tan Vo on 08/05/2023.
//

import SwiftUI

private struct ContainerPresentingView<Content: View>: View {
    
    @Binding var isPresented: Bool
    @ViewBuilder var content: () -> Content
    
    init(isPresented: Binding<Bool>, content: @escaping () -> Content) {
        UIView.setAnimationsEnabled(false)
        self._isPresented = isPresented
        self.content = content
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.gray.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    isPresented = false
                }
            content()
                .background(Color.white)
                .cornerRadius(radius: 24, corners: [.topLeft, .topRight])
        }
        .ignoresSafeArea()
        .background(ClearBackgroundView())
        .onDisappear {
            UIView.setAnimationsEnabled(true)
        }
    }
}

public extension View {
    func fullScreenCoverBottom<Content>(isPresented: Binding<Bool>,
                                           onDismiss: (() -> Void)? = nil,
                                           @ViewBuilder content: @escaping () -> Content) -> some View where Content : View {
        self.fullScreenCoverCustom(isPresented: isPresented, onDismiss: onDismiss) {
            ContainerPresentingView(isPresented: isPresented, content: content)
        }
    }
    
    func toastMessage<Content>(isPresented: Binding<Bool>,
                                            onDismiss: (() -> Void)? = nil,
                                            @ViewBuilder content: @escaping () -> Content) -> some View where Content : View {
         self.fullScreenCoverCustom(isPresented: isPresented, onDismiss: onDismiss) {
             ShadowContainerPresentingView(isPresented: isPresented, content: content)
         }
     }
}


private struct ShadowContainerPresentingView<Content: View>: View {
    
    @Binding var isPresented: Bool
    @ViewBuilder var content: () -> Content
    
    init(isPresented: Binding<Bool>, content: @escaping () -> Content) {
        UIView.setAnimationsEnabled(false)
        self._isPresented = isPresented
        self.content = content
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.clear
            VStack {
                content()
                    .background(Color.white)
                    .cornerRadius(radius: 8, corners: .allCorners)
                    .shadow(color: .gray.opacity(0.5), radius: 20, x: 0, y: 0)
                Spacer().frame(height: 50)
            }
        }
        .ignoresSafeArea()
        .background(ClearBackgroundView())
        .onDisappear {
            UIView.setAnimationsEnabled(true)
        }
    }
}

fileprivate struct ClearBackgroundView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        return InnerView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) { }
    
    private class InnerView: UIView {
        override func didMoveToWindow() {
            super.didMoveToWindow()
            superview?.superview?.backgroundColor = .clear
        }
    }
}
