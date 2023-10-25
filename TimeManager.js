export class TimeManager {
    constructor () {
        this.update();

        setInterval(this.update(), 60 * 1000);
    }

    update() {
        const ruDaysOfWeek = ['Вс', 'Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб'];
        const enDaysOfWeek = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
        
        const ruMonths = ['янв.', 'февр.', 'марта', 'апр.', 'мая', 'июня', 'июля', 'авг.', 'сент.', 'окт.', 'нояб.', 'дек.'];
        const enMonths = ['Jan.', 'Feb.', 'Mar.', 'Apr.', 'May', 'June', 'July', 'Aug.', 'Sept.', 'Oct.', 'Nov.', 'Dec.'];

        const now = new Date();
        const hours = String(now.getHours()).padStart(2, '0');
        const minutes = String(now.getMinutes()).padStart(2, '0');

        const lang = (navigator.language || 'en').slice(0, 2); // получаем первые две буквы из кода языка

        let dayOfWeek, dayOfMonth, month;

        if (lang === 'ru') {
            dayOfWeek = ruDaysOfWeek[now.getDay()];
            dayOfMonth = now.getDate();
            month = ruMonths[now.getMonth()];
        } else {
            dayOfWeek = enDaysOfWeek[now.getDay()];
            dayOfMonth = now.getDate();
            month = enMonths[now.getMonth()];
        }

        document.getElementById('clock').textContent = `${dayOfWeek}, ${dayOfMonth} ${month} ${hours}:${minutes}`;
    }
}
