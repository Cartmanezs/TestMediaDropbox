//
//  ViewController.swift
//  TestMediaDropBox
//
//  Created by Igor Palyvoda on 26.08.2023.
//

import UIKit
import SwiftyDropbox

class MediaMainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
        
    private var mediaFiles: [MediaFile] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    private let mediaNetworkManager = MediaNetworkManager.shared
        
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticateIfNeeded()
    }
    
    private func authenticateIfNeeded() {
        if DropboxClientsManager.authorizedClient != nil || DropboxClientsManager.authorizedTeamClient != nil {
            fetchAndDisplayMediaFiles()
            print("work")
        } else {
            print("Not authenticated")
            configureAuthenticate()
        }
    }
    
    private func configureAuthenticate() {
        DropboxClientsManager.authorizeFromController(UIApplication.shared, controller: self, openURL: {(url: URL) -> Void in
            UIApplication.shared.openURL(url)})
    }
    
    func fetchAndDisplayMediaFiles() {
//        loadNextPageIfNecessary()
        mediaNetworkManager.fetchMediaFiles { [weak self] mediaFiles in
             guard let self = self else { return }
             self.mediaFiles = mediaFiles
            self.tableView.reloadData()
         }
     }
}

extension MediaMainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mediaFiles.count 
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MediaCell", for: indexPath) as? MediaCell else {
            return UITableViewCell()
        }
        
        let mediaFile = mediaFiles[indexPath.row]
        cell.configure(with: mediaFile)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let selectedMediaFile = mediaFiles[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailViewController = storyboard.instantiateViewController(withIdentifier: "MediaDetailViewController") as? MediaDetailViewController {
            detailViewController.mediaFile = selectedMediaFile
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}
