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
                                              @ViewBuilder content: @escaping (Item) -> Content) -> some View where Item : Identifiable, Content : View {
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
