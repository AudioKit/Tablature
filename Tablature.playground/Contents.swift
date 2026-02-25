import Tablature
import PlaygroundSupport
import SwiftUI

// MARK: - Section 1: Static Tablature
//
// Static tablature is built from three types:
//
//   TabNote     — a single note: string index, fret number, and time position (seconds).
//   TabMeasure  — a measure containing notes with a duration and time signature.
//   TabSequence — an ordered list of measures tied to a StringInstrument.
//
// TablatureView renders a TabSequence as standard tablature notation with
// horizontal staff lines, fret numbers, bar lines, and string labels.
//
// The library ships with several built-in examples:
//   .smokeOnTheWater, .cMajorScale, .eMinorChord, .bluesLick
//
// You can also build a passage from scratch:
//
//   let measure = TabMeasure(
//       duration: 4.0,
//       notes: [
//           TabNote(string: 3, fret: 0, time: 0),
//           TabNote(string: 3, fret: 3, time: 1),
//           TabNote(string: 3, fret: 5, time: 2),
//       ]
//   )
//   let seq = TabSequence(instrument: .guitar, measures: [measure])
//   TablatureView(sequence: seq)

// MARK: - Section 2: Theming
//
// TablatureStyle controls colors, fonts, spacing, and sizing. Apply it with the
// .tablatureStyle() view modifier or set it via the environment.
//
//   TablatureView(sequence: .smokeOnTheWater)
//       .tablatureStyle(TablatureStyle(
//           stringSpacing: 24,
//           measureWidth: 400,
//           lineThickness: 2,
//           fretColor: .blue,
//           lineColor: .gray
//       ))
//
// The default style adapts to light/dark mode automatically.

// MARK: - Section 3: Live View with Simulated Input
//
// LiveTablatureModel is an ObservableObject that accumulates timestamped notes.
// LiveTablatureView renders them in real time using Canvas + TimelineView — notes
// appear at the right edge and scroll left as time advances.
//
// Create a model, then call addNote(string:fret:) whenever a note arrives:
//
//   let model = LiveTablatureModel(instrument: .guitar, timeWindow: 5.0)
//   model.addNote(string: 0, fret: 5)
//
// The model automatically prunes off-screen notes to keep memory bounded.
// Below, a Timer drives simulated input to demonstrate the scrolling effect.

struct ContentView: View {
    @StateObject private var liveModel = LiveTablatureModel(instrument: .guitar)
    @State private var isPlaying = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // MARK: - Live Tablature
                Text("Live Tablature")
                    .font(.headline)
                LiveTablatureView(model: liveModel)
                    .frame(height: 140)
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(8)
                HStack {
                    Button(isPlaying ? "Stop" : "Play Demo") {
                        isPlaying.toggle()
                        if isPlaying {
                            liveModel.reset()
                            startSimulatedInput()
                        }
                    }
                    Button("Reset") {
                        isPlaying = false
                        liveModel.reset()
                    }
                }

                Divider()

                // MARK: - Static Examples
                Text("Smoke on the Water")
                    .font(.headline)
                TablatureView(sequence: .smokeOnTheWater)

                Text("C Major Scale")
                    .font(.headline)
                TablatureView(sequence: .cMajorScale)

                Text("E Minor Chord")
                    .font(.headline)
                TablatureView(sequence: .eMinorChord)

                Text("Blues Lick (Articulations)")
                    .font(.headline)
                TablatureView(sequence: .bluesLick)

                // MARK: - Custom Styled
                Text("Custom Styled")
                    .font(.headline)
                TablatureView(sequence: .smokeOnTheWater)
                    .tablatureStyle(TablatureStyle(
                        stringSpacing: 24,
                        measureWidth: 400,
                        lineThickness: 2,
                        fretColor: .blue,
                        lineColor: .gray
                    ))
            }
            .padding()
        }
        .frame(width: 800, height: 1000)
    }

    private func startSimulatedInput() {
        let pattern: [(string: Int, fret: Int)] = [
            (0, 0), (0, 3), (1, 0), (1, 2), (2, 0), (2, 2),
            (3, 0), (3, 2), (4, 0), (4, 3), (5, 0), (5, 3),
        ]
        var index = 0

        Timer.scheduledTimer(withTimeInterval: 0.35, repeats: true) { timer in
            guard isPlaying else {
                timer.invalidate()
                return
            }
            let entry = pattern[index % pattern.count]
            liveModel.addNote(string: entry.string, fret: entry.fret)
            index += 1
        }
    }
}

PlaygroundPage.current.setLiveView(ContentView())
