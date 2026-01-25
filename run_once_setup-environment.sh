#!/bin/bash
set -e # Exit on error

bash "${CHEZMOI_SOURCE_DIR}/scripts/install_dnf_plugins.sh"
bash "${CHEZMOI_SOURCE_DIR}/scripts/install_omp.sh"
bash "${CHEZMOI_SOURCE_DIR}/scripts/install_things.sh"
bash "${CHEZMOI_SOURCE_DIR}/scripts/install_shell.sh"
