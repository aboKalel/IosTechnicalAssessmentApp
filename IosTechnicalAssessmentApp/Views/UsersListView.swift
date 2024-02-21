//
//  UsersList.swift
//  IosTechnicalAssessmentApp
//
//  Created by Ibrahim on 10/08/1445 AH.
//


import SwiftUI

struct UsersList: View {
    var username: String = ""
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var users: FetchedResults<Users>
    @State var usernameTextFieldValue: String = ""
    @State var userseList: [UserData] = []
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                if !userseList.isEmpty {
                    List(userseList, id: \.id) { user in
                        HStack{
                            VStack(alignment: .leading){
                                Text(user.name ?? "")
                                    .font(.system(size: 14))
                                    .fontWeight(.bold)
                                Text(user.email ?? "")
                                    .font(.system(size: 12))
                                    .foregroundStyle(.gray)
                            }
                            Spacer()
                            
                            HStack{
                                Text(user.status?.rawValue ?? "")
                                    .font(.system(size: 12))
                                    .foregroundStyle(user.status == .active ? .green : .gray)
                                Image("angle-left-solid")
                                    .resizable()
                                    .frame(width: 8, height: 14)
                                    .rotationEffect(Angle.degrees(180))

                            }
                        }.frame(height: 40)
                    }
                    .listStyle(.inset)

                } else {
                    Text("sorry no data check network")
                }

                     GeometryReader { reader in
                         Color("appColor")
                             .frame(height: reader.safeAreaInsets.top, alignment: .top)
                             .ignoresSafeArea()
                     }
            }.onAppear {
                self.userseList = ViewModel().fetchUsers(viewContext: moc)
            }
        }.navigationTitle("usrlist")
        
        
    }
}

#Preview {
    UsersList(username: "")
}
