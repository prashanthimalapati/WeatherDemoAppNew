//
//  ViewController.swift
//  WeatherDemoApp
//
//  Created by prashanthi M on 01/08/20.
//  Copyright © 2020 unilever. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces


class ViewController: UIViewController,UITextFieldDelegate{

    
    @IBOutlet weak var tableDataView: UITableView!
    var updatedLocationData = [WeatherData]()
    var timeZone : String = String()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableDataView.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updatedLocationData = DatabaseHandler.fetchedWeatherData()
        print("updatedLocationData : \(updatedLocationData)")
        if !updatedLocationData.isEmpty {
            self.tableDataView.isHidden = false
            self.tableDataView.reloadData()
        }
    }
    
    @IBAction func addLocationBtnTapped(_ sender: Any) {
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }
    
    func getLocationData() {
    
        updatedLocationData = DatabaseHandler.fetchedWeatherData()
        DispatchQueue.main.async {
              self.tableDataView.isHidden = false
              self.tableDataView.reloadData()
        }
    }
    
}

extension ViewController : UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = updatedLocationData.count == 0 ? 0 : updatedLocationData.count
        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityTableViewCell", for: indexPath) as! CityTableViewCell
            cell.cityNameLabel.text = updatedLocationData[indexPath.row].cityName
            cell.timeLabel.text = updatedLocationData[indexPath.row].cityTimeZone
            cell.tempLabel.text = updatedLocationData[indexPath.row].cityTemp
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name:"Main", bundle:nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "WeatherDeatilsController") as! WeatherDeatilsController
        vc.country = updatedLocationData[indexPath.row].country ?? ""
        vc.citySpeed = updatedLocationData[indexPath.row].speed ?? ""
        vc.cityPressure = updatedLocationData[indexPath.row].pressure ?? ""
        vc.cityHumidity = updatedLocationData[indexPath.row].humudity ?? ""
        present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DispatchQueue.main.async {
                self.updatedLocationData.remove(at: indexPath.row)
                self.tableDataView.deleteRows(at: [indexPath], with: .fade)
                DatabaseHandler.deleteWeatherData()
            }
        }
    }
   
}


extension ViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        // Get the place name from 'GMSAutocompleteViewController'
        // Then display the name in textField
        ConnectionManager().getWeather(city: place.name!) { (message,data) in
            do
            {
                if let jsonData = data
                {
                    print(jsonData)
                    let locationData = try JSONDecoder().decode(LocationModel.self, from: jsonData)
                    if !locationData.weather!.isEmpty{
                        let cityName = locationData.name
                        let timeOffSet = locationData.timezone
                        let currentDate = Date()
                        let epochDate = currentDate.timeIntervalSince1970
                        let timezoneEpochOffset = (epochDate + Double(timeOffSet!))
                        let timeZoneOffsetDate = Date(timeIntervalSince1970: timezoneEpochOffset)
                        print(timeZoneOffsetDate)
                        let format = DateFormatter()
                        format.dateFormat = "h:mm a"
                        format.timeZone = TimeZone(abbreviation: "UTC")
                        let timeValue = format.string(from: timeZoneOffsetDate)
                        let cityTimeZone = timeValue
                        let cityTemp = "\(String(format: "%.0f", (locationData.main?.temp)! - 273.15))℃"
                        
                       let cityHumidity = "\((locationData.main?.humidity)!)"
                       let cityPressure = "\((locationData.main?.pressure)!)"
                       let citySpeed = "\((locationData.wind?.speed)!)"
                      let country = locationData.sys?.country ?? ""
                        
                        DispatchQueue.main.async {
                            DatabaseHandler.saveObject(cityName: cityName ?? "", cityTimeZone: cityTimeZone , cityTemp: cityTemp , humudity: cityHumidity , pressure: cityPressure , speed: citySpeed , country: country )
                            self.getLocationData()
                        }
                    }
                }
            }
            catch
            {
                print("Parse Error: \(error)")
            }
        }
        
        
        // Dismiss the GMSAutocompleteViewController when something is selected
        dismiss(animated: true, completion: nil)
        
        
        
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // Handle the error
        print("Error: ", error.localizedDescription)
    }
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        // Dismiss when the user canceled the action
        dismiss(animated: true, completion: nil)
    }
    
    
}



