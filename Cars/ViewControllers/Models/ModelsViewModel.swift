protocol ModelsViewModelObserver {
    func didUpdateModels()
    func didFailToUpdateModels(withError error: Error)
}

class ModelsViewModel: Observable {
    typealias Observer = ModelsViewModelObserver
    
    private let carsService: CarsService
    private let manufacturer: Manufacturer
    var models: [ModelViewModel] = []
    private(set) var allItemsLoaded = false
    private var currentPage = 0
    private var loadModelsTask: ServiceTask? = nil
    
    init(carsService: CarsService, manufacturer: Manufacturer) {
        self.carsService = carsService
        self.manufacturer = manufacturer
    }
    
    func loadNextPage() {
        let modelsAreBeingLoaded = loadModelsTask != nil
        guard !modelsAreBeingLoaded else { return }
        
        guard !allItemsLoaded else { return }
        
        let pageSize = 15
        let currentModels = models
                
        loadModelsTask = carsService.getModels(manufacturer: manufacturer, page: currentPage, pageSize: pageSize) { [weak self] result in
                self?.loadModelsTask = nil
                switch result {
                    case .success(let listResponse):
                        self?.models = currentModels + listResponse.items.enumerated().map({ (index, model) in
                                let actualIndex = currentModels.count + index + 1
                                let rowType: RowType = actualIndex % 2 == 1 ? .odd : .even
                                return ModelViewModel(name: model.name, rowType: rowType)
                            })
                        self?.allItemsLoaded = listResponse.items.count < pageSize || self?.currentPage == (listResponse.totalPageCount - 1)
                        self?.currentPage += 1
                        self?.notifyObservers({ $0.didUpdateModels() })
                    case .failure(let error):
                        self?.notifyObservers({ $0.didFailToUpdateModels(withError: error) })
                }
            }
        print("Loading page \(currentPage)...")
    }
}
