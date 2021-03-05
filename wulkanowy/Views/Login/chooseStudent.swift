//
//  chooseStudent.swift
//  wulkanowy
//
//  Created by Tomasz on 02/03/2021.
//

import Foundation
import SwiftUI
import KeychainAccess
import SwiftyJSON

struct ChooseStudentView: View {
    @Environment(\.presentationMode) var presentation
    @AppStorage("isLogged") private var isLogged: Bool = false
    
    let keychain = Keychain()
    var displayStudents: Array<String> = Array()
    
    @State private var selectedStudent: String = ""
    
    init() {
        var responseBody = keychain["students"]
        while responseBody == nil {
            responseBody = keychain["students"]
        }
        
        let data = Data(responseBody!.utf8)
        let json = try! JSON(data: data)
        selectedStudent = "\(json["Envelope"][0]["Login"]["DisplayName"])"
        
        var i: Int = 0
        while true {
            if (String(describing: json["Envelope"][i]) == "null") {
                break
            }
            else {
                displayStudents.append(String(describing: json["Envelope"][i]["Login"]["DisplayName"]))
                i += 1
            }
        }
    }
    
    
    private func saveStudent() {
        let responseBody = keychain["students"]
        
        let data = Data(responseBody!.utf8)
        let json = try! JSON(data: data)
        
        var i: Int = 0
        if(selectedStudent == "") {
            selectedStudent = "\(json["Envelope"][i]["Login"]["DisplayName"])"
        }
        while true {
            let student = "\(json["Envelope"][i]["Login"]["DisplayName"])"
            if(student == selectedStudent) {
                
                //adding student key to allStudentsKeys
                let keyFingerprint: String! = keychain["keyFingerprint"]
                let allStudentsKeys: String! = keychain["allStudentsKeys"] ?? ""
                
                //parsing allStudentsKeys to array
                var allStudents: [String] = []
                let data = Data(allStudentsKeys!.utf8)
                do {
                    let array = try JSONSerialization.jsonObject(with: data) as! [String]
                    allStudents = array
                } catch {
                    print(error)
                }
                allStudents.append(keyFingerprint!)
                keychain["allStudentsKeys"] = "\(allStudents)"
                
                
                //saving student
                keychain["student-\(String(describing: keyFingerprint!))"] = "\(json["Envelope"][i])"
                
                break
            }
            i += 1
        }
        isLogged = true
        presentation.wrappedValue.dismiss()
    }
    
    var body: some View {
        VStack {
            Spacer()
            Text("selectStudent")
                .font(.title)
                .padding(.top)
            Picker(selection: $selectedStudent, label: Text("selectStudent")) {
                ForEach(displayStudents, id: \.self) { student in
                    Text(student)
                }
            }
            Spacer()
            Button("registerButton") {saveStudent()}
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .background(Color.accentColor.opacity(0.1))
                .cornerRadius(12)
            
        }.padding()
    }
}



struct ChooseStudentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ChooseStudentView()
        }
        .preferredColorScheme(.dark)
    }
}
