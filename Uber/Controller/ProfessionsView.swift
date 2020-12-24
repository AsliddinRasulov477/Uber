import UIKit
import Alamofire
import SwiftyJSON

class ProfessionsView: UIView {
    
    // MARK: - Properties
    
    var panGR : UIPanGestureRecognizer!
    
    var progressBool : Bool = false
    var contentOffsetY: Bool = true
    
    var jobs: [[String: String]] = []
    var selectedJobs: [String] = []
        
    let professionsTableView: UITableView = {
        let tableView = UITableView()
        
        tableView.register(
            ProfessionsTableCell.self,
            forCellReuseIdentifier: ProfessionsTableCell.identifire
        )
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        
        tableView.bounces = false
        tableView.bouncesZoom = false
        tableView.showsVerticalScrollIndicator = false
        
        return tableView
    }()
    
    let searchButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = #colorLiteral(red: 0.2549019608, green: 0.831372549, blue: 0.0431372549, alpha: 1)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 35
        button.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        button.setImage(#imageLiteral(resourceName: "search").withTintColor(.systemBackground), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        
        AF.request("http://167.99.33.2/api/jobs", method: .get).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                DispatchQueue.main.async {
                    let json = JSON(value)
                    for i in 0..<json["data"].count {
                        let jobID = json["data"][i]["_id"].string ?? ""
                        let jobTitle = json["data"][i]["title"].string ?? ""
                        self.jobs.append([jobID: jobTitle])
                        self.professionsTableView.reloadData()
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    
        panGR = UIPanGestureRecognizer(target: self, action: #selector(pan))
        panGR.delegate = self
        self.addGestureRecognizer(panGR)
        
        layer.cornerRadius = 16
        layer.maskedCorners = [.layerMinXMinYCorner,
                               .layerMaxXMinYCorner]
        
        addShadow()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Helper Functions
    
    func configure() {
        configureProfessionsTableView()
    }
    
    
    func configureProfessionsTableView() {
        addSubview(professionsTableView)
            
        professionsTableView.delegate = self
        professionsTableView.dataSource = self
        
        professionsTableView.anchor(
            top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor,
            paddingTop: 15, paddingBottom: 0.15 * UIScreen.main.bounds.height
        )
    }
    
    func configureSearchButton() {
        DispatchQueue.main.async {
            guard let keyWindow = UIApplication.shared.keyWindow else { return }
            keyWindow.addSubview(self.searchButton)
            self.searchButton.anchor(
                bottom: keyWindow.bottomAnchor, right: keyWindow.rightAnchor,
                paddingBottom: 30, paddingRight: 30,
                width: 70, height: 70
            )
            self.searchButton.addTarget(
                self, action: #selector(self.handleSearchButton),
                for: .touchUpInside
            )
        }
    }
    
    
    // MARK: - Selectors
    
    @objc private func handleSearchButton() {
        guard let controller = UIApplication.shared.keyWindow?.rootViewController
                as? HomeController else { return }
        let professionsView = controller.view.subviews.last
        UIView.animate(withDuration:  0.3) {
            professionsView?.frame.origin.y = controller.view.frame.height
        } completion: { _ in
            professionsView?.removeFromSuperview()
            self.searchButton.removeFromSuperview()
            controller.presentWorkers(selectedJobID: self.selectedJobs[0])
        }
    }
}

   
// MARK: - UITableViewDelegate, UITableViewDataSource

extension ProfessionsView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobs.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ProfessionsTableCell.identifire, for: indexPath
        ) as! ProfessionsTableCell
        
        if selectedJobs.count == 0 {
            cell.contentView.backgroundColor = .systemBackground
        }
        
        for (key, value) in jobs[indexPath.row] {
            cell.textLabel?.text = value
            if selectedJobs.contains(key) {
                cell.contentView.backgroundColor = #colorLiteral(red: 0.2549019608, green: 0.831372549, blue: 0.0431372549, alpha: 1)
            } else {
                cell.contentView.backgroundColor = .systemBackground
            }
        }
            
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ProfessionsTableCell
        
        for (key, _) in jobs[indexPath.row] {
            if selectedJobs.contains(key) {
                cell.contentView.backgroundColor = .systemBackground
                selectedJobs = selectedJobs.filter { $0 != key }
            } else {
                cell.contentView.backgroundColor = #colorLiteral(red: 0.2549019608, green: 0.831372549, blue: 0.0431372549, alpha: 1)
                selectedJobs.append(key)
            }
        }
                
        if selectedJobs.count == 1 {
            configureSearchButton()
        } else
        if selectedJobs.count == 0  {
            searchButton.removeFromSuperview()
        }
    }
}

extension ProfessionsView : UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool{

        return true
    }
}
