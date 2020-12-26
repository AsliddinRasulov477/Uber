import UIKit
import SideMenu
import Alamofire
import SwiftyJSON
import CoreLocation
import YandexMapsMobile

protocol HomeControllerDelegate: AnyObject {
    func handleHomeButton()
}

class HomeController: UIViewController  {
    
    // MARK: - Properties
        
    private let mapView = YMKMapView()
    private var placemarkMapObjects: [String: YMKPlacemarkMapObject] = [:]
    
    private var menu : SideMenuNavigationController?
    
    private let locationManager = LocationHandler.shared.locationManager
    
    private let orderHeaderView = OrderHeaderView()
    private let burgerButton = BurgerButton()
    private let homeButton = HomeButton()
    
    private var user = User()
    
    weak var delegate: HomeControllerDelegate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkIfUserLoggedIn()
        
        if traitCollection.userInterfaceStyle == .dark {
            mapView.mapWindow.map.isNightModeEnabled = true
        } else {
            mapView.mapWindow.map.isNightModeEnabled = false
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.userInterfaceStyle == .dark {
            mapView.mapWindow.map.isNightModeEnabled = true
        } else {
            mapView.mapWindow.map.isNightModeEnabled = false
        }
    }

   
    // MARK: - API
    
    private func checkIfUserLoggedIn() {
        if UserDefaults.standard.string(forKey: "ID") == nil {
            DispatchQueue.main.async {
                let navC = UINavigationController(rootViewController: LoginController())
                navC.modalPresentationStyle = .fullScreen
                self.present(navC, animated: true, completion: nil)
            }
        } else {
            configure()
        }
    }
    
    private func fetchUserData(comletion: @escaping(Bool) -> Void) {
        guard let uid = UserDefaults.standard.string(forKey: "ID") else {
            return
        }
        AF.request("http://167.99.33.2/api/clients/" + uid, method: .get).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if json["success"].boolValue {
                    self.user.name = json["data"]["name"].string ?? ""
                    self.user.phone = json["data"]["phone"].string ?? ""
                    comletion(true)
                } else {
                    comletion(false)
                }
            case .failure(let error):
                comletion(false)
                print(error)
            }
        }
    }
    
    // MARK: - Helper Functions
    
    func configure() {
        hasLocationPermission()
        configureMapView()
        configureBurger()
        configurOrderHeaderView()
    }
    
    func configureBurger() {
        view.addSubview(burgerButton)
        burgerButton.addTarget(
            self, action: #selector(handleSideMenu), for: .touchUpInside
        )
        burgerButton.anchor(
            top: view.topAnchor, left: view.leftAnchor,
            paddingTop: UIApplication.shared.windows[0].safeAreaInsets.top + 10, paddingLeft: 20,
            width: 60, height: 60
        )
        configureMenu()
    }
    
    func configureMenu() {
        fetchUserData { [self] (success) in
            if success {
                let rootVC = MenuListController(
                    menuItemsText: user.name,
                    menuItemsImage: #imageLiteral(resourceName: "fullname").withTintColor(.label),
                    menuPhoneNumber: user.phone
                )
            
                menu = SideMenuNavigationController(
                    rootViewController: rootVC
                )
                menu?.leftSide = true
                menu?.menuWidth = 0.6 * view.frame.width
                menu?.setNavigationBarHidden(true, animated: true)
                SideMenuManager.default.leftMenuNavigationController = menu
            }
        }
    }
    
    func configureHomeButton() {
        view.addSubview(homeButton)
        homeButton.addTarget(
            self, action: #selector(handleHome), for: .touchUpInside
        )
        homeButton.anchor(
            top: view.topAnchor, right: view.rightAnchor,
            paddingTop: view.safeAreaInsets.top + 10, paddingRight: 20,
            width: 60, height: 60
        )
    }
   
    private func configureMapView() {
        view.addSubview(mapView)
        mapView.frame = view.frame
    }
    
    func configurePlacemark() {
        guard let coordinate = locationManager.location?.coordinate else {
            return
        }
        
        mapView.mapWindow.map.isRotateGesturesEnabled = false
        
        mapView.mapWindow.map.move(
            with: YMKCameraPosition(target: YMKPoint(latitude: coordinate.latitude, longitude: coordinate.longitude), zoom: 15, azimuth: 0, tilt: 0),
            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 2),
            cameraCallback: nil
        )
       
        let mapObjects = mapView.mapWindow.map.mapObjects
        
        mapObjects.clear()
        
        mapObjects.addPlacemark(with: YMKPoint(latitude: coordinate.latitude, longitude: coordinate.longitude), image: #imageLiteral(resourceName: "user"), style: YMKIconStyle())
        
    }
    
    func configurOrderHeaderView() {
        view.addSubview(orderHeaderView)
        orderHeaderView.delegate = self
        
        orderHeaderView.frame = CGRect(
            x: 0, y: view.frame.height,
            width: view.frame.width, height: 70
        )
        
        UIView.animate(withDuration: 0.5) {
            self.orderHeaderView.frame.origin.y = self.view.frame.height - 80
        }
    }
    
    // MARK: - Selectors
    
    @objc func handleHome() {
        delegate?.handleHomeButton()
        configurePlacemark()
        homeButton.removeFromSuperview()
    }
    
    @objc func handleSideMenu() {
        present(menu!, animated: true)
    }
}



// MARK: - LocationServices

extension HomeController: CLLocationManagerDelegate {
    func hasLocationPermission() {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                UserDefaults.standard.setValue("notDetermined", forKey: "authorizationStatus")
                locationManager.requestWhenInUseAuthorization()
            case .restricted, .denied:
                UserDefaults.standard.setValue("denied", forKey: "authorizationStatus")
                deniedAuthorization()
            case .authorizedWhenInUse:
                locationManager.requestAlwaysAuthorization()
                UserDefaults.standard.setValue("authorizedWhenInUse", forKey: "authorizationStatus")
            case .authorizedAlways:
                UserDefaults.standard.setValue("authorizedAlways", forKey: "authorizationStatus")
            default:
                UserDefaults.standard.setValue("", forKey: "authorizationStatus")
            }
        } else {
            UserDefaults.standard.setValue("", forKey: "authorizationStatus")
        }
    }
    
    func deniedAuthorization() {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Location Permission Required", message: "Please enable location permissions in settings.", preferredStyle: UIAlertController.Style.alert)

            let okAction = UIAlertAction(title: "Settings", style: .default, handler: {(cAlertAction) in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            })

           
            alertController.addAction(okAction)
        
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

// MARK: - OrderHeaderViewDelegate

extension HomeController: OrderHeaderViewDelegate {
    
    func handleYourLocationButton() {
        let locationManager = LocationHandler.shared.locationManager
        
        guard let coordinate = locationManager.location?.coordinate else {
            return
        }
    
        mapView.mapWindow.map.move(
            with: YMKCameraPosition(target: YMKPoint(latitude: coordinate.latitude, longitude: coordinate.longitude), zoom: 15, azimuth: 0, tilt: 0),
            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 2),
            cameraCallback: nil
        )
    }

    func presentProfessions() {
        
        let professionsView = ProfessionsView()
        
        professionsView.backgroundColor = .systemBackground
        
        professionsView.frame = CGRect(
            x: 0, y: view.frame.height,
            width: view.frame.width, height: view.frame.height
        )
        
        UIView.animate(withDuration: 0.5) {
            professionsView.frame.origin.y = self.view.frame.height * 0.15
        }
        
        let blackView = BlackView()
        professionsView.addSubview(blackView)
        blackView.centerX(inView: professionsView)
        blackView.anchor(
            top: professionsView.topAnchor, paddingTop: 5, width: 50, height: 5
        )
        
        view.addSubview(professionsView)
    }
    
    func presentWorkers(selectedJobID: String) {
        
        let workersView = WorkersView(
            mapView: mapView, frame: view.frame, selectedJobID: selectedJobID
        )

        workersView.frame = CGRect(
            x: 0, y: view.frame.height,
            width: view.frame.width, height: view.frame.height
        )
        
        UIView.animate(withDuration: 0.5) {
            workersView.frame.origin.y = self.view.frame.height - 200
        }
        
        view.addSubview(workersView)
    }
}
