import Foundation

class CarsService {
    private let apiService: APIService
    
    init(apiService: APIService) {
        self.apiService = apiService
    }
}

// MARK: - Requests
extension CarsService {
    @discardableResult
    func getManufacturers(page: Int, pageSize: Int, completion: @escaping (Result<ListResponse<Manufacturer>, Error>) -> ()) -> ServiceTask? {
        let parameters = [
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "pageSize", value: String(pageSize)),
            ]
        let context = RequestContext(apiMethod: "/v1/car-types/manufacturer", parameters: parameters)
        return apiService.runTask(context: context, completion: { (result: Result<GetManufacturersResponse, Error>) in
                switch result {
                case .success(let response):
                    let manufacturers = response.wkda.map({ Manufacturer(id: $0.0, name: $0.1) }).sorted(by: { $0.name < $1.name }) // The server should send to us an already sorted array instead of a dictionary. Otherwise we have to predict how the objects are supposed to be sorted which can lead to a potential bug.
                    let listResponse = ListResponse(page: response.page, pageSize: response.pageSize, totalPageCount: response.totalPageCount, items: manufacturers)
                    completion(.success(listResponse))
                case .failure(let error):
                    completion(.failure(error))
                }
            })?.asServiceTask()
    }
}
