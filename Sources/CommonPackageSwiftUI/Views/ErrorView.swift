//
//  ErrorView.swift
//  wisnet
//
//  Created by Tan Vo on 10/10/2022.
//

import SwiftUI

public struct ErrorView: View {
    let error: Error
    let retryAction: () -> Void
    
    public init(error: Error, retryAction: @escaping () -> Void) {
        self.error = error
        self.retryAction = retryAction
    }
    
    public var body: some View {
        VStack {
            Text("An Error Occured")
                .font(.title)
            Text(error.localizedDescription)
                .font(.callout)
                .multilineTextAlignment(.center)
                .padding(.bottom, 40).padding()
            Button(action: retryAction, label: { Text("Retry").bold() })
        }
    }
}
