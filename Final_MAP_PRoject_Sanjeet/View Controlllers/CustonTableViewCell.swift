//
//  CustonTableViewCell.swift
//  Final_MAP_PRoject_Sanjeet
//
//  Created by user205584 on 12/4/21.
//

import UIKit

class CustonTableViewCell: UITableViewCell {
    var city:String?{
        didSet{
            cityLabel.text = city
            fetchWeatherData(forCity: city)
        }
    }
    
    var activityIndicator:UIActivityIndicatorView?
    @IBOutlet weak var cityLabel: UILabel!
    
    let weatherBaseURL = "https://api.openweathermap.org/data/2.5/weather"
    let apiKey = "#API KEy"
    var weatherData:cityWeather?
    
    var imageURL:String?{
        if let weatherData = weatherData {
            return "http://openweathermap.org/img/wn/"+weatherData.weather[0].icon+"@2x.png"
        }
        else{
            return nil
        }
    }
    
    @IBOutlet weak var detailedLabel: UILabel!
    @IBOutlet weak var weatherLogoImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func fetchWeatherData(forCity city:String?){
        if let city = city {
            self.activityIndicator?.startAnimating()
            var urlcomponents = URLComponents(string: weatherBaseURL)
            urlcomponents?.queryItems = ["q":city,"appid":apiKey,].map{
                URLQueryItem(name: $0.key, value: $0.value)
            }
            
            if let url = urlcomponents?.url
            {
                apiNetworkService.shared.getDataFromURL(AtURL: url) {data in
                    let jsondecoder = JSONDecoder()
                    self.weatherData =  try? jsondecoder.decode(cityWeather.self, from: data)
                    self.setImage()
                }
            }
        }
    }
    
    func setImage(){
        if let url = self.imageURL
        {
            if let url = URL(string: url){
                apiNetworkService.shared.getDataFromURL(AtURL: url) {data  in
                    DispatchQueue.main.async {
                        self.detailedLabel.text = self.weatherData?.main.temp.description
                        self.weatherLogoImage.image = UIImage(data: data)
                        self.activityIndicator?.stopAnimating()
                        
                    }
                }
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
            
        // Configure the view for the selected state
    }
    
}
