import React, { useState, useEffect } from 'react';
import Header from './components/Header';
import Sidebar from './components/Sidebar';
import SnippetList from './components/SnippetList';

export default function App() {
  const [snippets, setSnippets] = useState([]);
  const [filter, setFilter] = useState('all');

  useEffect(() => {
    fetch('/api/snippets')
      .then((res) => res.json())
      .then(setSnippets)
      .catch((err) => console.error('Failed to load snippets:', err));
  }, []);

  const addSnippet = async (text) => {
    try {
      const res = await fetch('/api/snippets', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ text }),
      });
      const snippet = await res.json();
      setSnippets((prev) => [snippet, ...prev]);
    } catch (err) {
      console.error('Failed to add snippet:', err);
    }
  };

  const deleteSnippet = async (id) => {
    try {
      await fetch(`/api/snippets/${id}`, { method: 'DELETE' });
      setSnippets((prev) => prev.filter((s) => s.id !== id));
    } catch (err) {
      console.error('Failed to delete snippet:', err);
    }
  };

  const filteredSnippets =
    filter === 'recent' ? snippets.slice(0, 5) : snippets;

  return (
    <div className="app">
      <Header snippets={snippets} onPaste={addSnippet} />
      <div className="layout">
        <Sidebar filter={filter} onFilterChange={setFilter} />
        <SnippetList snippets={filteredSnippets} onDelete={deleteSnippet} />
      </div>
    </div>
  );
}
