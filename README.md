# dotfiles

Personal machine setup and configuration — scripted, versioned, reproducible.

## Philosophy

Every layer of machine setup is scripted and versioned. On any new Linux machine, the environment can be reproduced by cloning this repo and running scripts in order.

## Structure

dotfiles/
├── machine-setup/        — OS and application install scripts
│   ├── setup.sh          — Layer 1: installs system dependencies
│   └── git_config.sh     — Layer 2: configures Git and GitHub auth
├── app_config/
│   └── vscode/
│       ├── extensions.txt — list of VS Code extensions to install
│       └── settings.json  — VS Code user settings (Linux-ready)
└── README.md

## Usage

### On a new machine

**Step 1 — Clone the repo:**

git clone https://github.com/arjunjalan/dotfiles.git ~/dotfiles

**Step 2 — Run system bootstrap:**

cd ~/dotfiles/machine-setup
bash setup.sh

**Step 3 — Configure Git and GitHub:**

bash git_config.sh

**Step 4 — Install VS Code extensions:**

cat ~/dotfiles/app_config/vscode/extensions.txt | xargs -L1 code --install-extension

**Step 5 — Apply VS Code settings:**

cp ~/dotfiles/app_config/vscode/settings.json ~/.config/Code/User/settings.json

## Roadmap

- config/ — personal dotfiles (.bashrc, .gitconfig) managed via symlinks
- install.sh — symlink manager for config/
