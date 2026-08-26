import React, { useState } from 'react';
import Header from './components/Header';
import Sidebar from './components/Sidebar';
import SnippetList from './components/SnippetList';

let nextId = 4;

const seedSnippets = [
  { id: 1, text: 'console.log("hello, world!");', createdAt: Date.now() - 3000 },
  { id: 2, text: 'const sum = (a, b) => a + b;', createdAt: Date.now() - 2000 },
  { id: 3, text: 'document.querySelector("#app").textContent = "Ready";', createdAt: Date.now() - 1000 },
];

export default function App() {
  const [snippets, setSnippets] = useState(seedSnippets);
  const [filter, setFilter] = useState('all');

  const addSnippet = (text) => {
    const snippet = { id: nextId++, text, createdAt: Date.now() };
    setSnippets((prev) => [snippet, ...prev]);
  };

  const deleteSnippet = (id) => {
    setSnippets((prev) => prev.filter((s) => s.id !== id));
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
