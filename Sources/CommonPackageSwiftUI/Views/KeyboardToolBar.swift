//
//  KeyboardToolBar.swift
//  wisnet
//
//  Created by Tan Vo on 11/10/2022.
//

import SwiftUI

public final class KeyboardResponder: ObservableObject {
    
    private var notificationCenter: NotificationCenter
    @Published private(set) var currentHeight: CGFloat = 0

    init(center: NotificationCenter = .default) {
        notificationCenter = center
        notificationCenter.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func dismiss() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    deinit {
        notificationCenter.removeObserver(self)
    }

    @objc func keyBoardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            currentHeight = keyboardSize.height
        }
    }

    @objc func keyBoardWillHide(notification: Notification) {
        currentHeight = 0
    }
}

struct KeyboardView<Content, ToolBar> : View where Content : View, ToolBar: View {
    @StateObject private var keyboard: KeyboardResponder = KeyboardResponder()
    let toolbarFrame: CGSize = CGSize(width: UIScreen.main.bounds.width, height: 40.0)
    var content: () -> Content
    var toolBar: () -> ToolBar
    
    var body: some View {
        ZStack {
            content()
                .padding(.bottom, (keyboard.currentHeight == 0) ? 0 : toolbarFrame.height)
            VStack {
                 Spacer()
                 toolBar()
                    .frame(width: toolbarFrame.width, height: toolbarFrame.height)
                    .background(Color.red)
            }
            .opacity((keyboard.currentHeight == 0) ? 0 : 1)
            .animation(.easeOut)
        }
        .padding(.bottom, keyboard.currentHeight)
        .edgesIgnoringSafeArea(.bottom)
        .animation(.easeOut)
    }
}

struct KeyboardToolBar: View {
    @State private var name: String = ""
    @State private var phoneNumber: String = ""
    
    var body: some View {
        KeyboardView {
            VStack {
                TextField("Name", text: $name)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.secondary, lineWidth: 1)
                    .frame(height: 50))
                    .keyboardType(.namePhonePad)
                
                TextField("Phone Number", text: $phoneNumber)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.secondary, lineWidth: 1)
                    .frame(height: 50))
                    .keyboardType(.numberPad)
                
                Button(action: { }, label: {
                    Text("Continue")
                })
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 8)
                .stroke(Color.secondary, lineWidth: 1))
                Spacer()
            }
            .padding()
        } toolBar: {
            HStack {
                Spacer()
                Button(action: {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                                    to: nil, from: nil, for: nil)
                }, label: {
                    Text("Done")
                })
            }
            .padding()
        }
    }
}
