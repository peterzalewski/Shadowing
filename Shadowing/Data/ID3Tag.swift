//
//  ID3Tag.swift
//  Shadowing
//
//  Created by Pete Zalewski on 6/29/19.
//  Copyright © 2019 Pete Zalewski. All rights reserved.
//

import Foundation

enum FrameType: String {
    case LeadArtist = "TP1"
    case Picture = "PIC"
    case Title = "TAL"
}

struct ID3Tag {
    private var info: [FrameType:String]
    
    subscript(frameType: FrameType) -> String? {
        return info[frameType]
    }
    
    // Ref.: https://github.com/beevik/id3/blob/master/docs/id3v2.2.txt
    static func from(_ data: Data) -> ID3Tag? {
        guard data.count > 10 else { return nil }
        guard data[0 ..< 3] == "ID3".data(using: .ascii) else { return nil }
        
        // Even ID3 minor versions carry breaking changes, so this only parses 2.2
        guard Int(data[3]) == 2 else { return nil }

        // For some reason, the highest bit in each byte of the ID3 tag size is ignored,
        // so we only shift by 7 instead of 8.
        let size = Int([6, 7, 8, 9].reduce(UInt32(0)) { ($0 << 7) | UInt32(data[$1]) })
        let tagEnd = size + 10

        var info = [FrameType:String]()
        var offset = 10

        while offset < tagEnd {
            // Some ID3 tags include null padding after the last frame. If found, skip to the end.
            guard data[offset] != 0 else {
                offset = tagEnd
                break
            }
            
            let frameIdentifier = String(data: data[offset ..< offset + 3], encoding: .ascii)!
            let frameSize = Int(data[offset + 3 ..< offset + 6].reduce(UInt32(0)) { ($0 << 8) | UInt32($1) })
            let frameEnd = offset + frameSize + 5
            
            if let frameType = FrameType(rawValue: frameIdentifier) {
                switch frameType {
                case .LeadArtist, .Title:
                    info[frameType] = String(data: data[offset + 7 ..< frameEnd], encoding: .ascii)!
                default:
                    print("Found frame type: \(frameType) at offset: \(offset)")
                }
            } else {
                print("Unrecognized frame type: \(frameIdentifier)")
            }
            
            // Move to next frame
            offset = frameEnd + 1
        }

        return ID3Tag(info: info)
    }
}
