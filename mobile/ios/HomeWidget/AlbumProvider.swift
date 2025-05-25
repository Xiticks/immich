import WidgetKit
import AppIntents

struct Album: AppEntity {
  let id: String
  let name: String
  
  static var typeDisplayRepresentation: TypeDisplayRepresentation = "Album"
  var displayRepresentation: DisplayRepresentation {
    DisplayRepresentation(title: "\(name)")
  }
  static var defaultQuery = AlbumQuery()
  
  static let Random = Album(id: "random", name: "Random")
}

struct AlbumQuery: EntityQuery {
  func entities(for identifiers: [Album.ID]) async throws -> [Album] {
    []
  }
  
  func suggestedEntities() async throws -> [Album] {
    [Album.Random, Album(id: "123", name: "Test")]
  }
  
  func defaultResult() async -> Album? {
    Album.Random
  }
}

struct AlbumConfigurationIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Album" }
    static var description: IntentDescription { "Choose an album to shuffle throughout the day." }

    @Parameter(title: "Album", default: Album.Random)
    var album: Album
}

struct AssetEntry: TimelineEntry {
    let date: Date
    let albumId: String?
    let path: String?
  
    init(date: Date, albumId: String? = nil, path: String? = nil)
    {
      self.date = date
      self.albumId = albumId
      self.path = path
    }
}

struct AlbumProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> AssetEntry {
      AssetEntry(date: .now)
    }

    func snapshot(for configuration: AlbumConfigurationIntent, in context: Context) async -> AssetEntry {
      AssetEntry(date: .now, albumId: configuration.album.id)
    }
    
    func timeline(for configuration: AlbumConfigurationIntent, in context: Context) async -> Timeline<AssetEntry> {
        var entries: [AssetEntry] = []

        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
          let entry = AssetEntry(date: entryDate, albumId: configuration.album.id)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}
