import asyncio
import requests
import sys

import argparse

import argus_auth
from argus_util import argus_log

#argus_backend = "http://localhost:3000"
argus_backend = "https://argus-h2-backend.fly.dev"

async def send_to_backend(pluginpath, boon_data, weapon_data, familiar_data, extra_data, elemental_data, pin_data, vow_data, arcana_data):
    argus_token = argus_auth.get_argus_token(pluginpath, argus_backend)
    
    if argus_token == "FAIL":
        argus_log("Failed to read token from config file. :(")
        return

    argus_log("Logged in user: " + argus_token.strip())

    argus_log("Boon list: " + str(boon_data.strip()))
    argus_log("Weapon: " + str(weapon_data.strip()))
    argus_log("Familiar: " + str(familiar_data.strip()))
    argus_log("Extras: " + str(extra_data.strip()))
    argus_log("Elements: " + str(elemental_data.strip()))
    argus_log("Pins: " + str(pin_data.strip()))
    argus_log("Vows: " + str(vow_data.strip()))
    argus_log("Arcana: " + str(arcana_data.strip()))
   
    response = requests.post(
        argus_backend + "/run_info",
        json = {
            "argusProtocolVersion": "1",
            "argusToken": argus_token,
            "runData": {
                "boonData": boon_data.strip(),
                "weaponData": weapon_data.strip(),
                "familiarData": familiar_data.strip(),
                "extraData": extra_data.strip(),                        
                "elementalData" : elemental_data.strip(),
                "pinData" : pin_data.strip(),
                "vowData": vow_data.strip(),
                "arcanaData": arcana_data.strip()
            },
        })
    argus_log("Response: " + str(response))

def read_data_from_stdin():
    boon_data = sys.stdin.readline()
    weapon_data = sys.stdin.readline()
    familiar_data = sys.stdin.readline()
    extra_data = sys.stdin.readline()
    elemental_data = sys.stdin.readline()
    pin_data = sys.stdin.readline()
    vow_data = sys.stdin.readline()
    arcana_data = sys.stdin.readline()

    return boon_data, weapon_data, familiar_data, extra_data, elemental_data, pin_data, vow_data, arcana_data

def main():
    if args["login"]: # doing just argus login and saving to config. no data sending
        argus_log("Doing argus login...")
        res = argus_auth.initial_auth_check(args["pluginpath"], argus_backend)
        if res == "HAVE_TOKEN":
            argus_log("Skipping auth. Already have token in config file.")
        elif res == "FAIL":
            argus_log("Failed login after all retries.")
        else:
            argus_log("Successful login with token: " + res)
    else:
        boon_data, weapon_data, familiar_data, extra_data, elemental_data, pin_data, vow_data, arcana_data = read_data_from_stdin()
        asyncio.run(send_to_backend(args["pluginpath"], boon_data, weapon_data, familiar_data, extra_data, elemental_data, pin_data, vow_data, arcana_data))

if __name__ == "__main__":
    arg_parser = argparse.ArgumentParser(description="Send Argus data to the Argus backend.")
    arg_parser.add_argument('--pluginpath', required=True, help="Path to the Argus plugin folder.")
    arg_parser.add_argument('--login', action="store_true", help="Just do login. No sending.")

    args = vars(arg_parser.parse_args())

    main()