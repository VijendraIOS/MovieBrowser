//
//  SettingViewController.swift
//  MovieBrowser
//
//  Created by Sumit Vishwakarma on 23/12/18.
//  Copyright © 2018 Sumit Vishwakarma. All rights reserved.
//

import UIKit

protocol SettingViewControllerDelegate {
	func didSelected(index:Int)
}

class SettingViewController: UIViewController {

	@IBOutlet weak var settingTableView:UITableView!
	var delegate:SettingViewControllerDelegate? = nil
	var selectedIndex:Int = -1
	var arraySettingMenu:[String] = ["Most popular", "Highest rated"]
	
    override func viewDidLoad() {
        super.viewDidLoad()
		setupTableView()
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	//MARK: IBActions
	@IBAction func buttonActionDone(sender:UIBarButtonItem) {
		
		delegate?.didSelected(index: selectedIndex)
		self.dismiss(animated: true, completion: nil)
	}
	
	//MARK: Methods
	func setupTableView() {
		
		settingTableView.delegate = self
		settingTableView.dataSource = self
	}
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: kSETTING_CELL_ID)
		(indexPath.row == selectedIndex) ? (cell?.accessoryType = .checkmark) : (cell?.accessoryType = .none)
		cell?.textLabel?.text = arraySettingMenu[indexPath.row]
		return cell!
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		selectedIndex = indexPath.row
		self.settingTableView.reloadData()
	}
}

