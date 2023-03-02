//
//  DocumentTableViewController.swift
//  EmojiArt
//
//  Created by Максим Митрофанов on 02.03.2023.
//

import UIKit

class DocumentTableViewController: UITableViewController {
    
    private var documents = ["One", "Two", "Three"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        documents += ["Untitled".iterated(for: documents)]
        tableView.reloadData()
    }
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documents.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentCellWithData", for: indexPath)
        var cellConfiguration = cell.defaultContentConfiguration()
        cellConfiguration.text = documents[indexPath.row]
        cell.contentConfiguration = cellConfiguration
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            documents.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
