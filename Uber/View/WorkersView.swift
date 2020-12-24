import UIKit
import CallKit
import Alamofire
import SwiftyJSON
import CoreLocation
import YandexMapsMobile


class WorkersView: UIView {
    
    // MARK: - Properties
    
    var panGR : UIPanGestureRecognizer!
    
    var progressBool : Bool = false
    var contentOffsetY: Bool = true
    
    var constHeight: CGFloat = 200
    
    private var workerIndex = 0
    private var worker = Worker()
    private var workers: [Worker] = []
    
    var selectedJobID: String = ""
    
    private var mapView: YMKMapView!
    private var drivingSession: YMKDrivingSession!
    
    private let locationManager = LocationHandler.shared.locationManager
    
    var homeButton = HomeButton()
    let nextANDpreviousView = ChangeWorkerView()

    let workersTableView: UITableView = {
        let tableView = UITableView()
        
        tableView.register(
            WorkerMainCell.self,
            forCellReuseIdentifier: WorkerMainCell.identifire
        )
        
        tableView.register(
            WorkerDescriptionCell.self,
            forCellReuseIdentifier: WorkerDescriptionCell.identifire
        )
        
        tableView.register(
            WorkerPhotoCollectionCell.self,
            forCellReuseIdentifier: WorkerPhotoCollectionCell.identifire
        )
    
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        return tableView
    }()
    

    
    // MARK: - Lifecycle

    init(mapView: YMKMapView, frame: CGRect, selectedJobID: String) {
        super.init(frame: frame)
    
        self.mapView = mapView
        self.selectedJobID = selectedJobID
        
        panGR = UIPanGestureRecognizer(target: self, action: #selector(pan))
        panGR.delegate = self
        self.addGestureRecognizer(panGR)
        
        
        layer.cornerRadius = 16
        layer.maskedCorners = [.layerMinXMinYCorner,
                               .layerMaxXMinYCorner]

        addShadow()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: Helper Functions
    
    func configure() {
        showWorkersOnMap { success in
            if success {
                guard let controller = UIApplication.shared.keyWindow?.rootViewController
                        as? HomeController else { return }
                controller.delegate = self
                controller.configureHomeButton()
                self.configureWorkersTableView()
            } else {
                self.removeFromSuperview()
                print("Worker topilmadi!!!!!")
            }
        }
    }
    
    func configureWorkersTableView() {
        addSubview(workersTableView)
        
        workersTableView.delegate = self
        workersTableView.dataSource = self
        
        workersTableView.anchor(
            top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor,
            paddingTop: 50, paddingBottom: 0.1 * UIScreen.main.bounds.height
        )

        configureNextAndPrevious()
    }
    
    func configureNextAndPrevious() {
        addSubview(nextANDpreviousView)
        nextANDpreviousView.delegate = self
        nextANDpreviousView.anchor(
            left: leftAnchor, bottom: workersTableView.topAnchor, right: rightAnchor,
            height: 50
        )
    }
    
    
    // MARK: - API
    
    private func showWorkersOnMap(completion: @escaping(Bool) -> Void) {
        fetchWorkersData { (fetched) in
            if fetched {
                if self.workers.count > 0 {
                    self.worker = self.workers[self.workerIndex]
                    completion(true)
                } else {
                    completion(false)
                }
                
            }
        }
    }

    private func fetchWorkersData(completion: @escaping(Bool) -> Void) {
        
        guard let coordinate = locationManager.location?.coordinate  else { return }

        let params: [String : Any] = [
            "job": selectedJobID,
            "latlng": "\(coordinate.latitude),\(coordinate.longitude)"
        ]
    
        AF.request("http://167.99.33.2/api/users/filter",
                   method: .get, parameters: params).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                for i in 0..<json["data"].count {
                    let worker = Worker()
                    worker.distance = json["data"][i]["distance"].double ?? 0.0
                    worker.firstName = json["data"][i]["firstName"].string ?? ""
                    worker.lastName = json["data"][i]["lastName"].string ?? ""
                    worker.phone = json["data"][i]["phone"].string ?? ""
                    worker.description = json["data"][i]["description"].string ?? ""
                    worker.images = json["data"][i]["images"].arrayObject as! [String]
                    worker.avatar = json["data"][i]["avatar"].string ?? ""
                    let coordinate = json["data"][i]["location"]["coordinates"].arrayObject as! [Double]
                    let loction = Location(coordinate: coordinate)
                    worker.location = loction
                    self.workers.append(worker)
                }
                
                completion(true)
            case .failure(let error):
                print(error)
            }
        }
    }

    private func annotationWorkers(worker: Worker, completion: @escaping(Bool) -> Void) {

        let mapObjects = self.mapView.mapWindow.map.mapObjects
        mapObjects.clear()
        
        guard let coordinate = locationManager.location?.coordinate else { return }
        
        mapObjects.addPlacemark(with: YMKPoint(latitude: coordinate.latitude, longitude: coordinate.longitude), image: #imageLiteral(resourceName: "user"), style: YMKIconStyle())
        
        mapObjects.addPlacemark(with: YMKPoint(latitude: worker.location.coordinate[0], longitude: worker.location.coordinate[1]), image: #imageLiteral(resourceName: "worker"), style: YMKIconStyle())
        
        drawRoute()
        
        completion(true)
    }
    
    func drawRoute() {
        
        let coordinate = worker.location.coordinate
        
        guard let location = locationManager.location else {
            return
        }
        
        let requestPoints : [YMKRequestPoint] = [
            YMKRequestPoint(point: YMKPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), type: .waypoint, pointContext: nil),
            YMKRequestPoint(point: YMKPoint(latitude: coordinate[0], longitude: coordinate[1]), type: .waypoint, pointContext: nil),
        ]
        
        let responseHandler = {(routesResponse: [YMKDrivingRoute]?, error: Error?) -> Void in
            if let routes = routesResponse {
                let mapObjects = self.mapView.mapWindow.map.mapObjects
                let polyline = mapObjects.addPolyline(with: routes[0].geometry)
                polyline.strokeWidth = 3
                polyline.strokeColor = .red
            } else {
                fatalError()
            }
        }
        
        let drivingRouter = YMKDirections.sharedInstance().createDrivingRouter()
        drivingSession = drivingRouter.requestRoutes(
            with: requestPoints,
            drivingOptions: YMKDrivingDrivingOptions(),
            vehicleOptions: YMKDrivingVehicleOptions(),
            routeHandler: responseHandler)
        
        
    }
    
    private func showAroundUser() {
        let coordinateWorker = worker.location.coordinate
    
        self.mapView.mapWindow.map.move(
            with: YMKCameraPosition(
                target: YMKPoint(
                    latitude: coordinateWorker[0] - 0.005,
                    longitude: coordinateWorker[1]
                ), zoom: 15, azimuth: 0, tilt: 0
            )
        )
    }
}


// MARK: - UITableViewDelegate, UITableViewDataSource

extension WorkersView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let workerMainCell = tableView.dequeueReusableCell(
                withIdentifier: WorkerMainCell.identifire, for: indexPath
            ) as! WorkerMainCell
            
            workerMainCell.delegate = self
            
            workerMainCell.configure(with: worker)
            
            annotationWorkers(worker: worker) { (success) in
                if success {
                    self.showAroundUser()
                }
            }
            return workerMainCell
        } else
        if indexPath.section == 1 {
            let workerDescriptionCell = tableView.dequeueReusableCell(
                withIdentifier: WorkerDescriptionCell.identifire, for: indexPath
            ) as! WorkerDescriptionCell
            
            workerDescriptionCell.configure(with: worker)
            
            return workerDescriptionCell
        } else
        if indexPath.section == 2 {
            let workerPhotoCollectionCell = tableView.dequeueReusableCell(
                withIdentifier: WorkerPhotoCollectionCell.identifire, for: indexPath
            ) as! WorkerPhotoCollectionCell
            
            workerPhotoCollectionCell.configure(worker: worker)
            
            return workerPhotoCollectionCell
        }
        
        return UITableViewCell()
    }
}

// MARK: - UIGestureRecognizerDelegate

extension WorkersView : UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool{

        return true
    }
}


// MARK: - NextANDPreviousViewDelegate

extension WorkersView: ChangeWorkerViewDelegate {
    func changeWorker(with tag: Int) {
        if tag == 1 && workerIndex == workers.count - 1 {
            workerIndex = -1
        }
        
        if tag == -1 && workerIndex == 0 {
            workerIndex = workers.count
        }
        
        workerIndex += tag
        
        worker = workers[workerIndex]
        
        workersTableView.reloadData()
    }
}


// MARK: - HomeControllerDelegate

extension WorkersView: HomeControllerDelegate {
    func handleHomeButton() {
        UIView.animate(withDuration: 0.3) {
            self.alpha = 0
            self.mapView.mapWindow.map.mapObjects.clear()
        } completion: { _ in
            self.workers = []
            self.removeFromSuperview()
        }
    }
}


// MARK: - WorkerMainCellDelegate

extension WorkersView: WorkerMainCellDelegate {
    func handleCallNowButton() {
        let url: URL = URL(string: "TEL://\(worker.phone)")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
