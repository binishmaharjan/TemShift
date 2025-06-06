import SharedUIs
import SwiftUI

struct CreateAccountView: View {
    enum FocusableField: Hashable {
        case email
        case password
    }
    
    init(viewModel: CreateAccountViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: Properties
    @State private var viewModel: CreateAccountViewModel
    @FocusState private var focusedField: FocusableField?
    
    var body: some View {
        VStack(spacing: 12) {
            title
                .padding(.bottom, 48)
            
            emailTextField
            
            passwordTextField
            
            createButton
                .padding(.bottom, 12)
    
            separator
                .padding(.bottom, 12)
            
            signUpGoogleButton
            
            signUpAppleButton
            
            createAccountCaution
        }
        .padding(.horizontal, 24)
        .vSpacing(.top)
        .loadingView(viewModel.isLoading)
        .appAlert(isPresented: $viewModel.alertConfig.isPresented, alertConfig: viewModel.alertConfig)
    }
}

extension CreateAccountView {
    @ViewBuilder
    private var title: some View {
        Text(l10.onboardingTitle)
            .foregroundStyle(Color.text)
            .font(.customTitle)
    }
    
    @ViewBuilder
    private var emailTextField: some View {
        PrimaryTextField(
            l10.commonTextFieldEmail,
            icon: .icnMail,
            text: $viewModel.email,
            fieldIdentifier: .email,
            focusedField: $focusedField
        )
    }
    
    @ViewBuilder
    private var passwordTextField: some View {
        PrimaryTextField(
            l10.commonTextFieldPassword,
            icon: .icnLock,
            text: $viewModel.password,
            fieldIdentifier: .password,
            focusedField: $focusedField,
            isSecure: true
        )
    }
    
    @ViewBuilder
    private var createButton: some View {
        PrimaryButton(title: l10.createAccountButtonSignUp) {
            Task {
                await viewModel.createButtonTapped()
            }
        }
        .disabled(!viewModel.isCreateButtonEnabled)
    }
    
    @ViewBuilder
    private var separator: some View {
        HStack {
            Rectangle()
                .frame(height: 1)
            
            Text("or")
                .font(.customFootnote)
            
            Rectangle()
                .frame(height: 1)
        }
        .foregroundStyle(Color.text.opacity(0.5))
    }
    
    @ViewBuilder
    private var signUpGoogleButton: some View {
        SecondaryButton(
            image: .icnGoogle,
            title: l10.createAccountButtonWithGoogle,
            isTemplate: false
        ) {
            Task {
                await viewModel.signUpWithGoogleButtonTapped()
            }
        }
    }
    
    @ViewBuilder
    private var signUpAppleButton: some View {
        SecondaryButton(
            image: .icnApple,
            title: l10.createAccountButtonWithApple,
            isTemplate: false
        ) {
            print(l10.createAccountButtonWithApple)
        }
    }
    
    @ViewBuilder
    private var createAccountCaution: some View {
        Text(createAccountCautionString)
            .foregroundStyle(Color.subText)
            .font(.customCaption)
            .multilineTextAlignment(.center)
    }
}

extension CreateAccountView {
    private var createAccountCautionString: AttributedString {
        var attributedString = AttributedString(l10.createAccountWarning)
        if let range = attributedString.range(of: l10.createAccountWarningSubstring1) {
            attributedString[range].foregroundColor = Color.appPrimary
        }
        if let range = attributedString.range(of: l10.createAccountWarningSubstring2) {
            attributedString[range].foregroundColor = Color.appPrimary
        }
        return attributedString
    }
}

#Preview {
    CreateAccountView(viewModel: CreateAccountViewModel(coordinator: .init()))
}
