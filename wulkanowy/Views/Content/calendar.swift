//
//  attendance.swift
//  wulkanowy
//
//  Created by Tomasz on 24/02/2021.
//

import SwiftUI
import KeychainAccess
import Sdk

struct CalendarView: View {
    @State private var showModal = false
    @AppStorage("isLogged") private var isLogged: Bool = false
    
    var body: some View {
        if(isLogged == false){
            VStack {
                Text("You are not logged in")
                Button("Log in") {self.showModal = true}
                    .sheet(isPresented: $showModal, onDismiss: {
                                print(self.showModal)
                            }) {
                                LoginView()
                            }
            }.padding()
        } else {
            ScrollView {
                PullToRefresh(coordinateSpaceName: "pullToRefresh") {
                        print("Refreshing..")
                    }
                Text("Here is calendar (in my imagination)")
            }.coordinateSpace(name: "pullToRefresh")
        }
    }
}



struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CalendarView()
        }
        .preferredColorScheme(.dark)
    }
}
