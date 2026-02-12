import UIKit

class Question2ViewController: UIViewController {

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
            let row = UIStackView()
            row.axis = .horizontal
            row.distribution = .fillEqually

            let label = UILabel()
            label.text = answer.text

            let toggle = UISwitch()
            toggle.tag = index

            row.addArrangedSubview(label)
            row.addArrangedSubview(toggle)

            multipleStackView.addArrangedSubview(row)
        }

        let submit = UIButton(type: .system)
        submit.setTitle("Submit Answer", for: .normal)
        submit.addTarget(self, action: #selector(multipleSubmitTapped), for: .touchUpInside)
        multipleStackView.addArrangedSubview(submit)
    }

    @objc func multipleSubmitTapped() {
        let currentAnswers = questions[questionIndex].answers

        for case let row as UIStackView in multipleStackView.arrangedSubviews {
            if let toggle = row.arrangedSubviews.last as? UISwitch, toggle.isOn {
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
            performSegue(withIdentifier: "Results2", sender: nil)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Results2" {
            let vc = segue.destination as! Result2ViewController
            vc.responses = answersChosen
        }
    }
}
