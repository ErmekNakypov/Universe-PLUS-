//
//  MarsPhotosView.swift
//  Univserse-PLUS
//
//  Created by Накыпов Эрмек on 17/12/24.
//

import SwiftUI

struct MarsPhotosView: View {
    
    @StateObject private var viewModel = MarsPhotosViewModel()
    
    @State private var selectedRover: String = "curiosity"
    @State private var selectedCamera: String = "All"
    @State private var selectedDate: Date = Date()
    @State private var page: Int = 1
    
    private let rovers = ["curiosity", "opportunity", "spirit"]
    private let cameras = ["All", "FHAZ", "RHAZ", "MAST", "CHEMCAM", "MAHLI", "MARDI", "NAVCAM", "PANCAM", "MINITES"]
    
    var body: some View {
        ZStack {

            Image("main_space")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Picker("Select Rover", selection: $selectedRover) {
                    ForEach(rovers, id: \.self) { rover in
                        Text(rover.capitalized)
                            .tag(rover)
                            .foregroundColor(.white)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white.opacity(0.1))
                )
                .foregroundColor(.white)
                .tint(.white)
                
                VStack(alignment: .leading) {
                    Text("Select Earth Date:")
                        .font(.headline)
                        .foregroundColor(.white)
                    DatePicker("", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white.opacity(0.1))
                        )
                        .colorScheme(.dark)
                        .foregroundColor(.white)
                }
                .padding()
                
                VStack(alignment: .leading) {
                    Text("Camera Type:")
                        .font(.headline)
                        .foregroundColor(.white)
                    Picker("Select Camera", selection: $selectedCamera) {
                        ForEach(cameras, id: \.self) { camera in
                            Text(camera == "All" ? "All Cameras" : camera)
                                .foregroundColor(.white)
                                .tag(camera)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white.opacity(0.1))
                    )
                }
                .padding()
                
                Button("Search") {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd"
                    let earthDate = formatter.string(from: selectedDate)
                    
                    viewModel.fetchPhotos(rover: selectedRover, sol: nil, earthDate: earthDate, camera: selectedCamera == "All" ? nil : selectedCamera, page: page)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                if viewModel.isLoading {
                    ProgressView()
                        .foregroundColor(.white)
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    ScrollView {
                        LazyVStack {
                            ForEach(viewModel.photos) { photo in
                                VStack(alignment: .leading) {
                                    AsyncImage(url: URL(string: photo.imgSrc)) { image in
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .cornerRadius(10)
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    Text(photo.camera.fullName)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    Text(photo.rover.name)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(10)
                            }
                        }
                    }
                }
            }
            .padding()
        }
    }
}
