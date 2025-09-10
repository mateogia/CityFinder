import SwiftUI

struct DetailScreen: View {
    let city: City
    let onToggleFavorite: () -> Void
    @StateObject private var viewModel = CityDetailViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if let thumbnail = viewModel.cityDetail?.thumbnail, let imageURL = URL(string: thumbnail.source) {
                    AsyncImage(url: imageURL) { phase in
                        if case .success(let image) = phase {
                            ZStack {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(minHeight: 150, maxHeight: 300)
                                    .blur(radius: 20, opaque: true)
                                    .clipped()
                                image
                                    .resizable()
                                    .frame(minHeight: 150, maxHeight: 300)
                                    .aspectRatio(contentMode: .fit)
                            }
                        }
                    }
                } else {
                    Image(systemName: "photo.on.rectangle.angled")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                        .frame(minHeight: 150, maxHeight: 300)
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
            .padding(.bottom, 10)
            switch viewModel.loadingState {
            case .loading:
                VStack(spacing: 16) {
                    ProgressView()
                    Text("Loading city details...")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .failure(let error):
                if let appError = error as? AppError, case .serverError(404) = appError {
                    ContentUnavailableView(
                        "Información no Disponible",
                        systemImage: "doc.text.magnifyingglass",
                        description: Text("No se encontraron detalles para esta ciudad en Wikipedia.")
                    )
                } else {
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 50))
                            .foregroundStyle(.red)
                        Text("Failed to load details")
                            .font(.headline)
                            .fontWeight(.semibold)
                        if let errorMessage = viewModel.errorMessage {
                            Text(errorMessage)
                                .font(.body)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            case .success, .idle:
                VStack(alignment: .center, spacing: 4) {
                    Text(viewModel.cityDetail?.title ?? city.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text(viewModel.cityDetail?.description ?? city.country)
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 15)
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
        .task(id: city.id) {
            await viewModel.fetchCityDetail(for: city.name)
        }
    }
}
