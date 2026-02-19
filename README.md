# Chill — iOS (SwiftUI)

A calm, secular meditation companion inspired by the *core principles* of **The Joy of Living** (experiential practice, beginner-friendly, neuroscience-compatible framing), while avoiding religious language, ritual, or dogma.

**App name:** Chill

This repo is authored to be:
- **Beginner-safe** (normalizes distraction, includes grounding exits)
- **Accessibility-first** (VoiceOver, Dynamic Type, high contrast, reduced motion)
- **Low-pressure** (no streak guilt, no performance scoring)

> Note: This workspace contains the full Swift source + resources. Because iOS builds require **Xcode on macOS**, you’ll open this in Xcode and create an iOS App project, then drop the `Sources/` content in (instructions below).

## Features (MVP)
- Guided + unguided sessions (3 / 5 / 8 / 12 minutes)
- 4 practice families:
  - Awareness (foundation)
  - Body-based (grounding)
  - Kindness (non-sentimental)
  - Open awareness (effortless, later)
- Captions/transcripts for every guided session
- Grounding “exit ramp” always available
- Gentle reflections (no scoring)
- Settings: font size, theme, reduced motion respect, bells toggle, ambient toggle, playback speed

## Project structure
- `Sources/` — Swift code (SwiftUI)
- `Resources/Sessions/` — session catalog + scripts/transcripts (JSON)
- `Docs/` — copy style guide + UX notes

## Build/run (macOS + Xcode)
1. Create a new Xcode project:
   - iOS → App
   - Interface: SwiftUI
   - Language: Swift
   - Minimum iOS: 17.0 (recommended)

2. Copy the `Sources/` directory into the Xcode project (drag into the project navigator).

3. Add resources:
   - Add `Resources/Sessions/` into the project and ensure “Copy items if needed” is checked.

4. Build & Run.

## Content philosophy
Meditation here is framed as a **trainable skill**.
- Awareness is already present.
- Thoughts/emotions are allowed.
- Practice is “familiarity over force.”

## License
TBD (choose when publishing).
