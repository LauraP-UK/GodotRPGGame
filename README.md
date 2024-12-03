# Development Journal

## Stable Version `alpha0.1.0`
[Watch Demo on YouTube](https://www.youtube.com/watch?v=2Wf7qZYmZMw)

This is the first stable version of the game, showcasing features like tilesets and animations for elements such as water, NPCs, the Player, and fade-out/in effects for loading.

### Key Highlights
- Fully functional collision detection between the Player and the environment.
- Support for multiple storeys in each level, enabling correct rendering order to simulate height in the map.
- Implemented tile-based triggers for unloading and loading adjacent levels.

### Known Issues
- Minor visual bugs in tile map layer ordering, planned for a complete system rework in future versions.

---

## Stable Version `alpha0.1.1`
[Watch Demo on YouTube](https://www.youtube.com/watch?v=BspFV97tyxs)

This version focused on reworking tile behaviour rules to ensure a unified structure using abstract contracts. (Think of Java Interfaces, or as close as GDScript allows.)

### Key Highlights
- Unified tile behaviour presets (`Solid`, `Open`, `One-Way`, etc.) with a streamlined triggering method for consistency and simplicity.
- Introduced sliding ice tiles: Actors stepping on these tiles are pushed continuously in the same direction until encountering an obstacle, enabling classic sliding ice puzzles.

---

## Stable Version `alpha0.2.0`
[Watch Demo on YouTube](https://www.youtube.com/watch?v=1DTj43-M8OQ)

This version features a reworked movement and loading system, marking the introduction of custom data nodes.

### Key Highlights
- **Custom Data Nodes:** Nodes in the editor now allow the specification of data such as NPC spawn points, item spawn points, and loading zones. At runtime, the game parses these nodes and uses them to set up internal processes dynamically.
- **Optimised Multi-Storey Movement:** Improved handling of Actors transitioning between different height levels within a map.
- **Seamless Loading Zones:**
  - Overhauled the initial fade-out/in loading system for entire levels.
  - Added zones for seamless loading and unloading of adjacent areas in larger maps without a loading screen.
  - Unloaded areas remain inactive, meaning NPCs and objects are not updated or ticked off-screen unnecessarily, improving performance.

---

### Notes
This project is an ongoing learning process, and future updates aim to further refine the systems while expanding functionality. Feedback is always welcome!
