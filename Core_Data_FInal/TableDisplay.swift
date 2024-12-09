import UIKit
import CoreData

class TableDisplay : UITableViewController, UISearchBarDelegate, ViewControllerDelegate
{
    let manageObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var items : [Item] = []
    
    var searching : Bool = false
    
    var textToBeSearched = ""
    
    var fabButton = UIButton()
    
    let customCell = CustomCell()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        
        fetchitem()
    }
    
    func dataUpdated(itemsent : Item) {
        if let index = items.firstIndex(where: { $0.sku == itemsent.sku }) {
            items[index] = itemsent
            fetchitem()
        }
    }
        
    func fetchitem()
    {
        items = try! manageObjectContext.fetch(Item.fetchRequest())
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchitem()
    }

    func setUpUI()
    {
        tableView.register(CustomCell.self, forCellReuseIdentifier: "cellId")
        tableView.estimatedRowHeight = 100
        tableView.backgroundColor = .systemBackground
        
        fabButton.translatesAutoresizingMaskIntoConstraints = false
        fabButton.tintColor = .white
        fabButton.backgroundColor = .systemBlue
        fabButton.layer.masksToBounds = false
        fabButton.layer.cornerRadius = 25
        fabButton.layer.shouldRasterize = false
        fabButton.setImage(UIImage(systemName: "plus"), for: .normal)
        fabButton.addTarget(self, action: #selector(fabButtonPressed), for: .touchUpInside)
        view.addSubview(fabButton)
        
        NSLayoutConstraint.activate([
            fabButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            fabButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            fabButton.widthAnchor.constraint(equalToConstant: 50),
            fabButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func searchItems() -> [Item]
    {
        if !searching {
                return items
        }
        let request = Item.fetchRequest() as NSFetchRequest<Item>
        let predicate = NSPredicate(format: "name CONTAINS[cd] %@ OR sku CONTAINS[cd] %@", textToBeSearched, textToBeSearched)
        request.predicate = predicate
        items = try! manageObjectContext.fetch(request)
        return items
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        textToBeSearched = searchText.lowercased()
        
        searching = !searchText.isEmpty
        if !searching {
            fetchitem()
        }
        tableView.reloadData()
    }
    
    @objc func fabButtonPressed()
    {
        let viewController = ViewController()
        viewController.delegate = self
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return searching ? searchItems().count : items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as? CustomCell else {
                fatalError("Unable to dequeue CustomTableViewCell")
        }
        
        let item = searching ? searchItems()[indexPath.row] : items[indexPath.row]
        
        cell.configure(item: item)
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let action = UIContextualAction(
            style: .normal, title: "Edit") { [self]
                (action, view, completionhandler) in
                
                let itemToEdit = self.items[indexPath.row]
                
                let viewController = ViewController()
                viewController.itemToEdit = itemToEdit
                viewController.nameField.text = itemToEdit.name
                viewController.descField.text = itemToEdit.desc
                viewController.rateField.text = String(itemToEdit.rate)
                viewController.skuField.text = String(itemToEdit.sku)
                
                if let imagePath = itemToEdit.image
                {
                    let fileURL = URL(fileURLWithPath: imagePath)
                    if let imageData = try? Data(contentsOf: fileURL)
                    {
                        viewController.imageField.image = UIImage(data: imageData)
                    }
                    else
                    {
                        viewController.imageField.image = UIImage(systemName: "photo")
                    }
                }
                
                viewController.delegate = self
                viewController.modalPresentationStyle = .fullScreen
                present(viewController, animated: true, completion: nil)
        }
        
        action.backgroundColor = .systemGreen
        
        let swipeAction = UISwipeActionsConfiguration(actions: [action])
        
        return swipeAction
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(
            style: .destructive, title: "Delete") {
                (action, view, completionhandler) in
                
                let itemToRemove = self.items[indexPath.row]
                self.manageObjectContext.delete(itemToRemove)
                try! self.manageObjectContext.save()
                self.fetchitem()
        }
        
        let swipeAction = UISwipeActionsConfiguration(actions: [action])
        
        return swipeAction
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerLabel = UILabel()
        headerLabel.text = "ITEMS"
        headerLabel.textAlignment = .center
        headerLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        
        let headerSearchBar = UISearchBar()
        headerSearchBar.searchBarStyle = .minimal
        headerSearchBar.delegate = self
        headerSearchBar.placeholder = "Search for the item"
        headerSearchBar.sizeToFit()
        headerSearchBar.isTranslucent = true
        
        let stackForHeader = UIStackView(arrangedSubviews: [headerLabel, headerSearchBar])
        stackForHeader.axis = .vertical
        stackForHeader.spacing = 10
        stackForHeader.alignment = .fill
        stackForHeader.distribution = .fillProportionally
        stackForHeader.translatesAutoresizingMaskIntoConstraints = false
        
        let headerView = UIView()
        headerView.backgroundColor = .systemBackground
        headerView.addSubview(stackForHeader)
        
        NSLayoutConstraint.activate([
            stackForHeader.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            stackForHeader.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            stackForHeader.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 10),
            stackForHeader.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -10)
        ])
        
        return headerView
    }
}

