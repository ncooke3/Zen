//
//  ViewController.swift
//  Meditation Timer
//
//  Created by Nicholas Cooke on 10/5/18.
//  Copyright © 2018 Nicholas Cooke. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftySound

class ViewController: UIViewController {
    
    
    var minutes = 10
    var timer = Timer()


    @IBOutlet weak var label: UILabel!
    
    
    @IBOutlet weak var sliderOutlet: UISlider!
    let step: Float = 5
    @IBAction func slider(_ sender: UISlider) {
        let minutes = Int(round(sender.value / step) * step)
        label.text = String(minutes) + " minutes"
    }
    
    @IBOutlet weak var beginOutlet: UIButton!
    @IBAction func begin(_ sender: Any) {
        if (beginOutlet.currentTitle?.isEqual("begin"))! {
            timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(ViewController.counter), userInfo: nil, repeats: true)
            Sound.play(file: "SingingBowl.m4a")
            beginOutlet.setTitle("end", for: [])
            sliderOutlet.isHidden = true
            
        } else {
            timer.invalidate()
            getQuote()
            Sound.play(file: "SingingBowl.m4a")
            beginOutlet.setTitle("begin", for: [])
            sliderOutlet.isHidden = false
        }

    }
    
    @objc func counter() {
        minutes -= 1
        label.text = String(minutes) + " minutes"
        
        if (minutes == 0) {
            timer.invalidate()
            getQuote()
            Sound.play(file: "SingingBowl.m4a")
        }
        
    }
    
    
    @IBOutlet weak var againOutlet: UIButton!
    @IBAction func again(_ sender: Any) {
        timer.invalidate()
        minutes = 10
        sliderOutlet.setValue(10, animated: true)
        label.text = "10 minutes"
        beginOutlet.setTitle("begin", for: [])
    }
    
    func getQuote() {
        Alamofire.request("https://andruxnet-random-famous-quotes.p.mashape.com/", method: .get, parameters: ["cat":"famous", "count":"1"], headers: ["X-Mashape-Key":"Pw5vWwsh83mshrXvLbPARRDTcjBEp1SGw1pjsnmHAWq03QRVS7"]).responseJSON {
            (dataResponse) in
            switch dataResponse.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                self.label.text = json.array?.first?["quote"].string
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}

