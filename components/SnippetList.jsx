import React from 'react';
import SnippetCard from './SnippetCard';

export default function SnippetList({ snippets, onDelete }) {
  if (snippets.length === 0) {
    return (
      <main className="snippet-list">
        <div className="empty">No snippets yet — press Paste to add one.</div>
      </main>
    );
  }

  return (
    <main className="snippet-list">
      {snippets.map((snippet) => (
        <SnippetCard key={snippet.id} snippet={snippet} onDelete={onDelete} />
      ))}
    </main>
  );
}
