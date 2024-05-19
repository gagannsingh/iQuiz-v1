//
//  QuizViewController.swift
//  iQuiz
//
//  Created by Gagan Singh on 5/19/24.
//

import Foundation
import UIKit

class QuizViewController: UIViewController {
    
    override func viewDidLoad() {
      super.viewDidLoad()
      // ... (initial UI setup)
      updateQuestion() // Load the first question
    }
  var quiz: Quiz! // Holds the selected quiz data
  var currentQuestionIndex: Int = 0 // Keeps track of the current question
  var score: Int = 0 // Tracks the user's score

    func updateQuestion() {
      guard currentQuestionIndex < quiz.questions.count else { return } // Check if it's the last question
      let question = quiz.questions[currentQuestionIndex]
      // Update UI elements with question text and answer options
      questionLabel.text = question.text
      // ... (set answer buttons with answer options)
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
      // Get the selected answer index
      let selectedIndex = // ... (logic to get selected answer index)
      let correctAnswerIndex = quiz.questions[currentQuestionIndex].correctAnswerIndex
      // Check if the answer is correct
      if selectedIndex == correctAnswerIndex {
        score += 1
      }
      // Show Answer Scene with segue
      performSegue(withIdentifier: "showAnswer", sender: self)
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
      currentQuestionIndex += 1
      if currentQuestionIndex < quiz.questions.count {
        updateQuestion() // Load the next question
      } else {
        performSegue(withIdentifier: "showFinished", sender: self) // To Finished Scene
      }
    }
}
