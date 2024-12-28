import os
from subprocess import check_call
from tenacity import retry, stop_after_attempt

PACKAGE = 'telegram-desktop'
VERSION = os.getenv('VERSION')
ARCH = 'x86_64'


def get_url(pkg: str, ver: str):
    return f'https://archive.archlinux.org/packages/{pkg[0]}/{pkg}/{pkg}-{ver}.pkg.tar.zst'


@retry(stop=stop_after_attempt(3))
def install_pkg_by_url(pkgs: list):
    check_call(['pacman', '-Ud', '--noconfirm'] + pkgs)


def get_target_pkg():
    check_call([
        'pacman', '-Uddw', '--noconfirm',
        get_url(PACKAGE, f'{VERSION}-{ARCH}')
    ])
    check_call([
        'tar', '-xvf',
        f'/var/cache/pacman/pkg/{PACKAGE}-{VERSION}-{ARCH}.pkg.tar.zst',
        '.BUILDINFO'
    ])


def proceed_buildinfo():
    buildtool, buildtoolver = None, None
    pkgs = []
    for line in map(str.strip, open('.BUILDINFO').read().splitlines()):
        if not line:
            continue
        key, val = map(str.strip, line.split('='))
        match key:
            case 'installed':
                p = val.rindex('-')
                p = val.rindex('-', 0, p)
                p = val.rindex('-', 0, p)
                pkgs.append(get_url(val[:p], val[p + 1:]))
            case 'buildtool':
                buildtool = val
            case 'buildtoolver':
                buildtoolver = val
    install_pkg_by_url(pkgs)
    if buildtool:
        install_pkg_by_url([get_url(buildtool, buildtoolver)])


def cleanup():
    os.remove('.BUILDINFO')


if __name__ == '__main__':
    get_target_pkg()
    proceed_buildinfo()
    cleanup()
