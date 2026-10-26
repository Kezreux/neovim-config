# Neovim cheatsheet

`<leader>` is **Space**. Press Space and **wait**, and a menu (which-key) shows every command.
Open this anytime with `<leader>h` (Space h). Close it with `q`. Learn **one level per week**. Don't try to learn everything at once.

Daily habit: 10 minutes of `:VimBeGood`. Do `:Tutor` once at the very start.

---

## Level 1: Survive (week 1)

The big idea: you're in **Normal mode** most of the time. You only *visit* Insert mode to type.

| Key            | What it does                                   |
|----------------|------------------------------------------------|
| `i` / `a`      | Insert before / after the cursor               |
| `I` / `A`      | Insert at start / end of the line              |
| `o` / `O`      | New line below / above, then insert            |
| `Esc`          | Back to Normal mode (do this constantly)       |
| `h j k l`      | Left, down, up, right                          |
| `u` / `Ctrl-r` | Undo / redo                                    |
| `Ctrl-s`       | Save (LazyVim adds this). `:w` works too       |
| `:q`           | Quit. `:q!` quits without saving               |
| `<leader>qq`   | Quit everything                                |

## Level 2: Move with intent (week 2)

Stop holding `j`. Jump to where you want to go.

| Key              | What it does                                         |
|------------------|------------------------------------------------------|
| `w` / `b` / `e`  | Next word / back a word / end of word                |
| `0` / `^` / `$`  | Line start / first non-space char / line end         |
| `gg` / `G`       | Top / bottom of file                                 |
| `5j`, `12k`      | Move 5 down, 12 up (line numbers are relative)       |
| `Ctrl-d / Ctrl-u`| Half a page down / up                                |
| `f x` / `t x`    | Jump onto / just before the next `x` on this line    |
| `;` / `,`        | Repeat that `f`/`t` jump forward / backward          |
| `%`              | Jump to the matching bracket                         |
| `s`              | **Flash**: type 2 chars, then the label shown; jump anywhere on screen |
| `/text` `n` `N`  | Search, next match, previous match                   |
| `Ctrl-o / Ctrl-i`| Jump back / forward to where you were                |

Toggle `<leader>uP` to see hints for these motions on screen.

## Level 3: Edit like a sentence (week 3–4)

Commands are **verb + (count) + motion/object**. Once this clicks, vim becomes fast.

**Verbs:** `d` delete · `c` change (delete, then insert) · `y` yank (copy) · `>` `<` indent · `gc` comment

**Objects:** `iw` inner word · `aw` a word · `i"` inside quotes · `i(` inside parens · `it` inside tag · `ip` paragraph

| Example   | Meaning                                    |
|-----------|--------------------------------------------|
| `dw`      | delete to next word                        |
| `ciw`     | change this word                           |
| `ci"`     | change everything inside the quotes        |
| `da(`     | delete the parens and what's in them       |
| `yip`     | copy this paragraph                        |
| `d$` `D`  | delete to end of line                      |
| `dd` `yy` `cc` | delete / copy / change the whole line |
| `gcc`     | comment / uncomment this line              |
| `p` / `P` | paste after / before                       |
| `x`       | delete one character                       |
| `.`       | **repeat the last change** (very powerful) |
| `v` `V` `Ctrl-v` | select chars / lines / a block, then use a verb |

## Level 4: LazyVim superpowers (week 5+)

| Key              | What it does                                   |
|------------------|------------------------------------------------|
| `<leader>e`      | Toggle **Neo-tree** file explorer              |
| `<leader><space>`| Find file (fuzzy)                              |
| `<leader>/`      | Search text in the whole project (grep)        |
| `<leader>,`      | Switch between open buffers                    |
| `<leader>sk`     | Search all keymaps (forgot a key? use this)    |
| `<leader>gg`     | Lazygit                                        |
| `<leader>ft`     | Floating terminal                              |
| `gd` / `gr`      | Go to definition / list references             |
| `K`              | Show docs for the thing under the cursor       |
| `<leader>ca`     | Code actions (quick fixes)                     |
| `<leader>cr`     | Rename symbol everywhere                       |
| `]d` / `[d`      | Next / previous diagnostic (error)             |
| `Ctrl-h/j/k/l`   | Move between split windows                     |
| `<leader>-` `<leader>\|` | Split below / right                    |
| `H` / `L`        | Previous / next buffer (tab)                   |
| `<leader>bd`     | Close buffer                                   |

### Inside Neo-tree

| Key    | Action                    |
|--------|---------------------------|
| `Enter`/`l` | Open                 |
| `h`    | Close folder              |
| `a`    | Add file (end with `/` for a folder) |
| `d`    | Delete                    |
| `r`    | Rename                    |
| `c` / `m` | Copy / move            |
| `H`    | Show hidden files         |
| `?`    | Show all Neo-tree keys    |

---

**Stuck?** `Esc Esc`, then `<leader>sk` to search keys, or `:help <thing>`.
Extra plugins and languages: `:LazyExtras`. Plugin manager: `:Lazy`. Health check: `:checkhealth`.
