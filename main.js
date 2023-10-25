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

let counter = 1;
const ball = document.querySelector('#ball');

const stepSize = 2000
const stepTime = 1000

setTimeout(() => {
    ball.classList.add('ball');
}, stepSize);
setTimeout(() => {
    ball.classList.remove('ball');
}, stepSize + stepTime);

setTimeout(() => {
    ball.classList.add('ball');
}, stepSize * 2);
setTimeout(() => {
    ball.classList.remove('ball');
}, stepSize * 2 + stepTime);

setTimeout(() => {
    ball.classList.add('ball');
}, stepSize * 3);
setTimeout(() => {
    ball.classList.remove('ball');
}, stepSize * 3 + stepTime);

setTimeout(() => {
    ball.classList.add('ball');
}, stepSize * 4);
setTimeout(() => {
    ball.classList.remove('ball');
}, stepSize * 4 + stepTime);