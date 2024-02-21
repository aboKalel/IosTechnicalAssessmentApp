//
//  LoginPageView.swift
//  IosTechnicalAssessmentApp
//
//  Created by Ibrahim on 09/08/1445 AH.
//

import SwiftUI

struct LoginPageView: View {
    @State var usernameTextFieldValue: String = ""
    @State var passwordTextFieldValue: String = ""
    @State private var showAlert = false
    @State private var allowEnterHomePage = false
    var viewModel = ViewModel()
    
    func checkEmptyTextFields() -> Bool{
        if !usernameTextFieldValue.isEmpty && !passwordTextFieldValue.isEmpty {
            return true
        } else {
            return false
        }
    }
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                Color("logInColor")
                    .ignoresSafeArea()
                VStack(alignment: .center, spacing: 20) {
                    Text("Hello,")
                        .font(.largeTitle)
                        .foregroundStyle(Color("appColor"))
                    
                    TextField("username", text: $usernameTextFieldValue)
                        .padding()
                        .background(Color.white.opacity(0.3).cornerRadius(10))
                    SecureField("password", text: $passwordTextFieldValue)
                        .padding()
                        .background(Color.white.opacity(0.3).cornerRadius(10))
                    ZStack{
                        
                        NavigationLink {
                            HomePage(username: usernameTextFieldValue, viewModel: viewModel)
                                .navigationBarBackButtonHidden(true)
                                .environmentObject(viewModel)
                            
                        } label: {
                            Text("LogIn")
                                .padding(.horizontal, 48)
                                .padding(.vertical, 12)
                                .background(Color("appColor").cornerRadius(10))
                                .foregroundStyle(.white)
                            
                        }.simultaneousGesture(TapGesture().onEnded {
                            KeychainHelper.storeUserLoginInfo(username: usernameTextFieldValue, password: passwordTextFieldValue)
                        })
                        if !allowEnterHomePage {
                            Text("LogIn")
                                .padding(.horizontal, 48)
                                .padding(.vertical, 12)
                                .background(Color.white.opacity(0.00001).cornerRadius(10))
                                .foregroundStyle(Color.white.opacity(0.00001))
                                .onChange(of: usernameTextFieldValue, { oldValue, newValue in
                                    allowEnterHomePage = checkEmptyTextFields()
                                })
                                .onChange(of: usernameTextFieldValue, { oldValue, newValue in
                                    allowEnterHomePage = checkEmptyTextFields()
                                })
                                .onTapGesture {
                                    allowEnterHomePage = checkEmptyTextFields()
                                        showAlert = !allowEnterHomePage
                                    
                                }

                        }
                        
                    }.edgesIgnoringSafeArea(.all)
                        .alert(isPresented: $showAlert) {
                        return Alert(title: Text("Empty TextFields !"), message: Text("plase make sure username and password are not empty" ), dismissButton: .default(Text("Dissmiss")))
                        
                    }

                }

                .padding()
                .padding(.top, 120)
                
            }
        }
    }
}

#Preview {
    LoginPageView(usernameTextFieldValue: "", passwordTextFieldValue: "")
}
