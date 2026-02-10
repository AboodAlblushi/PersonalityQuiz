//
//  ResultViewController.swift
//  PersonalityQuiz
//
//  Created by Abdullah on 05/02/2026.
//

import UIKit

class Result3ViewController: UIViewController {
    
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
            resultAnswerLabel.text = "🎉 Extrovert"
            resultDefinitionLabel.text = "You gain energy from being around others."
        case .cat:
            resultAnswerLabel.text = "🛋️ Introvert"
            resultDefinitionLabel.text = "You recharge best when spending time alone."
        case .rabbit:
            resultAnswerLabel.text = "🤝 Social Introvert"
            resultDefinitionLabel.text = "You enjoy people, but only in close, meaningful settings."
        case .turtle:
            resultAnswerLabel.text = "⚖️ Ambivert"
            resultDefinitionLabel.text = "You balance social time and alone time well."
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
