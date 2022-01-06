protocol CodedViewLifecycle {
    func addSubviews()
    func constraintSubviews()
    func configureAdditionalSettings()
    
}

protocol ComponentRendering: CodedViewLifecycle {
    func renderModel()
}
