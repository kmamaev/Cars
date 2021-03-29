import UIKit

private struct Constants {
    static let cellReuseID = "reuseID"
    private init() {}
}

class ModelsViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    
    var viewModel: ModelsViewModel!
}

// MARK: - ViewController's lifecycle
extension ModelsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewModel()
        configureNavigationBar()
        configureTableView()
    }
}

// MARK: - Configuration
private extension ModelsViewController {
    func configureViewModel() {
        viewModel.addObserver(self)
    }
    
    func configureNavigationBar() {
        navigationItem.title = NSLocalizedString("Models.Title", comment: "")
    }
    
    func configureTableView() {
        tableView.register(UINib(nibName: "ModelCell", bundle: nil), forCellReuseIdentifier: Constants.cellReuseID)
    }
}

extension ModelsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = viewModel.models.count
        if !viewModel.allItemsLoaded {
            count += 1
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < viewModel.models.count else {
            viewModel.loadNextPage()
            return SpinnerCell()
        }
        
        let cell: ModelCell = tableView.dequeueReusableCell(withIdentifier: Constants.cellReuseID, for: indexPath) as! ModelCell
        
        let model = viewModel.models[indexPath.row]
        cell.configureWith(model)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        viewModel.selectModel(at: indexPath.row)
    }
}

extension ModelsViewController: ModelsViewModelObserver {
    func didUpdateModels() {
        tableView.reloadData()
    }
    
    func didFailToUpdateModels(withError error: Error) {
        let message = NSLocalizedString("Models.Loading Error", comment: "")
        let okTitle = NSLocalizedString("Action.OK", comment: "")
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okTitle, style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    func didSelectModel(with viewModel: CarSummaryViewModel) {
        let message = "\(viewModel.manufacturer), \(viewModel.model)"
        let okTitle = NSLocalizedString("Action.OK", comment: "")
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okTitle, style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}
