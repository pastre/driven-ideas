struct RandomNameGeneratorAction: Action {
    
    static var type: String { "generateNewName" }
    
    @Injected
    private var renameUseCase: RenameUseCase
    
    func perform(using component: Component) {
        guard let nameable = component as? Nameable else {
            return
        }
        let name = renameUseCase.execute()
        nameable.set(name: name)
    }
    
    let dummy: String?
    
    enum CodingKeys: String, CodingKey {
        case dummy
    }
}


