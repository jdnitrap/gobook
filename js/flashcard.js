// Flashcard module - handles flashcard study mode

import { ui } from './ui.js';
import { dataLoader } from './data-loader.js';

export const flashcard = {
    async startFlashcards(app) {
        const notes = app.allNotes.filter(n => n.subject === app.currentNotesSubject);
        app.answers = notes;
        app.currentCardIndex = 0;
        app.cardFlipped = false;
        await this.showFlashcard(app);
        ui.showScreen('flashcardScreen');
    },

    async showFlashcard(app) {
        const card = app.answers[app.currentCardIndex];
        if (!card) return;

        document.getElementById('cardNumber').textContent = app.currentCardIndex + 1;
        document.getElementById('cardTotal').textContent = app.answers.length;

        const progress = Math.round(((app.currentCardIndex + 1) / app.answers.length) * 100);
        document.getElementById('cardProgressFill').style.width = progress + '%';

        app.cardFlipped = false;
        document.getElementById('cardContent').textContent = card.title;

        // Preload content for this card
        if (!card._contentLoaded) {
            card._content = await dataLoader.getNoteContent(card);
            card._contentLoaded = true;
        }
    },

    flipCard(app) {
        const card = app.answers[app.currentCardIndex];
        if (!card) return;

        app.cardFlipped = !app.cardFlipped;
        if (app.cardFlipped) {
            document.getElementById('cardContent').textContent = card._content || card.content || "Loading...";
        } else {
            document.getElementById('cardContent').textContent = card.title;
        }
    },

    async nextCard(app) {
        if (app.currentCardIndex < app.answers.length - 1) {
            app.currentCardIndex++;
            await this.showFlashcard(app);
        } else {
            ui.goHome(app);
        }
    }
};
