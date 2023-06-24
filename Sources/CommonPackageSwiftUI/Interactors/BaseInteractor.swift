//
//  File.swift
//  
//
//  Created by Tan Vo on 24/06/2023.
//

import SwiftUI
import Combine
 
public protocol WBaseInteractor {
    associatedtype AppState
    func activityIndicator(isLoading: Binding<Bool>)
    func handleErrorTracker(errorMessage: Binding<String?>)
    var activityIndicator: ActivityIndicator { get set }
    var cancelBag: CancelBag { get set }
    var errorTracker: ErrorTracker { get set }
    var appState: Store<AppState> { get set }
}

public extension WBaseInteractor {
    func activityIndicator(isLoading: Binding<Bool>) {
        activityIndicator.loading
            .sink(receiveValue: { flag in
                isLoading.wrappedValue = flag
            })
            .store(in: cancelBag)
    }
}
