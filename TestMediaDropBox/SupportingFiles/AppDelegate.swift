//
//  AppDelegate.swift
//  TestMediaDropBox
//
//  Created by Igor Palyvoda on 26.08.2023.
//

import UIKit
import SwiftyDropbox

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let dropboxAppKey = "1ozimqo3o18bo0x"
        switch(appPermission) {
        case .fullDropboxScoped:
            DropboxClientsManager.setupWithAppKey(dropboxAppKey)
        case .fullDropboxScopedForTeamTesting:
            DropboxClientsManager.setupWithTeamAppKey(dropboxAppKey)
        }

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

public enum AppPermission {
    case fullDropboxScoped
    case fullDropboxScopedForTeamTesting
}

let appPermission = AppPermission.fullDropboxScoped