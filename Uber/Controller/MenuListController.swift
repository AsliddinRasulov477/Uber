//
//  TableMenuView.swift
//  SideMenuWithTableView
//
//  Created by uchqun on 19/12/20.
//

import Foundation
import UIKit

struct MenuCellData  {
    let image : UIImage?
    let text : String?
}

class MenuListController : UITableViewController   {
    
    
    // MARK: - Properties
    
    private var menuData = [MenuCellData]()
    private var image : UIImage? = nil
    private var text : String? = nil
    private var phoneNumber : String? = nil
    
    
    
    // MARK: - Lifecycle
    
    init(menuItemsText: String , menuItemsImage : UIImage, menuPhoneNumber: String) {
        self.image = menuItemsImage
        self.phoneNumber = menuPhoneNumber
        self.text = menuItemsText
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMenuCellData()
        
        tableView.bounces = false
        tableView.bouncesZoom = false
        tableView.isScrollEnabled = false
        
        tableView.separatorColor = .clear
        tableView.backgroundColor = .systemBackground
        
        tableView.register(
            MenuCell.self, forCellReuseIdentifier: MenuCell.identifire
        )
        tableView.register(
            MenuTitleCell.self, forCellReuseIdentifier: MenuTitleCell.identifire
        )
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return menuData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let titleCell = tableView.dequeueReusableCell(
                withIdentifier: MenuTitleCell.identifire
            ) as! MenuTitleCell
            
            titleCell.configure(
                menuItemText: text ?? "", menuPhoneText: phoneNumber ?? "", image: image!
            )
            
            return titleCell
        } else {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: MenuCell.identifire
            ) as! MenuCell

            cell.configure(
                menuItemText: menuData[indexPath.row].text, image: menuData[indexPath.row].image
            )
            
            return cell
            
       }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 8 {
            
        }
    }
    
    
    // MARK: - Configure MenuCellData
    
    func configureMenuCellData() {
        menuData.append(contentsOf: [MenuCellData.init(image: nil, text: nil)])
        menuData.append(contentsOf: [MenuCellData.init(image: nil, text: nil)])
        menuData.append(contentsOf: [MenuCellData.init(image: nil, text: nil)])
        menuData.append(contentsOf: [MenuCellData.init(image: nil, text: nil)])
        menuData.append(contentsOf:
            [MenuCellData.init(image: #imageLiteral(resourceName: "construction-and-tools").withTintColor(.label), text: "menu1".localized)]
        )
        menuData.append(contentsOf:
            [MenuCellData.init(image: #imageLiteral(resourceName: "history").withTintColor(.label), text: "menu2".localized)]
        )
        menuData.append(contentsOf:
            [MenuCellData.init(image: #imageLiteral(resourceName: "gift-box-with-a-ribbon").withTintColor(.label), text: "menu3".localized)]
        )
        menuData.append(contentsOf: [MenuCellData.init(image: nil, text: nil)])
        menuData.append(contentsOf:
            [MenuCellData.init(image: #imageLiteral(resourceName: "translate").withTintColor(.label), text: "menu4".localized)]
        )
        menuData.append(contentsOf:
            [MenuCellData.init(image: #imageLiteral(resourceName: "information").withTintColor(.label), text: "menu5".localized)]
        )
        menuData.append(contentsOf:
            [MenuCellData.init(image: #imageLiteral(resourceName: "information-2").withTintColor(.label), text: "menu6".localized)]
        )
    }
}
