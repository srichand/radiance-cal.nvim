# radiance-cal.nvim

Syntax highlighting and filetype support for
[Radiance](https://www.radiance-online.org/) CAL function files in Neovim.

The highlighter follows the Radiance functional language rather than treating
CAL as C. It recognizes:

- nested `{ ... }` comments;
- real numbers and scientific notation;
- variable, constant, and function definitions;
- back-quote context qualification, including explicitly local and global
  names;
- rcalc channels such as `$1`;
- standard CAL functions, `rayinit.cal` names, renderer variables, and common
  rcalc and pcomb names.

## Installation

With [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "srichand/radiance-cal.nvim",
}
```

With [vim-plug](https://github.com/junegunn/vim-plug):

```vim
Plug 'srichand/radiance-cal.nvim'
```

Or install it as a native package:

```sh
git clone https://github.com/srichand/radiance-cal.nvim.git \
  ~/.local/share/nvim/site/pack/plugins/start/radiance-cal.nvim
```

Opening a `*.cal` file sets `filetype=radiancecal`. The filetype plugin also
sets `commentstring`, adds `.cal` to `suffixesadd`, and treats periods and
back-quotes as identifier characters.

## Highlight groups

The plugin defines the following groups and links them to standard Neovim
groups by default:

- `radianceCalComment`
- `radianceCalNumber`
- `radianceCalChannel`
- `radianceCalFunction`
- `radianceCalFunctionDefinition`
- `radianceCalDefinition`
- `radianceCalBuiltinFunction`
- `radianceCalConstant`
- `radianceCalBuiltinVariable`
- `radianceCalAssignmentOperator`
- `radianceCalOperator`
- `radianceCalDelimiter`

Colorschemes or user configuration can override any of these groups. For
example:

```lua
vim.api.nvim_set_hl(0, "radianceCalConstant", { link = "Float" })
```

## Development

Run the headless syntax test from the repository root:

```sh
nvim --headless -u NONE -i NONE -n -l tests/syntax.lua
```

## Language references

- [Radiance File Formats](https://floyd.lbl.gov/radiance/refer/filefmts.pdf),
  "Function File Format"
- [Radiance `rayinit.cal`](https://github.com/LBNL-ETA/Radiance/blob/master/src/rt/rayinit.cal)
- [`rcalc(1)`](https://floyd.lbl.gov/radiance/man_html/rcalc.1.html)
- [`pcomb(1)`](https://floyd.lbl.gov/radiance/man_html/pcomb.1.html)

## License

[MIT](LICENSE)
