public protocol CodedViewLifecycle {
    func addSubviews()
    func constraintSubviews()
    func configureAdditionalSettings()
}

public protocol ComponentRendering: CodedViewLifecycle {
    func renderModel()
}
