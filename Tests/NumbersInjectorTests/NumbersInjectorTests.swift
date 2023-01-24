import Swinject
import XCTest
@testable import NumbersInjector

final class NumbersInjectorTests: XCTestCase {

    private var sut: NumbersInjector { .shared }

    override  func setUp() {
        super.setUp()
        sut.apply([MockAssembly()])
    }

    func testExample() throws {
        XCTAssertNotNil(sut.get(MockUseCaseType.self))
        XCTAssertNotNil(sut.get(MockrepositoryType.self))
    }
}


private final class MockAssembly: Assembly {

    init() {}

    func assemble(container: Container) {
        container.registerUseCase()
        container.registerRepository()
    }


}

private extension Container {

    func registerUseCase() {
        register(MockUseCaseType.self) { resolver in
            MockUseCase(
                mockrepository: Mockrepository(
                    resolver.resolve(
                        LocalDSType.self)
                )
            )
        }.inObjectScope(.container)
    }

    func registerRepository() {
        register(MockrepositoryType.self) { resolver in
            Mockrepository(
                resolver.resolve(LocalDSType.self)
            )
        }.inObjectScope(.container)
    }
}

protocol MockUseCaseType {
    var name: String { get }
}

private class MockUseCase: MockUseCaseType {
    var name = ""
    var id = UUID()
    var mockrepository: MockrepositoryType

    init(mockrepository: MockrepositoryType) {
        self.mockrepository = mockrepository
    }
}

protocol MockrepositoryType {}
private class Mockrepository: MockrepositoryType {

    var localDS: LocalDSType?

    init(_ localDS: LocalDSType?) {
        self.localDS = localDS
    }

}

protocol LocalDSType {

}

private class LocalDS: LocalDSType {
    var localDS: UserDefaults?
    init(_ localDS: UserDefaults = UserDefaults.standard) {
        self.localDS = localDS
    }
}
