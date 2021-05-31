# ClassTools.jl

Tools for managing your GitHub classroom on Linux.
I use with [classroom.github.com](https://classroom.github.com), but I imagine it can work with any GitHub-oriented classroom.

---
[![License: MPL 2.0](https://img.shields.io/badge/License-MPL%202.0-brightgreen.svg)](https://opensource.org/licenses/MPL-2.0)

Extending to other git repositories shouldn't be hard, feel free to open an issue to discuss pull requests.

## Basic usage

**Get your classroom roster**

Download your `classroom_roster.csv` from GitHub classrooms, or create it any other way.
Possibly, any `csv` can work, but we namely use the column name `github_username` for the URL.

**Download an exercise**

You can use `download_assignment(REPO, PREFIX, CSV_FILE)` to download all assignments of the type

    github.com/REPO/PREFIX-USERNAME

where `REPO` and `PREFIX` are self-explanatory, `CSV_FILE` should be your roster file, and `USERNAME` is `row.github_username` for each `row` in `CSV_FILE`.

- The repo will be download to `PREFIX/USERNAME`.
- If something goes wrong (e.g., the student did not accept the invitation), you'll a red `×` and the error thrown. Check your roster file.

## Beyond that

There are some other exported functions that are more situational, and much less tested.
I'll eventually describe them here, or delete them.

## License

This code is licensed under the Mozilla Public License v2, copied [here](LICENSE).