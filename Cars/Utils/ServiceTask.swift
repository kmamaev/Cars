import Foundation

class ServiceTask {
    private let urlSessionTask: URLSessionDataTask
    
    init(urlSessionTask: URLSessionDataTask) {
        self.urlSessionTask = urlSessionTask
    }
    
    func cancel() {
        urlSessionTask.cancel()
    }
}

extension URLSessionDataTask {
    func asServiceTask() -> ServiceTask {
        return ServiceTask(urlSessionTask: self)
    }
}
