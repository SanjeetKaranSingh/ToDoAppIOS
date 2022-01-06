//
//  AddCityViewController.swift
//  Final_MAP_PRoject_Sanjeet
//
//  Created by user205584 on 11/29/21.
//

import UIKit

class AddCityViewController: UIViewController
{
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var toDoAddView: UIView!
    @IBOutlet weak var toDoTextBox: UITextField!
    var fetchResultsViewsOnMainScreenDelegate:performFetchDelegate?
    var shoudOnlyShowTodos:Bool?
    lazy var resultSet:[ToDo] = [ToDo](){
        didSet{
         //   tableView.reloadData()
        }
    }
    var cityModel:City?
    
    lazy var SearchedResultVC = storyboard?.instantiateViewController(withIdentifier: "searchedVC") as! SearchResultTBC
    lazy var searchController = UISearchController(searchResultsController: SearchedResultVC)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let shoudOnlyShowTodos = shoudOnlyShowTodos {
            if shoudOnlyShowTodos{
                showTodo()
            }
        }
        else{
            toDoAddView.isHidden = true
            SearchedResultVC.searchDelegate = self
            navigationItem.searchController = searchController
            searchController.searchResultsUpdater = self
        }
        // Do any additional setup after loading the view.
    }
    
    // MARK: - necessary functions
    func refreshResultSet(){
        // to refresh result set based on title
        guard let Title = title else{return}
        if let todoArray = ModelController.shared.getAllToDOs(ForCity: Title){
            resultSet = todoArray
        }
    }
    
    // MARK: - Actions

    @IBAction func cancelButtonClick(_ sender: Any) {
        
        CoreDataStack.shared.persistentContainer.viewContext.reset()
        //CoreDataStack.shared.persistentContainer.viewContext.refreshAllObjects()
    //    CoreDataStack.shared.saveContext()
        if let fetchResultsViewsOnMainScreen = fetchResultsViewsOnMainScreenDelegate{
            fetchResultsViewsOnMainScreen.performFetchAgain()
        }
        self.dismiss(animated: true, completion: nil)
     //   CoreDataStack.shared.persistentContainer
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        CoreDataStack.shared.saveContext()
    }
   override func viewWillDisappear(_ animated: Bool) {
       
       
    }
    @IBAction func saveButtonClick(_ sender: Any) {
        CoreDataStack.shared.saveContext()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addTodo() {
        if let todoTxt = toDoTextBox?.text, let city = title{
            if(!todoTxt.isEmpty){
            let todo = ToDo(context: CoreDataStack.shared.persistentContainer.viewContext)
            todo.item = todoTxt
            ModelController.shared.add(Todo: todo, withCity: city)
            resultSet.append(todo)
            tableView.insertRows(at: [IndexPath(row: resultSet.count - 1, section: 0)], with: .automatic)
                toDoTextBox.text = ""
            }
        }
    }
    
    func showTodo(){
        if let Title = title{
        ModelController.shared.PerformActionsOnselectedACity(City: Title)
        refreshResultSet()
        toDoAddView.isHidden = false
        tableView.reloadData()
            
        }
    }
}

extension AddCityViewController:UISearchResultsUpdating
{
    func updateSearchResults(for searchController: UISearchController) {
        toDoTextBox.text = ""
        DispatchQueue.main.asyncAfter(wallDeadline: DispatchWallTime.now() + 0.45) {
            if let searchControllerText = searchController.searchBar.text, let targitSearchTBC = searchController.searchResultsController as? SearchResultTBC
            {
                targitSearchTBC.showCities(withThisKeyordInName: searchControllerText)
                print(searchControllerText)
            }
            
        }
    }
}

extension AddCityViewController:selectedSearchResultDelegate
{
    func performOperation(OnSelectedCity city: String)
    {
        searchController.isActive = false
        title = city
        cityModel = ModelController.shared.add(cityWithname: city)
        showTodo()
    }
}

extension AddCityViewController:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultSet.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = resultSet[indexPath.row].item
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete){
            ModelController.shared.delete(Todo: resultSet[indexPath.row])
            refreshResultSet()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
