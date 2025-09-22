import asyncio
import requests
import sys

import urllib
import webbrowser
import secrets
import time
import configparser
import argparse
import os

extension_id = "sl19e3aebmadlewzt7mxfv3j3llwwv"

def do_argus_auth(config, config_file_path):
    base_url = "https://id.twitch.tv/oauth2/authorize"
    stateBytes = secrets.token_hex(16)
    params = {
        "response_type": "code",
        "client_id": extension_id,
        "state": stateBytes,
        "redirect_uri": "http://localhost:3000/oauth_token",
        "scope": urllib.parse.quote_plus("openid")
        }

    target_url = base_url + "?"

    for key, value in params.items():
        target_url += key + "=" + value + "&"

    webbrowser.open(target_url)
    retries = 60
    while retries > 0:
        response = requests.post("http://localhost:3000/get_argus_token", json = {"state": stateBytes}, timeout=60)

        print(response.text)
        if response.status_code == 200 and response.text != "FAIL":
            config["DEFAULT"] = {"argus_token" : response.text}
            with open(config_file_path, "w") as config_file:
                config.write(config_file)
            return response.text
        else:
            retries = retries - 1
        time.sleep(1)

def check_argus_token_ok(argus_token):
    response = requests.get("http://localhost:3000/check_argus_token", params={"argus_token" : argus_token})
    print("checking token " + argus_token + " and got response " + response.text)
    return response.status_code == 200 and response.text == "token_ok"

def get_argus_token():
    config_file_path = args["pluginpath"] + os.sep + "argus_token.ini"
    config = configparser.ConfigParser()
    config.read(config_file_path)

    if "DEFAULT" in config and "argus_token" in config["DEFAULT"]:
        argus_token = config["DEFAULT"]["argus_token"]
        if check_argus_token_ok(argus_token):
            return argus_token
    
    return do_argus_auth(config, config_file_path)

async def send_to_backend(boon_data, weapon_data, familiar_data, extra_data, elemental_data, pin_data):
    argus_token = get_argus_token()
    sys.stdout.write("Logged in user: " + argus_token + "\n")

    sys.stdout.write("Boon list: " + str(boon_data) + "\n")
    sys.stdout.write("Weapon: " + str(weapon_data) + "\n")
    sys.stdout.write("Familiar: " + str(familiar_data) + "\n")
    sys.stdout.write("Extras: " + str(extra_data) + "\n")
    sys.stdout.write("Elements: " + str(elemental_data) + "\n")
    sys.stdout.write("Pins: " + str(pin_data) + "\n")
   
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
                "pinData" : pin_data.strip()
            }
        })
    sys.stdout.write("Response: " + str(response))

NOBOONS = "NOBOONS"
NOWEAPONS = "NOWEAPONS"
NOFAMILIARS = "NOFAMILIARS"
NOEXTRAS = "NOEXTRAS"
NOELEMENTS = "NOELEMENTS"
NOPINS = "NOPINS"

def read_data_from_stdin():
    boon_data = sys.stdin.readline()
    weapon_data = sys.stdin.readline()
    familiar_data = sys.stdin.readline()
    extra_data = sys.stdin.readline()
    elemental_data = sys.stdin.readline()
    pin_data = sys.stdin.readline()

    if (boon_data == NOBOONS):
        boon_data = ""
    if (weapon_data == NOWEAPONS):
        weapon_data = ""
    if (familiar_data == NOFAMILIARS):
        familiar_data = ""
    if (extra_data == NOEXTRAS):
        extra_data = ""
    if (elemental_data == NOELEMENTS):
        elemental_data = ""
    if (pin_data == NOELEMENTS):
        pin_data = ""

    return boon_data, weapon_data, familiar_data, extra_data, elemental_data, pin_data

arg_parser = argparse.ArgumentParser(description="Send argus data to the argus backend.")
arg_parser.add_argument('--pluginpath', required=True, help="Full path to the Argus plugin folder.")
arg_parser.add_argument('--test', choices=["test1", "test2"], help="Run one of the prepared tests.")

args = vars(arg_parser.parse_args())

if "test" in args:
    if args["test"] == "test1":
        boon_data = "Common;;ApolloManaBoon Rare;;AphroditeSpecialBoon Epic;;PoseidonWeaponBoon Heroic;;PoseidonCastBoon Common;;DaggerBlinkAoETrait Duo;;PoseidonSplashSprintBoon Rare;;DoubleRewardBoon Legendary;;AmplifyConeBoon Infusion;;ElementalDodgeBoon"
        weapon_data = "Rare;;DaggerBlockAspect"
        familiar_data = "CatFamiliar"
        extra_data = "Epic;;ForceZeusBoonKeepsake Common;;SpellSummonTrait"
        elemental_data = "Fire:1;;Water:0;;Earth:3;;Air:0;;Aether:0"
        pin_data = "RandomStatusBoon;;DoubleExManaBoon"
    elif args["test"] == "test2":
        boon_data = "Common;;ApolloWeaponBoon"
        weapon_data = "NOWEAPONS"
        familiar_data = "NOFAMILIARS"
        extra_data = "NOEXTRAS"
        elemental_data = "Fire:0;;Water:0;;Earth:0;;Air:0;;Aether:0"
        pin_data = "NOPINS"
    else:
        boon_data, weapon_data, familiar_data, extra_data, elemental_data, pin_data = read_data_from_stdin()
else:
    boon_data, weapon_data, familiar_data, extra_data, elemental_data, pin_data = read_data_from_stdin()
asyncio.run(send_to_backend(boon_data, weapon_data, familiar_data, extra_data, elemental_data, pin_data))
