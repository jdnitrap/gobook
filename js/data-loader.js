// Data loading module - handles fetching questions, notes, and content from files

export const dataLoader = {
    async loadQuestions(app) {
        app.allQuestions = [];
        try {
            const response = await fetch('questions.json?v=' + Date.now());
            const data = await response.json();
            if (data.questions && Array.isArray(data.questions)) {
                app.allQuestions = data.questions;
            }
        } catch (error) {
            console.warn('Main questions.json not loaded or empty:', error);
        }
        try {
            const response2 = await fetch('th07b_questions.json');
            const data2 = await response2.json();
            if (data2.questions && Array.isArray(data2.questions)) {
                app.allQuestions = app.allQuestions.concat(data2.questions);
            }
        } catch (error) {
            console.warn('TH07B questions not loaded:', error);
        }
        document.getElementById('questionsCount').textContent = app.allQuestions.length;
        document.getElementById('subjectsCount').textContent = new Set(app.allQuestions.map(q => q.subject)).size;
    },

    async loadNotes(app) {
        app.allNotes = [];
        try {
            const response = await fetch('notes.json?v=' + Date.now());
            const data = await response.json();
            if (data.notes && Array.isArray(data.notes)) {
                app.allNotes = data.notes;
            }
        } catch (error) {
            console.warn('Main notes.json not loaded or empty:', error);
        }
        try {
            const response2 = await fetch('th07b_notes.json');
            const data2 = await response2.json();
            if (data2.notes && Array.isArray(data2.notes)) {
                app.allNotes = app.allNotes.concat(data2.notes);
            }
        } catch (error) {
            console.warn('TH07B notes not loaded:', error);
        }
        document.getElementById('notesSubjectsCount').textContent = new Set(app.allNotes.map(n => n.subject)).size;
    },

    async getNoteContent(note) {
        if (note.content) {
            return note.content;
        }
        if (note.contentFile) {
            try {
                const response = await fetch(note.contentFile);
                const text = await response.text();
                const pattern = new RegExp(`\\[Note ID: ${note.id}\\][\\s\\S]*?(?=\\[Note ID:|$)`);
                const match = text.match(pattern);
                if (match) {
                    return match[0].replace(`[Note ID: ${note.id}]`, '').trim();
                }
                return "Content not found";
            } catch (error) {
                return "Error loading content: " + error.message;
            }
        }
        return "No content available";
    }
};
