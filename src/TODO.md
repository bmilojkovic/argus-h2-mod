
## Will do
* Arcana cards
* Vows of night
* Backend is currently sending >5KB at around middle of run. Need to find a way to reduce it.
* Add icons to description text (currently limited to text only)
* Read pet effects correctly instead of assuming max rank
* Some specific keepsake details
  * Add evil eye detail (who killed you)
  * Add blackened fleece detail (current total damage)
  * Confirm all others are OK
* Add hammer ranks
* Security
  * Add timeout for pending argus token requests (also consider if other such timeouts are needed)
  * Implement twitch token refreshes
  * Implement asking the user to relogin with twitch
  * Have the backend check mod version and decide weather it should forward the data to extension or not. We want to do this in case of a big game patch, and data is all wrong.
  * Add nice logging messaging on frontend
* Support for:
  * Artemis
  * Hades
  * Arachne
  * Medea (check in-game)
  * Circe (check in-game)
  * Icarus (check in-game)
  * Athena (check in-game)
  * Dionysus (check in-game)
  * Hermes
  * Chaos (need to separate curses in-game and add them to extra)

## Need to test
* Test Apollo legendary with torches - seems to be a different Trait
* Check in-game how the chaos infusion boon (chant) works with respect to rarity. Is is infusion or common/rare/epic?

## Maybe doing
* Support for Echo?
* Consumables?