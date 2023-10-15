import { AppManager } from './AppManager.js';
import { TimeManager } from './TimeManager.js';
import { LocalManager } from './LocalManager.js';

const lang = navigator.language || navigator.userLanguage;

const app = document.querySelector('.app');
const appManager = new AppManager();
const timeManager = new TimeManager();
const localManager = new LocalManager();

const store = {
    name: 'multichat',

    init() {
        this.data = JSON.parse(localStorage.getItem(this.name));
    },

    set set(data) {
        this.data = {
            ...this.data,
            ...data,
        }
        
        localStorage.setItem(this.name, JSON.stringify(this.data));
    },
    get get() {
        return this.data
    }
}

document.addEventListener('mouseover', appManager.overSubscribe);
document.addEventListener('mousemove', appManager.outSubscribe);

document.addEventListener('mouseover', appManager.overSubscribe);
document.addEventListener('mousemove', appManager.outSubscribe);
document.addEventListener('keydown', appManager.langSubscribe);

store.init();
