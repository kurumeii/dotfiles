# Task Completion Checklist

## When Making Changes to Dotfiles

### 1. Code Quality Checks

#### For Lua Files (Neovim Config)
- [ ] Format code with stylua: `stylua <modified-files>` or `stylua .`
- [ ] Verify indentation is tabs (2-space width)
- [ ] Check line length doesn't exceed 120 characters
- [ ] Ensure no syntax errors: open file in nvim

#### For Shell Scripts
- [ ] Verify POSIX compliance if applicable
- [ ] Check script has proper shebang if executable
- [ ] Test script execution in target shell (bash/zsh)

#### For Config Files
- [ ] Validate syntax for specific file type:
  - YAML: `yamllint <file>` (if available)
  - JSON: `jq . <file>` (if available)
  - TOML: check syntax manually or with editor
  - KDL: check niri config with `niri validate`

### 2. Chezmoi-Specific Steps
- [ ] If adding new file: `chezmoi add <file>`
- [ ] If file contains secrets: use `.tmpl` extension and chezmoi templates
- [ ] If file should be executable: use `executable_` prefix or `chezmoi chattr +executable`
- [ ] Preview changes: `chezmoi diff`
- [ ] Test template rendering: `chezmoi cat <file>`
- [ ] Verify file will be placed correctly: `chezmoi apply --dry-run --verbose`

### 3. Testing
- [ ] Apply changes locally: `chezmoi apply`
- [ ] For Neovim changes: Restart nvim and check for errors (`:checkhealth` if needed)
- [ ] For shell changes: Source the rc file or restart shell
- [ ] For system configs: Test the affected application/service

### 4. Version Control
- [ ] Stage changes: `chezmoi git -- add .` or `git add .` in source directory
- [ ] Review staged changes: `chezmoi git -- diff --staged`
- [ ] Commit with descriptive message: `chezmoi git -- commit -m "description"`
- [ ] Push to remote: `chezmoi git -- push`

### 5. System Verification
- [ ] Run health check: `chezmoi doctor`
- [ ] Verify no untracked important files: `chezmoi unmanaged`
- [ ] Confirm all expected files are managed: `chezmoi managed`
- [ ] Final verification: `chezmoi verify`

## Special Considerations

### Template Files
- Never commit plain text secrets
- Always use KeePassXC integration for sensitive data
- Test template execution before applying

### Cross-Machine Compatibility
- Ensure changes work across different machines if applicable
- Use conditional logic in templates for machine-specific configs
- Document any machine-specific requirements

### Breaking Changes
- Document breaking changes in commit message
- Consider backward compatibility
- Update README if workflow changes
