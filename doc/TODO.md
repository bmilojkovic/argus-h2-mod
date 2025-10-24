## Will do

- Anvil Ring (Hephaestus): increased damage for Common Rarity
- Controlled Burn (Hestia): increased bonus from Poms of Power
- Sword Ring (Ares): increased damage
- Carnal Pleasure (Ares x Aphrodite): increased effectiveness
- Shadow Pounce (Artemis): increased effectiveness
- Life Tax (Hades): increased effectiveness; restorative effect is no longer reduced by Vow of Scars (Oath)
- Last Gasp (Hades): increased effectiveness
- Elephant Rockets (Coat - Shiva): increased damage
- Chakra Collider (Coat - Shiva): increased damage

- Make successful login screen have a link to the twitch extension.

## Need to test

- Improve the test generator:
  - Add arcana and vows
  - Make all generators have better strategies
- Test Apollo legendary with torches - seems to be a different Trait
- Test Dio keepsake - maybe it stays as a different keepsake in followup biomes.
- Make a benchmark for number of messages sent to twitch. Make sure it is below 100/min. Also, add a warning log if we get close.
- Check Linux

## For later

- Change frontend code so that it doesn't keep historic messages forever.
- To get actual values: look at TraitData and TraitLogic. Specifically ExtractValues and SetTraitTextData.
- Some specific keepsake details
  - Add evil eye detail (who killed you)
  - Add blackened fleece detail (current total damage)
- Artificer remaining use count
- Crimson dress current damage bonus.
- Add icons and colors to description text (currently we are limited to bold only)
- Add hammer ranks
- Use hammer frame where needed
- Have the backend check mod version and decide weather it should forward the data to extension or not. We want to do this in case of a big game patch, and data is all wrong.
- Have the backend throttle messages from mod if too many are coming in.
- Consumables
- Support for Echo
