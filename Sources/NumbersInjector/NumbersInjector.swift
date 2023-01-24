import Foundation
import Swinject

public final class NumbersInjector {

    public static let shared = NumbersInjector()
    private lazy var assembler = Assembler()
    private lazy var container = assembler.resolver as? Container
    private lazy var resolver = container?.synchronize()

    private init() {}

    public func apply(_ assemblies: [Assembly]) {
        assembler.apply(assemblies: assemblies)
    }

}

public extension NumbersInjector {
    func get<Service>(_ service: Service.Type) -> Service? {
        resolver?.resolve(service)
    }
}



