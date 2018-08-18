//
//  AboutUsViewController.swift
//  AimForThat2018
//
//  Created by Oscar Odon on 10/06/2018.
//  Copyright © 2018 Oscar Odon. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = Bundle.main.url(forResource: "AimForThat", withExtension: "html") {
            
            if let htmlData = try? Data(contentsOf: url) {
                
                let baseURL = URL(fileURLWithPath: Bundle.main.bundlePath)
                self.webView.load(htmlData, mimeType: "text/html", textEncodingName: "UTF-8", baseURL: baseURL)
                
            }
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func backPressed() {
        dismiss(animated: true, completion: nil)
    }

}
