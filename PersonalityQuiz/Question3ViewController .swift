import UIKit

class Question3ViewController: UIViewController {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var singleStackView: UIStackView!
    @IBOutlet weak var multipleStackView: UIStackView!
    @IBOutlet weak var rangedStackView: UIStackView!
    @IBOutlet weak var rangedLabel1: UILabel!
    @IBOutlet weak var rangedLabel2: UILabel!
    @IBOutlet weak var rangedSlider: UISlider!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var questionProgressView: UIProgressView!

    var questions: [Question] = [

        Question(
            text: "Which kind of friend are you?",
            type: .single,
            answers: [
                Answer(text: "The leader of the group", type: .lion),
                Answer(text: "The chill, quiet one", type: .cat),
                Answer(text: "The supportive, caring one", type: .rabbit),
                Answer(text: "The wise advice-giver", type: .turtle)
            ]
        ),

        Question(
            text: "How do you usually help your friends?",
            type: .multiple,
            answers: [
                Answer(text: "Give them motivation", type: .lion),
                Answer(text: "Listen without judging", type: .cat),
                Answer(text: "Comfort and reassure them", type: .rabbit),
                Answer(text: "Offer thoughtful solutions", type: .turtle)
            ]
        ),

        Question(
            text: "How do you act in group situations?",
            type: .ranged,
            answers: [
                Answer(text: "I stay in the background", type: .cat),
                Answer(text: "I help when needed", type: .rabbit),
                Answer(text: "I balance everyone out", type: .turtle),
                Answer(text: "I naturally take charge", type: .lion)
            ]
        )
    ]

    var questionIndex = 0
    var answersChosen: [Answer] = []

    var questionTimer: Timer?
    var timeRemaining: Int = 300

    override func viewDidLoad() {
        super.viewDidLoad()

        questions.shuffle()
        for i in 0..<questions.count {
            questions[i].answers.shuffle()
        }

        updateUI()
    }

    // MARK: - Timer
    @objc func updateTimer() {
        timeRemaining -= 1
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        timerLabel.text = String(format: "%02d:%02d", minutes, seconds)

        if timeRemaining <= 0 {
            stopTimer()
            nextQuestion()
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

    // MARK: - UI
    func updateUI() {

        singleStackView.isHidden = true
        multipleStackView.isHidden = true
        rangedStackView.isHidden = true

        let currentQuestion = questions[questionIndex]
        questionLabel.text = currentQuestion.text

        let progress = Float(questionIndex) / Float(questions.count)
        questionProgressView.setProgress(progress, animated: true)

        switch currentQuestion.type {
        case .single:
            configureSingleStack(answers: currentQuestion.answers)
        case .multiple:
            configureMultipleStack(answers: currentQuestion.answers)
        case .ranged:
            configureRangedStack(answers: currentQuestion.answers)
        }

        startTimer()
    }

    // MARK: - Dynamic Single
    func configureSingleStack(answers: [Answer]) {
        singleStackView.isHidden = false
        singleStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for (index, answer) in answers.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(answer.text, for: .normal)
            button.tag = index
            button.addTarget(self, action: #selector(singleButtonTapped(_:)), for: .touchUpInside)
            singleStackView.addArrangedSubview(button)
        }
    }

    @objc func singleButtonTapped(_ sender: UIButton) {
        stopTimer()
        let answer = questions[questionIndex].answers[sender.tag]
        answersChosen.append(answer)
        nextQuestion()
    }

    // MARK: - Dynamic Multiple
    func configureMultipleStack(answers: [Answer]) {
        multipleStackView.isHidden = false
        multipleStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for (index, answer) in answers.enumerated() {
            let toggle = UISwitch()
            toggle.tag = index

            let label = UILabel()
            label.text = answer.text

            let stack = UIStackView(arrangedSubviews: [label, toggle])
            stack.axis = .horizontal
            stack.distribution = .equalSpacing

            multipleStackView.addArrangedSubview(stack)
        }

        let submitButton = UIButton(type: .system)
        submitButton.setTitle("Submit Answer", for: .normal)
        submitButton.addTarget(self, action: #selector(multipleSubmitTapped), for: .touchUpInside)
        multipleStackView.addArrangedSubview(submitButton)
    }

    @objc func multipleSubmitTapped() {
        let answers = questions[questionIndex].answers

        for view in multipleStackView.arrangedSubviews {
            if let stack = view as? UIStackView,
               let toggle = stack.arrangedSubviews.last as? UISwitch,
               toggle.isOn {
                answersChosen.append(answers[toggle.tag])
            }
        }

        nextQuestion()
    }

    // MARK: - Ranged
    func configureRangedStack(answers: [Answer]) {
        rangedStackView.isHidden = false
        rangedSlider.setValue(0.5, animated: false)
        rangedLabel1.text = answers.first?.text
        rangedLabel2.text = answers.last?.text
    }

    @IBAction func rangedAnswerButtonPressed() {
        let answers = questions[questionIndex].answers
        let index = Int(round(rangedSlider.value * Float(answers.count - 1)))
        answersChosen.append(answers[index])
        nextQuestion()
    }

    // MARK: - Navigation
    func nextQuestion() {
        questionIndex += 1
        if questionIndex < questions.count {
            updateUI()
        } else {
            performSegue(withIdentifier: "Results3", sender: nil)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Results3" {
            let vc = segue.destination as! Result3ViewController
            vc.responses = answersChosen
        }
    }
}
