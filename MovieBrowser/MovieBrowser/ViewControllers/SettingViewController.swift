//
//  SettingViewController.swift
//  MovieBrowser
//
//  Created by Vijendra Vishwakarma on 23/12/18.
//  Copyright © 2018 Vijendra Vishwakarma. All rights reserved.
//

import UIKit
protocol SettingViewControllerDelegate {
	func didSelected(index:Int)
}
/*!
	@brief: The SettingViewController
	@discussion:  This class is designed and implemented to change settings of the movie type.
	@superclass SuperClass: UIViewController
	@classdesign: It is design for all the iPhone size.
*/
class SettingViewController: UIViewController {
	
	//MARK: IBOutlets and Variables
	@IBOutlet weak var settingTableView:UITableView!
	var delegate:SettingViewControllerDelegate? = nil
	var selectedIndex:Int = -1
	var arraySettingMenu:[String] = ["Most popular", "Highest rated"]
	
	//MARK: UIViewController's life cycle methods
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
	
	//MARK: UITableViewDataSource
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
	
	//MARK: UITableViewDelegates
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		selectedIndex = indexPath.row
		self.settingTableView.reloadData()
	}
}

