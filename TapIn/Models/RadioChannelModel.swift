//
//  RadioChannelModel.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 02/09/2022.
//

import Foundation


struct RadioChannelModel {
    var keyname: String
    var label: String
    var numberOfSongsInChannel: Int
    var lastPlayedSongIndex: Int?
    
    init(keyname: String, label: String) throws {
        self.keyname = keyname
        self.label = label
        
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
        self.lastPlayedSongIndex = nil
//
//        if let resourcePath = Bundle.main().resourcePath {
//            print(resourcePath)
//            do {
//                let temp = try FileManager.default().contentsOfDirectory(atPath: resourcePath)
//                print(temp)
//                let assetsPath = resourcePath + "/" + temp[6]
//                let temp2 = try FileManager.default().contentsOfDirectory(atPath: assetsPath)
//                print (temp2)
//            }
//            catch let error as NSError {
//                print(error)
//            }
//        }
    }
}

//static let radioChannels: [String: String] = [
//    "Relaxing Piano": "piano",
//    "Lofi Beats": "lofi",
//    "Techno Bops": "techno",
//    "Jazzy Jazz": "jazz"
//]
