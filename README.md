# Argus 👀

Argus is a `Hades II` mod that supports the Argus Twitch extension. It will show your viewers various details about your run. May chat never ask you about your fear setup ever again. 🎉

## Features

Sends data from your `Hades II` game to Twitch, displaying the following to your viewers:

- Run information (boons, hammers, keepsake, weapon, familiar, ...)
- Arcana loadout
- Fear setup
- Up to three boons pinned in the codex will be shown (with requirements) as targets for this run.

Note that the Twitch overlay will not always update instantly. We send updatesonly when you exit a room during a run. There are no updates in the Crossroads or mid-fight.

See the full list of data that we show to viewers [below](#full-argus-scope).

## Installation instructions

- The mod has not been tested on Linux or Mac yet. We officially support only Windows for now.
- To install this mod, you need [r2modman](https://thunderstore.io/package/ebkr/r2modman/), which is a mod manager. This is because we publish through [Thunderstore](https://thunderstore.io/) for our and your convenience.
- Once you have `r2modman` installed, just find Argus in the list of `Hades II` mods and install it.

## Setting up after install and testing with Twitch

You can follow the steps below and check if everything is working properly before going live on Twitch.

- Once the mod is installed, run the game with the mod active. You need to run the game from r2modman, and not from Steam. During startup you will be prompted to connect your Twitch account with Argus. The only thing we will ask for and use is permission to read your username. This process ensures that streamers can not be impersonated in our system.
- During game startup, you will be asked to authenticate through Twitch for the connection process. The prompt **will appear in a browser window**. When this happens, `Hades II` might appear frozen. This is fine - the game does that when it loses focus. After the connection with Argus is established, you can come back to the game.
- The connection step above needs to be done only once. If you failed to connect your account with Argus and want to try again, you can just restart the game or load a save - that is when the mod gets reloaded and will attempt the process if it hasn't succeeded yet.
- The next step is to enable the Argus Twitch extension on your stream. Go to `Twitch → Creator Dashboard → Extensions → Discovery`, find it in the extension search and enable it. You do not need to configure anything on the Twitch extension for it to start working.

With these steps done, you should be ready and set up. If you want to check that everything is working correctly, do the following:

- Go to `Twitch → Creator Dashboard → Extensions → My Extensions` and open the Argus configuration panel. It should confirm that the connection step you did previously was successful.
- To preview the extension, go to your `Stream Manager` tab on Twitch and click on the Argus 👀 icon listed under your `Quick Actions`. A window will pop up that shows you what your viewers will see as an overlay on your stream. If you want to see things changing, just start a `Hades II` run and go through one room. The display on twitch updates whenever you leave a room while doing a run. Note that it will not update in the Crossroads.

## What Argus doesn't see 🙈

Some notable things are still invisible to Argus and will hopefully be cleared up in the future. Here is a list of several items we assume you expect to have, but we do not support (yet):

- **Pom upgrades.** All boons will be shown as if they have 0 pom upgrades. This means that the numbers on the descriptions will not exactly match the game once your build starts getting juicy.
- **Chaos details.** Argus isn't able to percieve all the randomness that Chaos commands. Chaos curses and boons will be shown in their most basic version, which will almost certainly not match what you have in the game. The description will be correct, but number of rooms and particular numbers / percentages will be off.
- **Consumable items.** Consumable items such as those bought at the Well of Charon are currently invisible to Argus.
- **Path of stars upgrades.** Selene Hexes are fine, but each individual upgrade doesn't seem worth the limited room that we have on the extension UI, so Argus just skips them.
- **Any values that change over time.** Things such as:
  - Remaining healing left on the Ghost Onion Keepsake.
  - Current damage bonus from the Crimson Dress.
  - Number of uses on Moon Water.
  - etc.

We pray to Hera that Argus gains more insight in the near future and with it the ability to see all of these spicy details, and more. 🙏

## Full Argus scope

As a rule-of-thumb: if the information would be contained in a wiki page, we probably have it. Here is a comprehensive list of things currently observable by Argus:

- **Rarities**: Anything that has a rarity we almost certainly have covered. Boons, keepsakes, weapons, arcana cards, etc. will be shown with their respective rarities correctly.
- Panel 1: **Run**
  - Weapon
  - Familiar
  - All boons from all 9 primary Gods
    - Aphrodite
    - Apollo
    - Ares
    - Demeter
    - Hephaestus
    - Hera
    - Hestia
    - Poseidon
    - Zeus
  - Boons / Gifts from:
    - Artemis
    - Hades
    - Arachne
    - Medea
    - Circe
    - Icarus
    - Athena
    - Dionysus
    - Hermes
    - Chaos (including curses)
  - Keepsake
  - Hex
- Panel 2: **Arcana**
  - All currently active Arcana cards with their descriptions, shown in no particular order. The original layout from the Altar of Ashes is a goal for the future.
- Panel 3: **Vows of Night**
  - Shown like in the Oath of the Unseen with full descriptions.
- Panel 4: **Pinned boons**
  - Up to three boons pinned in the codex will be shown here as targets for the run. If these boons have requirements, they will be shown as well.

## Contact

If you have feedback or questions, feel free to contact the original author of this mod at: bandza88@gmail.com or come by the [Twitch stream](https://www.twitch.tv/crazy__penguin) where this mod was originally developed.
