//
//  FeedbackView.swift
//  iosapp
//
//  Created by Bastian Schmalbach on 04.10.20.
//  Copyright © 2020 Bastian Schmalbach. All rights reserved.
//

import SwiftUI

struct FeedbackView: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @EnvironmentObject var myUrl: ApiUrl
    
    var screen = UIScreen.main.bounds
    
    @State var feedback: String = ""
    @State var feedbackType: String = ""
    @State var feedbackOptions = ["Verbesserung", "Kritik", "Sonstiges"]
    @State var feedbackOptionSelected = -1
    
    @State var loading = false
    @State var success = false
    @State var successScale = false
    @State var loadingAnimation = false
    
    @State var firstResponder: Bool? = false
    
    @ObservedObject var user = UserDataStore()
    
    var body: some View {
        
        let binding = Binding<String>(get: {
            self.feedback
        }, set: {
            self.feedback = $0
        })
        
        return ZStack {
            Color("background")
                .edgesIgnoringSafeArea(.all)
            VStack {
                Button(action: {
                    self.mode.wrappedValue.dismiss()
                    impact(style: .medium)
                }) {
                    HStack (spacing: 10){
                        Image(systemName: "arrow.left")
                            .font(.system(size: screen.width < 500 ? screen.width * 0.040 : 18, weight: .medium))
                            .foregroundColor(Color("black"))
                        Text("Einstellungen")
                            .font(.system(size: screen.width < 500 ? screen.width * 0.040 : 18, weight: .medium))
                            .foregroundColor(Color("black"))
                        Spacer()
                    }
                    .padding(.leading, 20)
                    .padding(.vertical, 10)
                }
                
                if (!(firstResponder ?? false)){
                Image("HappyTab")
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(1.3)
                    .frame(minHeight: 50, idealHeight: 100, maxHeight: 200)
                    .layoutPriority(1)
                    .padding()
                Text("Gib hier dein Feedback ein und wähle eine zutreffende Kategorie.")
                    .frame(maxWidth: 612)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 16))
                    .fixedSize(horizontal: false, vertical: true)
                    .padding()
                }
                HStack (spacing: 10){
                    Button(action: {
                        self.feedbackOptionSelected = 0
                        self.feedbackType = feedbackOptions[0]
                        firstResponder = false
                    }){
                        Text(feedbackOptions[0])
                            .font(.system(size: screen.width < 500 ? screen.width * 0.035 : 14, weight: Font.Weight.medium))
                            .padding(15)
                            .frame(height: 25 + UIScreen.main.bounds.height / 50)
                            .foregroundColor(Color(feedbackOptionSelected == 0 ? "white" : "black"))
                            .background(Color(feedbackOptionSelected == 0 ? "blue" : "background"))
                            .cornerRadius(15)
                    }
                    Button(action: {
                        self.feedbackOptionSelected = 1
                        self.feedbackType = feedbackOptions[1]
                        firstResponder = false
                    }){
                        Text(feedbackOptions[1])
                            .font(.system(size: screen.width < 500 ? screen.width * 0.035 : 14, weight: Font.Weight.medium))
                            .padding(15)
                            .frame(height: 25 + UIScreen.main.bounds.height / 50)
                            .foregroundColor(Color(feedbackOptionSelected == 1 ? "white" : "black"))
                            .background(Color(feedbackOptionSelected == 1 ? "blue" : "background"))
                            .cornerRadius(15)
                    }
                    Button(action: {
                        self.feedbackOptionSelected = 2
                        self.feedbackType = feedbackOptions[2]
                        firstResponder = false
                    }){
                        Text(feedbackOptions[2])
                            .font(.system(size: screen.width < 500 ? screen.width * 0.035 : 14, weight: Font.Weight.medium))
                            .padding(15)
                            .frame(height: 25 + UIScreen.main.bounds.height / 50)
                            .foregroundColor(Color(feedbackOptionSelected == 2 ? "white" : "black"))
                            .background(Color(feedbackOptionSelected == 2 ? "blue" : "background"))
                            .cornerRadius(15)
                    }
                }
                .frame(maxWidth: screen.width - 30)
                
                Section {
                    ZStack{
                        MultilineTextView(text: binding, isFirstResponder: $firstResponder, maxLength: 250)
                            .frame(minHeight: screen.height / 20, idealHeight: screen.height / 10, maxHeight: screen.height / 5)
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Text("\(feedback.count)/250")
                                    .padding(10)
                                    .font(.system(size: screen.width < 500 ? screen.width * 0.03 : 12))
                                    .opacity(0.5)
                            }
                        }
                    }
                    .frame(minHeight: screen.height / 20, idealHeight: screen.height / 10, maxHeight: screen.height / 5)
                    .frame(maxWidth: UIScreen.main.bounds.width - 30)
                    .padding(.vertical, 5)
                }
                
                Button(action: {
                    impact(style: .rigid)
                    firstResponder = false
                    self.loading = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                        self.loadingAnimation = true
                    }
                    postFeedback()
                }) {
                    HStack (spacing: 15){
                        Image(systemName: "plus.bubble")
                            .font(.system(size: UIScreen.main.bounds.width < 500 ? UIScreen.main.bounds.width * 0.05 : 20, weight: Font.Weight.medium))
                        Text("Feedback senden")
                            .font(.system(size: UIScreen.main.bounds.width < 500 ? UIScreen.main.bounds.width * 0.045 : 20))
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.white)
                    .padding(15)
                    .frame(height: 30 + UIScreen.main.bounds.height / 50)
                    .background(Color(feedback.count < 5 || feedbackOptionSelected == -1 ? "blueDisabled" : "blue"))
                    .cornerRadius(15)
                }.disabled(feedback.count < 5 || feedbackOptionSelected == -1)
                Spacer()
                Spacer()
            }
            .padding(.bottom, 20)
            .blur(radius: loading ? 4 : 0)
            if (loading) {
                ZStack {
                    if (success) {
                        VStack {
                            LottieView(filename: "success", loop: false)
                                .frame(width: successScale ? 250 : 180, height: successScale ? 250 : 180)
                                .animation(.spring())
                        }
                        .onAppear(){
                            haptic(type: .success)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                                self.successScale = true
                            }
                        }
                    }
                    if (!success) {
                        VStack {
                            LottieView(filename: "loadingCircle", loop: true)
                                .frame(width: 80, height: 80)
                                .background(Color("white"))
                                .cornerRadius(50)
                        }
                    }
                }
                .frame(width: successScale ? 200 : 150, height: successScale ? 200 : 150)
                .background(Color("white"))
                .cornerRadius(50)
                .scaleEffect(loadingAnimation ? 1 : 0.5)
                .shadow(radius: 5)
                .animation(.spring())
            }
        }
        .gesture(DragGesture()
                    .onChanged({ (value) in
                        if value.translation.width > 40 {
                            self.mode.wrappedValue.dismiss()
                        }
                    })
        )
        .animation(.spring())
    }
    
    func postFeedback(){
        let feedbackData = Feedback(feedback: feedback, feedbackType: feedbackType, userID: user.user._id, userName: user.user.name ?? "")
        
        guard let encoded = try? JSONEncoder().encode(feedbackData) else {
            print("Failed to encode order")
            return
        }
        guard let url = URL(string: myUrl.feedbacks) else { return }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        
        print(feedbackData)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let data = data {
                if let decoded = try? JSONDecoder().decode(Message.self, from: data) {
                    if decoded.message.contains("erfolgreich"){
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.success = true
                            self.successScale = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                self.feedback = ""
                                self.feedbackType = ""
                                self.feedbackOptionSelected = -1
                                self.loadingAnimation = false
                                self.successScale = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    self.loading = false
                                    self.success = false
                                }
                            }
                        }
                        return
                    }
                    else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                self.loading = false
                                self.success = false
                                self.loadingAnimation = false
                                self.successScale = false
                        }
                        return
                    }
                }
                else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            self.loading = false
                            self.success = false
                            self.loadingAnimation = false
                            self.successScale = false
                    }
                    return
                }
            } else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.loading = false
                        self.success = false
                        self.loadingAnimation = false
                        self.successScale = false
                }
                return
            }
        }.resume()
    }
}

struct Feedback: Encodable, Decodable {
    var _id: String?
    var __v: Int?
    var feedback: String
    var feedbackType: String
    var userID: String
    var userName: String
}

struct FeedbackView_Previews: PreviewProvider {
    static var previews: some View {
        FeedbackView()
    }
}
