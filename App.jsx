import React, { useState } from 'react';
import Header from './components/Header';
import Sidebar from './components/Sidebar';
import SnippetList from './components/SnippetList';

export default function App() {
  const [snippets, setSnippets] = useState([]);
  const [filter, setFilter] = useState('all');

  const addSnippet = (text) => {
    setSnippets(prev => [{ id: Date.now(), text, createdAt: Date.now() }, ...prev]);
  };

  const deleteSnippet = (id) => {
    setSnippets(prev => prev.filter(s => s.id !== id));
  };

  const filteredSnippets = filter === 'recent' ? snippets.slice(0, 5) : snippets;

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
