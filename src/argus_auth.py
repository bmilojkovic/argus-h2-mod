import os
import sys
import urllib
import webbrowser
import secrets
import time
import configparser
import requests

from argus_util import argus_log

argus_backend = "http://localhost:3000"
extension_id = "sl19e3aebmadlewzt7mxfv3j3llwwv"

def do_argus_auth(config, config_file_path):
    base_url = "https://id.twitch.tv/oauth2/authorize"
    stateBytes = secrets.token_hex(16)
    params = {
        "response_type": "code",
        "client_id": extension_id,
        "state": stateBytes,
        "redirect_uri": argus_backend + "/oauth_token",
        "scope": urllib.parse.quote_plus("openid")
        }

    target_url = base_url + "?"

    for key, value in params.items():
        target_url += key + "=" + value + "&"

    webbrowser.open(target_url)
    retries = 60
    while retries > 0:
        response = requests.post(argus_backend + "/get_argus_token", json = {"state": stateBytes}, timeout=60)

        argus_log("asked for argus token and got: " + response.text)
        if response.status_code == 200 and response.text != "FAIL":
            config["DEFAULT"] = {"argus_token" : response.text}
            with open(config_file_path, "w") as config_file:
                config.write(config_file)
            return response.text
        else:
            retries = retries - 1
        time.sleep(1)

def check_argus_token_ok(argus_token):
    response = requests.get(argus_backend + "/check_argus_token", params={"argus_token" : argus_token})
    argus_log("checking token " + argus_token + " and got response " + response.text)
    return response.status_code == 200 and response.text == "token_ok"

def get_argus_token(pluginpath):
    config_file_path = pluginpath + os.sep + "argus_token.ini"
    config = configparser.ConfigParser()
    config.read(config_file_path)

    if "DEFAULT" in config and "argus_token" in config["DEFAULT"]:
        argus_token = config["DEFAULT"]["argus_token"]
        if check_argus_token_ok(argus_token):
            return argus_token
    
    return do_argus_auth(config, config_file_path)