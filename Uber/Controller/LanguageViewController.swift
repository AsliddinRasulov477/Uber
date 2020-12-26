//
//  LanguageViewController.swift
//  QuizApp
//
//  Created by Akhadjon Abdukhalilov on 10/9/20.
//  Copyright © 2020 Akhadjon Abdukhalilov. All rights reserved.
//

import UIKit

class LanguageViewController: UIViewController {
    
    let languages:[String] = ["8".localized, "9".localized,"7".localized]
    let languagesArray = ["uz-Cyrl", "ru", "uz"]

    lazy var tableView:UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
       // tableView.separatorStyle = .none
        tableView.backgroundColor =  #colorLiteral(red: 0.9724746346, green: 0.9725909829, blue: 0.9724350572, alpha: 1)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor =  #colorLiteral(red: 0.9724746346, green: 0.9725909829, blue: 0.9724350572, alpha: 1)
        setupView()
    }

    func setupView(){
        title = "1".localized
        view.addSubview(tableView)
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
       
    }
}

extension LanguageViewController:UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = languages[indexPath.row]
    
        if LocalizationSystem.shared.locale == Locale(identifier: languagesArray[indexPath.row]){
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let lang = indexPath.row + 1
        LocalizationSystem.shared.locale =
                            Bundle.main.localizations.filter { $0 != "Base" }.map { Locale(identifier: $0) }[lang]
        tableView.reloadData()
        title = "1".localized
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}
