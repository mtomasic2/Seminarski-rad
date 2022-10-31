//
//  ContentView.swift
//  Test
//
//  Created by FOI on 29.10.2022..
//

import SwiftUI

struct UnosView : View{
    @StateObject var data = dataAccessIN()
    @State private var ime = ""
    @State private var prezime = ""
    @State private var godine = ""
    @State private var email = ""
    
    func pritisnuoGumbUnosa() {
        let db = data.spojiSeNaBP()
        data.unesiNovogKorisnika(db: db, imeUnos: ime, prezimeUnos: prezime, godineUnos: godine, emailUnos: email)
        self.ime = ""
        self.prezime = ""
        self.godine = ""
        self.email = ""
    }
    
    var body: some View {
        VStack(spacing: 10.0) {
            Text("Unesi novog korisnika: ")
            TextField(text: $ime, prompt: Text("Ime")) {}
            .frame(width: 200.0)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .background(Color.gray)
                .border(Color.black, width: 1)
                .accessibilityIdentifier("textImeField")
            TextField(text: $prezime, prompt: Text("Prezime")) {}
            .frame(width: 200.0)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .background(Color.gray)
                .border(Color.black, width: 1)
            TextField(text: $godine, prompt: Text("Godine")) {}
            .frame(width: 200.0)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .background(Color.gray)
                .border(Color.black, width: 1)
            TextField(text: $email, prompt: Text("Email")) {}
            .frame(width: 200.0)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .background(Color.gray)
                .border(Color.black, width: 1)
                .textInputAutocapitalization(.never)
            Button(action: pritisnuoGumbUnosa) {
                Text("Unesi")
            }
                .buttonStyle(.borderedProminent)
        }
    }
}

struct IspisView: View{
    @StateObject var data = dataAccessIN()
    
    var body: some View {
        let db = data.spojiSeNaBP()
        let sviKorisnici = data.dohvaćanjeKorisnika(db: db)
        Text("ID   Ime   Prezime   Godine   Email")
            .padding(.bottom, 15.0)
        ForEach(sviKorisnici, id: \.id) { korisnik in
            Text("\(korisnik.id)   \(korisnik.ime)   \(korisnik.prezime)   \(korisnik.godine)   \(korisnik.email)")
        }
    }
}

struct AzurirajView: View {
    @StateObject var data = dataAccessIN()
    @State private var id = ""
    @State private var email = ""
    
    func pritisnuoGumbIzmjene() {
        let db = data.spojiSeNaBP()
        data.azurirajTablicu(db: db, idUnosa: id, emailUnosa: email)
        self.id = ""
        self.email = ""
    }
    
    var body: some View {
        VStack(spacing: 10.0) {
            Text("Izmjeni postojećeg korisnika: ")
            TextField(text: $id, prompt: Text("ID")) {}
                .frame(width: 200.0)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .background(Color.gray)
                .border(Color.black, width: 1)
            
            TextField(text: $email, prompt: Text("Email")) {}
            .frame(width: 200.0)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .background(Color.gray)
                .border(Color.black, width: 1)
                .textInputAutocapitalization(.never)
            
            Button(action: pritisnuoGumbIzmjene) {
                Text("Izmjeni")
            }
                .buttonStyle(.borderedProminent)
        }
    }
}

struct DeleteView : View {
    @StateObject var data = dataAccessIN()
    @State private var id = ""
    
    func pritisnuoGumbObrisi() {
        let db = data.spojiSeNaBP()
        data.obrisiRedTablice(db: db, idUnosa: id)
        self.id = ""
    }
    
    var body: some View {
        Text("Obrisi postojećeg korisnika: ")
        TextField(text: $id, prompt: Text("ID")) {}
            .frame(width: 200.0)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .background(Color.gray)
            .border(Color.black, width: 1)
        Button(action: pritisnuoGumbObrisi) {
            Text("Obrisi")
        }
        .buttonStyle(.borderedProminent)
    }
}


struct ContentView: View {
    @StateObject var data = dataAccessIN()
    
    var body: some View {
        NavigationView {
            ZStack (alignment: .topLeading){
                VStack (alignment: .leading) {
                    Text("Odaberi neku od sljedećih opcija:")
                    NavigationLink(destination: UnosView()) {
                        Text("Unesi novog korisnika")
                    }
                    .buttonStyle(.borderedProminent)
                    
                    NavigationLink(destination: IspisView()) {
                        Text("Ispisi sve korisnike")
                    }
                    .buttonStyle(.borderedProminent)
                    
                    NavigationLink(destination: AzurirajView()) {
                        Text("Azuriraj korisnicku mail adresu")
                    }
                    .buttonStyle(.borderedProminent)
                    
                    NavigationLink(destination: DeleteView()) {
                        Text("Obrisi korisnika po ID-u")
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .environmentObject(data)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

