struct GetModelsResponse: Decodable {
    let page: Int
    let pageSize: Int
    let totalPageCount: Int
    let wkda: [String: String]
}
