import SwiftUI
import RealmSwift

fileprivate let channels: [RadioChannel] = [
    RadioChannel(key: "LofiBeats", title: "Lofi Beats", songs: [
        RadioSong(file: "song-1", title: "Joy Ride", singer: "Aves"), // v
        RadioSong(file: "song-2", title: "Old Sneakers", singer: "Cosmonkey"), // v
        RadioSong(file: "song-3", title: "Passionate Choices", singer: "Mansij"),
        RadioSong(file: "song-4", title: "Loose Tension", singer: "Reel Life"), // v
        RadioSong(file: "song-5", title: "See For Your Shelf Instrumental", singer: "Sam Barsh"), // v
        RadioSong(file: "song-6", title: "Cafe Radio", singer: "Nu Alkemi$t"), // v
        RadioSong(file: "song-7", title: "Low Fidelity", singer: "Tide Electric"), // v
        RadioSong(file: "song-8", title: "Lavender", singer: "VAULTZ"), // v
        RadioSong(file: "song-9", title: "Cloud Pillow", singer: "Neon Beach"), // v
        RadioSong(file: "song-10", title: "Wise As A Serpent", singer: "Ghost Beatz"), // v
        RadioSong(file: "song-11", title: "Will You Dance with Me", singer: "Lalinea"), // v
        RadioSong(file: "song-12", title: "By My Side", singer: "K. Solis"), // v
        RadioSong(file: "song-13", title: "Marigolds in May", singer: "Jamie Bathgate"), // v
        RadioSong(file: "song-14", title: "Café de Paris", singer: "MILANO") // v
    ]),
    RadioChannel(key: "TechnoBops", title: "Techno Bops", songs: [
        RadioSong(file: "song-1", title: "nuer self", singer: "Far Away"), // v
        RadioSong(file: "song-2", title: "Neon Affair", singer: "Notize"), // v
        RadioSong(file: "song-3", title: "X-Lover", singer: "Thee Alchemist Oxford"), // v
        RadioSong(file: "song-4", title: "Focuser", singer: "Neon Beach"), // v
        RadioSong(file: "song-5", title: "How You Do", singer: "BRASKO"), // v
        RadioSong(file: "song-6", title: "Open Your Eyes", singer: "Basketcase"), // v
        RadioSong(file: "song-7", title: "In Your Atmosphere", singer: "Nu Alkemi$t"), // v
        RadioSong(file: "song-8", title: "Cloud City", singer: "Neon Beach"), // v
        RadioSong(file: "song-9", title: "Stargirl", singer: "élise"), // v
        RadioSong(file: "song-10", title: "Spacewalk", singer: "Reveille"), // v
        RadioSong(file: "song-11", title: "Glasgow", singer: "Falls"), // v
        RadioSong(file: "song-12", title: "Raw Aesthetic", singer: "Falls"), // v
        RadioSong(file: "song-13", title: "Outrun", singer: "Aardverk"), // v
        RadioSong(file: "song-14", title: "Status", singer: "Jamie Bathgate") // v
    ]),
    RadioChannel(key: "Classical", title: "Classical", songs: [
        RadioSong(file: "song-1", title: "Ballerina", singer: "Yehezkel Raz"), // v
        RadioSong(file: "song-2", title: "Presence", singer: "Aija Alsina"), // v
        RadioSong(file: "song-3", title: "Belonging", singer: "Muted"), // v
        RadioSong(file: "song-4", title: "Air on a G String (Bach)", singer: "Ian Post"), // v
        RadioSong(file: "song-5", title: "Gymnopédie no. 1", singer: "Romi Kopelman"), // v
        RadioSong(file: "song-6", title: "Bachs Cello Suite - Reimagined", singer: "Ardie Son"), // v
        RadioSong(file: "song-7", title: "Moonlight Sonata - Mvt. 1 (Beethoven)", singer: "Brooklyn Classical"), // v
        RadioSong(file: "song-8", title: "Paris", singer: "Daniel Robinson"), // v
        RadioSong(file: "song-9", title: "Canon in D Major - (Pachelbel) - Instrumental Version", singer: "Ian Post"), // v
        RadioSong(file: "song-10", title: "Gnossienne no. 1", singer: "Romi Kopelman"), // v
        RadioSong(file: "song-11", title: "Für Elise (Beethoven)", singer: "Brooklyn Classical"), // v
        RadioSong(file: "song-12", title: "Flower Duet (Lakmé)", singer: "Hawkins"), // v
        RadioSong(file: "song-13", title: "Dear Frédéric", singer: "Elise Solberg"), // v
        RadioSong(file: "song-14", title: "Canon in D", singer: "Amanda Welch"), // v
        RadioSong(file: "song-15", title: "Dawning Sprite", singer: "Lincoln Davis"), // v
        RadioSong(file: "song-16", title: "High Class Klaus", singer: "Wild Wonder"), // v
    ]),
    RadioChannel(key: "JazzyJazz", title: "Smooth Jazz", songs: [
        RadioSong(file: "song-1", title: "Lucky Me", singer: "Cast Of Characters"), // v
        RadioSong(file: "song-2", title: "What's the Big Deal", singer: "Ryan Saranich"), // v
        RadioSong(file: "song-3", title: "Lazy Evenings", singer: "Sam Barsh"), // v
        RadioSong(file: "song-4", title: "les rues la nuit seul", singer: "Renderings"), // v
        RadioSong(file: "song-5", title: "Sunny Side Up", singer: "The Night Train"), // v
        RadioSong(file: "song-6", title: "What A Gal", singer: "The Night Train"), // v
        RadioSong(file: "song-7", title: "Secret Agent T.", singer: "T. Bless & the Professionals"), // v
        RadioSong(file: "song-8", title: "Richard Goes Stompin", singer: "Ziv Grinberg"), // v
        RadioSong(file: "song-9", title: "Arak Deluxe", singer: "David Gives"), // v
        RadioSong(file: "song-10", title: "Morning in the Rain", singer: "Mark Yencheske") // v
    ]),
    RadioChannel(key: "Dramatic", title: "Dramatique", songs: [
        RadioSong(file: "song-1", title: "Still Life", singer: "ANBR"), // v
        RadioSong(file: "song-2", title: "Muted", singer: "Zoom Out"), // v
        RadioSong(file: "song-3", title: "Zaphenath-Paneah", singer: "Quinten Coblentz"), // v
        RadioSong(file: "song-4", title: "Illusion", singer: "Cody Martin"), // v
        RadioSong(file: "song-5", title: "Building A Fort", singer: "Cody Martin"), // v
        RadioSong(file: "song-6", title: "Lore", singer: "Wicked Cinema"), // v
        RadioSong(file: "song-7", title: "With You Always", singer: "Moments"), // v
        RadioSong(file: "song-8", title: "Penumbra", singer: "EFGR"), // v
    ]),
    RadioChannel(key: "ChristmasJingles", title: "Christmas Jingles", songs: [
        RadioSong(file: "song-1", title: "Silent Night", singer: "The Dandelions"), // v
        RadioSong(file: "song-2", title: "Winter Wonder", singer: "Cast Of Characters"), // v
        RadioSong(file: "song-3", title: "Auld Lang Syne", singer: "Elise Solberg"), // v
        RadioSong(file: "song-4", title: "We Wish You A Merry Christmas", singer: "Ryan Saranich"), // v
        RadioSong(file: "song-5", title: "Christmas Shopping", singer: "Adam Saban"), // v
        RadioSong(file: "song-6", title: "Silent Night", singer: "Ghost Beatz"), // v
        RadioSong(file: "song-7", title: "O' Holy Night (A Lullaby)", singer: "Alternate Endings"), // v
        RadioSong(file: "song-8", title: "Deck the Halls", singer: "Duffmusiq"), // v
    ]),
]

final class RadioState: WorkspaceComponentViewModel {
    
    // MARK: Main properties
    
    @IndexingCollection(collectionLength: channels.count)
    private var currentChannelIndex: Int = 0 {
        didSet {
            currentChannel = channels[currentChannelIndex]
            UserDefaultsManager.main.radioChannelIndex = currentChannelIndex
        }
    }
    
    @Published var currentChannel: RadioChannel
    
    private var player: RadioPlayer? = nil
    
    // MARK: Init
    
    init(workspace: WorkspaceDB) {
        let currentChannelIndex = UserDefaultsManager.main.radioChannelIndex
        self.currentChannelIndex = currentChannelIndex
        self.currentChannel = channels[currentChannelIndex]
        
        super.init(workspace: workspace, realm: RealmManager.shared.realm, component: .radio)
        
        initializePlayer()
    }
    
    // MARK: Changing channel
    
    func goToPrevChannel() {
        currentChannelIndex -= 1
        self.initializePlayer()
    }
    
    func goToNextChannel() {
        currentChannelIndex += 1
        self.initializePlayer()
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
        self.player = RadioPlayer(channel: currentChannel, isPlaying: isActive)
    }
    
    deinit {
        print("WAS DEINITIALIZED")
    }
}
