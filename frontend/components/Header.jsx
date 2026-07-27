import React from 'react';

export default function Header({ snippets, onPaste }) {
  const handlePaste = async () => {
    try {
      const text = await navigator.clipboard.readText();
      if (text.trim()) onPaste(text);
    } catch (err) {
      console.error('Clipboard read failed:', err);
      alert('Could not read clipboard. Check browser permissions.');
    }
  };

  const handleLoad = async () => {
    for (const snippet of snippets) {
      try {
        await navigator.clipboard.writeText(snippet.text);
        await new Promise((r) => setTimeout(r, 800));
      } catch (err) {
        console.error('Load failed at snippet:', snippet.id, err);
      }
    }
  };

  return (
    <header className="header">
      <h1>Snippets</h1>
      <div className="header-actions">
        <button className="btn btn-primary" onClick={handlePaste}>
          Paste
        </button>
        <button
          className="btn btn-secondary"
          onClick={handleLoad}
          disabled={snippets.length === 0}
        >
          Load
        </button>
      </div>
    </header>
  );
}
