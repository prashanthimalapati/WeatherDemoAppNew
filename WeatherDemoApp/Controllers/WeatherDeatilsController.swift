//
//  WeatherDeatilsControllerViewController.swift
//  WeatherDemoApp
//
//  Created by prashanthi M on 02/08/20.
//  Copyright © 2020 unilever. All rights reserved.
//

import UIKit

class WeatherDeatilsController: UIViewController {

    @IBOutlet weak var countryLbl: UILabel!
    @IBOutlet weak var speedLbl: UILabel!
    @IBOutlet weak var pressueLbl: UILabel!
    @IBOutlet weak var humudityLbl: UILabel!
    var cityHumidity = ""
    var cityPressure = ""
    var citySpeed = ""
    var country = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.countryLbl.text = country
        self.humudityLbl.text = cityHumidity + "%"
        self.pressueLbl.text = cityPressure + "hPa"
        self.speedLbl.text = citySpeed + "km/hr"
        
        // Do any additional setup after loading the view.
    }
    

    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
