//
//  MediaTargetTableViewController.swift
//  Shadowing
//
//  Created by Pete Zalewski on 6/29/19.
//  Copyright © 2019 Pete Zalewski. All rights reserved.
//

import Foundation
import UIKit

class MediaTargetTableViewController : UITableViewController {
    var mediaTargets: [MediaTarget]!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mediaTargets = MediaTargetProvider.localTargets()
    }
}

extension MediaTargetTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mediaTargets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MediaTarget", for: indexPath)
        let mediaTarget = mediaTargets[indexPath.row]
        cell.textLabel?.text = mediaTarget.title ?? mediaTarget.audioLocation.path
        cell.detailTextLabel?.text = mediaTarget.author
        return cell
    }
}
