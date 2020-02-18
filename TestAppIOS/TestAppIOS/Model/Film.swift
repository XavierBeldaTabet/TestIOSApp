//
//  Film.swift
//  TestAppIOS
//
//  Created by Admin on 18/02/2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import UIKit

struct JSON_Film: Codable{
    var Title:String
    var Year:String
    var Runtime:String
    var Genre:String
    var Plot:String
    var Poster:String
    var Website:String
    var Released:String
}

public class Film {
    let title:String?
    let image:UIImage?
    let year:String?
    let duration:String?
    let genre:String?
    let plot:String?
    let web:String?
    let release:String?
    
    init(title: String, image: UIImage, year: String, duration: String, genre: String, plot: String, web: String, release: String) {
        self.title = title
        self.image = image
        self.year = year
        self.duration = duration
        self.genre = genre
        self.plot = plot
        self.web = web
        self.release = release
    }
    init(json: JSON_Film) {
        self.title = json.Title
        self.year = json.Year
        self.duration = json.Runtime
        self.genre = json.Genre
        self.plot = json.Plot
        self.web = json.Website
        self.release = json.Released
        do{
            let icon_data = try Data(contentsOf: URL(string: json.Poster)!)
            self.image = UIImage(data: icon_data)
        }catch{
            self.image = UIImage(systemName: "film")
        }
    }
}
