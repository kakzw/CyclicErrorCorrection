# Cyclic Error Correction App

This SwiftUI app demonstrates a (15,11) cyclic error correction code simulation, which utilizes parity bits to detect and correct single-bit errors in transmitted messages.

## Overview
The app implements a simplified model of a cyclic error correction process involving:
- **Transmission Model (TxModel)**: This class handles message creation, encoding with parity bits, and simulates transmission by introducing error patterns.
- **Reception Model (RxModel)**: Manages the reception of encoded messages, decoding by calculating syndromes, and correcting errors based on predefined error maps.
- **Result Model**: Centralizes the simulation results for display purposes.
- **Input Model**: Tracks user inputs for message and error pattern entry, validating input completeness.
- **Random Model**: Generates random messages and error patterns for simulation purposes.

## Features
- **Simulation**: Users can input a message and an error pattern to simulate the error correction process.
- **Auto Simulation**: Can auto simulate without tapping on "Simulate" button. It changes the result view as the input changes automatically.
- **Result Display**: Displays the original message, code word, error pattern, corrected code word, corrected message, and whether the message was corrected successfully.
- **Code Word View**: Displays a list of all message and code word pairs.
- **Syndrom View**: Displays a list of all syndrom and error pattern pairs.

## Screenshots

## Installation
- To run this app, make sure you have `XCode` installed.
- Clone this repository.
- Open `CyclicErrorCorrection.xcodeproj` in `XCode`.
- Build and run the app on your iOS device or simulator.

## Usage
### Manual Simulation
1. **Message Input**: Enter 4 bit binary message (ex. 1001).
2. **Error Pattern Input**: Enter a 7 bit binary error pattern (ex. 1101000).
3. **View Result**: Tap the "Simulate" button to trigger the error correction process.

### Auto Simulation
1. **Auto Simulation Toggle**: Enable the "Auto Simulation" toggle button.
2. **Message and Error Pattern Inputs**: Enter valid message and error pattern similar to manual simulation.
3. **View Result**: Results are displayed automatically upon input.
