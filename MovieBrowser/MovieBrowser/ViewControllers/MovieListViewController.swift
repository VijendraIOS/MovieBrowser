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
  var arrayMovies:[Movies] = [Movies]()
  //MARK: UIViewController's life cycle methods
  override func viewDidLoad() {
    
    super.viewDidLoad()
    self.title = "Movies"
    
    setupCollectionView()
    callAPIToGetMovieList()
  }
  
  override func didReceiveMemoryWarning() {
    
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  //MARK: Methods
  
  fileprivate func setupCollectionView() {
    
    collectionViewMovie.dataSource  = self
    collectionViewMovie.delegate      = self
  }
  
  func callAPIToGetMovieList() {
    
    let url = "https://api.themoviedb.org/3/list/1?api_key=7c18796081fc8f45f308151b448511e2&language=en-US";
    
    RESTAPIManager.makeHTTPGETRequest(url) { (json, error) in
      guard let items = json["items"].array else {
        return
      }
      print(items)
      
      for item in items {
        
        self.arrayMovies.append(Movies(json: item))
      }
      
      DispatchQueue.main.async {
        self.collectionViewMovie.reloadData()
      }
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

extension MovieListViewController : UICollectionViewDelegateFlowLayout {
  
  //MARK: UICollectionViewDelegateFlowLayout
  fileprivate var sectionInsets: UIEdgeInsets {
    return UIEdgeInsetsMake(15, 15, 15, 15)
  }
  
  fileprivate var itemsPerRow: CGFloat {
    return 2
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
