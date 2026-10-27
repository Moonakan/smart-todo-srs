/* Лабораторная работа 3: добавление, редактирование и удаление. */
(() => {
  'use strict';

  const STORAGE_KEY = 'collection-organizer-v1';
  const LABELS = { book: 'Книга', vinyl: 'Винил', movie: 'Фильм', game: 'Игра' };
  const form = document.getElementById('itemForm');
  const list = document.getElementById('itemsList');
  const emptyMessage = document.getElementById('emptyMessage');
  const counter = document.getElementById('counter');
  const formMessage = document.getElementById('formMessage');
  const saveButton = document.getElementById('saveButton');
  const cancelButton = document.getElementById('cancelButton');
  const formTitle = document.getElementById('formTitle');
  let editingId = null;

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

  function makeAction(label, action, id, className) {
    const button = document.createElement('button');
    button.type = 'button';
    button.className = `button small ${className}`;
    button.textContent = label;
    button.dataset.action = action;
    button.dataset.id = id;
    return button;
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
      const actions = document.createElement('div');
      actions.className = 'item-actions';
      actions.append(
        makeAction('Редактировать', 'edit', item.id, 'edit'),
        makeAction('Удалить', 'delete', item.id, 'delete')
      );
      li.append(info, actions);
      list.append(li);
    });
  }

  function resetEditor() {
    editingId = null;
    form.reset();
    saveButton.textContent = 'Добавить предмет';
    formTitle.textContent = 'Добавить предмет';
    cancelButton.hidden = true;
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

    if (editingId) {
      const item = items.find((entry) => entry.id === editingId);
      if (!item) {
        showMessage('Предмет не найден.', true);
        resetEditor();
        return;
      }
      const oldValues = { ...item };
      Object.assign(item, { name, category, creator, year: yearText, notes });
      if (!persist()) {
        Object.assign(item, oldValues);
        return;
      }
      showMessage('Изменения сохранены.');
    } else {
      const item = { id: makeId(), name, category, creator, year: yearText, notes, status: 'В коллекции' };
      items.push(item);
      if (!persist()) {
        items.pop();
        return;
      }
      showMessage('Предмет добавлен в коллекцию.');
    }
    resetEditor();
    render();
  });

  list.addEventListener('click', (event) => {
    const button = event.target.closest('button[data-action]');
    if (!button) return;
    const item = items.find((entry) => entry.id === button.dataset.id);
    if (!item) return;
    if (button.dataset.action === 'edit') {
      editingId = item.id;
      document.getElementById('name').value = item.name;
      document.getElementById('category').value = item.category;
      document.getElementById('creator').value = item.creator || '';
      document.getElementById('year').value = item.year || '';
      document.getElementById('notes').value = item.notes || '';
      saveButton.textContent = 'Сохранить изменения';
      formTitle.textContent = 'Редактировать предмет';
      cancelButton.hidden = false;
      showMessage('');
      form.scrollIntoView({ behavior: 'smooth', block: 'start' });
    } else if (button.dataset.action === 'delete') {
      if (!window.confirm(`Удалить «${item.name}» из коллекции?`)) return;
      const index = items.indexOf(item);
      items.splice(index, 1);
      if (!persist()) {
        items.splice(index, 0, item);
        return;
      }
      if (editingId === item.id) resetEditor();
      showMessage('Предмет удалён.');
      render();
    }
  });

  cancelButton.addEventListener('click', () => {
    resetEditor();
    showMessage('Редактирование отменено.');
  });

  render();
})();
