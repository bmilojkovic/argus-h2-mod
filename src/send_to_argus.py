import asyncio
import requests
import sys

import argparse

import argus_auth
import argus_testing
from argus_util import argus_log

async def send_to_backend(boon_data, weapon_data, familiar_data, extra_data, elemental_data, pin_data, vow_data, arcana_data):
    argus_token = argus_auth.get_argus_token(args["pluginpath"])
    
    argus_log("Logged in user: " + argus_token)

    argus_log("Boon list: " + str(boon_data))
    argus_log("Weapon: " + str(weapon_data))
    argus_log("Familiar: " + str(familiar_data))
    argus_log("Extras: " + str(extra_data))
    argus_log("Elements: " + str(elemental_data))
    argus_log("Pins: " + str(pin_data))
    argus_log("Vows: " + str(vow_data))
    argus_log("Arcana: " + str(arcana_data))
   
    response = requests.post(
        "http://localhost:3000/run_info",
        json = {
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
            }
        })
    sys.stdout.write("Response: " + str(response))

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
    if args["test"] is not None:
        boon_data, weapon_data, familiar_data, extra_data, elemental_data, pin_data, vow_data, arcana_data = argus_testing.get_test_data(args["test"])
    else:
        boon_data, weapon_data, familiar_data, extra_data, elemental_data, pin_data, vow_data, arcana_data = read_data_from_stdin()
    asyncio.run(send_to_backend(boon_data, weapon_data, familiar_data, extra_data, elemental_data, pin_data, vow_data, arcana_data))

if __name__ == "__main__":
    arg_parser = argparse.ArgumentParser(description="Send Argus data to the Argus backend.")
    arg_parser.add_argument('--pluginpath', required=True, help="Path to the Argus plugin folder.")
    arg_parser.add_argument('--test', choices=["test1", "test2"], help="Run one of the prepared tests.")

    args = vars(arg_parser.parse_args())

    main()