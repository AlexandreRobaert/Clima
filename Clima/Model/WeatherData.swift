
// MARK: - WeatherData
struct WeatherData: Codable {
    let name, base: String
    let id, timezone, cod, dt, visibility: Int
    let coord: Coord
    let weather: [Weather]
    let main: Main
    let wind: Wind
    let clouds: Clouds
    let sys: Sys
}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main, weatherDescription, icon: String
    
    enum CodingKeys: String, CodingKey {
        case id, main, icon
        case weatherDescription = "description"
    }
}

// MARK: - Main
struct Main: Codable {
    let temperatura, sensacaoTermica, temperaturaMinima, temperaturaMaxima: Double
    let pressao, umidade: Int
    
    enum CodingKeys: String, CodingKey {
        case temperatura = "temp"
        case sensacaoTermica = "feels_like"
        case temperaturaMinima = "temp_min"
        case temperaturaMaxima = "temp_max"
        case pressao = "pressure"
        case umidade = "humidity"
    }
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
    let deg: Int
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}

// MARK: Sys
struct Sys: Codable {
    let id, type: Int?
    let sunrise, sunset: Int
    let country: String
}
