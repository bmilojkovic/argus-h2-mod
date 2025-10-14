## Will do

- Write README for twitch and backend repositories.
- Add python as a dependency in the main mod DOCs
- Make successful login screen have a link to the twitch extension.

## Need to test

- Make a test generator for python script
- Test Apollo legendary with torches - seems to be a different Trait
- Test Dio keepsake - maybe it stays as a different keepsake in followup biomes.
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
- Have the backend throttle messages from mod if too many are coming in.
- Consumables
- Support for Echo
