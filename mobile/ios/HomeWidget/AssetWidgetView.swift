import SwiftUI

struct AssetView : View {
  var image: UIImage
  
  var body: some View {
    ZStack() {
      Color(uiColor: .systemBackground)
      
      Image(uiImage: image)
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipped()
    }
  }
}


struct PlaceholderView: View {
  var body: some View {
    GeometryReader {
      reader in
      
      VStack {
        Spacer()
        HStack {
          VStack(alignment: .leading) {
            
            RoundedRectangle(cornerRadius: 6)
              .fill(Color(.systemGray4))
              .frame(width: reader.size.width * 0.65, height: 20)
            
            RoundedRectangle(cornerRadius: 6)
              .fill(Color(.systemGray4))
              .frame(width:  reader.size.width * 0.3, height: 15)
          }.padding([.leading, .bottom], 5)
          Spacer()
        }
      }
    }.edgesIgnoringSafeArea(.all)
  }
}
