from twitchAPI.twitch import Twitch
from twitchAPI.helper import first
from twitchAPI.oauth import UserAuthenticationStorageHelper
import asyncio
import requests
import sys

extension_id = "sl19e3aebmadlewzt7mxfv3j3llwwv"
api_client_secret = "jaj66oy02as7x9kplcotsxje7lounb"

async def send_to_backend(boon_data, weapon_data, familiar_data, elemental_data, pin_data):
    sys.stdout.write("Boon list: " + str(boon_data) + "\n")
    sys.stdout.write("Weapon: " + str(weapon_data) + "\n")
    sys.stdout.write("Familiar: " + str(familiar_data) + "\n")
    sys.stdout.write("Elements: " + str(elemental_data) + "\n")
    sys.stdout.write("Pins: " + str(pin_data) + "\n")
    # initialize the twitch instance, this will by default also create a app authentication for you
    twitch = await Twitch(extension_id, api_client_secret)

    target_scope = []
    helper = UserAuthenticationStorageHelper(twitch, target_scope)
    await helper.bind() # do OAuth login, or use the existing one
    
    # figure out the logged in user (broadcaster)
    logged_in_user = await first(twitch.get_users())
    response = requests.post(
        "http://localhost:3000/run_info",
        json = {
            "user": logged_in_user.id,
            "boonData": boon_data.strip(),
            "weaponData": weapon_data.strip(),
            "familiarData": familiar_data.strip(),
            "elementalData" : elemental_data.strip(),
            "pinData" : pin_data.strip()
        })
    sys.stdout.write("Response: " + str(response))

NOBOONS = "NOBOONS"
NOWEAPONS = "NOWEAPONS"
NOFAMILIARS = "NOFAMILIARS"
NOELEMENTS = "NOELEMENTS"
NOPINS = "NOPINS"

def read_data_from_stdin():
    boon_data = sys.stdin.readline()
    weapon_data = sys.stdin.readline()
    familiar_data = sys.stdin.readline()
    elemental_data = sys.stdin.readline()
    pin_data = sys.stdin.readline()

    if (boon_data == NOBOONS):
        boon_data = ""
    if (weapon_data == NOWEAPONS):
        weapon_data = ""
    if (familiar_data == NOFAMILIARS):
        familiar_data = ""
    if (elemental_data == NOELEMENTS):
        elemental_data = ""
    if (pin_data == NOELEMENTS):
        pin_data = ""

    return boon_data, weapon_data, familiar_data, elemental_data, pin_data

if (len(sys.argv) > 1):
    if sys.argv[1] == "test1":
        boon_data = "Common;;ApolloManaBoon Rare;;AphroditeSpecialBoon Epic;;PoseidonWeaponBoon Heroic;;PoseidonCastBoon ZeusWhateverBoon"
        weapon_data = "Rare;;DaggerBlockAspect"
        familiar_data = "CatFamiliar"
        elemental_data = "Fire:1;;Water:0;;Earth:3;;Air:0;;Aether:0"
        pin_data = "RandomStatusBoon;;DoubleExManaBoon"

    elif sys.argv[1] == "test2":
        boon_data = "Common;;ApolloWeaponBoon"
        weapon_data = "NOWEAPON"
        familiar_data = "NOFAMILIAR"
        elemental_data = "Fire:0;;Water:0;;Earth:0;;Air:0;;Aether:0"
        pin_data = "NOPINS"
    else:
        boon_data, weapon_data, familiar_data, elemental_data, pin_data = read_data_from_stdin()
else:
    boon_data, weapon_data, familiar_data, elemental_data, pin_data = read_data_from_stdin()
asyncio.run(send_to_backend(boon_data, weapon_data, familiar_data, elemental_data, pin_data))
