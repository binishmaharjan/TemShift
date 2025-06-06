import Foundation
import SharedModels
import SharedUIs
import SwiftUI
import UIKit

public enum AuthenticationResult {
    case showMainTab
}

@MainActor
public final class AuthenticationCoordinator: FlowCoordinator {
    public typealias ResultType = AuthenticationResult
    
    // MARK: Init
    public init() {
        print("ℹ️ \(Self.self): Start AuthenticationCoordinator")
    }
    
    deinit {
        print("ℹ️ \(Self.self): Deinit AuthenticationCoordinator")
    }
    
    // MARK: Properties
    public var childCoordinator: (any Coordinator)?
    public weak var finishDelegate: (any CoordinatorFinishDelegate)?
    public lazy var startNavigationController: UINavigationController = {
        let navigationController = UINavigationController()
        return navigationController
    }()
    
    private var navigationControllers = [UINavigationController]()
    private var topNavigationController: UINavigationController {
        navigationControllers.last ?? startNavigationController
    }
    private var rootNavigationController: UINavigationController {
        navigationControllers.first ?? startNavigationController
    }
    private var routePresentationDelegates: [PresentationDelegate] = []
    
    // MARK: Methods
    public func start() {
        let viewModel = OnboardingViewModel(coordinator: self)

        let view = OnboardingView(viewModel: viewModel)
            .toolbar(.hidden)
        let viewController = NamedUIHostingController(rootView: view)
        navigationControllers.append(startNavigationController)
        startNavigationController.setViewControllers([viewController], animated: false)
    }
}

// MARK: Onboarding Navigation
extension AuthenticationCoordinator {
    func onboardingRequestNavigation(for route: OnboardingViewModel.Route) {
        switch route {
        case .createAccount:
            pushCreateAccountView()
            
        case .login:
            pushLoginView()
        }
    }
    
    private func pushCreateAccountView() {
        let viewModel = CreateAccountViewModel(coordinator: self)
        
        let view = CreateAccountView(viewModel: viewModel)
            .navigationBar()
            .withCustomBackButton()
        
        let viewController = NamedUIHostingController(rootView: view)
        startNavigationController.pushViewController(viewController, animated: true)
    }
    
    private func pushLoginView() {
        let viewModel = SignInViewModel(coordinator: self)
        
        let view = SignInView(viewModel: viewModel)
            .navigationBar()
            .withCustomBackButton()
        
        let viewController = NamedUIHostingController(rootView: view)
        startNavigationController.pushViewController(viewController, animated: true)
    }
    
    func popLast() {
        startNavigationController.popViewController(animated: true)
    }
}

// MARK: SignIn Navigvation
extension AuthenticationCoordinator {
    func signInRequestNavigation(for route: SignInViewModel.Route) {
        switch route {
        case .forgotPassword:
            presentForgotPasswordView()
        }
    }
    
    private func presentForgotPasswordView() {
        let navigationController = UINavigationController()
        
        let viewModel = ForgotPasswordViewModel()
        let view = ForgotPasswordView(viewModel: viewModel)
            .navigationBar()
            .withCustomCloseButton { [weak navigationController, weak self] in
                // For Close Button Tapped
                navigationController?.dismiss(animated: true)
                if let presentedNavigationController = navigationController {
                    self?.navigationControllers.removeAll { $0 === presentedNavigationController }
                    self?.routePresentationDelegates.removeLast()
                }
            }
        
        let viewController = NamedUIHostingController(rootView: view)
        navigationController.setViewControllers([viewController], animated: false)
        navigationControllers.append(navigationController)
        
        // For Swipe Down
        let presentationDelegate = PresentationDelegate { [weak self] in
            self?.navigationControllers.removeLast()
            self?.routePresentationDelegates.removeLast()
        }
        navigationController.presentationController?.delegate = presentationDelegate
        routePresentationDelegates.append(presentationDelegate)
        
        startNavigationController.present(navigationController, animated: true)
    }
}
