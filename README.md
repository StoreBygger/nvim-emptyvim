Innstallasjon:

- Kopier / flytt filer inn i ~/.config/nvim/
- Pass på at mappen er tom før du flytter inn filene.
- Se pakker under hva du må innstallere,
  - Gi beskjed om du må innstallere en pakke som ikke er oppgitt nedenfor.

```bash
git clone https://github.com/StoreBygger/nvim-emptyvim
mv nvim-emptyvim/* ~/.config/nvim
mdkir -p ~/.config/nvim/sessions
```

for å innstallere nye språk må disse tingene legges til:
Fil nvim/lua/plugins/lsp.lua - legg til language server i ensure_installed - Legg til på bunnen:
" require("lspconfig")["<languageserver>"].setup {
capabilities = capabilities
}" - Legg til kommando for å kjøre språket ved tastetrykk <F5> i ui.lua, toggleterm

Eksterne plugins en trenger å innstallere: ( ikke komplett )

- nodejs
- npm
- lazygit
- fd-find ( kan og prøve bare fd)
- composer
- php
- javac ( kan og prøve bare "jdk-openjdk"
- julia
- alle pakker nødvendig for innstallerte språk
- wget
- tree-sitter
- "sudo luarocks install luacheck"
  - - jsregexp
- "sudo npm install -g neovim"
  - eslint
  - shellcheck
- pip install flake8 neovim-remote --break-system-packages
- npm install -g stylelint stylelint-config-standard
