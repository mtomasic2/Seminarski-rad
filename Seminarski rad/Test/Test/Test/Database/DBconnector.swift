import SQLite
import Combine
import Foundation

class Korisnik{
    var id: Int64;
    var ime: String;
    var prezime: String;
    var godine: Int64;
    var email: String;
    init(id: Int64, ime: String, prezime: String, godine: Int64, email: String) {
        self.id = id
        self.ime = ime
        self.prezime = prezime
        self.godine = godine
        self.email = email
    }
}

class dataAccessIN: ObservableObject{
    var korisnici = Table("korisnici")
    var id = Expression<Int64>("id")
    var ime = Expression<String>("ime")
    var prezime = Expression<String>("prezime")
    var godine = Expression<Int64>("godine")
    var email = Expression<String>("email")
    
    func spojiSeNaBP() -> Connection {
        let path = NSSearchPathForDirectoriesInDomains(
                        .documentDirectory, .userDomainMask, true
                    ).first!
        let sourcePath = "\(path)/db.sqlite3"
        return try! Connection(sourcePath)
    }
    
    //_ = copyDatabaseIfNeeded(sourcePath: sourcePath)
    
    func copyDatabaseIfNeeded(sourcePath: String) -> Bool {
        let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let destinationPath = documents + "/db.sqlite3"
        let exists = FileManager.default.fileExists(atPath: destinationPath)
        guard !exists else { return false }
        do {
            try FileManager.default.copyItem(atPath: sourcePath, toPath: destinationPath)
            return true
        } catch {
          print("error during file copy: \(error)")
            return false
        }
    }
    
    func kreirajTablicu(db: Connection) {
        do {
            try db.run(korisnici.create(ifNotExists: true) { table in
                table.column(id, primaryKey: .autoincrement)
                table.column(ime)
                table.column(prezime)
                table.column(godine)
                table.column(email)
            })
        } catch {
            print("Pogreska prilikom kreiranja tablice!: \(error)")
        }
    }
    
    func unesiNovogKorisnika(db: Connection, imeUnos: String, prezimeUnos: String, godineUnos: String, emailUnos: String) {
        kreirajTablicu(db: db)
        let godineParsed = Expression<Int64>(godineUnos)
        let unos = korisnici.insert(ime <- imeUnos, prezime <- prezimeUnos, godine <- godineParsed, email <- emailUnos)
        try! db.run(unos)
    }
    
    func dohvaćanjeKorisnika(db: Connection) -> Array<Korisnik> {
        let upit = korisnici.select(korisnici[*])
        var sviKorisnici: Array<Korisnik> = []
        
        for korisnici in try! db.prepare(upit){
            sviKorisnici.append(Korisnik(id: korisnici[id], ime: korisnici[ime], prezime: korisnici[prezime], godine: korisnici[godine], email: korisnici[email]))
        }
        return sviKorisnici;
    }
    
    func azurirajTablicu(db: Connection, idUnosa: String, emailUnosa: String ) {
        let idUnosaParse = Expression<Int64>(idUnosa)
        let azurirajPo = korisnici.filter(id == idUnosaParse)
        try! db.run(azurirajPo.update(email <- emailUnosa))
    }
    
    func obrisiRedTablice(db: Connection, idUnosa: String){
        let idUnosaParsed = Expression<Int64>(idUnosa)
        let filterDelete = korisnici.filter(id == idUnosaParsed)
        try! db.run(filterDelete.delete())
    }
    
    func deleteRecords(db: Connection){
        try! db.run(korisnici.delete())
    }
}
