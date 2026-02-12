import Foundation

class QuizHistoryManager {
    
    static let shared = QuizHistoryManager()
    private let key = "quiz_history"
    private let hasSeededKey = "has_seeded_history"
    
    private init() {
        seedSampleDataIfNeeded()
    }
    
    // MARK: - Save
    func saveResult(_ result: QuizResult) {
        var history = fetchHistory()
        history.append(result)
        
        if let encoded = try? JSONEncoder().encode(history) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
    
    // MARK: - Load
    func fetchHistory() -> [QuizResult] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([QuizResult].self, from: data) else {
            return []
        }
        return decoded
    }
    
    // MARK: - Sample Data Seeder
    private func seedSampleDataIfNeeded() {
        let hasSeeded = UserDefaults.standard.bool(forKey: hasSeededKey)
        if hasSeeded { return }
        
        let samples: [QuizResult] = [
            QuizResult(title: "Animal Personality Quiz", result: "🦁 You are a Lion!", date: Date().addingTimeInterval(-86400 * 1)),
            QuizResult(title: "Best Time of Day Quiz", result: "🌅 Morning Person", date: Date().addingTimeInterval(-86400 * 2)),
            QuizResult(title: "Which Friend Are You Quiz", result: "🐰 Supportive Friend", date: Date().addingTimeInterval(-86400 * 3)),
            QuizResult(title: "Introvert vs Extrovert Quiz", result: "⚖️ Ambivert", date: Date().addingTimeInterval(-86400 * 4))
        ]
        
        if let encoded = try? JSONEncoder().encode(samples) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
        
        UserDefaults.standard.set(true, forKey: hasSeededKey)
    }
}
