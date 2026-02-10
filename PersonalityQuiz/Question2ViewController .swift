//
//  QuestionViewController.swift
//  PersonalityQuiz
//
//  Created by Abdullah on 05/02/2026.
//

import UIKit

class Question2ViewController: UIViewController {

    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var singleStackView: UIStackView!
    @IBOutlet weak var singleButton1: UIButton!
    @IBOutlet weak var singleButton2: UIButton!
    @IBOutlet weak var singleButton3: UIButton!
    @IBOutlet weak var singleButton4: UIButton!
    
    
    
    @IBOutlet weak var multipleStackView: UIStackView!
    @IBOutlet weak var multipleLabel1: UILabel!
    @IBOutlet weak var multipleLabel2: UILabel!
    @IBOutlet weak var multipleLabel4: UILabel!
    @IBOutlet weak var multipleLabel3: UILabel!
    
    
    
    @IBOutlet weak var multiSwitch1: UISwitch!
    @IBOutlet weak var multiSwitch2: UISwitch!
    @IBOutlet weak var multiSwitch3: UISwitch!
    @IBOutlet weak var multiSwitch4: UISwitch!
    
    @IBOutlet weak var rangedStackView: UIStackView!
    @IBOutlet weak var rangedLabel1: UILabel!
    @IBOutlet weak var rangedLabel2: UILabel!
    @IBOutlet weak var rangedSlider: UISlider!
    
 
    @IBOutlet weak var timerLabel: UILabel!
    
    
    @IBOutlet weak var questionProgressView: UIProgressView!
    
    
    var questions: [Question] = [

        Question(
            text: "What time of day do you feel most alive?",
            type: .single,
            answers: [
                Answer(text: "Early morning 🌅", type: .turtle),
                Answer(text: "Late night 🌙", type: .cat),
                Answer(text: "Afternoon ☀️", type: .lion),
                Answer(text: "Evening 🌇", type: .rabbit)
            ]
        ),

        Question(
            text: "When are you most productive?",
            type: .multiple,
            answers: [
                Answer(text: "Right after waking up", type: .turtle),
                Answer(text: "Late at night", type: .cat),
                Answer(text: "Midday", type: .lion),
                Answer(text: "After sunset", type: .rabbit)
            ]
        ),

        Question(
            text: "How do you feel about mornings?",
            type: .ranged,
            answers: [
                Answer(text: "I hate them", type: .cat),
                Answer(text: "I tolerate them", type: .rabbit),
                Answer(text: "They’re fine", type: .lion),
                Answer(text: "I love them", type: .turtle)
            ]
        )
    ]
    
    var questionIndex = 0
    
    var answersChosen: [Answer] = []
    
    var questionTimer: Timer?
    var timeRemaining: Int = 300

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 🔀 RANDOMIZE QUESTIONS (SAFE)
         questions.shuffle()
         
         // 🔀 RANDOMIZE ANSWERS INSIDE EACH QUESTION (SAFE)
         for i in 0..<questions.count {
             questions[i].answers.shuffle()
         }
         
        // Do any additional setup after loading the view.
        updateUI()
    }
    
    @objc func updateTimer() {
        timeRemaining -= 1

        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60

        timerLabel.text = String(format: "%02d:%02d", minutes, seconds)

        if timeRemaining <= 0 {
            stopTimer()
            skipQuestionDueToTimeout()
        }
    }

    func startTimer() {
        questionTimer?.invalidate()
        timeRemaining = 300

        timerLabel.text = "05:00"

        questionTimer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(updateTimer),
            userInfo: nil,
            repeats: true
        )
    }

    func stopTimer() {
        questionTimer?.invalidate()
        questionTimer = nil
    }

    func skipQuestionDueToTimeout() {
        nextQuestion()
    }

    
    
    func updateUI(){
        
        singleStackView.isHidden = true
        multipleStackView.isHidden = true
        rangedStackView.isHidden = true
        
        navigationItem.title = "Question #\(questionIndex + 1)"
        
        let currentQuestion = questions[questionIndex]
        let currentAnswers = currentQuestion.answers
        let totalProgress = Float(questionIndex) / Float(questions.count)
        
        questionLabel.text = currentQuestion.text
        questionProgressView.setProgress(totalProgress, animated: true)
        
        switch currentQuestion.type {
        case .single:
            
            updateSingleStack(using: currentAnswers)
        case .multiple:
           
            updateMultipleStack(using: currentAnswers)
        case .ranged:
            
            updateRangedStack(using: currentAnswers)
        }
        
        startTimer()
        
    }
    
    func updateSingleStack(using answers: [Answer]){
        singleStackView.isHidden = false
        singleButton1.setTitle(answers[0].text, for: .normal)
        singleButton2.setTitle(answers[1].text, for: .normal)
        singleButton3.setTitle(answers[2].text, for: .normal)
        singleButton4.setTitle(answers[3].text, for: .normal)
    }
    
    func updateMultipleStack(using answers: [Answer]){
        multipleStackView.isHidden = false
        multiSwitch1.isOn = false
        multiSwitch2.isOn = false
        multiSwitch3.isOn = false
        multiSwitch4.isOn = false
        
        multipleLabel1.text = answers[0].text
        multipleLabel2.text = answers[1].text
        multipleLabel3.text = answers[2].text
        multipleLabel4.text = answers[3].text

        
    }
    
    func updateRangedStack(using answers: [Answer]){
        rangedStackView.isHidden = false
        rangedSlider.setValue(0.4, animated: false)
        rangedLabel1.text = answers.first?.text
        rangedLabel2.text = answers.last?.text
    }
    
    
    @IBAction func singleAnswerButtonPressed(_ sender: UIButton) {
        stopTimer()
        let currentAnswers = questions[questionIndex].answers
        switch sender{
        case singleButton1:
            answersChosen.append(currentAnswers[0])
        case singleButton2:
            answersChosen.append(currentAnswers[1])
        case singleButton3:
            answersChosen.append(currentAnswers[2])
        case singleButton4:
            answersChosen.append(currentAnswers[3])
        
        default :
            break
        }
        nextQuestion()
        
    }
    
    @IBAction func multipleAnswerButtonPressed() {
        let currentAnswers = questions[questionIndex].answers
        
        if multiSwitch1.isOn{
            answersChosen.append(currentAnswers[0])
        }
        if multiSwitch2.isOn{
            answersChosen.append(currentAnswers[1])
        }
        if multiSwitch3.isOn{
            answersChosen.append(currentAnswers[2])
        }
        if multiSwitch4.isOn{
            answersChosen.append(currentAnswers[3])

        }
        nextQuestion()
    }
    
    @IBAction func rangedAnswerButtonPressed() {
        
        let currentAnswers = questions[questionIndex].answers
        let index = Int(round(rangedSlider.value * Float(currentAnswers.count - 1)))
        
        answersChosen.append(currentAnswers[index])
        nextQuestion()
        
    }
    func nextQuestion(){
        
        questionIndex += 1
        
        if questionIndex < questions.count{
            updateUI()
        } else {
            performSegue(withIdentifier: "Results2", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Results2"{
            let results2ViewController = segue.destination as! Result2ViewController
            results2ViewController.responses = answersChosen // Use the lowercase variable!
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
