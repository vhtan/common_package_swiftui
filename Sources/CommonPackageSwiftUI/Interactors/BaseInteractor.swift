//
//  File.swift
//  
//
//  Created by Tan Vo on 24/06/2023.
//

import SwiftUI
import Combine
 
public protocol BaseInteractor {
    var activityIndicator: ActivityIndicator { get set }
    var cancelBag: CancelBag { get set }
    var errorTracker: ErrorTracker { get set }
}
