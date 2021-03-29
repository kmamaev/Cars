struct ManufacturerViewModel {
    let name: String
    let rowType: RowType
    
    let manufacturer: Manufacturer
    
    init(manufacturer: Manufacturer, index: Int) {
        self.name = manufacturer.name
        self.rowType = index % 2 == 1 ? .odd : .even
        
        self.manufacturer = manufacturer
    }
}
