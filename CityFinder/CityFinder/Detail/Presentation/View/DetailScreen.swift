import SwiftUI

struct DetailView: View {
    let city: City
    let onToggleFavorite: () -> Void
    @StateObject private var viewModel = CityDetailViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if let thumbnail = viewModel.cityDetail?.thumbnail, let imageURL = URL(string: thumbnail.source) {
                    AsyncImage(url: imageURL) { phase in
                        if case .success(let image) = phase {
                            RoundedRectangle(cornerRadius: 16)
                                .frame(height: 200)
                                .frame(maxWidth: .infinity)
                                .overlay(
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                )
                                .clipped()
                        }
                    }
                } else {
                    Image(systemName: "photo.on.rectangle.angled")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                        .frame(height: 200)
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
            if case .loading = viewModel.loadingState {
                ProgressView("Loading cities...")
            } else {
                VStack(alignment: .center, spacing: 4) {
                    Text(viewModel.cityDetail?.title ?? city.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text(viewModel.cityDetail?.description ?? city.country)
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
                Text(viewModel.cityDetail?.extract ?? "No additional information available")
                    .font(.body)
                    .padding(.top, 10)
                VStack(alignment: .leading, spacing: 12) {
                    Label("\(city.name), \(city.country)", systemImage: "globe.americas")
                        .font(.subheadline)
                    Label("Lat: \(city.lat), Lon: \(city.long)", systemImage: "mappin.and.ellipse")
                        .font(.subheadline)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.blue.opacity(0.3),
                            in: RoundedRectangle(cornerRadius: 20))
            }
        }
        .padding(.all, 15)
        .navigationTitle(city.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: onToggleFavorite) {
                    Image(systemName: city.isFavorite ? "star.fill" : "star")
                }
                .symbolEffect(.bounce, value: city.isFavorite)
            }
        }
        .task {
            await viewModel.fetchCityDetail(for: city.name)
        }
    }
}
