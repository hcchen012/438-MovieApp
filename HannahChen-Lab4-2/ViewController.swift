//
//  ViewController.swift
//  HannahChen-Lab4-2
//
//  Created by Hannah Chen on 10/12/22.
//

//Reference for UICollectionView: https://www.kodeco.com/18895088-uicollectionview-tutorial-getting-started#toc-anchor-013
//Reference for SearchBar: https://guides.codepath.com/ios/Search-Bar-Guide
//Reference for ActivityIndicatorView: https://stackoverflow.com/questions/56613143/i-am-trying-to-get-an-uiactivityindicatorview-to-show-when-i-am-loading-a-uitabl
//Icon images from: "https://www.freeiconspng.com/img/"


import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var loadingCircle: UIActivityIndicatorView!
    
    
    var movieData:[Movie] = []
    var theImageCache:[UIImage] = []
    var noResults = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.title = "Movie Search"
        
        let cellSize = UIScreen.main.bounds.width / 3 - 10
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
        layout.itemSize = CGSize(width: cellSize, height: cellSize * 1.5)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        collectionView.collectionViewLayout = layout
        
        searchBar.delegate = self
        loadingCircle.isHidden = true
        setupCollectionView()
    }

    //CollectionView required
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //restrict to 20 movies max
        return theImageCache.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieCollectionViewCell
        
//        cell.movieImage.image = UIImage(named: array[indexPath.row])
        
        cell.movieImage.image = theImageCache[indexPath.row]
        cell.movieTitle.text = movieData[indexPath.row].title
        return cell
    }
    
    //push ViewController on click
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("in push")
        let detailedVC = DetailedViewController()
        detailedVC.movieTitle = movieData[indexPath.row].title
        detailedVC.releaseDate = movieData[indexPath.row].release_date
        detailedVC.voteCount = movieData[indexPath.row].vote_count
        detailedVC.voteAvg = movieData[indexPath.row].vote_average
        detailedVC.id = movieData[indexPath.row].id
        
        
        //get higher quality image
        if theImageCache[indexPath.row] != UIImage(named: "no-image-found.png"){
            let url = URL(string: "https://image.tmdb.org/t/p/w300" + movieData[indexPath.row].poster_path!)
//                print("image url: \(url)")
//                w### is what size dimensions you want the image returned to be
            let data = try? Data(contentsOf: url!)
            
            if (data == nil){
                detailedVC.image = theImageCache[indexPath.row]
            }
            else{
                detailedVC.image = UIImage(data: data!)
            }
        }
        
        navigationController?.pushViewController(detailedVC, animated: true)
        
    }
    
    
    //Other Functions
    func setupCollectionView(){
        collectionView.dataSource = self
        collectionView.delegate = self
        
        movieData.removeAll()
        theImageCache.removeAll()
        
        loadingCircle.isHidden = false
        loadingCircle.startAnimating()
        DispatchQueue.global().async {
            
            self.fetchDataForCollectionView(query: "")
            
            DispatchQueue.main.async {
                
                self.loadingCircle.stopAnimating()
                self.loadingCircle.isHidden = true
                self.collectionView.reloadData()
            }
        }
    }
    
    func fetchDataForCollectionView(query: String){
        let apiKey:String = "2c6b31eee40c624041cc6ff6b11d5aaf"
        if query == ""{
            //fetch current popular movies
            guard let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)") else {
                print("Invalid URL")
                    return
            }
            let data = try! Data(contentsOf: url)
            if data.count > 0{
                movieData = try! JSONDecoder().decode(APIResults.self, from: data).results
                print("the data is \(movieData)")
                if movieData.count != 0{
                    cacheImages()
                }
            }
        }
        else{
            let searchQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            guard let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&query=\(searchQuery)") else {
                print("Invalid URL")
                    return
            }
            let data = try! Data(contentsOf: url)
            if data.count > 0{
                movieData = try! JSONDecoder().decode(APIResults.self, from: data).results
                print("the data is \(movieData)")
                if movieData.count != 0{
                    cacheImages()
                }
                else{
                    noResults = true
                }
            }
            else{
                noResults = true
            }
        }
    }
    
    
    func cacheImages(){
        for movie in movieData{
            if theImageCache.count >= 20{
                break
            }
            if movie.poster_path != nil{
                let url = URL(string: "https://image.tmdb.org/t/p/w200" + movie.poster_path!)
//                print("image url: \(url)")
//                w### is what size dimensions you want the image returned to be
                let data = try? Data(contentsOf: url!)
                
                if (data == nil){
                    let image = UIImage(named: "no-image-found.png")
                    theImageCache.append(image!)
                }
                else{
                    let image = UIImage(data: data!)
                    theImageCache.append(image!)
                }
            }
            else{
                let image = UIImage(named: "no-image-found.png")
                theImageCache.append(image!)
            }
        }
        print("\(theImageCache)")
    }
    
    
    // Search
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchText = searchBar.text!
        print(searchText)
        searchBar.resignFirstResponder()
        
        movieData.removeAll()
        theImageCache.removeAll()
//        collectionView.reloadData()
        
        loadingCircle.isHidden = false
        loadingCircle.startAnimating()
        
        DispatchQueue.global().async {
            
            self.fetchDataForCollectionView(query: searchText)
            
            DispatchQueue.main.async {
                
                self.loadingCircle.stopAnimating()
                self.loadingCircle.isHidden = true
                self.collectionView.reloadData()
                if self.noResults == true{
                    let alert = UIAlertController(title: "No Result Found", message: "Unfortunately, there are no results for your search at this time. Please try another keyword.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    
                    self.noResults = !self.noResults
                }
            }
        }
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            self.searchBar.showsCancelButton = true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.showsCancelButton = false
            searchBar.text = ""
            searchBar.resignFirstResponder()
    }

}

