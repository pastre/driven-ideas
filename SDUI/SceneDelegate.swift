//
//  SceneDelegate.swift
//  SDUI
//
//  Created by Bruno Pastre on 11/11/21.
//

import UIKit
import CoreBFF

enum NavigationType: String, Decodable {
    case push
    case modal
}

final class DrivenNavigationHandler {
    typealias EngineFactory = () -> DrivenEngine
    
    private let factory: EngineFactory
    private var modalStack: [UIViewController] = []
    private var currentViewController: UIViewController? { modalStack.last }
    
    init(factory: @autoclosure @escaping EngineFactory) {
        self.factory = factory
        modalStack.append(makeDrivenController())
    }
    
    func handle(deeplink url: URL) {
        let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        guard components?.scheme == "mydemo", // TODO inject scheme
              components?.host == "route",
              let navigationTypeString = components?.queryItems?.first(where: { $0.name == "navigationType" })?.value,
              let navigationType = NavigationType(rawValue: navigationTypeString),
              let payload = components?.queryItems?.first(where: { $0.name == "payload" })?.value,
              let data = Data(base64Encoded: payload)
        else { return }
        let newEngine = DrivenEngine(
            componentRepository: .default,
            actionRepository: .default,
            useCaseRepository: .default)
        switch navigationType {
        case .push:
            let newController = makeDrivenController()
            currentViewController?.navigationController?.pushViewController(newController, animated: true)
        case .modal:
            let newController = makeDrivenController()
            currentViewController?.present(newController, animated: true, completion: nil)
            modalStack.append(newController)
        }
        try? newEngine.render(data: data)
    }
    
    func start(using window: UIWindow) {
        window.rootViewController = currentViewController
        window.makeKeyAndVisible()
    }
    
    private func makeRootController() -> UIViewController {
        UINavigationController(rootViewController: makeDrivenController())
    }
    
    private func makeDrivenController() -> UIViewController {
        DemoViewController(engine: factory())
    }
}

@available(iOS 13.0, *)
final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    private let drivenNavigationHandler = DrivenNavigationHandler(factory: DrivenEngine(
        componentRepository: .default,
        actionRepository: .default,
        useCaseRepository: .default
    ))
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        URLContexts.forEach {
            drivenNavigationHandler.handle(deeplink: $0.url)
        }
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        drivenNavigationHandler.start(using: window)
        self.window = window
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}
