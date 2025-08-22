# FEW THING TO CHANGE

- [FEW THING TO CHANGE](#few-thing-to-change)
  - [Keymaps](#keymaps)
  - [Plugins](#plugins)
  <!--toc:end-->

## Keymaps

- [ ]Change keymaps for mini-surround
- [ ] Unify Search and Find into a single Keystroke
  - [ ] _Leader f_ for find: everything
    - `ff`: Find Files
    - `ft`: Find Theme
    - `fm`: Find Marks
    - `fw`: Find a word (visual mode)
    - `fl`: Find lines in buffer
    - `fg`: Find and Grug (normal mode)
    - `fg`: Find and GrugWithin (Visual mode)
    - `fk`: Find keymaps
    - `fh`: Find help
    - `fb`: Find buffers
    - `fv`: Find visited (path)
    - `fT`: Find Todo/Readme/Fixme
    - `fr`: Find registers
    - `fd`: Find diagnostics (For current buffer)
    - `fD`: Find diagnostics (For all buffers)
    - `fc`: Find config files (maybe chezmoi one ?)
    - `fp`: Find plugins place
  - [ ] _leader s_ for session:
    - `ss`: Session save
    - `sl`: Session load (list)
    - `sr`: Session restore most recent
    - `sd`: Session delete (list)
- [ ] ctrl:
  - `<c-l>`: Accept completion
- [ ] Shift:
  - `<s-s>`: Change line and move cursor to the Indent first
- [ ] _Leader t_ for terminial
  - `tl`: Toggle right terminal
  - `tj`: Toggle down terminal
  - `tf`: Toggle floating terminal
- [ ] _Leader tabs_ for tabs
  - `tabs tabs`: Cycle through tabs
  - `tabs h`: Switch to tab on the left
  - `tabs l`: Switch to tab on the right
  - `tabs n`: New tab
- [x] _Leader e_ for Explorer (should be using mini.files)
  - `h`: Go out plus
  - `<c-s>`: Synchronize
  - `<c-w>s`: Split Horizontal
  - `<c-w>v`: Split Vertical
  - `/`: toggle hidden files
  - Should not delete permanent files
  - can trigger rename with LSP
- [ ] _Leader c_ for code
  - `csc`: Create spelling config (cspell)
  - `csw`: Create spelling word (From diagnostics)
  - `csW`: Create spelling word (input)
  - `csa`: Create spelling words (all from diagnostics)

## Plugins

- [x] Use mini.files instead of Snacks.explorer
- [x] Disabled Scratch plugins
- [ ] Modified Flash plugins
- [ ] Modified mini.hipatterns to see more colors
- [ ] Modified lualine
- [ ] Modifed buffersline
