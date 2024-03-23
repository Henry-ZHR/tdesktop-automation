import json
import os

with open(os.getenv('GITHUB_OUTPUT'), 'a') as github_output:
    info = json.load(open('info.json', 'r'))
    for (key, value) in info.items():
        print(f'{key}: {value}')
        print(f'{key}={value}', file=github_output)
