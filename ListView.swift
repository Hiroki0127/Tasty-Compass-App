//
//  ListView.swift
//  Tasty Compass
//


import SwiftUI
import MapKit

struct ListView: View {
    
    @ObservedObject var viewModel = ListViewModel()
    @State private var landmarks: [Landmark] = [Landmark]()
    
    private func nearByRestaurants() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = viewModel.searchText
        
        let searchText = MKLocalSearch(request: request)
        searchText.start {(response, error) in
            if let response  = response {
                let mapItems = response.mapItems
                self.landmarks = mapItems.map {
                    Landmark(placemark: $0.placemark)
                }
                
            }
        }
    }
    
    
    var body: some View {
        NavigationView{
            List {
                ForEach(viewModel.businesses, id: \.id) {
                    business in
                    Link(destination: URL(string: business.url!)!, label: {
                        HStack{
                            VStack{
                                Text(business.name ?? "")
                                    .font(.headline)
                            }
                            VStack{
                                Text(business.price ?? "")
                                    .font(.subheadline)
                            }
                            VStack{
                                if business.isClosed! {
                                    Text("[Open]")
                                        .font(.subheadline)
                                }
                                else {
                                    Text("[Closed]")
                                        .font(.subheadline)
                                }
                                //if isClosed!= print open , else print closed
                            }
                            Spacer()
                            AsyncImage(url: URL(string: business.imageURL!)){ image in
                                image.resizable()
                                  .frame(width:100, height: 100)
                                  .clipped()
                                  .cornerRadius(10)
                              } placeholder: {
                                ProgressView()
                              }
                        }
                    })
                }
            }
            .listStyle(.plain)
            .navigationTitle(Text("Restaurants near you"))
            .searchable(text: $viewModel.searchText)
            //.toolbar {
              //  ToolbarItem(placement: .navigationBarTrailing) {
                //    Image(systemName: "person")
                //}
            //}
            //.onAppear(perform: viewModel.search)
            .onAppear() {
                viewModel.search()
                //viewModel.
                
            }
        }
    }
    
    struct ListView_Previews: PreviewProvider {
        static var previews: some View{
            ListView()
        }
    }
}

