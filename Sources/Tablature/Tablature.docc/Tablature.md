# ``Tablature``

Guitar, bass, and any stringed instrument tablature visualization for SwiftUI.

## Overview

Tablature is a Swift package that renders tablature notation for stringed instruments using SwiftUI. It supports both static tablature display from pre-built sequences and real-time scrolling tablature driven by live input (e.g., a MIDI guitar).

The library is dependency-free and works on macOS 12+, iOS 15+, and visionOS 1+.

### Quick Start — Static Tablature

Build a `TabSequence` from measures and notes, then display it with `TablatureView`:

```swift
import Tablature

let measure = TabMeasure(
    duration: 4.0,
    notes: [
        TabNote(string: 3, fret: 0, time: 0),
        TabNote(string: 3, fret: 3, time: 1),
        TabNote(string: 3, fret: 5, time: 2),
    ]
)
let sequence = TabSequence(instrument: .guitar, measures: [measure])

TablatureView(sequence: sequence)
```

### Quick Start — Live Tablature

Create a `LiveTablatureModel` and feed it notes over time:

```swift
import Tablature

let model = LiveTablatureModel(instrument: .guitar, timeWindow: 5.0)

LiveTablatureView(model: model)

// Add notes as they arrive:
model.addNote(string: 0, fret: 5)
```

Notes appear at the right edge and scroll left as time advances. The model automatically prunes off-screen notes to keep memory bounded.

### Theming

Customize appearance with `TablatureStyle` via the environment:

```swift
TablatureView(sequence: .smokeOnTheWater)
    .tablatureStyle(TablatureStyle(
        stringSpacing: 24,
        measureWidth: 400,
        fretColor: .blue
    ))
```

### Performance

`LiveTablatureView` uses `Canvas` with `TimelineView` for efficient rendering at display frame rate. The `LiveTablatureModel` calls `pruneOffScreenNotes()` on every note addition, discarding notes that have scrolled past the visible time window. This keeps memory usage constant regardless of session length.

## Topics

### Models

- ``StringInstrument``
- ``TabNote``
- ``TabMeasure``
- ``TabSequence``
- ``Articulation``
- ``LiveNote``

### Views

- ``TablatureView``
- ``LiveTablatureView``

### Configuration

- ``TablatureStyle``
- ``LiveTablatureModel``

### Examples

- ``TabSequence/smokeOnTheWater``
- ``TabSequence/cMajorScale``
- ``TabSequence/bluesLick``
- ``TabSequence/eMinorChord``
