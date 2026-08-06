import express from 'express';

const app = express();
app.use(express.json());

let snippets = [
  {
    id: 1,
    text: 'console.log("Hello, world!");',
    createdAt: Date.now() - 3000,
  },
  {
    id: 2,
    text: 'const sum = (a, b) => a + b;',
    createdAt: Date.now() - 2000,
  },
  {
    id: 3,
    text: 'document.querySelector("#app").textContent = "Ready";',
    createdAt: Date.now() - 1000,
  },
];

let nextId = 4;

app.get('/api/snippets', (_req, res) => {
  res.json(snippets);
});

app.post('/api/snippets', (req, res) => {
  const { text } = req.body;
  if (!text || !text.trim()) {
    return res.status(400).json({ error: 'text is required' });
  }
  const snippet = { id: nextId++, text, createdAt: Date.now() };
  snippets.unshift(snippet);
  res.status(201).json(snippet);
});

app.delete('/api/snippets/:id', (req, res) => {
  const id = Number(req.params.id);
  snippets = snippets.filter((s) => s.id !== id);
  res.status(204).end();
});

const PORT = 3001;
app.listen(PORT, () => {
  console.log(`Backend on port ${PORT}`);
});
