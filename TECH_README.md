# How Argus Works

If you wish to dive deeper into how Argus works, you might want to look at two other relevant repositories:

- [Argus Backend](https://github.com/bmilojkovic/argus-h2-backend)
- [Argus Twitch Extension](https://github.com/bmilojkovic/argus-h2-twitch)

The main flow of data from the game to Twitch is as follows:

1. The data is parsed and assembled in the mod Lua code.
2. The Lua code invokes a python script to send the collected information to our backend service.
3. Our backend service does additional parsing and data transformation to prepare everything for the frontend. It then uses the Twitch pubsub API to broadcast information to viewers.
4. The Twitch extension receives this broadcast and displays information to viewers.

## Lua logic

TODO: coming soon

## Python logic

TODO: coming soon

## Connecting the user's Twitch account with Argus

TODO: coming soon
