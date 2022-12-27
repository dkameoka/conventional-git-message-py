#!/usr/bin/env bash

set -o errexit -o noclobber -o nounset -o pipefail

mkdir --parents --verbose /usr/local/bin/
rm --force --verbose /usr/local/bin/conventional-git-messages
cat << 'EOCGM' > /usr/local/bin/conventional-git-messages
#!/usr/bin/env bash

set -o errexit -o noclobber -o nounset -o pipefail

rm --force --verbose .git/hooks/commit-msg
cat << 'EOCM' > .git/hooks/commit-msg
#!/usr/bin/env python3

import argparse
import re
import sys

if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description='Git Commit Message Hook: Validate Conventional Format')
    parser.add_argument(
        type = argparse.FileType('r'),
        dest = 'message_file',
        help = 'Git provided message file path')
    args = parser.parse_args()
    lines = args.message_file.read().splitlines()

    if len(lines) == 0: # Empty message
        sys.exit(1)

    #Line lengths
    first_line_len = len(lines[0])
    if first_line_len > 50:
        print(f'Short description is longer ({first_line_len}) than 50 characters',
            file = sys.stdout)
        sys.exit(1)
    for line in lines:
        line_len = len(line)
        if line_len > 72:
            print(f'Body line is longer ({line_len}) than 72 characters',file = sys.stdout)
            sys.exit(1)

    #First line
    conventional_cpattern = re.compile(
        '(' # Type
            'build|'
            'change|'
            'chore|'
            'ci|'
            'deprecate|'
            'docs|'
            'feat|'
            'fix|'
            'perf|'
            'refactor|'
            'remove|'
            'revert|'
            'security|'
            'style|'
            'test|'
            'wip'
        ')'
        r'(\([^\)]+\))?!?' # Optional scope and exclamation mark
        ': .+') # Short summary / description
    if conventional_cpattern.fullmatch(lines[0]) is None:
        print('Short description doesn\'t meet the conventional format rules:\n'
            ' Format: "type(scope)!: short description" '
            'followed by an empty line and the body and footer.\n'

            ' Type must be one of the following: build, change, chore, ci, deprecate, docs, feat, '
            'fix, perf, refactor, remove, revert, security, style, test, or wip.\n'

            ' (Scope) is an optional noun that describes the code section.\n'
            ' The exclamation point is optional and it indicates breaking changes.\n'

            '\n__Types For Features__\n'
            ' feat: Add feature\n'
            ' remove: Remove feature\n'
            ' change: Change feature\n'
            ' deprecate: Mark feature to be removed\n'
            ' wip: Work In Progress. Must be squashed away\n'
            '\n__Other Types__\n'
            ' build: Update build system files\n'
            ' chore: Required periodic changes\n'
            ' ci: Update configurations or continuouse integration files\n'
            ' docs: Update documentation\n'
            ' fix: Fix a bug\n'
            ' perf: Improve performance without changing features\n'
            ' refactor: Revise code without changing features\n'
            ' revert: Remove a problematic commit\n'
            ' security: Fix an bug that resolves a security issue\n'
            ' style: Revise how code looks\n'
            ' test: Update test code\n',file = sys.stderr)
        sys.exit(1)

    #Multiple lines
    if len(lines) > 1:
        if len(lines[1]) != 0:
            print('Second line in message must be empty')
            sys.exit(1)

    sys.exit(0)

EOCM
echo "Wrote .git/hooks/commit-msg"
chmod --verbose +x .git/hooks/commit-msg
echo "To uninstall it from this repository, remove .git/hooks/commit-msg"

EOCGM
echo "Wrote /usr/local/bin/conventional-git-messages"
chmod --verbose +x /usr/local/bin/conventional-git-messages
