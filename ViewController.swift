//
//  ViewController.swift
//  Repeat
//
//  Created by Ahmed Yacoob on 11/19/21.
//

import UIKit
import TheAnimation
import AVFoundation

class ViewController : UIViewController {
    var player: AVAudioPlayer?
    var computerSequence: [Int] = []
    var currentLevel = 0 {
        didSet{
            currentuserSequence = 0
        }
    }
    var currentuserSequence = 0{
        didSet{
            summaryText.text = "Sequence: \(currentuserSequence)/\(currentLevel)"
        }
    }
    var userTurn = false {
        didSet{
            if gameStart{
                if userTurn{
                    text.text = "Your Turn"
                }
                else{
                    text.text="LEVEL \(currentLevel) COMPLETE"
                    //userSequence = []
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.6) {
                        self.text.text = "Computer Turn"
                    }
                    
                }
            }
            else{
                text.text = "GAME OVER: YOU COMPLETED \(currentLevel) LEVELS"
            }
        }
    }
    var gameStart = false
    var repeatsAvailable = 3 {
        didSet{
            repeatText.text = "Repeats Available: \(repeatsAvailable)"
            if repeatsAvailable==0{
                playRepeatButton.isHidden = true
            }
            else{
                playRepeatButton.isHidden = false
            }
        }
        
    }
    
    let summaryText: UILabel = {
        let st = UILabel()
        st.translatesAutoresizingMaskIntoConstraints = false
        return st
    }()
    
    let repeatText: UILabel = {
        let rt = UILabel()
        rt.translatesAutoresizingMaskIntoConstraints = false
        return rt
    }()
    let text: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.font = UIFont(name: "Helvetica", size: 24)
        text.text = "REPEAT"
        text.adjustsFontSizeToFitWidth = true
        text.minimumScaleFactor = 0.5
        //text.backgroundColor = .brown
        text.textAlignment = .center
        return text
    }()
    
    let playRepeatButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .brown
        button.setTitle("Play", for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(gameRepeatStart), for: .touchUpInside)
        return button
    }()
    
    let summaryView: UIView = {
        let sv = UIView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    
    
    
    let containerView: UIView = {
        let vview = UIView()
        vview.translatesAutoresizingMaskIntoConstraints = false
        return vview
    }()
    
    let baseString = "piano-mp3_"
    
    let mp3Strings = ["C6", "D6", "E6", "F6", "D2"]
    
  
    
    
    var containerViews = [UIView]()
    let colors: [UIColor] = [.red, .green, .blue, .yellow]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(containerView)
        view.addSubview(playRepeatButton)
        view.addSubview(summaryView)
        view.addSubview(text)
        summaryView.addSubview(repeatText)
        summaryView.addSubview(summaryText)
        setupcontainerviews()
        //setupinitialtexts()
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            containerView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            
            playRepeatButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playRepeatButton.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 100),
            playRepeatButton.heightAnchor.constraint(equalToConstant: 50),
            playRepeatButton.widthAnchor.constraint(equalToConstant: 200),
            
            summaryView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            summaryView.bottomAnchor.constraint(equalTo: text.topAnchor),
            summaryView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            summaryView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.3),
            
        
            summaryText.trailingAnchor.constraint(equalTo: summaryView.trailingAnchor, constant: -10),
            summaryText.topAnchor.constraint(equalTo: summaryView.topAnchor,constant: 10),
            
            text.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            text.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
            text.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            
            repeatText.trailingAnchor.constraint(equalTo: summaryView.trailingAnchor, constant: -10),
            repeatText.topAnchor.constraint(equalTo: summaryText.bottomAnchor, constant: 20),
           
            
            containerViews[0].leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            containerViews[0].topAnchor.constraint(equalTo: containerView.topAnchor),

            
            containerViews[1].leadingAnchor.constraint(equalTo: containerViews[0].trailingAnchor),
            containerViews[1].topAnchor.constraint(equalTo: containerView.topAnchor),
            
            
            containerViews[2].leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            containerViews[2].topAnchor.constraint(equalTo: containerViews[0].bottomAnchor),
            
            
            containerViews[3].leadingAnchor.constraint(equalTo:containerViews[2].trailingAnchor),
            containerViews[3].topAnchor.constraint(equalTo: containerViews[1].bottomAnchor)
            
        ])

    }
    
    private func setupcontainerviews(){
        for i in 0..<4{
            let vview = ContainerButton(id: i)
            vview.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            vview.backgroundColor = colors[i]
            vview.layer.opacity = 0.12
            vview.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(vview)
            NSLayoutConstraint.activate([
                vview.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.50),
                vview.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.50)
            ])
            containerViews.append(vview)
            
        }
    }
    
    private func setupAnimation(index: Int, endofgame: Bool = false){
        var transform = CATransform3DIdentity
        transform.m34 = -1.0/500.0
        transform = CATransform3DTranslate(transform, 0, 0, 10)
        let zanimation = BasicAnimation(keyPath: .transform)
        zanimation.fromValue = containerViews[0].layer.transform
        zanimation.toValue = transform
        zanimation.duration = 0.5
        let opacityanimation = BasicAnimation(keyPath: .opacity)
        opacityanimation.toValue = 1.0
        opacityanimation.duration = 0.5
        if endofgame{
            playSound(4)
        }
        else{
            playSound(index)
        }
        zanimation.animate(in: containerViews[index].layer)
        opacityanimation.animate(in: containerViews[index].layer)
        
    }
    
    
    
    func playSound(_ index: Int) {
        guard let url = Bundle.main.url(forResource: baseString+mp3Strings[index], withExtension: "mp3") else {
            print("file not found")
            return
            
        }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = player else { return }
            player.play()
            DispatchQueue.main.asyncAfter(deadline: .now()+0.4, execute: {
                player.stop()
            })

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    @objc func buttonTapped(_ sender: Any?){
        if gameStart && userTurn{
            guard let button = sender as? ContainerButton else {
                print("cast failed")
                return
            }
            if button.id != computerSequence[currentuserSequence]{
                setupAnimation(index: computerSequence[currentuserSequence], endofgame: true)
                print("tapped ID: \(String(describing: button.id))")
                print("computerID: \(computerSequence[0])")
                print("end of game")
                //function for handling end of game and cleanup
                endofGame()
            }
            else{
                setupAnimation(index: button.id)
                currentuserSequence += 1
                if currentuserSequence == computerSequence.count{
                    print("transition to next level")
                    self.userTurn = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        self.playNextComputerSequence()
                    }
                    
                }
                
            }
        }
    }
    
    func generateNextTile(){
        let random = Int.random(in: 0..<4)
        computerSequence.append(random)
    }
    
    @objc func gameRepeatStart(_ sender: Any?){
        if !gameStart{
            var timeRemaining: Int = 3
            
            let _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                print("in timer")
                if timeRemaining == 0{
                    timer.invalidate()
                    self.startGame()
                }
                self.text.text = "STARTING IN \(timeRemaining)"
                timeRemaining-=1
                
            }
                
        }
        else{
            userTurn = false
            if repeatsAvailable > 0 {
                playSequence()
                repeatsAvailable -= 1
            }
        }
    }
    
    func playNextComputerSequence(){
        currentLevel += 1
        generateNextTile()
        playSequence()
    }
    
    func playSequence(){
        for i in 0..<computerSequence.count{
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0*Double(i)) {
                print("sequence \(self.computerSequence[i])")
                self.setupAnimation(index: self.computerSequence[i])
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0*Double(computerSequence.count) + 0.3) {
            self.userTurn = true
            self.text.text = "Your Turn"
        }
    }
    
    func endofGame(){
        gameStart = false
        userTurn = false
        playRepeatButton.setTitle("PLAY", for: .normal)
    }
    
    func startGame(){
        currentLevel = 0
        repeatsAvailable = 3
        computerSequence = []
        playRepeatButton.setTitle("Repeat", for: .normal)
        gameStart = true
        playNextComputerSequence()
    }
}

