const translations = {
    en: {
        active: "Active",
        status: "Status",
        install: "Install",
        'alert-title': "Application for Mac OS.",
        'alert-description': "Switching the language layout using any keys or their combinations.",
        'info-press': 'Press: Shift + Command',
        'info-close': 'Close application',
        'info-cancel': 'Canceling system hotkeys',
        'info-switch': 'Switching active',
    },
    ru: {
        active: "Активно",
        status: "Статус",
        install: "Установить",
        'alert-title': "Приложение для Mac OS.",
        'alert-description': "Переключение языковой раскладки любыми клавишами или их комбинациями.",
        'info-press': 'Нажми: Shift + Command',
        'info-close': 'Закрыть приложение',
        'info-cancel': 'Отмена системных хоткеев',
        'info-switch': 'Переключение активно',
    }
};

export class LocalManager {
    _userLang;

    constructor() {
       this._userLang = (navigator.language || 'en').slice(0, 2);
       this.localize(this._userLang);
    }

    localize(language) {
        // Текстовые элементы
        const textElements = [...document.querySelectorAll('[data-translate-key]')];
        textElements.forEach(element => {
            const key = element.getAttribute('data-translate-key');
            if (translations[language] && translations[language][key]) {
                element.textContent = translations[language][key];
            }
        });

        // Атрибуты data-info
        const dataInfoElements = [...document.querySelectorAll('[data-info]')];
        dataInfoElements.forEach(element => {
            const key = element.getAttribute('data-info-key');
            if (translations[language] && translations[language][key]) {
                element.setAttribute('data-info', translations[language][key]);
            }
        });
    }
}
