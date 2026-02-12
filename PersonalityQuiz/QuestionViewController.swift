import UIKit

class QuestionViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var singleStackView: UIStackView!
    @IBOutlet weak var multipleStackView: UIStackView!
    @IBOutlet weak var rangedStackView: UIStackView!
    @IBOutlet weak var rangedLabel1: UILabel!
    @IBOutlet weak var rangedLabel2: UILabel!
    @IBOutlet weak var rangedSlider: UISlider!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var questionProgressView: UIProgressView!

    // MARK: - Data
    var questions: [Question] = [
        Question(
            text: "Which food do you like the most?",
            type: .single,
            answers: [
                Answer(text: "Steak", type: .lion),
                Answer(text: "Fish", type: .cat),
                Answer(text: "Carrot", type: .rabbit),
                Answer(text: "Corn", type: .turtle)
            ]
        ),
        Question(
            text: "Which activities do you enjoy?",
            type: .multiple,
            answers: [
                Answer(text: "Swimming", type: .turtle),
                Answer(text: "Sleeping", type: .cat),
                Answer(text: "Cuddling", type: .rabbit),
                Answer(text: "Eating", type: .lion)
            ]
        ),
        Question(
            text: "How much do you enjoy car rides?",
            type: .ranged,
            answers: [
                Answer(text: "I dislike them", type: .cat),
                Answer(text: "I get a little nervous", type: .rabbit),
                Answer(text: "I barely notice them", type: .turtle),
                Answer(text: "I love them", type: .lion)
            ]
        )
    ]

    private var questionIndex = 0
    private var answersChosen: [Answer] = []

    // MARK: - Timer
    var questionTimer: Timer?
    var timeRemaining: Int = 300

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    // MARK: - UI Update
    func updateUI() {
        singleStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        multipleStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        singleStackView.isHidden = true
        multipleStackView.isHidden = true
        rangedStackView.isHidden = true

        let currentQuestion = questions[questionIndex]
        let answers = currentQuestion.answers

        questionLabel.text = currentQuestion.text
        questionProgressView.progress = Float(questionIndex) / Float(questions.count)

        switch currentQuestion.type {
        case .single:
            configureSingleStack(answers: answers)
        case .multiple:
            configureMultipleStack(answers: answers)
        case .ranged:
            configureRangedStack(answers: answers)
        }

        startTimer()
    }

    // MARK: - Single
    func configureSingleStack(answers: [Answer]) {
        singleStackView.isHidden = false

        for (index, answer) in answers.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(answer.text, for: .normal)
            button.tag = index
            button.addTarget(self, action: #selector(singleAnswerTapped(_:)), for: .touchUpInside)
            singleStackView.addArrangedSubview(button)
        }
    }

    @objc func singleAnswerTapped(_ sender: UIButton) {
        stopTimer()
        let answer = questions[questionIndex].answers[sender.tag]
        answersChosen.append(answer)
        nextQuestion()
    }

    // MARK: - Multiple
    func configureMultipleStack(answers: [Answer]) {
        multipleStackView.isHidden = false

        for (index, answer) in answers.enumerated() {
            let container = UIStackView()
            container.axis = .horizontal
            container.spacing = 8

            let label = UILabel()
            label.text = answer.text

            let toggle = UISwitch()
            toggle.tag = index

            container.addArrangedSubview(label)
            container.addArrangedSubview(toggle)
            multipleStackView.addArrangedSubview(container)
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

    @IBAction func rangedSubmitTapped() {
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
            performSegue(withIdentifier: "Results", sender: nil)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Results" {
            let vc = segue.destination as! ResultViewController
            vc.responses = answersChosen
        }
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
        questionTimer = Timer.scheduledTimer(timeInterval: 1,
                                             target: self,
                                             selector: #selector(updateTimer),
                                             userInfo: nil,
                                             repeats: true)
    }

    func stopTimer() {
        questionTimer?.invalidate()
        questionTimer = nil
    }
}
