struct ButtonAction: Action {
    
    let stringToPrint: String
    
    @Injected
    private var printUseCase: PrintUseCase
    
    func perform(using component: Component) {
        printUseCase.execute()
        print(stringToPrint)
    }
    
    static var type: String { "buttonAction" }
}

