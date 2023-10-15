export class AppManager {
    _infoDescription;
    _infoDescriptionTimer;
    _lang;

    constructor() {
        this._infoDescription = document.querySelector('[data-info-description]');
        this._lang = document.querySelector('.lang');

        this.overSubscribe = this._focEvent(this.overSubscribe.bind(this));
        this.outSubscribe = this._focEvent(this.outSubscribe.bind(this));
        this.langSubscribe = this.langSubscribe.bind(this);
    }

    _focEvent(originSubscribe) {
        return (event) => {
            if (this._isInternalEvent(event)) {
                return;
            }

            originSubscribe(event)
        }
    }

    _isInternalEvent(event) {
        return event.relatedTarget && event.target.contains(event.relatedTarget);
    }

    overSubscribe(event) {
        if (event.target.hasAttribute('data-info')) {
            clearTimeout(this._infoDescriptionTimer);
            this._infoDescription.innerHTML = event.target.dataset.info;
            this._infoDescription.classList.add('is-active');
        }
    }

    outSubscribe(event) {
        if (!event.target.closest('[data-info]')) {
            clearTimeout(this._infoDescriptionTimer);
            this._infoDescription.classList.remove('is-active');
            this._infoDescriptionTimer = setTimeout(() => {
                this._infoDescription.innerHTML = '';
            }, 500);
        }
    }

    langSubscribe(event) {
        if (event.shiftKey) {
            // для Windows и Linux
            if (event.altKey && !event.metaKey) {
                console.log('Windows/Linux: Shift + Alt combination detected');
                this._lang.classList.toggle('second');
                this._lang.innerHTML = this._lang.innerHTML === 'A' ? 'O' : 'A';
                
            }
            // для Mac
            if (!event.altKey && event.metaKey) {
                console.log('Mac: Shift + Command combination detected');
                this._lang.classList.toggle('second');
                this._lang.innerHTML = this._lang.innerHTML === 'A' ? 'O' : 'A';
            }
        }
    }
}
