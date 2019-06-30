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
                url in return MediaTarget(audio: url, text: url)
            }
        }
        return []
    }
}
