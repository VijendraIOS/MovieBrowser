//
//  MovieListViewController.swift
//  MovieBrowser
//
//  Created by Vijendra Vishwakarma on 22/12/18.
//  Copyright © 2018 Vijendra Vishwakarma. All rights reserved.
//

import UIKit

class MovieListViewController: UIViewController {
	
	//MARK: IBOutlet and Variables
	
	@IBOutlet weak var collectionViewMovie:UICollectionView!
	
	@IBOutlet weak var searchBar: UISearchBar!
	var arrayMovies:[Movies] = [Movies]()
	var searchController:UISearchController!
	var pageCount:Int = 0
	var selectedMovieTypeIndex:Int = -1
	
	//MARK: UIViewController's life cycle methods
	override func viewDidLoad() {
		
		super.viewDidLoad()
		self.title = "Movies"
		
		setupCollectionView()
		configureSearchBar()()
		MBProgressHUD.showAdded(to: self.view, animated: true)
		if(isInternetAvailable()) {
			
			callAPIToGetMovieList()
		}else {
			
			Utility.showAlert(in: self, message: kNO_INTERNET_CONNECTION, title: "Alert")
			DispatchQueue.main.async {
				
				MBProgressHUD.hide(for: self.view, animated: true)
			}
		}
	}
	
	//MARK: IBActions
	@IBAction func buttonActionLoadMore(sender:UIButton) {
	}
	
	@IBAction func buttonActionSetting(_ sender: UIBarButtonItem) {
		
		openSettingViewController()
	}
	
	//MARK: Methods
	fileprivate func setupCollectionView() {
		
		collectionViewMovie.dataSource  = self
		collectionViewMovie.delegate      = self
	}
	
	fileprivate func configureSearchBar() {
		
		searchBar.delegate 				 = self		
		searchBar.showsCancelButton  = true
		searchBar.searchBarStyle        = .default
		searchBar.barTintColor            = UIColor.red
		searchBar.tintColor                 = .black
		searchBar.backgroundColor     = UIColor(displayP3Red: 0/255, green: 199/255, blue: 242/255, alpha: 1.0)
		let cancelButtonAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
		UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes , for: .normal)
	}
	
	fileprivate func callAPIToGetMovieList(type:String) {
		
		let url = "https://api.themoviedb.org/3/list/1?api_key=7c18796081fc8f45f308151b448511e2&language=en-US";
		switch type {
		case MOVIE_TYPE.Normal:
			<#code#>
		default:
			<#code#>
		}
		RESTAPIManager.makeHTTPGETRequest(url) { (json, error) in
			guard let items = json["items"].array else {
				return
			}
			for item in items {
				
				self.arrayMovies.append(Movies(json: item))
			}
			DispatchQueue.main.async {
				MBProgressHUD.hide(for: self.view, animated: true)
				self.collectionViewMovie.reloadData()
			}
		}
	}
	
	func openSettingViewController() {
		
		let settingVC  = UIStoryboard.settingViewController()
		settingVC.selectedIndex = selectedMovieTypeIndex
		settingVC.delegate = self
		let nav = UINavigationController(rootViewController: settingVC)
		nav.modalPresentationStyle = UIModalPresentationStyle.popover
		let popover = nav.popoverPresentationController
		settingVC.preferredContentSize = CGSize(width: 200, height: 100)
		popover?.delegate = self
		popover?.sourceView = self.view
		popover?.sourceRect = CGRect(x: self.view.frame.size.width, y: 75, width: 0, height: 0)
		self.present(nav, animated: true, completion: nil)
	}
}

extension MovieListViewController: UISearchBarDelegate {
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		
		searchBar.resignFirstResponder()
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		print("search button action")
	}
}

extension MovieListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
	
	//MARK: UICollectionViewDataSource
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		
		return 1;
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		
		return arrayMovies.count;
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kMOVIE_CELL_ID, for: indexPath) as! MovieCell
		let currentMovieDetail = arrayMovies[indexPath.row]
		cell.labelMovieTitle.text = arrayMovies[indexPath.row].originalTitle
		//let url = "https://image.tmdb.org/t/p/w342\(currentMoveDetail.posterImage!)"
		let url = currentMovieDetail.posterImage
		print(url)
		cell.imageViewPoster.loadImageUsingCache(withUrl: url)
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		let movieDetailVC = UIStoryboard.movieDetailViewController()
		movieDetailVC.currentMovie = arrayMovies[indexPath.row]
		self.navigationController?.pushViewController(movieDetailVC, animated: true)
	}
}

extension MovieListViewController: UICollectionViewDelegateFlowLayout {
	
	//MARK: UICollectionViewDelegateFlowLayout
	fileprivate var sectionInsets: UIEdgeInsets {
		return UIEdgeInsetsMake(15, 15, 15, 15)
	}
	
	fileprivate var itemsPerRow: CGFloat {
		return 3
	}
	
	fileprivate var interitemSpace: CGFloat {
		return 5.0
	}
	
	func collectionView(_ collectionView: UICollectionView,
						layout collectionViewLayout: UICollectionViewLayout,
						sizeForItemAt indexPath: IndexPath) -> CGSize {
		let sectionPadding = sectionInsets.left * (itemsPerRow + 1)
		let interitemPadding = max(0.0, itemsPerRow - 1) * interitemSpace
		let availableWidth = collectionView.bounds.width - sectionPadding - interitemPadding
		let widthPerItem = availableWidth / itemsPerRow
		
		return CGSize(width: widthPerItem, height: widthPerItem)
	}
	
	func collectionView(_ collectionView: UICollectionView,
						layout collectionViewLayout: UICollectionViewLayout,
						insetForSectionAt section: Int) -> UIEdgeInsets {
		return sectionInsets
	}
	
	func collectionView(_ collectionView: UICollectionView,
						layout collectionViewLayout: UICollectionViewLayout,
						minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 15.0
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return interitemSpace
	}
}
extension MovieListViewController: UIPopoverPresentationControllerDelegate {
	
	func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
		return UIModalPresentationStyle.none
	}
}

extension MovieListViewController: SettingViewControllerDelegate {
	
	func didSelected(index: Int) {
		
		selectedMovieTypeIndex = index
	}
}

