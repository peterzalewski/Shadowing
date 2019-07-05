//
//  MediaTargetProvider.swift
//  Shadowing
//
//  Created by Pete Zalewski on 6/29/19.
//  Copyright © 2019 Pete Zalewski. All rights reserved.
//

import Foundation

class MediaTargetProvider {
    static func localTargets() -> [MediaTarget] {
        if let audioFiles = Bundle.main.urls(forResourcesWithExtension: "mp3", subdirectory: nil) {
            return audioFiles.map {
                url in
                let data = try! Data(contentsOf: url)
                let id3Tag = ID3Tag.from(data)
                return MediaTarget(author: id3Tag?[.LeadArtist], title: id3Tag?[.Title], audioLocation: url, textLocation: url)
            }
        }
        return []
    }
}
