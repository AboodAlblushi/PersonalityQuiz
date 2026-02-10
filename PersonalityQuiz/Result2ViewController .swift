//
//  ResultViewController.swift
//  PersonalityQuiz
//
//  Created by Abdullah on 05/02/2026.
//

import UIKit

class Result2ViewController: UIViewController {
    
    @IBOutlet weak var resultAnswerLabel: UILabel!
    @IBOutlet weak var resultDefinitionLabel: UILabel!
    var responses : [Answer]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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

        switch mostCommonAnswer {
        case .lion:
            resultAnswerLabel.text = "☀️ Afternoon Person"
            resultDefinitionLabel.text = "You’re energetic, productive, and thrive during the busiest hours."
        case .cat:
            resultAnswerLabel.text = "🌙 Night Owl"
            resultDefinitionLabel.text = "You feel most alive late at night when things are quiet."
        case .rabbit:
            resultAnswerLabel.text = "🌇 Evening Person"
            resultDefinitionLabel.text = "You enjoy calm vibes and winding down as the day ends."
        case .turtle:
            resultAnswerLabel.text = "🌅 Morning Person"
            resultDefinitionLabel.text = "You feel fresh and focused early in the day."
        }
    }

    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
