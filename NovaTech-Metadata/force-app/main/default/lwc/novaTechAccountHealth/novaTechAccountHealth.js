import { LightningElement, api, wire } from 'lwc';
import getAccountHealth from '@salesforce/apex/NovaTechAccountHealthController.getAccountHealth';

export default class NovaTechAccountHealth extends LightningElement {
    @api recordId;

    health;
    error;

    @wire(getAccountHealth, { accountId: '$recordId' })
    wiredHealth({ data, error }) {
        if (data) {
            this.health = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.health = undefined;
        }
    }

    get hasQuoteActivity() {
        return this.health && this.health.quoteCount > 0;
    }
}