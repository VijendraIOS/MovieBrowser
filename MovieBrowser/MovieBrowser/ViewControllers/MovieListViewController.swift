//
//  MovieListViewController.swift
//  MovieBrowser
//
//  Created by Vijendra Vishwakarma on 22/12/18.
//  Copyright © 2018 Vijendra Vishwakarma. All rights reserved.
//

import UIKit
/*!
	@brief :The MoviesListViewController class
	@discussion:  This class is designed and implemented to show list of movies according to sorted order most popular movies, top rated movies or via search.
	@superclass SuperClass: UIViewController
	@classdesign: It is design for all the iPhone size.
*/
class MovieListViewController: UIViewController {
	
	//MARK: IBOutlet and Variables
	@IBOutlet weak var collectionViewMovie:UICollectionView!
	@IBOutlet weak var searchBar: UISearchBar!
	var arrayMovies:[Movies] = [Movies]()
	var pageCount:Int = 1
	var selectedMovieTypeIndex:Int = -1
	var currentShowingMovieType:MOVIE_TYPE = MOVIE_TYPE.normal
	var searchText:String = ""
	
	//MARK: UIViewController's life cycle methods
	override func viewDidLoad() {
		
		super.viewDidLoad()
		self.title = "Movies"
		
		setupCollectionView()
		configureSearchBar()
		callAPIToGetMovieList(type: MOVIE_TYPE.normal.rawValue, searchText: "")
	}
	
	//MARK: IBActions
	@IBAction func buttonActionLoadMore(sender:UIButton) {
		
		switch currentShowingMovieType {
		case MOVIE_TYPE.normal:
			
			callAPIToGetMovieList(type:MOVIE_TYPE.normal.rawValue, searchText: "")
		case MOVIE_TYPE.search:
			
			callAPIToGetMovieList(type: MOVIE_TYPE.search.rawValue, searchText: self.searchText)
		case MOVIE_TYPE.mostPopular:
			
			callAPIToGetMovieList(type: MOVIE_TYPE.mostPopular.rawValue, searchText: "")
		case MOVIE_TYPE.topRated:
			
			callAPIToGetMovieList(type: MOVIE_TYPE.topRated.rawValue, searchText: "")
		}
	}
	
	@IBAction func buttonActionSetting(_ sender: UIBarButtonItem) {
		
		openSettingViewController()
	}
	
	//MARK: Methods
	/*!
		@brief It is a setupCollectionView method
		@description This method is used to setup collectionView delegate and datasource.
		@param nil
	*/
	fileprivate func setupCollectionView() {
		
		collectionViewMovie.dataSource  = self
		collectionViewMovie.delegate = self
	}
	
	/*!
		@brief It is a configureSearchBar method
		@description This method is used to configure search bar like background controller , delegates.
		@param nil
	*/
	fileprivate func configureSearchBar() {
		
		searchBar.delegate = self
		searchBar.showsCancelButton = true
		searchBar.searchBarStyle = .default
		searchBar.barTintColor = UIColor.red
		searchBar.tintColor = .black
		searchBar.backgroundColor = UIColor(displayP3Red: 0/255, green: 199/255, blue: 242/255, alpha: 1.0)
		let cancelButtonAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
		UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes , for: .normal)
	}
	
	/*!
		@brief It is a callAPIToGetMovieList method
		@description This method is to get movies list like most popular, top rated etc.
		@param type : Type may be most popular, top rated movies
		@parm searchText : only apply when searching movies
	*/
	fileprivate func callAPIToGetMovieList(type:String,searchText:String) {
		
		if(!isInternetAvailable()) {
			
			Utility.showAlert(in: self, message: kNO_INTERNET_CONNECTION, title: kALERT)
			return;
		}
		MBProgressHUD.showAdded(to: self.view, animated: true)
		var url = ""
		switch type {
			
		case MOVIE_TYPE.normal.rawValue:
	
			self.title = "Movies"
			url = Utility.getGeneralMovieListURL(with: pageCount)
		case MOVIE_TYPE.search.rawValue:
			
			self.title = "Movies"
			self.searchText = ""
			url = Utility.getSearchMovieListURL(for: pageCount, keywordToSearch: searchText)
		case MOVIE_TYPE.mostPopular.rawValue:
			
			self.title = "Most Popular Movies"
			url = Utility.getMostPopularMovieListURL(for: pageCount)
		case MOVIE_TYPE.topRated.rawValue:
			
			self.title = "Top Rated Movies"
			url = Utility.getTopRatedMovieURL(for:pageCount)
		default:
			self.title = "Movies"
			url = Utility.getGeneralMovieListURL(with: pageCount)
		}
		
		RESTAPIManager.makeHTTPGETRequest(url) { (json, error) in
			
			if(error != nil) {
				
				DispatchQueue.main.async {
					MBProgressHUD.hide(for: self.view, animated: true)
					Utility.showAlert(in: self, message: kERROR_WEB_SERVICE, title: kALERT)
					return
				}
			}
			
			guard let items = (type == MOVIE_TYPE.normal.rawValue) ? json["items"].array : json["results"].array else {
				
				DispatchQueue.main.async {
				
					MBProgressHUD.hide(for: self.view, animated: true)
					Utility.showAlert(in: self, message: kNO_DATA_FOUND+" for page count \(self.pageCount)", title: kALERT)
				}
				return
			}
			
			if(items.isEmpty) {
				
				DispatchQueue.main.async {
					
					MBProgressHUD.hide(for: self.view, animated: true)
					Utility.showAlert(in: self, message: kNO_DATA_FOUND+" for page count \(self.pageCount)", title: kALERT)
				}
				return
			}
			
			if(self.pageCount == 1) {
				
				self.arrayMovies.removeAll()
			}
			for item in items {
				
				self.arrayMovies.append(Movies(json: item))
			}
			DispatchQueue.main.async {
				
				MBProgressHUD.hide(for: self.view, animated: true)
				self.pageCount = self.pageCount+1
				self.collectionViewMovie.reloadData()
			}
		}
	}
	
	/*!
		@brief It is a openSettingViewController method
		@description This method is to open setting screen as a popover screen.
		@param nil
	*/
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
	
	//MARK: UISearchBarDelegate
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		
		searchBar.resignFirstResponder()
		searchBar.text = ""
		if(currentShowingMovieType == MOVIE_TYPE.search) {
			
			pageCount = 1
			currentShowingMovieType = MOVIE_TYPE.normal
			callAPIToGetMovieList(type: MOVIE_TYPE.normal.rawValue, searchText: "")
		}
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		
		if(searchBar.text != "") {
			
			pageCount = 1
			currentShowingMovieType = MOVIE_TYPE.search
			searchText = searchBar.text!
			searchBar.resignFirstResponder()
			callAPIToGetMovieList(type: MOVIE_TYPE.search.rawValue, searchText: searchBar.text!)
		}
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
		cell.configureCell(with: arrayMovies[indexPath.row])
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
	
	//MARK: UIPopoverPresentationControllerDelegate
	func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
		return UIModalPresentationStyle.none
	}
}

extension MovieListViewController: SettingViewControllerDelegate {
	
	//MARK: SettingViewControllerDelegate
	func didSelected(index: Int) {
		
		selectedMovieTypeIndex = index
		pageCount = 1
		if(index == 0) {
			
			//code for the most popular movies
			currentShowingMovieType = MOVIE_TYPE.mostPopular
			callAPIToGetMovieList(type: MOVIE_TYPE.mostPopular.rawValue, searchText: "")
		}else {
			
			//code for the top rated movies
			currentShowingMovieType = MOVIE_TYPE.topRated
			callAPIToGetMovieList(type:MOVIE_TYPE.topRated.rawValue, searchText: "")
		}
	}
}

