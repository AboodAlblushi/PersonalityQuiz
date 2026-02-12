import UIKit

class ResultViewController: UIViewController {
    
    @IBOutlet weak var resultAnswerLabel: UILabel!
    @IBOutlet weak var resultDefinitionLabel: UILabel!
    var responses: [Answer]!

    override func viewDidLoad() {
        super.viewDidLoad()
        calculatePersonalityResult()
        navigationItem.hidesBackButton = true
    }
    
    func calculatePersonalityResult() {
        var frequencyOfAnswers: [AnimalType: Int] = [:]
        let responseTypes = responses.map { $0.type }
        
        for response in responseTypes {
            frequencyOfAnswers[response] = (frequencyOfAnswers[response] ?? 0) + 1
        }
        
        let mostCommonAnswer = frequencyOfAnswers.sorted {
            $0.value > $1.value
        }.first!.key
        
        resultAnswerLabel.text = "You are a \(mostCommonAnswer.rawValue)!"
        resultDefinitionLabel.text = mostCommonAnswer.definition
        
        let quizResult = QuizResult(
            title: "Which animal are you quiz",
            result: resultAnswerLabel.text ?? "",
            date: Date()
        )

        QuizHistoryManager.shared.saveResult(quizResult)

    }
    
    // ✅ Done button → go back to homepage root
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        if let nav = navigationController {
            nav.popToRootViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
}
