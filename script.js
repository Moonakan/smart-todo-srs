/* Лабораторная работа 3: добавление и просмотр предметов коллекции. */
(() => {
  'use strict';

  const STORAGE_KEY = 'collection-organizer-v1';
  const LABELS = { book: 'Книга', vinyl: 'Винил', movie: 'Фильм', game: 'Игра' };
  const form = document.getElementById('itemForm');
  const list = document.getElementById('itemsList');
  const emptyMessage = document.getElementById('emptyMessage');
  const counter = document.getElementById('counter');
  const formMessage = document.getElementById('formMessage');

  function loadItems() {
    try {
      const stored = JSON.parse(localStorage.getItem(STORAGE_KEY) || '[]');
      return Array.isArray(stored) ? stored.filter((item) => item && typeof item.name === 'string') : [];
    } catch (error) {
      console.warn('Не удалось загрузить коллекцию:', error);
      return [];
    }
  }

  const items = loadItems();

  function persist() {
    try {
      localStorage.setItem(STORAGE_KEY, JSON.stringify(items));
      return true;
    } catch (error) {
      console.error('Не удалось сохранить коллекцию:', error);
      showMessage('Не удалось сохранить данные в браузере.', true);
      return false;
    }
  }

  function showMessage(text, isError = false) {
    formMessage.textContent = text;
    formMessage.classList.toggle('error', isError);
  }

  function makeId() {
    return typeof crypto !== 'undefined' && typeof crypto.randomUUID === 'function'
      ? crypto.randomUUID()
      : `item-${Date.now()}-${Math.random().toString(36).slice(2)}`;
  }

  function render() {
    list.replaceChildren();
    counter.textContent = `Всего: ${items.length}`;
    emptyMessage.hidden = items.length > 0;

    items.forEach((item) => {
      const li = document.createElement('li');
      li.className = 'item';
      const info = document.createElement('div');
      const title = document.createElement('h3');
      title.className = 'item-title';
      title.textContent = item.name;
      const meta = document.createElement('p');
      meta.className = 'item-meta';
      meta.textContent = [LABELS[item.category] || item.category, item.creator, item.year].filter(Boolean).join(' · ');
      info.append(title, meta);
      if (item.notes) {
        const note = document.createElement('p');
        note.className = 'item-note';
        note.textContent = item.notes;
        info.append(note);
      }
      li.append(info);
      list.append(li);
    });
  }

  form.addEventListener('submit', (event) => {
    event.preventDefault();
    const name = document.getElementById('name').value.trim();
    const category = document.getElementById('category').value;
    const creator = document.getElementById('creator').value.trim();
    const yearText = document.getElementById('year').value.trim();
    const notes = document.getElementById('notes').value.trim();

    if (!name || !LABELS[category]) {
      showMessage('Укажите название и выберите тип коллекции.', true);
      return;
    }
    if (yearText && (!/^\d{1,4}$/.test(yearText) || Number(yearText) > 2100)) {
      showMessage('Год выпуска должен быть целым числом от 0 до 2100.', true);
      return;
    }

    const item = { id: makeId(), name, category, creator, year: yearText, notes, status: 'В коллекции' };
    items.push(item);
    if (!persist()) {
      items.pop();
      return;
    }
    form.reset();
    showMessage('Предмет добавлен в коллекцию.');
    render();
    document.getElementById('name').focus();
  });

  render();
})();

