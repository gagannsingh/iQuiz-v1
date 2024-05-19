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
    
    
    //part 2
    
    
    struct Question: Decodable {
        let text: String
        let answers: [String]
        let correctAnswerIndex: Int
        
        // Implement the Decodable protocol
        private enum CodingKeys: String, CodingKey {
            case text
            case answers
            case correctAnswer = "correct_answer_index" // Adjust key name if needed
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            text = try container.decode(String.self, forKey: .text)
            answers = try container.decode([String].self, forKey: .answers)
            correctAnswerIndex = try container.decode(Int.self, forKey: .correctAnswer)
        }
        
        func downloadQuizData(completion: @escaping ([Question]?, Error?) -> Void) {
            guard let url = URL(string: "http://tednewardsandbox.site44.com/questions.json") else { return }
            let session = URLSession.shared
            let task = session.dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(nil, error)
                    print(error.localizedDescription)
                } else if let data = data {
                    do {
                      let decoder = JSONDecoder()
                      let questions = try decoder.decode([Question].self, from: data)
                      completion(questions, nil)
                    } catch {
                        completion(nil, error)
                        print(error.localizedDescription)
                    }
                }
            }
            task.resume()
        }
        
        
        

    }
    
}
