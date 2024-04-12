# 🚀 typing-metrics.nvim

🚨 **heavily WIP !!** 🚨

**typing-metrics.nvim** is a lightweight, efficient plugin for Neovim that helps
you track your typing speed in real-time. Designed to be unobtrusive,
customizable, and user-friendly, it's an ideal tool for developers looking to
monitor and improve their typing efficiency.

## 🛣️ Feature Roadmap

- [x] Statusbar widget
- [ ] Realtime display options (Popup, virtual text/hover (virtual is maybe unfeasable?))
- [ ] Buffer Statistics (track stats for each file)
- [ ] Session Statistics (track stats for a 'session'/instance of nvim)
- [ ] Setup Language/file-type based segregation of stats
- [ ] Save stats to a database

## 📖 Overview

Neovim Typing-Speed Tracker offers a seamless experience for monitoring your
typing speed and accuracy, empowering you to enhance your typing skills right
within your favorite editor.

## 🛠️ Installation

Install the Typing-Speed Tracker using your preferred Neovim package manager:

### Using [Packer](https://github.com/wbthomason/packer.nvim)

```lua
use {'JakobSachs/typing-metrics.nvim'}
```

### Using [Vim-Plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'JakobSachs/typing-metrics.nvim'
```

## 📚 Usage

After installation, the plugin will automatically begin tracking your typing
speed when you open a buffer. Explore these commands for additional
functionality:

- `:Example` - To be determined...

## ⚙️ Configuration

Tailor the plugin's behavior to your liking with these settings in your
`init.vim` or `init.lua`:

```lua
-- Example configuration in Lua
require('typing-metrics').setup({
    display_mode = 'statusline', -- Options: 'statusline', 'floating', 'overlay'
    average_word_length = 5,
    update_interval = 1000, -- In milliseconds
    privacy_mode = false,
})
```

## ✨ Contributing

Your contributions are welcome! Whether it's fixing bugs, improving
documentation, or suggesting new features, we value your input.

## 📄 License

This project is licensed under the AGPL-3.0 license - see the [LICENSE](LICENSE) file
for details.
