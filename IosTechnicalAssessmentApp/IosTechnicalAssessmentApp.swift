//
//  IosTechnicalAssessmentApp.swift
//  IosTechnicalAssessmentApp
//
//  Created by Ibrahim on 09/08/1445 AH.
//

import SwiftUI

@main
struct IosTechnicalAssessmentApp: App {
    @StateObject private var dataController = DataController()
  
    var body: some Scene {
        WindowGroup {
            LoginPageView()
                .environment(\.managedObjectContext, dataController.container.viewContext)

        }
    }
}
