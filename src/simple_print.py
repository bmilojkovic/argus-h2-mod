from twitchAPI.twitch import Twitch
from twitchAPI.helper import first
from twitchAPI.oauth import UserAuthenticationStorageHelper
import asyncio
import requests
import sys

extension_id = "sl19e3aebmadlewzt7mxfv3j3llwwv"
api_client_secret = "jaj66oy02as7x9kplcotsxje7lounb"

async def twitch_example(run_data):
    # initialize the twitch instance, this will by default also create a app authentication for you
    twitch = await Twitch(extension_id, api_client_secret)

    target_scope = []
    helper = UserAuthenticationStorageHelper(twitch, target_scope)
    await helper.bind() # do OAuth login, or use the existing one
    
    # figure out the logged in user (broadcaster)
    logged_in_user = await first(twitch.get_users())
    response = requests.post("http://localhost:3000/run_info", json = {"user": logged_in_user.id, "run_data": run_data})
    print(response)
    
run_data = sys.stdin.readline()
asyncio.run(twitch_example(run_data))
