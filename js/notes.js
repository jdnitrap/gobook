// Notes module - handles notes viewing

import { ui } from './ui.js';
import { dataLoader } from './data-loader.js';

export const notes = {
    async viewNotes(app) {
        const notesForSubject = app.allNotes.filter(n => n.subject === app.currentNotesSubject);
        const container = document.getElementById('notesListContainer');
        container.innerHTML = '';

        document.getElementById('notesViewTitle').textContent = app.currentNotesSubject + ' Notes';
        document.getElementById('notesCountDisplay').textContent = notesForSubject.length;

        for (const note of notesForSubject) {
            const noteDiv = document.createElement('div');
            noteDiv.className = 'note-card';
            const content = await dataLoader.getNoteContent(note);
            let html = `<h4>${note.title}</h4><p>${content}</p>`;
            if (note.image) {
                html += `<div style="text-align: center;">
                            <img src="${note.image}" alt="${note.title}" class="note-diagram">
                            <div class="note-image-label">${note.imageLabel || note.title}</div>
                        </div>`;
            }
            noteDiv.innerHTML = html;
            container.appendChild(noteDiv);
        }

        ui.showScreen('notesScreen');
    }
};
