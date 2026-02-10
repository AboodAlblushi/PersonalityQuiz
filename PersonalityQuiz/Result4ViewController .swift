//
//  ResultViewController.swift
//  PersonalityQuiz
//
//  Created by Abdullah on 05/02/2026.
//

import UIKit

class Result4ViewController: UIViewController {
    
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
            resultAnswerLabel.text = "🚀 Motivation: Achievement"
            resultDefinitionLabel.text = "You’re driven by success, goals, and progress."
        case .cat:
            resultAnswerLabel.text = "🕊️ Motivation: Freedom"
            resultDefinitionLabel.text = "You value independence and living on your own terms."
        case .rabbit:
            resultAnswerLabel.text = "❤️ Motivation: Connection"
            resultDefinitionLabel.text = "You’re motivated by relationships and emotional bonds."
        case .turtle:
            resultAnswerLabel.text = "🛡️ Motivation: Stability"
            resultDefinitionLabel.text = "You’re motivated by security, balance, and consistency."
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
