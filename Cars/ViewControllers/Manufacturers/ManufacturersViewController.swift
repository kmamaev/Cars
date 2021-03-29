import UIKit

private struct Constants {
    static let cellReuseID = "reuseID"
    private init() {}
}

class ManufacturersViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    
    var viewModel: ManufacturersViewModel!
}

// MARK: ViewController's lifecycle
extension ManufacturersViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewModel()
        configureNavigationBar()
        configureTableView()
    }
}

// MARK: Configuration
private extension ManufacturersViewController {
    func configureViewModel() {
        viewModel.addObserver(self)
    }
    
    func configureNavigationBar() {
        navigationItem.title = NSLocalizedString("Manufacturers.Title", comment: "")
    }
    
    func configureTableView() {
        tableView.register(UINib(nibName: "ManufacturerCell", bundle: nil), forCellReuseIdentifier: Constants.cellReuseID)
    }
}

extension ManufacturersViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = viewModel.manufacturers.count
        if !viewModel.allItemsLoaded {
            count += 1
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < viewModel.manufacturers.count else {
            viewModel.loadNextPage()
            return SpinnerCell()
        }
        
        let cell: ManufacturerCell = tableView.dequeueReusableCell(withIdentifier: Constants.cellReuseID, for: indexPath) as! ManufacturerCell
        
        let manufacturer = viewModel.manufacturers[indexPath.row]
        cell.configureWith(manufacturer)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        viewModel.selectManufacturer(at: indexPath.row)
    }
}

extension ManufacturersViewController: ManufacturersViewModelObserver {
    func didUpdateManufacturers() {
        tableView.reloadData()
    }
    
    func didFailToUpdateManufacturers(withError error: Error) {
        let message = NSLocalizedString("Manufacturers.Loading Error", comment: "")
        let okTitle = NSLocalizedString("Action.OK", comment: "")
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okTitle, style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    func didSelectManufacturer(with viewModel: ModelsViewModel) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let modelsViewController = storyboard.instantiateViewController(identifier: "ModelsViewController") as ModelsViewController
        modelsViewController.viewModel = viewModel
        navigationController?.pushViewController(modelsViewController, animated: true)
    }
}
