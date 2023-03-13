//
//  GalleryTabsViewController.swift
//  Image Gallery
//
//  Created by Максим Митрофанов on 13.03.2023.
//

import UIKit

class GalleryTabsViewController: UITableViewController {
    
    var pinnedGalleries = [String]()
    var galleries = ["Animals", "Sports", "Programming"]
    var recentlyDeleted = ["Farm", "Planets"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return pinnedGalleries.count }
        else if section == 1 { return galleries.count }
        else { return recentlyDeleted.count }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GalleryCell", for: indexPath)
        
        //Pinned Galleries
        if indexPath.section == 0 {
            var cellConfig = UIListContentConfiguration.cell()
            cellConfig.text = pinnedGalleries[indexPath.row]
            cell.contentConfiguration = cellConfig
        }
        
        //Standard Gallery
        else if indexPath.section == 1 {
            var cellConfig = UIListContentConfiguration.cell()
            cellConfig.text = galleries[indexPath.row]
            cell.contentConfiguration = cellConfig
        }

        //Recently deleted
        else {
            var cellConfig = UIListContentConfiguration.cell()
            cellConfig.text = recentlyDeleted[indexPath.row]
            cell.contentConfiguration = cellConfig
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 { return "Pinned"}
        else if section == 1 { return "Your Galleries"}
        else { return "Recently Deleted" }
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && indexPath.section == 1 {
            tableView.performBatchUpdates {
                let rowTitle = galleries[indexPath.row]
                galleries.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                recentlyDeleted = [rowTitle] + recentlyDeleted
                tableView.insertRows(at: [IndexPath(row: 0, section: 2)], with: .top)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let recoverGalleryAction = createRecoverSwipeAction(using: indexPath)
        let deleteForeverAction = createDeleteForeverSwipeAction(using: indexPath)
        let configuration = UISwipeActionsConfiguration(actions: [recoverGalleryAction, deleteForeverAction])
        
        if indexPath.section == 0 { return UISwipeActionsConfiguration(actions: []) }
        else if indexPath.section == tableView.numberOfSections - 1 { return configuration }
        else { return nil }
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let pinGalleryAction = createPinGallerySwipeAction(using: indexPath)
        let unpinGalleryAction = createUnpinGalleryAction(using: indexPath)
        
        if indexPath.section == 0 { return UISwipeActionsConfiguration(actions: [unpinGalleryAction])}
        else if indexPath.section == 1 { return UISwipeActionsConfiguration(actions: [pinGalleryAction]) }
        else { return nil }
    }

    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let removedItem = galleries.remove(at: fromIndexPath.row)
        galleries.insert(removedItem, at: to.row)
    }

    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 1 { return true }
        else { return false }
    }
    
    // Bar button actions
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        tableView.isEditing.toggle()
    }
    
    @IBAction func plusButtonPressed(_ sender: UIBarButtonItem) {
        galleries.append("New Gallery".madeUnique(withRespectTo: galleries))
        tableView.insertRows(at: [IndexPath(row: galleries.count - 1, section: 1)], with: .bottom)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension GalleryTabsViewController {
    private func createRecoverSwipeAction(using indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: nil) { [weak self] (action, view, handler) in
            self?.tableView.performBatchUpdates {
                if let rowTitle = self?.recentlyDeleted[indexPath.row] {
                    self?.recentlyDeleted.remove(at: indexPath.row)
                    self?.tableView.deleteRows(at: [indexPath], with: .fade)
                    
                    self?.galleries.append(rowTitle)
                    self?.tableView.insertRows(at: [IndexPath(row: (self?.galleries.count)! - 1, section: 1)], with: .bottom)
                }
            }
            handler(true)
        }
        action.image = UIImage(systemName: "arrow.up.bin")
        action.backgroundColor = .systemGreen
        
        return action
    }
    
    private func createDeleteForeverSwipeAction(using indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: nil) { [weak self] (action, view, handler) in
            self?.tableView.performBatchUpdates {
                self?.recentlyDeleted.remove(at: indexPath.row)
                self?.tableView.deleteRows(at: [indexPath], with: .fade)
            }
            handler(true)
        }
        action.image = UIImage(systemName: "trash")
        action.backgroundColor = .systemRed
        
        return action
    }
    
    private func createPinGallerySwipeAction(using indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: nil) { [weak self] (action, view, handler) in
            self?.tableView.performBatchUpdates {
                guard let itemTitle = self?.galleries[indexPath.row] else { return }
                self?.pinnedGalleries.append(itemTitle)
                
                guard let pinnedRowsCount = self?.pinnedGalleries.count else { return }
                if pinnedRowsCount == 0 {
                    self?.tableView.insertRows(at: [IndexPath(row: pinnedRowsCount , section: 0)], with: .bottom)
                } else {
                    self?.tableView.insertRows(at: [IndexPath(row: pinnedRowsCount - 1, section: 0)], with: .bottom)
                }
                
                self?.galleries.remove(at: indexPath.row)
                self?.tableView.deleteRows(at: [indexPath], with: .bottom)
                
            }
        }
        
        action.image = UIImage(systemName: "pin")
        action.backgroundColor = .systemYellow
        
        return action
    }
    
    private func createUnpinGalleryAction(using indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: nil) { [weak self] (action, view, handler) in
            self?.tableView.performBatchUpdates {
                guard let itemTitle = self?.pinnedGalleries[indexPath.row] else { return }
                self?.galleries.append(itemTitle)
                
                guard let galleriesCount = self?.galleries.count else { return }
                
                if galleriesCount == 0 {
                    self?.tableView.insertRows(at: [IndexPath(row: galleriesCount , section: 1)], with: .top)
                } else {
                    self?.tableView.insertRows(at: [IndexPath(row: galleriesCount - 1, section: 1)], with: .top)
                }
                
                self?.pinnedGalleries.remove(at: indexPath.row)
                self?.tableView.deleteRows(at: [indexPath], with: .top)
            }
        }
        
        action.image = UIImage(systemName: "pin.slash")
        action.backgroundColor = .systemGray
        
        return action
    }
}
