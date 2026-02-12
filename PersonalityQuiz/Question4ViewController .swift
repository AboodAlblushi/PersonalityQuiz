import UIKit

class Question4ViewController: UIViewController {

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
            text: "How do you usually feel at social gatherings?",
            type: .single,
            answers: [
                Answer(text: "I love them and feel energized", type: .lion),
                Answer(text: "I enjoy them in small doses", type: .cat),
                Answer(text: "I feel comfortable with close friends", type: .rabbit),
                Answer(text: "I prefer quiet environments", type: .turtle)
            ]
        ),

        Question(
            text: "What do you prefer doing in your free time?",
            type: .multiple,
            answers: [
                Answer(text: "Hanging out with lots of people", type: .lion),
                Answer(text: "Spending time alone", type: .cat),
                Answer(text: "Relaxing with close friends", type: .rabbit),
                Answer(text: "Enjoying calm, solo activities", type: .turtle)
            ]
        ),

        Question(
            text: "How do you recharge after a long day?",
            type: .ranged,
            answers: [
                Answer(text: "Being alone", type: .cat),
                Answer(text: "Doing something peaceful", type: .turtle),
                Answer(text: "Talking to close friends", type: .rabbit),
                Answer(text: "Going out and socializing", type: .lion)
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

    // MARK: - UI Update
    func updateUI() {
        singleStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        multipleStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        singleStackView.isHidden = true
        multipleStackView.isHidden = true
        rangedStackView.isHidden = true

        navigationItem.title = "Question #\(questionIndex + 1)"

        let currentQuestion = questions[questionIndex]
        questionLabel.text = currentQuestion.text
        questionProgressView.setProgress(Float(questionIndex) / Float(questions.count), animated: true)

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
            let toggle = UISwitch()
            toggle.tag = index

            let label = UILabel()
            label.text = answer.text

            let row = UIStackView(arrangedSubviews: [label, toggle])
            row.axis = .horizontal
            row.distribution = .equalSpacing

            multipleStackView.addArrangedSubview(row)
        }

        let submit = UIButton(type: .system)
        submit.setTitle("Submit Answer", for: .normal)
        submit.addTarget(self, action: #selector(multipleSubmitTapped), for: .touchUpInside)
        multipleStackView.addArrangedSubview(submit)
    }

    @objc func multipleSubmitTapped() {
        let currentAnswers = questions[questionIndex].answers

        for view in multipleStackView.arrangedSubviews {
            if let row = view as? UIStackView,
               let toggle = row.arrangedSubviews.last as? UISwitch,
               toggle.isOn {
                answersChosen.append(currentAnswers[toggle.tag])
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
            performSegue(withIdentifier: "Results4", sender: nil)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Results4" {
            let vc = segue.destination as! Result4ViewController
            vc.responses = answersChosen
        }
    }
}
