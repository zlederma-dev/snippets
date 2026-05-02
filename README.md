# Snippets

A minimal clipboard manager web app. Paste, organize, and bulk-reload text snippets.

## Setup

```
npm install
npm run dev
```

## Features

- **Paste** — reads your clipboard and adds it as a new snippet
- **Copy** — copies an individual snippet back to your clipboard
- **Delete** — removes a snippet
- **Load** — sequences all snippets into the clipboard one by one, with a short delay between each

## Deployment

After running `npm run build`, copy the dist folder to your EC2 instance:

```
scp -i ~/.ssh/EC2_Tutorial.pem -r $(pwd)/dist ec2-user@<public-ip>:/app
```

## Load + Flycut

The Load button is designed to work with clipboard managers like [Flycut](https://github.com/TermiT/Flycut). When triggered, it writes each snippet to the clipboard 800ms apart, giving Flycut time to capture each entry into its history. Afterward you can page through them with Flycut's clippings shortcut.
