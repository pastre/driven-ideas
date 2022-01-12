import CoreBFF

extension ComponentRepository {
    static let `default`: ComponentRepository = {
        var repository = ComponentRepository()
        repository.register(TextModel.self)
        repository.register(ButtonModel.self)
        repository.register(RandomNameGeneratorModel.self)
        repository.register(BannerCarouselModel.self)
        repository.register(BannerModel.self)
        return repository
    }()
}

extension ActionRepository {
    static let `default`: ActionRepository = {
        var repository = ActionRepository()
        repository.append(ButtonAction.self)
        repository.append(RandomNameGeneratorAction.self)
        repository.append(OpenURLAction.self)
        return repository
    }()
}

extension UseCaseRepository {
    static let `default`: UseCaseRepository = {
        let repository = UseCaseRepository()
        
        repository.register(for: PrintUseCase.self) {
            PrintUseCase()
        }
        
        repository.register(for: RenameUseCase.self) {
            RenameUseCase()
        }
        
        repository.register(for: OpenURLUseCase.self) {
            OpenURLUseCase()
        }
        
        return repository
    }()
}
