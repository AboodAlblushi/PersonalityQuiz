import UIKit

class HomepageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // 🔁 Unwind from Result → Homepage (root)
    @IBAction func unwindToHomepage(_ segue: UIStoryboardSegue) {
        // Ensure we always land on the homepage root
        navigationController?.popToRootViewController(animated: false)
    }
}
