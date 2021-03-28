protocol ManufacturersViewModelObserver {
    func didUpdateManufacturers()
    func didFailToUpdateManufacturers(withError error: Error)
}

class ManufacturersViewModel: Observable {
    typealias Observer = ManufacturersViewModelObserver
    
    private let carsService: CarsService
    private(set) var manufacturers: [ManufacturerViewModel] = []
    private(set) var allItemsLoaded = false
    private var currentPage = 0
    private var loadManufacturersTask: ServiceTask? = nil
    
    init(carsService: CarsService) {
        self.carsService = carsService
    }
    
    func loadNextPage() {
        let manufacturersAreBeingLoaded = loadManufacturersTask != nil
        guard !manufacturersAreBeingLoaded else { return }
        
        guard !allItemsLoaded else { return }
        
        let pageSize = 15
        let currentManufactureres = manufacturers
                
        loadManufacturersTask = carsService.getManufacturers(page: currentPage, pageSize: pageSize) { [weak self] result in
                self?.loadManufacturersTask = nil
                switch result {
                    case .success(let listResponse):
                        self?.manufacturers = currentManufactureres + listResponse.items.enumerated().map({ (index, manufacturer) in
                                let actualIndex = currentManufactureres.count + index + 1
                                let rowType: RowType = actualIndex % 2 == 1 ? .odd : .even
                                return ManufacturerViewModel(name: manufacturer.name, rowType: rowType)
                            })
                        self?.allItemsLoaded = listResponse.items.count < pageSize || self?.currentPage == (listResponse.totalPageCount - 1)
                        self?.currentPage += 1
                        self?.notifyObservers({ $0.didUpdateManufacturers() })
                    case .failure(let error):
                        self?.notifyObservers({ $0.didFailToUpdateManufacturers(withError: error) })
                }
            }
        print("Loading page \(currentPage)...")
    }
}
