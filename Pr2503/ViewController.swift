import UIKit

class ViewController: UIViewController {

    //MARK: - Outlet

    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var generatePasswordButton: UIButton!
    

    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.bruteForce(passwordToUnlock: "1!gr")
    }
    //MARK: - Action

    @IBAction func generatePasswordButtonPressed(_ sender: UIButton) {
    }
    

}


    //MARK: - Brute force Func
extension ViewController {

   private func bruteForce(passwordToUnlock: String) {
        let allowedCharacters:   [String] = String().printable.map { String($0) }

        var password: String = ""

        while password != passwordToUnlock {
            password = generateBruteForce(password, fromArray: allowedCharacters)
        }
    }

    private func indexOf(character: Character, _ array: [String]) -> Int {
        return array.firstIndex(of: String(character))!
    }

    private func characterAt(index: Int, _ array: [String]) -> Character {
        return index < array.count ? Character(array[index])
        : Character("")
    }

    private func generateBruteForce(_ string: String, fromArray array: [String]) -> String {
        var str: String = string

        if str.count <= 0 {
            str.append(characterAt(index: 0, array))
        }
        else {
            str.replace(at: str.count - 1,
                        with: characterAt(index: (indexOf(character: str.last!, array) + 1) % array.count, array))

            if indexOf(character: str.last!, array) == 0 {
                str = String(generateBruteForce(String(str.dropLast()), fromArray: array)) + String(str.last!)
            }
        }

        return str
    }

}
