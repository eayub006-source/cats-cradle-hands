# Cat's Cradle

A single-file HTML/JavaScript webcam art app built with p5.js and MediaPipe Hands.

## What this project does

- Requests webcam access and uses the mirrored camera feed as the live background.
- Tracks both hands with MediaPipe Hands in real time.
- Draws glowing neon dots on finger joints.
- Connects fingertips between the left and right hands with elastic, animated string beams.
- Changes string thickness and glow based on hand separation.
- Adds particle bursts when fingertips touch.
- Uses a dark futuristic theme with cyan, magenta, and yellow glow accents plus CRT-style scanlines.

## What I built

I created the full interaction layer, rendering system, and camera pipeline in one standalone `index.html` file so it can run directly in a browser without a build step.

## How to run locally

Use the included PowerShell helper to serve the folder over your local network:

```powershell
.\start-local.ps1
```

Then open the shown address from the device you want to use, for example:

- `http://localhost:8000/` on the same machine.
- `http://<your-local-ip>:8000/` from another device on the same Wi-Fi network.

If your browser blocks camera access over a local network address, use localhost on the same machine or serve the folder over HTTPS. Camera permission is only reliable on `localhost` or a secure origin.

## Sharing with other people

The app is published here:

- https://github.com/eayub006-source/cats-cradle-hands

If someone wants to run it locally, they should clone the repo, run `start-local.ps1`, and open the printed URL. If they want webcam access from a phone or another device on the network, they may need to use a secure HTTPS host because browsers block camera access on plain HTTP network addresses.

## Files

- `index.html` - the complete single-file app.
- `README.md` - project summary and usage notes.
- `start-local.ps1` - local web server helper for easy browser testing.
