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
import NVActivityIndicatorView


class ViewController: UIViewController, NVActivityIndicatorViewable {
    
    
    var minutes = 10
    var timer = Timer()
    var activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 91, y: 375, width: 200, height: 200),
                                                        type: NVActivityIndicatorType(rawValue: NVActivityIndicatorType.ballScaleRippleMultiple.rawValue)!, color: UIColor(white: CGFloat(237 / 255.0), alpha: 1))
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var sliderOutlet: UISlider!
    let step: Float = 5
    @IBAction func slider(_ sender: UISlider) {
        minutes = Int(round(sender.value / step) * step)
        label.text = String(minutes) + " minutes"
    }
    
    @IBOutlet weak var beginOutlet: UIButton!
    @IBAction func begin(_ sender: Any) {
        if (beginOutlet.currentTitle?.isEqual("begin"))! {
            timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(ViewController.counter), userInfo: nil, repeats: true)
            beginOutlet.setTitle("end", for: [])
            Sound.play(file: "SingingBowl.m4a")
            sliderOutlet.isHidden = true
            activityIndicatorView.startAnimating()
            UIApplication.shared.isIdleTimerDisabled = true
        
        } else if (beginOutlet.currentTitle?.isEqual("end"))! {
            timer.invalidate()
            getQuote()
            Sound.play(file: "SingingBowl.m4a")
            sliderOutlet.isHidden = true
            activityIndicatorView.stopAnimating()
            beginOutlet.setTitle("again", for: [])
            UIApplication.shared.isIdleTimerDisabled = false
            
        } else {
            timer.invalidate()
            minutes = 10
            sliderOutlet.setValue(10, animated: true)
            label.text = "10 minutes"
            sliderOutlet.isHidden = false
            beginOutlet.setTitle("begin", for: [])
            UIApplication.shared.isIdleTimerDisabled = false
        }

    }
    
    @objc func counter() {
        minutes -= 1
        if (minutes == 0) {
            timer.invalidate()
            getQuote()
            Sound.play(file: "SingingBowl.m4a")
            activityIndicatorView.stopAnimating()
            beginOutlet.setTitle("again", for: [])
            UIApplication.shared.isIdleTimerDisabled = false
        } else if (minutes == 1) {
            label.text = String(minutes) + " minute"
        } else {
            label.text = String(minutes) + " minutes"
        }
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
        self.view.addSubview(activityIndicatorView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
