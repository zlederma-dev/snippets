import React, { useState } from 'react';

export default function SnippetCard({ snippet, onDelete }) {
  const [copied, setCopied] = useState(false);

  const handleCopy = async () => {
    try {
      await navigator.clipboard.writeText(snippet.text);
      setCopied(true);
      setTimeout(() => setCopied(false), 1500);
    } catch (err) {
      console.error('Copy failed:', err);
    }
  };

  return (
    <div className="card">
      <pre className="card-text">{snippet.text}</pre>
      <div className="card-actions">
        <button className="btn btn-copy" onClick={handleCopy}>
          {copied ? 'Copied!' : 'Copy'}
        </button>
        <button className="btn btn-delete" onClick={() => onDelete(snippet.id)}>
          Delete
        </button>
      </div>
    </div>
  );
}
