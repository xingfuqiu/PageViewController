//
//  TableViewController.swift
//  test
//
//  Created by XingfuQiu on 2017/7/18.
//  Copyright © 2017年 XingfuQiu. All rights reserved.
//

import UIKit

protocol TableViewControllerDelegate{
    func tableViewDidScrollPassY(_ tableviewScrollY:CGFloat)
}

class TableViewController: UITableViewController {
    
    var delegate: TableViewControllerDelegate?
    var sign: String!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("\(sign) in viewWillAppear")
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("\(sign) in viewWillDisappear")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(sign) in viewDidLoad")
    }
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.delegate?.tableViewDidScrollPassY(scrollView.contentOffset.y)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 20
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = "\(indexPath.row)"
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

}
