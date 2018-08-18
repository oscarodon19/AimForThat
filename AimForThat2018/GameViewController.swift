//
//  ViewController.swift
//  AimForThat2018
//
//  Created by Oscar Odon on 03/06/2018.
//  Copyright © 2018 Oscar Odon. All rights reserved.
//

import UIKit
import QuartzCore

class GameViewController: UIViewController {

    var currentValue : Int = 0
    var targetValue  : Int = 0
    var score        : Int = 0
    var round        : Int = 0
    var time         : Int = 0
    var timer        : Timer?
    
    @IBOutlet weak var slider     : UISlider!
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var scoreLabel : UILabel!
    @IBOutlet weak var roundLabel : UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var maxScoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpSlider()
        
        resetGame()
    }
    
    func setUpSlider() {
        
        let thumbImageNormal = #imageLiteral(resourceName: "SliderThumb-Normal")
        let thumbImageHighlighted = #imageLiteral(resourceName: "SliderThumb-Highlighted")
        let trackLeftImage = #imageLiteral(resourceName: "SliderTrackLeft")
        let trackRightImage = #imageLiteral(resourceName: "SliderTrackRight")
        
        self.slider.setThumbImage(thumbImageNormal, for: .normal)
        self.slider.setThumbImage(thumbImageHighlighted, for: .highlighted)
        
        let insets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        
        let trackLeftResizable  = trackLeftImage.resizableImage(withCapInsets: insets)
        let trackRightResizable = trackRightImage.resizableImage(withCapInsets: insets)
        
        self.slider.setMinimumTrackImage(trackLeftResizable, for: .normal)
        self.slider.setMaximumTrackImage(trackRightResizable, for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showAlert(_ sender: UIButton) {
        
        let difference : Int = abs(self.currentValue - self.targetValue) // abs(diferencia) calcula el valor absoluto del valor que se mande como parámetro
        
        var points = 100 - difference
        
        let title : String
        switch difference {
            case 0 :
                title  = "Perfect Score!!!"
                points = Int(10.0 * Float(points))
            case 1...5:
                title  = "Almost Perfect!"
                points = Int(1.5 * Float(points))
            case 6...12:
                title  = "You are close..."
                points = Int(1.2 * Float(points))
            default:
                title = "You are so far... ☹️"
            
        }
        
        self.score += points
        
        let message = """
        You scored \(points) points
        """
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default, handler: { action in
                self.startNewRound()
            })
        
        alert.addAction(action)
        
        present(alert, animated: true)
        
    }
    
    @IBAction func sliderMoved(_ sender: UISlider) {
        
        self.currentValue = lroundf(sender.value) //El lroundf(floatingPointValue) redondea el número para abajo
    
    }
    
    @IBAction func startNewGame () {
        resetGame()
        
        let transition = CATransition()
        transition.type = kCATransitionFade
        transition.duration = 1
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
        
        self.view.layer.add(transition, forKey: nil)
        
    }
    
    func startNewRound() {
        self.targetValue  = 1 + Int(arc4random_uniform(100))
        self.currentValue = 50
        self.slider.value = Float(self.currentValue)
        self.round += 1
        
        updateLabels()
    }
    
    func updateLabels() {
        self.targetLabel.text = "\(self.targetValue)"
        self.scoreLabel.text  = "\(self.score)"
        self.roundLabel.text  = "\(self.round)"
        self.timeLabel.text   = "\(self.time)"
    }
    
    func resetGame() {
        
        // Comprobamos puntuación máxima aquí
        var maxScore = UserDefaults.standard.integer(forKey: "maxscore")
        
        if maxScore < self.score {
            maxScore = self.score
            UserDefaults.standard.set(maxScore, forKey: "maxscore")
        }
        
        self.maxScoreLabel.text = "\(maxScore)"
        
        // Reiniciamos variables de juego
        self.score = 0
        self.round = 0
        self.time = 30
        
        // Reiniciamos el temporizador
        stopTimer()
        startTimer()
        
        updateLabels()
        startNewRound()
    }
    
    func startTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
        }
    }
    
    func stopTimer() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
    
    @objc func tick() {
        self.time -= 1
        self.timeLabel.text = "\(self.time)"
        
        if self.time <= 0 {
            
            stopTimer()
            
            let message = """
                Time is up!
                You must start a new game!
            """
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Ok", style: .default, handler: { action in
                 self.startNewGame()
            })
            
            alert.addAction(action)
            
            present(alert, animated: true)
        }
    }
    
}

