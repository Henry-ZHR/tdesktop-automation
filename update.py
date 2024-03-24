import json

import requests

from git import Repo

API_URL = 'https://archlinux.org/packages/extra/x86_64/telegram-desktop/json/'

info = json.load(open('info.json', 'r'))
print('Current version:', info['version'])

content = json.loads(requests.get(API_URL).content)
latest_version = f"{content['pkgver']}-{content['pkgrel']}"
print('Latest version:', latest_version)

if info['version'] != latest_version:
    info['version'] = latest_version
    json.dump(info, open('info.json', 'w'), indent=4)

    repo = Repo()
    with repo.config_writer() as cw:
        cw.set_value('user', 'name', 'github-actions[bot]')
        cw.set_value('user', 'email',
                     'github-actions[bot]@users.noreply.github.com')
    repo.index.add('info.json')
    repo.index.commit('Upstream: ' + latest_version)
    repo.remote().push().raise_if_error()
