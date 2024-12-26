import os
import urllib
from subprocess import check_call

PACKAGE = 'telegram-desktop'
VERSION = os.getenv('VERSION')
ARCH = 'x86_64'


def download_and_install_package(pkg, ver, install=True):
    if ver:
        check_call([
            'pacman', '-Udd' if install else '-Uddw', '--noconfirm',
            f'https://archive.archlinux.org/packages/{pkg[0]}/{pkg}/{pkg}-{urllib.parse.quote(ver)}.pkg.tar.zst'
        ])
    else:
        check_call(
            ['pacman', '-Sdd' if install else '-Sddw', '--noconfirm', pkg])


def get_target_package():
    download_and_install_package(PACKAGE, f'{VERSION}-{ARCH}', install=False)
    check_call([
        'tar', '-xvf',
        f'/var/cache/pacman/pkg/{PACKAGE}-{VERSION}-{ARCH}.pkg.tar.zst',
        '.BUILDINFO'
    ])


def proceed_buildinfo():
    buildtool, buildtoolver = None, None
    for line in map(str.strip, open('.BUILDINFO').read().splitlines()):
        if not line:
            continue
        key, val = map(str.strip, line.split('='))
        match key:
            case 'installed':
                download_and_install_package(val)
            case 'buildtool':
                buildtool = val
            case 'buildtoolver':
                buildtoolver = val
    if buildtool:
        download_and_install_package(buildtool, buildtoolver)


def cleanup():
    os.remove('.BUILDINFO')


if __name__ == '__main__':
    get_target_package()
    proceed_buildinfo()
    cleanup()
