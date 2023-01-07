import json
import subprocess
import requests

from os import getenv
from pkg_resources import parse_version

github_token = getenv('GITHUB_TOKEN')
if github_token:
    print('Got GITHUB_TOKEN')

info = json.load(open('info.json', 'r'))
repo, current_version = info['repo'], info['version']
print('Repo:', repo)
print('Current version:', current_version)

with requests.get(f'https://api.github.com/repos/{repo}/releases/latest',
                  headers={'authorization': f'Bearer {github_token}'}
                  if github_token else {}) as r:
    print('::group::GitHub API response')
    print(f'Status code: {r.status_code}')
    print(f'Content: {r.content}')
    print('::endgroup::')

    latest_version = parse_version(json.loads(
        r.content)['tag_name']).base_version
    print('Latest version:', latest_version)

if parse_version(latest_version) > parse_version(current_version):
    print('Updating...', flush=True)
    info['version'] = latest_version
    json.dump(info, open('info.json', 'w'))
    subprocess.check_call(
        ['git', 'config', 'user.name', 'github-actions[bot]'])
    subprocess.check_call([
        'git', 'config', 'user.email',
        'github-actions[bot]@users.noreply.github.com'
    ])
    subprocess.check_call([
        'git', 'commit', '--all', '--message',
        f'Update version to {latest_version}'
    ])
    subprocess.check_call(['git', 'push'])
