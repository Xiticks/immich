import WidgetKit
import SwiftUI

struct AlbumPlaceholderView: View {
  var body: some View {
    VStack  {
      Image(systemName: "photo.on.rectangle.angled.fill")
          .symbolRenderingMode(.hierarchical)
          .resizable()
          .frame(maxWidth: 50, maxHeight: 50)
          .foregroundColor(.gray)
          
        Text("Select an Album")
            .font(.headline)
            .foregroundColor(.primary)
            .multilineTextAlignment(.center)
        Text("Tap to configure")
            .font(.caption)
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
    }
  }
}

struct AlbumWidgetView : View {
    var entry: AlbumProvider.Entry

    var body: some View {
      ZStack() {
        if let _ = entry.albumId {
          if let path = entry.path,
           let uiImage = UIImage(contentsOfFile: path) {
          AssetView(image: uiImage)
        } else {
          PlaceholderView()
        }
        } else {
          AlbumPlaceholderView()
        }
      }
    }
}

struct AlbumWidget: Widget {
    let kind: String = "AlbumWidget"

    var body: some WidgetConfiguration {
    
        AppIntentConfiguration(kind: kind, intent: AlbumConfigurationIntent.self, provider: AlbumProvider()) { entry in
          AlbumWidgetView(entry: entry)
                .containerBackground(.ultraThickMaterial, for: .widget)
        }
    }
}


#Preview(as: .systemSmall) {
  AlbumWidget()
} timeline: {
  AssetEntry(date: .now)
  AssetEntry(date: .now, albumId: "Im:Fav")
  AssetEntry(date: .now, albumId: "Im:Fav", path: "<3")
}
