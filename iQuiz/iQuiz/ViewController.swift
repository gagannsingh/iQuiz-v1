//
//  ViewController.swift
//  iQuiz
//
//  Created by Gagan Singh on 5/18/24.
//

import UIKit

struct Quiz {
  let title: String
  let description: String
  let image: UIImage?
}

struct Question: Decodable {
    let text: String!
    let answers: [String]!
    let correctAnswerIndex: Int!
    }



class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizzes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let quiz = quizzes[indexPath.row]
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        cell.label.text = quiz.title
        cell.subtitle.text = quiz.description
        cell.iconImageView.image = quiz.image
        return cell
    }
    
    
    
    //initialize
    @IBOutlet weak var iQuizLabel: UILabel!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        table.delegate = self
    }
    
    @IBAction func settingsClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Settings", message: "Settings go here", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    
    // Array of Quiz objects
    var quizzes: [Quiz] = [
        Quiz(title: "Mathematics", description: "Test your math skills", image: UIImage(named: "mathImage")),
        Quiz(title: "Marvel Super Heroes", description: "Who is the strongest Avenger?", image: UIImage(named: "superheroImage")),
        Quiz(title: "Science", description: "Explore the wonders of science", image: UIImage(named: "scienceImage"))
    ]
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 161
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showQuiz", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showQuiz" {
            if let destinationVC = segue.destination as? QuizViewController,
               let indexPath = table.indexPathForSelectedRow {
                destinationVC.quiz = quizzes[indexPath.row]
            }
        }
        
        
    }
}


class QuizViewController: UIViewController {
    
    @IBOutlet weak var questionLabel: UILabel!
    
    //button 0,1,2,3
    @IBOutlet var buttons: [UIButton]!
    
    var selectedAnswerIndex: Int? // Stores the selected button index

    
    @IBOutlet weak var home: UIButton!
    
    @IBAction func homeClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var submit: UIButton!

    
    var quiz: Quiz?
    var Questions = [Question]()
    var QNumber = Int()
    var AnswerNumber = Int()
    var currentQuestionIndex = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let quiz = quiz {
              self.title = quiz.title
              // Load questions based on the selected quiz
          }
        displayQuestion()

    }
    
    func displayQuestion() {
        guard currentQuestionIndex < Questions.count else {
            showResults()
            return
        }

        let question = Questions[currentQuestionIndex]
        questionLabel.text = question.text
        selectedAnswerIndex = nil

        for (index, button) in buttons.enumerated() {
            button.setTitle(question.answers[index], for: .normal)
            button.backgroundColor = .systemBackground
            button.isUserInteractionEnabled = true
            button.tag = index
            button.addTarget(self, action: #selector(answerSelected(_:)), for: .touchUpInside)
        }
    }
    
    @objc func answerSelected(_ sender: UIButton) {
        selectedAnswerIndex = sender.tag
        for button in buttons {
            button.backgroundColor = button.tag == selectedAnswerIndex ? .lightGray : .systemBackground
        }
    }
    
    
    func loadQuestions(for quiz: Quiz) {
        Questions = [
            Question(text: "A + B", answers: ["a", "b", "c", "d"], correctAnswerIndex: 2)
        ]
    }
    
    func pickQuestion() {
        if Questions.count > 0 {
            QNumber = 0
            questionLabel.text = Questions[QNumber].text
            AnswerNumber = Questions[QNumber].correctAnswerIndex
            for i in 0..<buttons.count {
                buttons[i].setTitle(Questions[QNumber].answers[i], for: .normal)
            }
            Questions.remove(at: QNumber)
        } else {
            NSLog("Done for now")
        }
    }
    
    @IBAction func btn1(_ sender: Any) {
        if AnswerNumber == 0{
            pickQuestion()
        }
        else{
        NSLog("Wrong")
        }
    }
    
    @IBAction func btn2(_ sender: Any) {
        if AnswerNumber == 1{
            pickQuestion()
        }
        else{
        NSLog("Wrong")
        }
    }
    
    @IBAction func btn3(_ sender: Any) {
        if AnswerNumber == 2{
            pickQuestion()
        }
        else{
        NSLog("Wrong")
        }
    }
    
    @IBAction func btn4(_ sender: Any) {
        if AnswerNumber == 3{
            pickQuestion()
        }
        else{
        NSLog("Wrong")
        }
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
      let selectedIndex = sender.tag  // Assuming buttons have tags set (0-3)

      // Disable interaction after selection
      sender.isUserInteractionEnabled = false
      sender.backgroundColor = .lightGray // Change color to indicate selection

      selectedAnswerIndex = selectedIndex
    }
    
    @IBAction func submitTapped(_ sender: Any, currentQuestionIndex: Int) {
        guard let selectedAnswerIndex = selectedAnswerIndex else {
            let alert = UIAlertController(title: "No Answer Selected", message: "Please select an answer before submitting.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)
            return
        }

        let correctAnswerIndex = Questions[currentQuestionIndex].correctAnswerIndex
        let isCorrect = (selectedAnswerIndex == correctAnswerIndex)

        // Provide feedback to the user
        let feedback = isCorrect ? "Correct!" : "Wrong! The correct answer was \(Questions[currentQuestionIndex].answers[correctAnswerIndex!])."
        let alert = UIAlertController(title: "Feedback", message: feedback, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.currentQuestionIndex += 1
            self.displayQuestion()
        }))
        present(alert, animated: true)
    }
    
    func showResults() {
        let alert = UIAlertController(title: "Quiz Completed", message: "You have completed the quiz!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true)
    }
    
    
    
    
}
