//
//  ViewController.swift
//  TestAppIOS
//
//  Created by Admin on 18/02/2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    private var film:Film?

    @IBOutlet weak var film_info_view: UIView!
    @IBOutlet weak var title_label: UILabel!
    @IBOutlet weak var year_label: UILabel!
    @IBOutlet weak var image_icon: UIImageView!
    @IBOutlet weak var search_btn: UIButton!
    @IBOutlet weak var title_text_field: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        search_btn.makeRound()
        search_btn.addShadow()
        film_info_view.layer.cornerRadius = 20
        film_info_view.addShadow()
        add_tap_to_film_view()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func add_tap_to_film_view(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        film_info_view.addGestureRecognizer(tap)
    }

    func addSpinner() {
        let child_spinner = SpinnerViewController()
        // add the spinner view controller to the parent controller
        addChild(child_spinner)
        child_spinner.view.frame = view.frame
        view.addSubview(child_spinner.view)
        child_spinner.didMove(toParent: self)
//        wait for x seconds before dismiss
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // then remove the child controller
            child_spinner.willMove(toParent: nil)
            child_spinner.view.removeFromSuperview()
            child_spinner.removeFromParent()
        }
    }
    
//    MARK: Button listener
    
    @IBAction func search_title(_ sender: Any) {
//        spinner for representing some work is in progress
        self.addSpinner()
        if title_text_field.hasText{
            let title = title_text_field.text ?? ""
            request(text: title){
                [weak self] (Result) in
                switch Result{
                case .success(let data):
                    let json_data = try! JSONDecoder().decode(JSON_Film.self, from: data)
                    self!.film = Film.init(json: json_data)
                    self?.film_info_view.isHidden = false
                    self?.title_label.text = "Title: " + (self?.film?.title)!
                    self?.year_label.text = "Year: " + (self?.film?.year)!
                    self?.image_icon.image = self?.film?.image
                case .failure(let _):
                    let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
                    let cancel = UIAlertAction(title: "", style: .cancel, handler: nil)
                    alert.addAction(cancel)
                    self!.present(alert, animated: true, completion: nil)
                }
            }
        } else{
            let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "", style: .cancel, handler: nil)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
}

