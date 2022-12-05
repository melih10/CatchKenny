//
//  ViewController.swift
//  CatchKenny
//
//  Created by Melih on 13.10.2022.
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highscoreLabel: UILabel!
    @IBOutlet weak var kennyImage: UIImageView!
    
    var timer1 = Timer()
    var timer2 = Timer()
    var counter = 0
    var score = 0
    var highscore = 0
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storedHighscore = UserDefaults.standard.object(forKey: "highscore")
        
        if storedHighscore == nil {
            highscore = 0
            highscoreLabel.text = "Highscore : \(highscore)"
        }
            if let newHighscore = storedHighscore as? Int {
                highscore = newHighscore
                highscoreLabel.text = "Highscore: \(highscore)"            }
        
        kennyImage.isUserInteractionEnabled = true
        counter = 10
        timer1 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerFunction), userInfo: nil, repeats: true)
        
        timer2 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(moveKenny), userInfo: nil, repeats: true)
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(clickAction))
        kennyImage.addGestureRecognizer(gesture)
    }
    
    @objc func timerFunction(){
        timeLabel.text = "Time: \(counter)"
        counter -= 1
        
        if counter == 0 {
            timer1.invalidate()
            timer2.invalidate()
            timeLabel.text = "Time's Over!"
            scoreLabel.text = "Score: \(self.score)"
            kennyImage.point(inside: CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 2), with: .none)
            
            if self.score > self.highscore {
                self.highscore = self.score
                highscoreLabel.text = "Highscore: \(self.highscore)"
                UserDefaults.standard.set(self.highscore, forKey: "highscore")
            }
            
            let alert = UIAlertController(title: "Time's Up!", message: "Do you want to play again?", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel)
            let replay = UIAlertAction(title: "Replay", style: UIAlertAction.Style.default) { UIAlertAction in
                self.score = 0
                self.scoreLabel.text = "Score:\(self.score)"
                self.counter = 10
                
                self.timer1 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerFunction), userInfo: nil, repeats: true)
                
                self.timer2 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.moveKenny), userInfo: nil, repeats: true)
                
            }
            alert.addAction(okButton)
            alert.addAction(replay)
            self.present(alert, animated: true)
        }
    }
  
    @objc func moveKenny(){
             let scorePositionY = scoreLabel.layer.position.y + 20
             let highscorePositionY = highscoreLabel.layer.position.y - 100
             let width = view.frame.size.width
             let randomInt1 = round(Double.random(in: (width * 0.1)..<(width * 0.9)))
             let randomInt2 = round(Double.random(in: (scorePositionY)..<(highscorePositionY)))
             
        kennyImage.frame = CGRect(x: randomInt1, y: randomInt2, width: 70, height: 100)
             view.addSubview(kennyImage)
     }
    
    @objc func clickAction() {
        score += 1
       scoreLabel.text = "Score: \(score)"
    }
    
    func saveHighscore(){
        UserDefaults.standard.set(scoreLabel.text, forKey: "score")
        UserDefaults.standard.set(highscoreLabel.text, forKey: "highscore")
    }
    
}

