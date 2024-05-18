//
//  SignInViewController.swift
//  MusicApp
//
//  Created by Damien L Thompson on 2024-05-16.
//

import UIKit
import WebKit

class SignInViewController: UIViewController {

    private let webView: WKWebView = {

        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true

        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs

        let webview = WKWebView(frame: .zero, configuration: config)

        return webview
    }()

    var viewModel: SignInViewModel?
    weak var coordinator: AuthCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        configureWebView()
        loadAuthView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        webView.frame = view.bounds
    }

    func configureViewController() {

        view.backgroundColor = .systemBackground
        title = "Log In"
    }

    func configureWebView() {

        webView.navigationDelegate = self
        webView.allowsLinkPreview = true
        webView.allowsBackForwardNavigationGestures = true
        view.addSubview(webView)
    }

    func loadAuthView() {
        
        guard let url = viewModel?.signInUrl else { return }

        webView.load(URLRequest(url: url))
    }
}

//MARK: - WebView Navigation Delegate
extension SignInViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {

        guard let url = webView.url else { return }

        let components = URLComponents(string: url.absoluteString)

        guard let code = components?.queryItems?.first(where: {
            $0.name == "code"
        })?.value else {
            return
        }

        webView.isHidden = true

        Task {
            do {
                try await viewModel?.signIn(with: code)
            } catch {
                print("signIn error: \(error)")
            }
        }
    }
}

//MARK: - SignInViewModel Delegate
extension SignInViewController: SignInViewModelDelegate {

    func didSignIn() {

        coordinator?.didReceiveAccessToken()
    }
}
