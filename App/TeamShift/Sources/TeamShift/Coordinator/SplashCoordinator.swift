import Foundation
import SharedModels
import SharedUIs
import SwiftUI

enum SplashResult {
    case showAuthentication
    case showMainTab
}

@MainActor
final class SplashCoordinator: FlowCoordinator {
    typealias ResultType = SplashResult
    
    // MARK: Init
    init() {
        print("\(Self.self): Start SplashCoordinator")
    }
    
    deinit {
        print("\(Self.self): Deinit SplashCoordinator")
    }
    
    // MARK: Coordinator
    weak var finishDelegate: (any CoordinatorFinishDelegate)?
    var childCoordinator: (any Coordinator)?
    
    // MARK: Properties
    private(set) var startViewController = UIViewController()
    
    // MARK: Methods
    func start() {
        let viewModel = SplashViewModel(coordinator: self)
        let view = SplashView(viewModel: viewModel)
        let viewController = NamedUIHostingController(rootView: view)
        startViewController = viewController
    }
}
