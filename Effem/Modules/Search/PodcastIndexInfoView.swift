//
//  PodcastIndexInfoView.swift
//  Effem
//
//  Created by Thomas Rademaker on 11/11/23.
//

import SwiftUI
import PodcastIndexKit

struct PodcastIndexInfoView: View {
    @State private var stats: StatProperties?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Effem is powered by Podcasting 2.0 and the [Podcast Index](https://podcastindex.org)")
                .font(.title2)
                .padding(.horizontal)
            
            Text("Total Podcasts in the Index...")
                .font(.title2)
                .padding()
            
            ZStack {
                Text("\(stats?.feedCountTotal ?? 0)")
                    .font(.largeTitle)
                    .foregroundStyle(.vividRed)
                    .padding(.horizontal)
                    .opacity(stats != nil ? 1 : 0)
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.vividRed)
                    .padding(.horizontal)
                    .opacity(stats == nil ? 1 : 0)
            }
        }
        .fullScreenColorView()
        .task { await getStats() }
    }
    
    private func getStats() async {
        stats = try? await StatsService().current().stats
        
    }
}

#Preview {
    NavigationStack {
        List {
            Text("search view")
                .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .searchable(text: .constant(""), prompt: "podcasts, episidoes, and more")
        .navigationTitle("search")
            .sheet(isPresented: .constant(true)) {
                PodcastIndexInfoView()
                    .presentationDragIndicator(.visible)
                    .presentationDetents([.medium])
                    .environment(PodcastIndexKit())
            }
    }
    .setupPodcastIndexKit()
}
