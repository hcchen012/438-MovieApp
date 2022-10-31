//
//  FavoritesViewController.swift
//  HannahChen-Lab4-2
//
//  Created by Hannah Chen on 10/20/22.
//

//Reference for deleting TableViewCell: https://www.hackingwithswift.com/example-code/uikit/how-to-swipe-to-delete-uitableviewcells
//Reference for dragging to rearrange cells: https://www.youtube.com/watch?v=iym7P9jQmpU


import UIKit

class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var favoriteMovies: [String] = []
    let userDefaults = UserDefaults.standard
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var clearButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationItem.title = "Favorite Movies"
        setupTableView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTableView()
    }
    
    //Required functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel!.text = favoriteMovies[indexPath.row]
        return cell
    }
    
    //Delete cell
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            favoriteMovies.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            userDefaults.set(favoriteMovies, forKey: "favoriteMovies")
        }
//        else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//        }
    }
    
    
//    // Drag Delegate
//    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
//        let dragItem = UIDragItem(itemProvider: NSItemProvider())
//        dragItem.localObject = tableView[indexPath.row]
//        return [ dragItem ]
//    }
//
    
    // Move cells
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // Update the model
        let selectedItem = favoriteMovies[sourceIndexPath.row]
        favoriteMovies.remove(at: sourceIndexPath.row)
        favoriteMovies.insert(selectedItem, at: destinationIndexPath.row)
    }

    
    @IBAction func edit(_ sender: Any) {
        tableView.isEditing = !tableView.isEditing
        
        switch tableView.isEditing{
        case true:
            editButton.title = "Done"
        case false:
            editButton.title = "Edit"
            userDefaults.set(favoriteMovies, forKey: "favoriteMovies")
        }
    }
    
    @IBAction func clearAll(_ sender: Any) {
        favoriteMovies.removeAll()
        userDefaults.set(favoriteMovies, forKey: "favoriteMovies")
        tableView.reloadData()
    }
    
    
    
    //Fetch data for table view from UserDefaults
    func setupTableView(){
        tableView.dataSource = self
        tableView.delegate = self
//        tableView.isEditing = false
//        tableView.dragInteractionEnabled = true
        
        favoriteMovies = userDefaults.stringArray(forKey: "favoriteMovies") ?? []
        self.tableView.reloadData()
        
//        DispatchQueue.global().async {
//
//            self.fetchDataForCollectionView(query: searchText)
//
//            DispatchQueue.main.async {
//
////                self.theSpinner.stopAnimating()
////                self.theSpinner.isHidden = true
//                self.collectionView.reloadData()
//            }
//        }
        
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
