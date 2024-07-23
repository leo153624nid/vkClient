//
//  FeedView.swift
//  vkClient
//
//  Created by A Ch on 23.07.2024.
//

import Kingfisher
import SwiftUI

struct FeedView: View {
    @ObservedObject var viewModel: FeedViewModel
    
    var body: some View {
        VStack {
            KFImage(URL(string: "https://cloud.tuist.io/images/tuist_logo_32x32@2x.png")!)
                .onTapGesture {
                    viewModel.perform(action: .loadNextPage)
                }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    FeedView(viewModel: FeedViewModel())
}
