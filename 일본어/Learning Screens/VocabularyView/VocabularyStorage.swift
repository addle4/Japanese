import Foundation

/// '오늘의 회화' 북마크 영구 저장(UserDefaults)
final class VocabularyStorage {
    static let shared = VocabularyStorage()
    private init() {}

    private let convoKey = "vocab.conversation.v1"

    /// 저장된 회화 단어 로드
    func loadConversation() -> [VocabItem] {
        guard let data = UserDefaults.standard.data(forKey: convoKey) else { return [] }
        return (try? JSONDecoder().decode([VocabItem].self, from: data)) ?? []
    }

    /// 회화 단어 저장
    func saveConversation(_ items: [VocabItem]) {
        guard let data = try? JSONEncoder().encode(items) else { return }
        UserDefaults.standard.set(data, forKey: convoKey)
    }

    /// 회화 단어 전체 삭제
    func clearConversation() {
        UserDefaults.standard.removeObject(forKey: convoKey)
    }
}
