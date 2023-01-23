import Foundation

struct MangaRoot: Decodable {
    let data: [Manga]
}

struct Manga: Decodable, Identifiable {
    let id: String
    let type: String
    
    let attributes: manga_Attributes
    let relationships: [manga_Relationships]
}

//main attributes for manga
struct manga_Attributes: Decodable {
    let title: manga_Title
    let description: manga_Description
    
    let year: Int?
    let lastChapter: String?
    //let status: String
}

struct manga_Title: Decodable{
    let en: String
    
}

struct manga_Description: Decodable{
    let en: String
}


struct manga_Relationships: Decodable{
    let id: String
    let type: String
    
    let attributes: relationship_Attributes
}

struct relationship_Attributes: Decodable{
    let cover_filename: String
    let author_name: String
    
    enum CodingKeys: String, CodingKey{
        case cover_filename = "fileName"
        case author_name = "name"
    }
}

var items: [Manga] = []

func fetchManga() async -> [Manga] {
    
    let url = URL(string: "https://api.mangadex.org/manga?availableTranslatedLanguage[]=en&includes[]=cover_art")!

    var request = URLRequest(url: url)

    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
    do{
        let (data, _) = try! await URLSession.shared.data(from: url)
        
        
        let manga = try JSONDecoder().decode(MangaRoot.self, from: data)
        
        return manga.data
    } catch {
        return []
    }
    
    
}

func populate() async {
    let fetched = await fetchManga()
    items = fetched
}


await populate()


