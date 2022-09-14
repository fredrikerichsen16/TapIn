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
    }
    
//    func getSong() -> AVAudioPlayer? {
//        let songIndex = Array(0..<numberOfSongsInChannel).randomElement()!
//        print("--------- !!! \(keyname)-\(songIndex)")
//        guard let songData = NSDataAsset(name: "\(keyname)-\(songIndex)", bundle: Bundle.main)?.data else {
//            print("FAEN I HELVETE!")
//            return nil
//        }
//        return try? AVAudioPlayer(data: songData)
//    }
    
    func getSong() -> AVAudioPlayer? {
        let songIndex = Array(0..<numberOfSongsInChannel).randomElement()!
        print("\(keyname)-\(songIndex).mp3")
        let path = Bundle.main.path(forResource: "\(keyname)-\(songIndex)", ofType: "mp3")!
        let url = URL(fileURLWithPath: path)
        
        return try? AVAudioPlayer(contentsOf: url)
    }
    
    //func getNextSong() throws -> AVAudioPlayer {
    //    var songIndexes = Array(0..<radioChannel.numberOfSongsInChannel)
    //
    //    if let lastPlayed = radioChannel.lastPlayedSongIndex,
    //       let index = songIndexes.firstIndex(of: lastPlayed) {
    //        songIndexes.remove(at: index)
    //    }
    //
    //    guard let songToPlay = songIndexes.randomElement(),
    //          let songData = NSDataAsset(name: "\(radioChannel.keyname)-\(songToPlay)")?.data
    //    else {
    //        throw NSError(domain: "RadioPlayer", code: 1)
    //    }
    //
    //    let audioPlayer = try! AVAudioPlayer(data: songData)
    //
    //    return audioPlayer
    //}

}



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

//static let radioChannels: [String: String] = [
//    "Relaxing Piano": "piano",
//    "Lofi Beats": "lofi",
//    "Techno Bops": "techno",
//    "Jazzy Jazz": "jazz"
//]
//
//func getNextSong() throws -> AVAudioPlayer {
//    var songIndexes = Array(0..<radioChannel.numberOfSongsInChannel)
//
//    if let lastPlayed = radioChannel.lastPlayedSongIndex,
//       let index = songIndexes.firstIndex(of: lastPlayed) {
//        songIndexes.remove(at: index)
//    }
//
//    guard let songToPlay = songIndexes.randomElement(),
//          let songData = NSDataAsset(name: "\(radioChannel.keyname)-\(songToPlay)")?.data
//    else {
//        throw NSError(domain: "RadioPlayer", code: 1)
//    }
//
//    let audioPlayer = try! AVAudioPlayer(data: songData)
//
//    return audioPlayer
//}
