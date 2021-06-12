
@_exported import SwiftComponents


public struct DeerModule {
    public static let router = Router()
    
    public static func registerModule() {
        router.register("myapp://user/<path1>/<path2>") { (url, val, context) -> UIViewController? in
            let r = url.urlValue?.lastPathComponent
            return nil
        }
       
    }
}

//MARK: - <#text#>

//TODO: -做 submode

//FIXME: -fix

#warning("警告")

enum R: String {
    case touxiang, right014
    
}
extension R {
    var image: UIImage? { UIImage(named: rawValue) }
}
