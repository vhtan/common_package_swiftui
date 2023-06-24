//
//  File.swift
//  
//
//  Created by Tan Vo on 24/06/2023.
//

import UIKit
import Combine

public typealias NotificationPayload = [AnyHashable: Any]
public typealias FetchCompletion = (UIBackgroundFetchResult) -> Void

public protocol SystemEventsHandler {
    func sceneOpenURLContexts(_ urlContexts: Set<UIOpenURLContext>)
    func sceneDidBecomeActive()
    func sceneWillResignActive()
    func handlePushRegistration(result: Result<Data, Error>)
    func appDidReceiveRemoteNotification(payload: NotificationPayload,
                                         fetchCompletion: @escaping FetchCompletion)
}
