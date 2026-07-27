import React from 'react';

const SECTIONS = [
  { id: 'all', label: 'All Snippets' },
  { id: 'recent', label: 'Recent' },
];

export default function Sidebar({ filter, onFilterChange }) {
  return (
    <aside className="sidebar">
      <nav>
        {SECTIONS.map((s) => (
          <button
            key={s.id}
            className={`sidebar-item ${filter === s.id ? 'active' : ''}`}
            onClick={() => onFilterChange(s.id)}
          >
            {s.label}
          </button>
        ))}
      </nav>
    </aside>
  );
}
