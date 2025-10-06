## Will do

- Forget-me-nots
  - Add scrolling for boons that have too many requirements
- Read pet effects correctly instead of assuming max rank
- Move argus tokens and ui parse data to S3
- Security
  - Add nice logging messaging on frontend
  - Make the frontend resistant to any properties missing.
- Support for:
  - Icarus (works, but goes in boons and should go in extra)
  - Medea (check in-game)
  - Circe (check in-game)
  - Athena (check in-game)
  - Dionysus (check in-game)
- Make successful login screen have a link to the twitch extension.

## Need to test

- Test Apollo legendary with torches - seems to be a different Trait
- Check in-game how the chaos infusion boon (chant) works with respect to rarity. Is is infusion or common/rare/epic?
- Make a benchmark for number of messages sent to twitch. Make sure it is below 100/min. Also, add a warning log if we get close.
- Check if perfect-level weapons work (they probably don't)
- If you get the same Chaos blessing twice, is it two Traits?
- Check Linux

## Maybe doing

- Support for Echo?
- Consumables?

## For later

- To get actual values: look at TraitData and TraitLogic. Specifically ExtractValues and SetTraitTextData.
- Some specific keepsake details
  - Add evil eye detail (who killed you)
  - Add blackened fleece detail (current total damage)
- Add icons to description text (currently we are limited to text only)
- Add colors to description text
- Add hammer ranks
- Have the backend check mod version and decide weather it should forward the data to extension or not. We want to do this in case of a big game patch, and data is all wrong.
