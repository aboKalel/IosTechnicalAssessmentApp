//
//  BackButtonView.swift
//  IosTechnicalAssessmentApp
//
//  Created by Ibrahim on 12/08/1445 AH.
//

import Foundation
import SwiftUI
struct BackButton: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Button(action: {
            // Handle back button action
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image("angle-left-solid")
                .resizable()
                .frame(width: 14, height: 22)
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.white)
        }
    }
}
