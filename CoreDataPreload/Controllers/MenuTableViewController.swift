//
//  ViewController.swift
//  CoreDataPreload
//
//  Created by Adnann Muratovic on 14.09.21.
//

import UIKit
import CoreData

class MenuTableViewController: UITableViewController {
    
    private var menuItems: [MenuItem] = []
    var fetchResultController: NSFetchedResultsController<MenuItem>!

    // ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loadMenuItems()
        
        // Make cell self size
        tableView.estimatedRowHeight = 66.0
        tableView.rowHeight = UITableView.automaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Load MenuItems from Database
    
    private func loadMenuItems() {
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let request: NSFetchRequest<MenuItem> = MenuItem.fetchRequest()
            let context = appDelegate.persistentContainer.viewContext
            do {
                menuItems = try context.fetch(request)
            }
            catch {
                print("Failed to retrive records")
                print(error)
            }
        }
    }
}

extension MenuTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuTableViewCell
        
        // Configure cell
        cell.nameLabel.text = menuItems[indexPath.row].name
        cell.detailLabel.text = menuItems[indexPath.row].detail
        cell.priceLabel.text = "$\(menuItems[indexPath.row].price)"
        
        return cell
    }
}

