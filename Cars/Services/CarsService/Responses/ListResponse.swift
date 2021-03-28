struct ListResponse<ItemType> {
    let page: Int
    let pageSize: Int
    let totalPageCount: Int
    let items: [ItemType]
}
