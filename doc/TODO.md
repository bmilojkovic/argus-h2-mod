# 1.1.0

## Will do

- Add names of levels (Common / Rare / etc) to the UI
  - Did boons, keepsakes and weapons
  - Familiars still need to be done
- Add hammer ranks
- Use hammer frame where needed
- Have the backend check mod version and decide wheather it should forward the data to extension or not.
  - We want to do this in case of a big game patch, and data is all wrong.
  - The streamer might have the mod not be updated, but they WILL be using the newest extension always.

## Might do (still considering if it is actually useful)

- Add names of images to messages. Right now they are just ID.png

## Might do (if required)

- Add icons and colors to description text (currently we are limited to bold only)
- Have the backend throttle messages from mod if too many are coming in.

## Need to test

- Boons
  - Anvil Ring (Hephaestus): increased damage for Common Rarity
  - Sword Ring (Ares): increased damage
  - Carnal Pleasure (Ares x Aphrodite): increased effectiveness
  - Chakra Collider (Coat - Shiva): increased damage
- Improve the test generator:
  - Add arcana and vows
  - Make all generators have better strategies
- Test Apollo legendary with torches - seems to be a different Trait
- Test Dio keepsake - maybe it stays as a different keepsake in followup biomes.
- Make a benchmark for number of messages sent to twitch. Make sure it is below 100/min. Also, add a warning log if we get close.
- Check Linux

# For later (2.0+)

- To get actual values: look at TraitData and TraitLogic. Specifically ExtractValues and SetTraitTextData.
- Some specific keepsake details
  - Add evil eye detail (who killed you)
  - Add blackened fleece detail (current total damage)
- Artificer remaining use count
- Crimson dress current damage bonus.
- Consumables
- Support for Echo
