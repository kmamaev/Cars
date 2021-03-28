import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let manufacturersViewController: ManufacturersViewController = {
                let manufacturersViewController = storyboard.instantiateViewController(identifier: "ManufacturersViewController") as ManufacturersViewController
                let apiService = APIService(host: "api-aws-eu-qa-1.auto1-test.com")
                apiService.additionalParamaters = [URLQueryItem(name: "wa_key", value: "coding-puzzle-client-449cc9d")]
                let carsService = CarsService(apiService: apiService)
                let manufacturersViewModel = ManufacturersViewModel(carsService: carsService)
                manufacturersViewController.viewModel = manufacturersViewModel
                return manufacturersViewController
            }()
        let navigationController = UINavigationController(rootViewController: manufacturersViewController)
        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
    }
}

