//
//  DetailedViewController.swift
//  HannahChen-Lab4-2
//
//  Created by Hannah Chen on 10/14/22.
//

//Reference for creating button programmatically: https://stackoverflow.com/questions/24030348/how-to-create-a-button-programmatically
//Reference for UserDefaults: https://cocoacasts.com/ud-3-how-to-store-an-array-in-user-defaults-in-swift


import UIKit

class DetailedViewController: UIViewController {

    var image:UIImage!
    var movieTitle:String!
    var releaseDate: String!
    var voteCount: Int!
    var voteAvg: Double!
    var id: Int!
    
    let userDefaults = UserDefaults.standard
    
    var currPos:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        navigationItem.title = movieTitle
        
        currPos += 120
        view.backgroundColor = UIColor.white
        let imageFrame = CGRect(x: view.frame.midX - image.size.width/2, y: currPos, width: image.size.width, height: image.size.height)

        let imageView = UIImageView(frame: imageFrame)
        imageView.image = image
        view.addSubview(imageView)
        
        currPos += image.size.height
//        let titleTextFrame = CGRect(x: 0, y: currPos + 20, width: view.frame.width, height: 30)
//        let titleTextView = UILabel(frame: titleTextFrame)
//        titleTextView.text = movieTitle
//        titleTextView.textAlignment = .center
//        view.addSubview(titleTextView)
        
        currPos += 20
        
        let dateTextFrame = CGRect(x: 0, y: currPos, width: view.frame.width, height: 30)
        let dateTextView = UILabel(frame: dateTextFrame)
        dateTextView.text = "Release Date: " + releaseDate
        dateTextView.textAlignment = .center
        view.addSubview(dateTextView)
        
        currPos += 30
        let countTextFrame = CGRect(x: 0, y: currPos, width: view.frame.width, height: 30)
        let countTextView = UILabel(frame: countTextFrame)
        countTextView.text = "Vote Count: " + String(voteCount)
        countTextView.textAlignment = .center
        view.addSubview(countTextView)
        
        currPos += 30
        let avgTextFrame = CGRect(x: 0, y: currPos, width: view.frame.width, height: 30)
        let avgTextView = UILabel(frame: avgTextFrame)
        avgTextView.text = "Vote Average: " + String(voteAvg)
        avgTextView.textAlignment = .center
        view.addSubview(avgTextView)
        
        currPos += 40
        let button = UIButton(type: UIButton.ButtonType.system) as UIButton
        let buttonFrame = CGRect(x: view.frame.midX - view.frame.width/4, y: currPos, width: view.frame.width/2, height: 30)
        button.frame = buttonFrame
        button.setTitle("Add to Favorites", for: .normal)
//        button.setTitleColor(UIColor.white, for: .normal)
//        button.backgroundColor = UIColor.blue
//        button.layer.cornerRadius = 20
//        button.clipsToBounds = true
        button.addTarget(self, action: #selector(addToFavorites), for: UIControl.Event.touchUpInside)
        view.addSubview(button)
        
    }
    
    @objc func addToFavorites(sender: UIButton!){
        print("add favorite clicked")
        
        var favoriteArray: [String] = userDefaults.stringArray(forKey: "favoriteMovies") ?? []

        if (favoriteArray.contains(movieTitle)) {
            //send an alert say already exists
            let alert = UIAlertController(title: "Movie Already Favorited", message: "This movie is already in your favorites list.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        else{
            //add to favorites in UserDefaults
            favoriteArray.append(movieTitle)
            UserDefaults.standard.set(favoriteArray, forKey: "favoriteMovies")
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
