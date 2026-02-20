# boarding_manager

This tool has been vibe coded to help count points for Airport Madness Manager (https://papaeya.com/products/Airport-Madness-Manager-board-game) a board game where you help passenger navigate an airport and not miss their flights.

A small Flutter app that helps you run and score a round of the board game Airport Madness Manager. It includes a 120-second round timer and a simple score tracker for 4 passenger colors (Red, Blue, Yellow, Green). You record stress, delays, and missed passengers, then the app computes one total score called “Passengers Agony”.

Main features
- 120-second timer with play, pause, reset. When time reaches 0, it shows a “Time Up!” popup.
- Stress tracking: 4x6 grid (4 colors, 6 cells each). Tap a cell to cycle its value 0 to 6, then back to 0.
- Delay tracking: 4 “Delayed” switches (one per color).
- Missed passengers tracking: 4 “Missed” counters (one per color). Tap to cycle 0 to 6.

Passengers Agony calculation (from calculateScore())
1) Stress score
   Sum of all stress values in the 4x6 grid (24 cells total).

2) Delay score
   10 points for each color marked Delayed.
   delayScore = 10 * (number of Delayed switches that are ON)

3) Missed passengers score
   20 points for each missed passenger count, summed across colors.
   leftBehindScore = 20 * (sum of all Missed counters)

Final formula
Passengers Agony = (sum of all stress cells)
                 + 10 * (number of delayed colors)
                 + 20 * (sum of missed counters)

Hosted here: https://boarding-manager.web.app/

