//
//  RadioChannelModel.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 02/09/2022.
//

import Foundation
import AVKit

struct RadioChannelModel {
    var keyname: String
    var label: String
    var numberOfSongsInChannel: Int
    let image: String
    
    init(keyname: String, label: String, image: String) throws {
        self.keyname = keyname
        self.label = label
        self.image = image
        
        if let resourcePath = Bundle.main.resourcePath,
           let assets = try? FileManager.default.contentsOfDirectory(atPath: resourcePath)
        {
            print(assets)
        }
        else
        {
            throw NSError(domain: "RadioChannelModel", code: -1)
        }
        
        self.numberOfSongsInChannel = 2
    }
    
    func getSong() -> AVAudioPlayer? {
        let songIndex = Array(0..<numberOfSongsInChannel).randomElement()!
        guard let url = Bundle.main.url(forResource: "\(keyname)-\(songIndex)", withExtension: "mp3") else {
            return nil
        }
        
        return try? AVAudioPlayer(contentsOf: url)
    }

}
