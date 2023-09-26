//
//  ViewExtension.swift
//  wisnet
//
//  Created by Tan Vo on 14/10/2022.
//

import SwiftUI

public extension View {
    func loadingView() -> some View {
        return EmptyView()
    }
    
    func failedView(_ error: Error) -> some View {
        ErrorView(error: error, retryAction: { })
    }
}

private struct SafeAreaInsetsKey: EnvironmentKey {
    static var defaultValue: EdgeInsets {
        (UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.safeAreaInsets ?? .zero).insets
    }
}

public extension EnvironmentValues {
    
    var safeAreaInsets: EdgeInsets {
        self[SafeAreaInsetsKey.self]
    }
}

private extension UIEdgeInsets {
    
    var insets: EdgeInsets {
        EdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
    }
}

public extension View {
    func fullScreenCoverCustom<Content: View>(isPresented: Binding<Bool>, onDismiss: (() -> Void)? = nil,
                                   @ViewBuilder content: @escaping () -> Content) -> some View {
        if #available(iOS 15.0, *) {
            return self.fullScreenCover(isPresented: isPresented, content: content)
        } else {
            return VStack(spacing: 0) {
                self
                EmptyView()
                    .fullScreenCover(isPresented: isPresented, content: content)
            }
        }
    }
    
    func fullScreenCoverCustom<Item, Content>(item: Binding<Item?>,
                                              onDismiss: (() -> Void)? = nil,
                                              @ViewBuilder content: @escaping (Item) -> Content) -> some View where Item : Swift.Identifiable, Content : View {
        if #available(iOS 15.0, *) {
            return self.fullScreenCover(item: item, onDismiss: onDismiss, content: content)
        } else {
            return VStack(spacing: 0) {
                self
                EmptyView()
                    .fullScreenCover(item: item, onDismiss: onDismiss, content: content)
            }
        }
    }
}

public extension View {
    func backgroundLinearGradient(colors: [Color],
                                  startPoint: UnitPoint = .topLeading,
                                  endPoint: UnitPoint = .bottomTrailing) -> some View {
        return self.background(
            LinearGradient(gradient: .init(colors: colors),
                           startPoint: startPoint, endPoint: endPoint)
            .ignoresSafeArea()
        )
    }
    
    func borderAndCorner(cornerRadius: CGFloat = 8,
                         lineWidth: CGFloat = 1,
                         color: Color = Color.gray) -> some View {
        return self.overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .strokeBorder(lineWidth: lineWidth)
                .foregroundColor(color)
                .clipped()
        )
        .cornerRadius(cornerRadius)
        .clipped()
    }
    
    func borderAndCornerDashLine(cornerRadius: CGFloat = 8,
                                 lineWidth: CGFloat = 1,
                                 color: Color = Color.gray,
                                 dash: CGFloat = 8) -> some View {
        return self.overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .strokeBorder(style: StrokeStyle(lineWidth: lineWidth, dash: [dash]))
                .foregroundColor(color)
                .clipped()
        )
        .cornerRadius(cornerRadius)
        .clipped()
    }
}

private struct ContainerPresentingView<Content: View>: View {
    
    @ViewBuilder var content: () -> Content
    
    init(content: @escaping () -> Content) {
        UIView.setAnimationsEnabled(false)
        self.content = content
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
            VStack {
                content()
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

public extension View {
    
    func fullScreenCoverCustomPresenting<Content>(isPresented: Binding<Bool>,
                                            onDismiss: (Completion)? = nil,
                                            @ViewBuilder content: @escaping () -> Content) -> some View where Content : View {
         self.fullScreenCoverCustom(isPresented: isPresented, onDismiss: onDismiss) {
             ContainerPresentingView(content: content)
         }
     }
    
    func fullScreenCoverCustomPresenting<Item, Content>(item: Binding<Item?>,
                                                        onDismiss: (() -> Void)? = nil,
                                                        @ViewBuilder content: @escaping (Item) -> Content) -> some View where Item : Swift.Identifiable, Content : View {
        self.fullScreenCoverCustom(item: item, onDismiss: onDismiss) { it in
            ContainerPresentingView {
                content(it)
            }
        }
    }
}
