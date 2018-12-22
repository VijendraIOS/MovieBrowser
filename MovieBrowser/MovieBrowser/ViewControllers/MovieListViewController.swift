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
    
    //MARK: UIViewController's life cycle methods
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "Movies"
        setupCollectionView()
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
}
extension MovieListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    //MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1;
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 9;
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kMOVIE_CELL_ID, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let moveDetailVC = UIStoryboard.movieDetailViewController()
        self.navigationController?.pushViewController(moveDetailVC, animated: true)
    }
}

