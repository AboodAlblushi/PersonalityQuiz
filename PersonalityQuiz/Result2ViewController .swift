import UIKit

class Result2ViewController: UIViewController {
    
    @IBOutlet weak var resultAnswerLabel: UILabel!
    @IBOutlet weak var resultDefinitionLabel: UILabel!
    
    var responses: [Answer]!

    override func viewDidLoad() {
        super.viewDidLoad()
        calculatePersonalityResult()
        navigationItem.hidesBackButton = true
    }
    
    // MARK: - Personality Logic
    func calculatePersonalityResult() {
        var frequencyOfAnswers: [AnimalType: Int] = [:]
        let responseTypes = responses.map { $0.type }
        
        for response in responseTypes {
            frequencyOfAnswers[response] = (frequencyOfAnswers[response] ?? 0) + 1
        }
        
        let mostCommonAnswer = frequencyOfAnswers.sorted { $0.value > $1.value }.first!.key
        
        switch mostCommonAnswer {
        case .lion:
            resultAnswerLabel.text = "☀️ Afternoon Person"
            resultDefinitionLabel.text = "You're energetic, productive, and thrive during the busiest hours."
        case .cat:
            resultAnswerLabel.text = "🌙 Night Owl"
            resultDefinitionLabel.text = "You feel most alive late at night when things are quiet."
        case .rabbit:
            resultAnswerLabel.text = "🌆 Evening Person"
            resultDefinitionLabel.text = "You enjoy calm vibes and winding down as the day ends."
        case .turtle:
            resultAnswerLabel.text = "🌅 Morning Person"
            resultDefinitionLabel.text = "You feel fresh and focused early in the day."
        }
        
        let quizResult = QuizResult(
            title: "Best Time of Day Quiz",
            result: resultAnswerLabel.text ?? "",
            date: Date()
        )

        QuizHistoryManager.shared.saveResult(quizResult)

        
    }
    
    // MARK: - Done Button (GO BACK TO HOMEPAGE)
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: true)
    }
}
