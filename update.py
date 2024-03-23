import json

from git import Repo
from git.cmd import Git

info = json.load(open('info.json', 'r'))
print('Url:', info['url'])
print('Current commit:', info['commit'])

pkg_repo = Repo.clone_from(url, 'pkg')
latest_commit = pkg_repo.head.commit
print('Latest commit:', latest_commit.hexsha)

if info['commit'] != latest_commit.hexsha:
    info['commit'] = latest_commit.hexsha
    json.dump(info, open('info.json', 'w'))

    repo = Repo()
    with repo.config_writer() as cw:
        cw.set_value('user', 'name', 'github-actions[bot]')
        cw.set_value('user', 'email',
                     'github-actions[bot]@users.noreply.github.com')
    repo.index.add('info.json')
    repo.index.commit('Upstream: ' + latest_commit.message)
    repo.remote().push().raise_if_error()
