# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Script conventions

Both shell scripts (`setup.sh`, `git_config.sh`) follow the same structure:
- `set -e` — abort on any error
- `confirm()` helper — prints a yellow prompt and reads `y/n` before each step
- `already_installed()` — skips gracefully if a tool is already present
- Steps are numbered and labeled (e.g. `Step 1/6`)

When adding a new tool to `setup.sh`, follow this pattern: wrap the install block in `if confirm "Step N/M — ..."`, update the step count in the header echo block, check `command -v` first and call `already_installed` if present, then install and print a green confirmation.

## VS Code settings

The `material-icon-theme.folders.associations` block in `settings.json` maps data-engineering folder names (bronze/silver/gold lakehouse conventions) to icons — preserve this block when editing the file.

## Roadmap (not yet implemented)

- `config/` — personal dotfiles (`.bashrc`, `.gitconfig`) managed via symlinks
- `install.sh` — symlink manager for `config/`
