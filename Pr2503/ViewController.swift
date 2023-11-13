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

        activityIndicator.isHidden = true
        generatePasswordButton.layer.cornerRadius = 8
    }

    //MARK: - Action

    @IBAction func generatePasswordButtonPressed(_ sender: UIButton) {

        let currentPassword = generatePassword(countCharacters: 3)

        activityIndicator.isHidden = false
        textField.isSecureTextEntry = true
        textField.text = "\(currentPassword)"
        passwordLabel.text = "Подбираем пароль..."
        activityIndicator.startAnimating()

        DispatchQueue.global().async {
            self.bruteForce(passwordToUnlock: currentPassword)
        }
    }
    
    //MARK: - generate password func

    private func generatePassword (countCharacters: Int) -> String {
        let allowedCharacters = String().printable
        let allowedCharactersCount = UInt32(String().printable.count)
        var password = ""

        for _ in 0 ..< countCharacters {
            let randomNum = Int(arc4random_uniform(allowedCharactersCount))
            let randomIndex = allowedCharacters.index(allowedCharacters.startIndex, offsetBy: randomNum)
            let randomCharacters = allowedCharacters[randomIndex]
            password += String(randomCharacters)
        }
        return password
    }
}


    //MARK: - Brute force Func
extension ViewController {

   private func bruteForce(passwordToUnlock: String) {
        let allowedCharacters:   [String] = String().printable.map { String($0) }

        var password: String = ""

        while password != passwordToUnlock {
            password = generateBruteForce(password, fromArray: allowedCharacters)
            print(password)
        }

       DispatchQueue.main.async {
           self.activityIndicator.stopAnimating()
           self.activityIndicator.isHidden = true
           self.passwordLabel.text = password
           self.textField.isSecureTextEntry = false
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
