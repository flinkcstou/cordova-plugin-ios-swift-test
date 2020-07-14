
//
//  AppCenter.swift
//  TestTask
//x3
//  Created by Tuigynbekov Yelzhan on 6/23/20.
//  Copyright © 2020 yelzhan.com. All rights reserved.
//

import UIKit
class AppCenter {

    static let shared = AppCenter()
    private var window: UIWindow = UIWindow()
    let vc = RecordViewController()

    // MARK: - Functions
    func createWindow(_ window: UIWindow) -> Void {
        self.window = window
    }
    private func makeKeyAndVisible() -> Void {
        window.makeKeyAndVisible()
        window.backgroundColor = .white
    }
    private func setRootController(_ controller: UIViewController) -> Void {
        window.rootViewController = controller
    }


    // MARK: - Start Configure
    func start() -> Void {
        makeKeyAndVisible()
        setRootController(vc)
    }
    func startCamera() -> Void {
        vc.startCamera()
    }
}
