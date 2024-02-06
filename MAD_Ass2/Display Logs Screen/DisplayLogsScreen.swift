//
//  DisplayLogsScreen.swift
//  MAD_Ass2
//
//  Created by Lee Espiritu on 6/2/2024.
//

import UIKit

class DisplayLogsScreen: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //Add custom navbar
        view.addSubview(CustomNavBar(title: "Display Logs"))
    }
    

    @IBAction func goBackPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
