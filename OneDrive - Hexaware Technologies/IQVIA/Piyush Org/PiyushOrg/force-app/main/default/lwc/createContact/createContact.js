import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import createContact from '@salesforce/apex/ContactService.createContact';

export default class ContactCreator extends LightningElement {
  firstName = '';
  lastName = '';
  email = '';
  isSaving = false;

  handleChange(event) {
    const { name, value } = event.target;
    this[name] = value;
  }

  async handleSave() {
    this.isSaving = true;
    try {
      const contactInput = {
        FirstName: this.firstName || null,
        LastName: this.lastName, // required
        Email: this.email || null
      };

      const id = await createContact({ contactInput });
      this.dispatchEvent(
        new ShowToastEvent({
          title: 'Success',
          message: `Contact created: ${id}`,
          variant: 'success'
        })
      );

      // Reset form or navigate as needed
      // e.g., this.firstName = ''; this.lastName = ''; this.email = '';

    } catch (error) {
      const message = this.reduceErrors(error);
      this.dispatchEvent(
        new ShowToastEvent({
          title: 'Error creating Contact',
          message,
          variant: 'error'
        })
      );
    } finally {
      this.isSaving = false;
    }
  }

  // Robust error normalizer (handles arrays, single objects, and generic errors)
  reduceErrors(error) {
    const messages = new Set();

    // Apex throws often return { body: { message: string } }
    if (Array.isArray(error?.body)) {
      error.body.forEach(e => {
        if (e?.message) messages.add(e.message);
      });
    } else if (error?.body?.message) {
      messages.add(error.body.message);
    } else if (error?.message) {
      messages.add(error.message);
    } else {
      messages.add('Unknown error');
    }

    return Array.from(messages).join(' | ');
  }
}