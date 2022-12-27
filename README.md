# Per repo Git hook commit message validator

* Validates [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/)' rules 1-6.
* Ensures short descriptions are not longer than 50 and body lines are not longer than 72.

## Conventional Rules Supported
* Follow the format: `type(scope)!: short description` followed by an empty line and the body and footer.
* Type must be one of the following: build, change, chore, ci, deprecate, docs, feat, fix, perf, refactor, remove, revert, security, style, test, or wip.
* (Scope) is an optional noun that describes the code section.
* The exclamation point is optional and it indicates breaking changes.

| Features | Description |
| :--- | :--- |
| feat | Add feature |
| remove | Remove feature |
| change | Change feature |
| deprecate | Mark feature to be removed |
| wip | Work In Progress. Must be squashed |

| Other | Description |
| :--- | :--- |
| build | Update build system files |
| chore | Required periodic changes |
| ci | Update configurations or continuouse integration files |
| docs | Update documentation |
| fix | Fix a bug |
| perf | Improve performance without changing features |
| refactor | Revise code without changing features |
| revert | Remove a problematic commit |
| security | Fix an bug that resolves a security issue |
| style | Revise how code looks |
| test | Update test code |

## Requires
* Bash
* Python 3
* A Git repo

