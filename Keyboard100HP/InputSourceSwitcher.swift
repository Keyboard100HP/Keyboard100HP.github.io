import Foundation
import Carbon

class InputSourceSwitcher {
    static func switchToNextInputSource() {
        // Получаем список доступных источников ввода
        let sources = TISCreateInputSourceList(nil, false).takeRetainedValue() as! [TISInputSource]

        // Отфильтровываем список, оставляя только языковые раскладки клавиатуры
        let keyboardSources = sources.filter {
            guard let category = TISGetInputSourceProperty($0, kTISPropertyInputSourceCategory) else { return false }
            return Unmanaged<CFString>.fromOpaque(category).takeUnretainedValue() as String == kTISCategoryKeyboardInputSource as String
        }

        // Получаем текущий активный источник ввода
        guard let currentSource = TISCopyCurrentKeyboardInputSource().takeRetainedValue() as? TISInputSource,
              let currentIndex = keyboardSources.firstIndex(of: currentSource) else {
            print("Ошибка: не удалось получить текущий источник ввода.")
            return
        }

        // Вычисляем следующий источник ввода для переключения
        let nextIndex = (currentIndex + 1) % keyboardSources.count
        let nextSource = keyboardSources[nextIndex]

        // Производим переключение на следующий источник ввода
        TISSelectInputSource(nextSource)
    }
}
