import UIKit

class Result4ViewController: UIViewController {
    
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

        for answer in responses {
            frequencyOfAnswers[answer.type, default: 0] += 1
        }

        let mostCommonAnswer = frequencyOfAnswers.sorted {
            $0.value > $1.value
        }.first!.key

        // 🧠 Introvert / Extrovert result mapping
        switch mostCommonAnswer {
        case .lion:
            resultAnswerLabel.text = "🎉 Extrovert"
            resultDefinitionLabel.text = "You gain energy from being around others and enjoy lively social environments."

        case .cat:
            resultAnswerLabel.text = "🛋️ Introvert"
            resultDefinitionLabel.text = "You recharge best when spending time alone and enjoy calm, quiet spaces."

        case .rabbit:
            resultAnswerLabel.text = "🤝 Social Introvert"
            resultDefinitionLabel.text = "You enjoy socializing, but mostly with close friends in comfortable settings."

        case .turtle:
            resultAnswerLabel.text = "⚖️ Ambivert"
            resultDefinitionLabel.text = "You balance social time and alone time well depending on your mood."
        }
        
        let quizResult = QuizResult(
            title: "Introvert vs Extrovert Quiz",
            result: resultAnswerLabel.text ?? "",
            date: Date()
        )

        QuizHistoryManager.shared.saveResult(quizResult)

    }

    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        if let nav = navigationController {
            nav.popToRootViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
}
