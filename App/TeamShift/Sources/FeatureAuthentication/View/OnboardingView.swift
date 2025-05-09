import SharedUIs
import SwiftUI

struct OnboardingView: View {
    init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
    }
    
    @State private var viewModel: OnboardingViewModel
    @State private var item: [Item] = [
        .init(color: .onboardingBackground, title: l10.onboardingTitle1, subTitle: l10.onboardingDescription1),
        .init(color: .onboardingBackground, title: l10.onboardingTitle2, subTitle: l10.onboardingDescription2),
        .init(color: .onboardingBackground, title: l10.onboardingTitle3, subTitle: l10.onboardingDescription3),
        .init(color: .onboardingBackground, title: l10.onboardingTitle4, subTitle: l10.onboardingDescription4),
    ]
    
    var body: some View {
        VStack(spacing: 12) {
            paginSlider
            
            createAccountButton
            
            loginButton
            
            continueAsGuestLink
        }
        .padding(.top, 34) // use safe area padding to avoid clipping of scrollview
        .frame(maxHeight: .infinity)
        .padding(.horizontal, 24)
        .background(Color.background)
        .loadingView(viewModel.isLoading)
        .appAlert(isPresented: $viewModel.alertConfig.isPresented, alertConfig: viewModel.alertConfig)
    }
}

// MARK: View
extension OnboardingView {
    @ViewBuilder
    private var paginSlider: some View {
        PagingSlider(data: $item) { $item in
            RoundedRectangle(cornerRadius: 15)
                .fill(item.color.gradient)
                .padding(.top, 8)
        } titleContent: { $item in
            VStack(spacing: 4) {
                Text(item.title)
                    .foregroundStyle(Color.text)
                    .font(.customTitle)
                    .lineLimit(1)
                
                Text(item.subTitle)
                    .foregroundStyle(Color.subText)
                    .font(.customFootnote)
                    .lineLimit(4)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.bottom, 8)
    }
    
    @ViewBuilder
    private var createAccountButton: some View {
        PrimaryButton(
            image: .icnPerson,
            title: l10.onboardingButtonCreate
        ) {
            viewModel.createAccountButtonTapped()
        }
    }
    
    @ViewBuilder
    private var loginButton: some View {
        SecondaryButton(
            image: .icnLogin,
            title: l10.onboardingButtonSignIn
        ) {
            viewModel.loginButtonTapped()
        }
    }
    
    @ViewBuilder
    private var continueAsGuestLink: some View {
        Text(continueAsGuestUserString)
            .foregroundStyle(Color.subText)
            .font(.customCaption)
            .bold()
            .padding(8)
            .onTapGesture {
                Task {
                    await viewModel.signUpAsGuestTapped()
                }
            }
    }
}

extension OnboardingView {
    private var continueAsGuestUserString: AttributedString {
        var attributedString = AttributedString(l10.onboardingButtonGuestUser)
        if let range = attributedString.range(of: l10.onboardingButtonGuestUserSubString) {
            attributedString[range].foregroundColor = Color.appPrimary
        }
        return attributedString
    }
}

#Preview {
    OnboardingView(viewModel: OnboardingViewModel(coordinator: .init()))
}
