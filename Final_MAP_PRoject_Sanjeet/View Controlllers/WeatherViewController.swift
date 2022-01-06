//
//  WeatherViewController.swift
//  Final_MAP_PRoject_Sanjeet
//
//  Created by user205584 on 12/4/21.
//

import UIKit
import CoreData

class WeatherViewController: UITableViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var shouldPerformSegue = true
    var searchController:UISearchController = UISearchController()
    var finishedfetchedCounter = 0
    lazy var fetchResultController:NSFetchedResultsController<City> = {
        let fetch = City.fetchRequest()
        
        navigationItem.searchController = searchController
        fetch.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let fetchResultController:NSFetchedResultsController<City> = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext:CoreDataStack.shared.persistentContainer.viewContext , sectionNameKeyPath: nil, cacheName: nil)
        return fetchResultController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        try? fetchResultController.performFetch()
        fetchResultController.delegate = self
        searchController.searchResultsUpdater = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    //MArk:- Segue function
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "TableCellToACVC" || segue.identifier == "AddCityToACVC"){
            let NavigationController = segue.destination as? UINavigationController
            let AddcityViewController = NavigationController?.viewControllers[0] as? AddCityViewController
            
            if let Vc = AddcityViewController{
                Vc.fetchResultsViewsOnMainScreenDelegate = self
            if let selectedPath = tableView.indexPathForSelectedRow
            {
                    
                    if(segue.identifier == "TableCellToACVC"){
                        Vc.title = fetchResultController.object(at: selectedPath).name
                        Vc.shoudOnlyShowTodos = true
                }
            }
            }
            else{
                shouldPerformSegue = false
            }
            
        }
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if(identifier == "TableCellToACVC")
        {
            return shouldPerformSegue
        }
        return true
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if let value = fetchResultController.sections?[section].numberOfObjects{
            return value
        }
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        activityIndicator.startAnimating()
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustonTableViewCell
        cell.city = fetchResultController.object(at: indexPath).name
        cell.activityIndicator = activityIndicator
        // Configure the cell...
        return cell
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete){
            ModelController.shared.delete(city: fetchResultController.object(at: indexPath))
        }
    }
}

extension WeatherViewController: NSFetchedResultsControllerDelegate {
    // These methods are called by the iOS runtime, in response to user interaction and/or changes in the data source
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    // Updates wrapper end
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    // Section update(s)
    func controller(_
        controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .automatic)
        case .delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .automatic)
        default: break
        }
    }
    
    // Row update(s)
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let index = newIndexPath {
                tableView.insertRows(at: [index], with: .automatic)
            }
        case .delete:
            if let index = indexPath {
                tableView.deleteRows(at: [index], with: .automatic)
            }
        case .update:
            if let index = indexPath {
                tableView.reloadRows(at: [index], with: .automatic)
            }
        case .move:
            if let deleteIndex = indexPath, let insertIndex = newIndexPath {
                tableView.deleteRows(at: [deleteIndex], with: .automatic)
                tableView.insertRows(at: [insertIndex], with: .automatic)
            }
        
        default:
            print("Row update error")
        }
    }
}

extension WeatherViewController:UISearchResultsUpdating
{
    func updateSearchResults(for searchController: UISearchController) {
        if let searchedtxt = searchController.searchBar.text{
            if(searchedtxt != ""){
                fetchResultController.fetchRequest.predicate = NSPredicate(format: "name MATCHES %@", searchedtxt+".*$")
            }
            else{
                fetchResultController.fetchRequest.predicate = nil
            }
            try? fetchResultController.performFetch()
            tableView.reloadData()
        }
    }
}

extension WeatherViewController:performFetchDelegate{
    func performFetchAgain(){
        try? fetchResultController.performFetch()
        tableView.reloadData()
    }
}
