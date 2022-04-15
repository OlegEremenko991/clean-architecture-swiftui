//
//  AppDelegate.swift
//  CountriesSwiftUI
//
//  Created by Alexey Naumov on 23.10.2019.
//  Copyright © 2019 Alexey Naumov. All rights reserved.
//

import UIKit
import Combine

typealias NotificationPayload = [AnyHashable: Any]
typealias FetchCompletion = (UIBackgroundFetchResult) -> Void

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    lazy var systemEventsHandler: SystemEventsHandler? = {
        systemEventsHandler(UIApplication.shared)
    }()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        systemEventsHandler?.handlePushRegistration(result: .success(deviceToken))
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        systemEventsHandler?.handlePushRegistration(result: .failure(error))
    }
    
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: NotificationPayload,
        fetchCompletionHandler completionHandler: @escaping FetchCompletion
    ) {
        systemEventsHandler?.appDidReceiveRemoteNotification(payload: userInfo, fetchCompletion: completionHandler)
    }
}

private extension AppDelegate {
    func systemEventsHandler(_ application: UIApplication) -> SystemEventsHandler? {
        sceneDelegate(application)?.systemEventsHandler
    }

    func sceneDelegate(_ application: UIApplication) -> SceneDelegate? {
        application.windows
            .compactMap { $0.windowScene?.delegate as? SceneDelegate }
            .first
    }
}
