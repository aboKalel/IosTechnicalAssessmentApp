//
//  HomePage.swift
//  IosTechnicalAssessmentApp
//
//  Created by Ibrahim on 10/08/1445 AH.
//

import SwiftUI

struct HomePage: View {
    var username: String = ""
    @State var messageTextFieldValue: String = ""
    enum AlertType {
        case showMessageAlert, showErrorAlert, showEmptyAlert
    }
    @State private var viewDidApperForThefirstTime = true
    @State private var showAlert = false
    @State private var alertType: AlertType?
    @State private var receiveMessage: String?
    enum ConnectionStatus {
        case connect
        case disconnect
    }
    @State private var connectionStatus: ConnectionStatus = .connect
    @Environment(\.managedObjectContext) var context
    var viewModel: ViewModel
    let webSocketManager = WebSocketHelper()
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                
                VStack{
                    HStack {
                        Text("Hello, \(username)")
                            .padding(.leading, 10)
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                        Spacer()
                        NavigationLink {
                            UsersList()
                                .navigationBarBackButtonHidden(true)
                                .navigationBarItems(leading: BackButton())
                        } label: {
                            Text("Users List")
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.white.cornerRadius(10))
                                .foregroundStyle(Color("appColor"))
                            
                        } .padding(.trailing, 10)
                            .padding(.vertical, 8)
                        
                    }.background(Color("appColor"))
                    
                    Spacer()
                    Button {
                        if connectionStatus == .disconnect {
                            connectionStatus = .connect
                            webSocketManager.connect()
                        } else {
                            connectionStatus = .disconnect
                            webSocketManager.disconnect()
                        }
                    } label: {
                        VStack {
                            Text("Connected to WebSocket")
                                .foregroundStyle(.gray)
                            Text(connectionStatus == .connect ? "disconnection" : "connection")
                                .padding(.horizontal, 36)
                                .padding(.vertical, 18)
                                .background(Color("appColor").cornerRadius(10))
                                .foregroundStyle(.white)
                        }
                    }
                    
                    Spacer()
                    ZStack(alignment: .trailing)
                    {
                        TextField("send message", text: $messageTextFieldValue)
                            .padding()
                            .padding(.trailing, 15)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.gray, lineWidth: 1)
                            )
                        Button(action:
                                {
                            if messageTextFieldValue.isEmpty {
                                alertType = .showEmptyAlert
                                showAlert = true
                            } else {
                                if connectionStatus == .connect {
                                    webSocketManager.sendMessage(message: messageTextFieldValue)
                                } else {
                                    alertType = .showErrorAlert
                                    showAlert = true
                                }
                            }
                           
                            
                        })
                        {
                            Image("paper-plane-regular")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height: 20)
                                .foregroundColor(Color("appColor"))
                        }     .alert(isPresented: $showAlert) {
                            switch alertType {
                            case .showMessageAlert:
                                return Alert(title: Text("Message sent!"), message: Text(receiveMessage ?? ""), dismissButton: .default(Text("Dissmiss")))
                            case .showErrorAlert:
                                return Alert(title: Text("showErrorAlert"), message: Text("plase make sure of connection status"), dismissButton: .default(Text("Dissmiss")))
                            case .some(.showEmptyAlert):
                                return Alert(title: Text("showEmptyAlert"), message: Text("plase make sure of the text field is not empty"), dismissButton: .default(Text("Dissmiss")))
                            case .none:
                                return Alert(title: Text(""), dismissButton: .default(Text("")))
                                
                            }
                        }
                        
                        .padding(.trailing, 8)
                    } .padding(.horizontal, 10)
                        .onAppear{
                            if viewDidApperForThefirstTime{
                                viewModel.getUsers { UsersResponse in
                                    viewModel.saveUsers(userseList: UsersResponse.data ?? [], viewContext: context)
                                }
                                viewDidApperForThefirstTime = false
                            }
                        }.onReceive(NotificationCenter.default.publisher(for: .receiveMessage)) { message in
                            guard let message = message.userInfo?["Message"] as? String else {return}
                            receiveMessage = message
                            alertType = .showMessageAlert
                            showAlert = true
                            
                        }
                }
           
                GeometryReader { reader in
                    Color("appColor")
                        .frame(height: reader.safeAreaInsets.top, alignment: .top)
                        .ignoresSafeArea()
                }
            }
        }
    }
}


#Preview {
    HomePage(username: "", viewModel: ViewModel())
}
