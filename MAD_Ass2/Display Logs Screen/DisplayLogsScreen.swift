//
//  DisplayLogsScreen.swift
//  MAD_Ass2
//
//  Created by Lee Espiritu on 6/2/2024.
//

import UIKit

class DisplayLogsScreen: UIViewController, UITableViewDelegate, UITableViewDataSource, LogsTableViewCellDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Add custom navbar
        view.addSubview(CustomNavBar(title: "Display Logs"))
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    

    @IBAction func goBackPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DBManager.getNumRows(entityName: "WorkoutRecord")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "logCell") as! LogsTableViewCell
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = tableView.dequeueReusableCell(withIdentifier: "logCell") as! LogsTableViewCell
        return cell.bounds.height
    }

    func didPressTakePhotoButton(in cell: LogsTableViewCell) {
        print("Hello")
    }

    
}
