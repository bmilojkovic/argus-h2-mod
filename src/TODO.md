## Will do

- Security
  - Make the frontend resistant to any properties missing.
- Make successful login screen have a link to the twitch extension.
- Stop doing auth every time

## Need to test

- Test generator for python script
- Test Apollo legendary with torches - seems to be a different Trait
- Check in-game how the chaos infusion boon (chant) works with respect to rarity. Is is infusion or common/rare/epic?
- Check in-game with pony:
  - All gods (DONE)
  - Artemis (DONE)
  - Hades (DONE)
  - Arachne (DONE)
  - Medea (DONE)
  - Circe
  - Icarus
  - Athena
  - Dionysus
  - Hermes
  - Chaos
  - Hammers
  - Weapons
  - Familiars
  - Keepsakes
  - Hexes
  - Vows
  - Arcana
  - Familiars and their levels
- Make a benchmark for number of messages sent to twitch. Make sure it is below 100/min. Also, add a warning log if we get close.
- Check if perfect-level weapons work (they probably don't)
- If you get the same Chaos blessing twice, is it two Traits?
- Check Linux

## For later

- To get actual values: look at TraitData and TraitLogic. Specifically ExtractValues and SetTraitTextData.
- Some specific keepsake details
  - Add evil eye detail (who killed you)
  - Add blackened fleece detail (current total damage)
- Crimson dress current damage bonus.
- Add icons and colors to description text (currently we are limited to bold only)
- Add hammer ranks
- Use hammer frame where needed
- Have the backend check mod version and decide weather it should forward the data to extension or not. We want to do this in case of a big game patch, and data is all wrong.
- Consumables
- Support for Echo
