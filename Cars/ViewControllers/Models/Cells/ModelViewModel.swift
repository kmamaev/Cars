struct ModelViewModel {
    let name: String
    let rowType: RowType
    
    let model: Model
    
    init(model: Model, index: Int) {
        self.name = model.name
        self.rowType = index % 2 == 1 ? .odd : .even
        
        self.model = model
    }
}
