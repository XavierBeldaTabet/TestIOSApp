//
//  DetailViewController.swift
//  TestAppIOS
//
//  Created by Admin on 18/02/2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var title_label: UILabel!
       @IBOutlet weak var year_label: UILabel!
       @IBOutlet weak var release_label: UILabel!
       @IBOutlet weak var runtime_label: UILabel!
       @IBOutlet weak var genre_label: UILabel!
       @IBOutlet weak var icon: UIImageView!
       @IBOutlet weak var web_label: UILabel!
     
       @IBOutlet weak var sinopsis_text_field: UILabel!
       
       var title_text: String?
       var year_text: String?
       var release_text: String?
       var runtime_text: String?
       var genre_text: String?
       var icon_image: UIImage?
       var web_text: String?
       var sinopsis_text : String?
       
       
       override func viewDidLoad() {
           super.viewDidLoad()
        title_label.text = NSLocalizedString("title", comment: "") + (title_text ?? "")
        year_label.text =  NSLocalizedString("year", comment: "") + (year_text ?? "")
        release_label.text = NSLocalizedString("release", comment: "") + (release_text ?? "")
        runtime_label.text = NSLocalizedString("runtime", comment: "") + (runtime_text ?? "")
        genre_label.text = NSLocalizedString("genre", comment: "") + (genre_text ?? "")
           icon.image = icon_image
        web_label.text = NSLocalizedString("web", comment: "") + (web_text ?? "")
        sinopsis_text_field.text = NSLocalizedString("plot", comment: "") + (sinopsis_text ?? "")
           add_tap_to_web_label()
       }
       
       func add_tap_to_web_label(){
        if web_text != nil{
           let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.web_label_tapped(_:)))
           
           self.web_label.isUserInteractionEnabled = true
           self.web_label.addGestureRecognizer(labelTap)
        }
       }
       
       @objc func web_label_tapped(_ sender: UITapGestureRecognizer){
           let objectsToShare = [web_text] as [Any]
           let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
           activityVC.excludedActivityTypes = []
           self.present(activityVC, animated: true, completion: nil)
       }
       
       @IBAction func back_btn(_ sender: Any) {
           self.dismiss(animated: true)
       }
}
