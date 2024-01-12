import SwiftUI
import RealmSwift
import Factory
import AVKit

 protocol SimpleAudioPlayerDelegate {
     func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool)
 }

final class RadioState: WorkspaceComponentViewModel, SimpleAudioPlayerDelegate {
    @Published var radioStatus = RadioStatus()
    
    private var player: RadioPlayer? = nil
    
    // MARK: Init
    
    init(workspace: WorkspaceDB, componentActivityTracker: ComponentActivityTracker) {
        let realm = Container.shared.realmManager.callAsFunction().realm
        super.init(workspace: workspace, realm: realm, componentActivityTracker: componentActivityTracker, component: .radio)
        
        initializePlayer()
    }
    
    // MARK: UI Properties

     var channelTitle: String {
         radioStatus.currentChannel.title
     }

     var songAndArtist: String {
         radioStatus.currentSong.title + " - " + radioStatus.currentSong.singers.joined(separator: ", ")
     }
    
    // MARK: Changing channel
    
    func goToPrevChannel() {
        radioStatus.currentChannelIndex -= 1
        radioStatus.changeSong()
        initializePlayer()
    }
    
    func goToNextChannel() {
        radioStatus.currentChannelIndex += 1
        radioStatus.changeSong()
        initializePlayer()
    }
    
    // MARK: Stop and start session
    
    override func startSession() {
        super.startSession()
        player?.play()
    }
    
    override func endSession() {
        super.endSession()
        player?.pause()
    }
    
    private func initializePlayer() {
        player = RadioPlayer(song: radioStatus.currentSong, isPlaying: isActive, delegate: self)
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
         radioStatus.changeSong()
         initializePlayer()
     }
    
    deinit {
        print("WAS DEINITIALIZED")
    }
}


struct RadioStatus {
     @IndexingCollection(collectionLength: channels.count)
     var currentChannelIndex: Int = 0 {
         didSet {
             currentChannel = channels[currentChannelIndex]
             UserDefaultsManager.standard.radioChannelIndex = currentChannelIndex
         }
     }

     var currentChannel: RadioChannel
     var currentSong: RadioSong

     mutating func changeSong() {
         currentSong = currentChannel.getNextSong()
     }

     init() {
         let currentChannelIndex = UserDefaultsManager.standard.radioChannelIndex
         self.currentChannelIndex = currentChannelIndex
         self.currentChannel = channels[currentChannelIndex]
         self.currentSong = currentChannel.getNextSong()
     }
 }

 fileprivate let channels: [RadioChannel] = [
     RadioChannel(key: "Lofi", title: "Lofi Beats", songs: [
         RadioSong(file: "vaozhosgroidfettkgfigdzk", title: "Joy Ride", singer: "Aves"),
         RadioSong(file: "blitfcxhmlbxwchsusiqnuyz", title: "Old Sneakers", singer: "Cosmonkey"),
         RadioSong(file: "hwmifymusyozhrjduusvgfjq", title: "Passionate Choices", singer: "Mansij"),
         RadioSong(file: "ikunvsrjlfhptmduqcsxqexv", title: "Loose Tension", singer: "Reel Life"),
         RadioSong(file: "bmccozfrqodcqmgfthulcaxg", title: "See For Your Shelf Instrumental", singer: "Sam Barsh"),
         RadioSong(file: "hovnasgzbqidmeozxcdeztrm", title: "Cafe Radio", singer: "Nu Alkemi$t"),
         RadioSong(file: "rxabgfxeurihhzsyajundxcy", title: "Low Fidelity", singer: "Tide Electric"),
         RadioSong(file: "ydrpsnsjcixxmfujnurhmczx", title: "Lavender", singer: "VAULTZ"),
         RadioSong(file: "lhvqkhyjvancdvlxybwfkpuw", title: "Cloud Pillow", singer: "Neon Beach"),
         RadioSong(file: "ofhlslwlodmdauingboqhvpu", title: "Wise As A Serpent", singer: "Ghost Beatz"),
         RadioSong(file: "sidkhvwbhuvxfsapoobisnwc", title: "Will You Dance with Me", singer: "Lalinea"),
         RadioSong(file: "gbxjfgkhmttmmpakwkcfaene", title: "By My Side", singer: "K. Solis"),
         RadioSong(file: "uyafqvvolpdeeyymkhedrjww", title: "Marigolds in May", singer: "Jamie Bathgate"),
         RadioSong(file: "zfagohpuifdlcrmpvgalyuxw", title: "Café de Paris", singer: "MILANO")
     ]),
     RadioChannel(key: "Techno", title: "Techno Bops", songs: [
         RadioSong(file: "vccjxzbfdschuvbuqkdllcwb", title: "nuer self", singer: "Far Away"),
         RadioSong(file: "hgyemgokctpyjyiuplfocicb", title: "Neon Affair", singer: "Notize"),
         RadioSong(file: "cvzkmppwrcxndvotmtfsvwnt", title: "X-Lover", singer: "Thee Alchemist Oxford"),
         RadioSong(file: "pvwuwxtpjryxchnwcxwyuwkg", title: "Focuser", singer: "Neon Beach"),
         RadioSong(file: "qlgylxyvphvvwzcqssnhktwc", title: "How You Do", singer: "BRASKO"),
         RadioSong(file: "agqterkpdkcfolasefqsvnvz", title: "Open Your Eyes", singer: "Basketcase"),
         RadioSong(file: "fjlniiakiaxvxxhvdebnljxb", title: "In Your Atmosphere", singer: "Nu Alkemi$t"),
         RadioSong(file: "riwcrppbhymzxrqdssdvlcsy", title: "Cloud City", singer: "Neon Beach"),
         RadioSong(file: "gdufnmawxlwjjzvswollcden", title: "Stargirl", singer: "élise"),
         RadioSong(file: "faeiotfzyuonexeuaugweawo", title: "Spacewalk", singer: "Reveille"),
         RadioSong(file: "gadlshalkhdifxxwyxsmpaom", title: "Glasgow", singer: "Falls"),
         RadioSong(file: "flzsnldnkrvnuoddhdnqpcga", title: "Raw Aesthetic", singer: "Falls"),
         RadioSong(file: "znwwvnsiflywcpffvmehkdyn", title: "Outrun", singer: "Aardverk"),
         RadioSong(file: "ixrcawmlcyorrexrgxuivgjz", title: "Status", singer: "Jamie Bathgate")
     ]),
     RadioChannel(key: "Classical", title: "Classical", songs: [
         RadioSong(file: "pxewffjzvdelqfboyoxnqqlc", title: "Ballerina", singer: "Yehezkel Raz"),
         RadioSong(file: "genlrozyotquvjpvhsujoqsm", title: "Presence", singer: "Aija Alsina"),
         RadioSong(file: "nlaamlluhwcsbbjkrheqmzjo", title: "Belonging", singer: "Muted"),
         RadioSong(file: "ioxbeymgmfjqsgnplynzrnkr", title: "Air on a G String (Bach)", singer: "Ian Post"),
         RadioSong(file: "xuthpknkufjpwgognurqwzfb", title: "Gymnopédie no. 1", singer: "Romi Kopelman"),
         RadioSong(file: "yyjupetgramxwzkcotocenzx", title: "Bachs Cello Suite - Reimagined", singer: "Ardie Son"),
         RadioSong(file: "bevthfrztnvhaoymiryingir", title: "Moonlight Sonata - Mvt. 1 (Beethoven)", singer: "Brooklyn Classical"),
         RadioSong(file: "ewkwzylwrghnhlidladwjhng", title: "Paris", singer: "Daniel Robinson"),
         RadioSong(file: "gkytorfewtqbrapynafosmog", title: "Canon in D Major - (Pachelbel) - Instrumental Version", singer: "Ian Post"),
         RadioSong(file: "swhqhddkywgtujzvfmnjemfv", title: "Gnossienne no. 1", singer: "Romi Kopelman"),
         RadioSong(file: "zmmdjdjppktytdhzvvosesxb", title: "Für Elise (Beethoven)", singer: "Brooklyn Classical"),
         RadioSong(file: "vdmlhkxmjkwvlwmmiaphxxqn", title: "Flower Duet (Lakmé)", singer: "Hawkins"),
         RadioSong(file: "xbdyrffnqkjgnrfbswyjrlse", title: "Dear Frédéric", singer: "Elise Solberg"),
         RadioSong(file: "hjulgydnoisbmgdirfnspiix", title: "Canon in D", singer: "Amanda Welch"),
         RadioSong(file: "pqtwqdshpmdyhhzctwovhusq", title: "Dawning Sprite", singer: "Lincoln Davis"),
         RadioSong(file: "qeqjyrqheematjffaervyccv", title: "High Class Klaus", singer: "Wild Wonder"),
     ]),
     RadioChannel(key: "Jazz", title: "Smooth Jazz", songs: [
         RadioSong(file: "mybqonivmgfhzzkzuyanrjdu", title: "Lucky Me", singer: "Cast Of Characters"),
         RadioSong(file: "segfwhssulgghtspiiblaauz", title: "What's the Big Deal", singer: "Ryan Saranich"),
         RadioSong(file: "kbzxnhlqnvesnmbgwsxudfyl", title: "Lazy Evenings", singer: "Sam Barsh"),
         RadioSong(file: "maplkztsgfxgifsglxflvunh", title: "les rues la nuit seul", singer: "Renderings"),
         RadioSong(file: "leyoeeqfuhirebsxduovbujc", title: "Sunny Side Up", singer: "The Night Train"),
         RadioSong(file: "dhfnymbhmraatuizsmfigcmj", title: "What A Gal", singer: "The Night Train"),
         RadioSong(file: "qklpmtczclklxhjuzusugvhp", title: "Secret Agent T.", singer: "T. Bless & the Professionals"),
         RadioSong(file: "vkggyujdxhwwnhvmwmnaginp", title: "Richard Goes Stompin", singer: "Ziv Grinberg"),
         RadioSong(file: "uymosmyyxxfkzrrcauhfwkge", title: "Arak Deluxe", singer: "David Gives"),
         RadioSong(file: "sruiylohotscviohogtqwvpn", title: "Morning in the Rain", singer: "Mark Yencheske"),
         RadioSong(file: "yizuyuvplzopromjoujsjlnd", title: "I've seen it all", singer: "Idokay"),
         RadioSong(file: "erdrpxxjoeitvvtmydsmpnhn", title: "Gymnopédie No. 1", singer: "T. Bless & the Professionals"),
     ]),
     RadioChannel(key: "Dramatic", title: "Dramatique", songs: [
         RadioSong(file: "gnxsdpvbnujzzsnrailnzeiv", title: "Still Life", singer: "ANBR"),
         RadioSong(file: "qlyhyberkjymrmsjpkhprkgl", title: "Muted", singer: "Zoom Out"),
         RadioSong(file: "mescbbanuztpluhzsxknebuk", title: "Zaphenath-Paneah", singer: "Quinten Coblentz"),
         RadioSong(file: "bpnrvlumegxmxaokftyxghio", title: "Illusion", singer: "Cody Martin"),
         RadioSong(file: "eplgkdxmnrxmcdvcofshadfd", title: "Building A Fort", singer: "Cody Martin"),
         RadioSong(file: "oqkymzchehblehpvcmzxmnyn", title: "Lore", singer: "Wicked Cinema"),
         RadioSong(file: "xmgjcysrhwakhbnsucdocuud", title: "With You Always", singer: "Moments"),
         RadioSong(file: "xafgbgbyogbraopabueaegsq", title: "Penumbra", singer: "EFGR"),
     ]),
     RadioChannel(key: "Christmas", title: "Christmas Jingles", songs: [
         RadioSong(file: "vtynjfrqqheaxlnxnvdrebcq", title: "Silent Night", singer: "The Dandelions"),
         RadioSong(file: "frzvzftzwljvkzmkkgjixvfv", title: "Winter Wonder", singer: "Cast Of Characters"),
         RadioSong(file: "yjuerlcxopynszqqfvpxctrr", title: "Auld Lang Syne", singer: "Elise Solberg"),
         RadioSong(file: "djxwexktgczyphjplzxwhhpg", title: "We Wish You A Merry Christmas", singer: "Ryan Saranich"),
         RadioSong(file: "xxksvjpulzgsyacudbqliqhf", title: "Christmas Shopping", singer: "Adam Saban"),
         RadioSong(file: "pknbspftqhykwbhpbbwfrlmq", title: "Silent Night", singer: "Ghost Beatz"),
         RadioSong(file: "ladamqdospqgkulpohwkbqnw", title: "O' Holy Night (A Lullaby)", singer: "Alternate Endings"),
         RadioSong(file: "kngyaajmkqrtutbsayvvzkjk", title: "Deck the Halls", singer: "Duffmusiq"),
     ]),
 ]
