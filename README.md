# elcord-wsl
#### Discord Rich Presence for Emacs on WSL

#### `elcord-wsl` uses [`discord-rpc`](https://www.npmjs.com/package/discord-rpc) and [`pm2`](https://www.npmjs.com/package/pm2)

## Setup
- Ensure Node.js is installed on Windows.
- Ensure PM2 is installed on WSL.
- On WSL, get the path of `node` on Windows with `whereis node`
- Clone this repository and define the path.
- `cd` and `npm install` to install dependencies.
- Include this snippet in your init file and customise the paths.
```elisp
;; do not use `straight-use-package`
(use-package elcord-wsl
  :load-path "~/.emacs.d/elcord-wsl" ;; customise the path
  :custom
  (elcord-wsl--load-path "~/.emacs.d/elcord-wsl") ;; customise the path
  (elcord-wsl--node-path "/mnt/c/Program Files/nodejs/node.exe")) ;; customise the path
```

## Interactive Functions
Functions | Description
-- | --
`M-x elcord-wsl--connect` | Starts the process
`M-x elcord-wsl--disconnect` | Deletes the process
---
`elcord-wsl--connect` might take very long to start, do not use this on startup. \
`elcord-wsl--disconnect` will always be called when killing Emacs, it is added in `kill-emacs-hook`.

## More Custom Symbols
Symbols | Description | Default
-- | -- | --
`elcord-wsl--assets-alist` | The art assets for `elcord-wsl` to load | `(("_default" . "_default"))`
`elcord-wsl--client-id` | The client ID of your Discord Application | `"698809287564328991"`
`elcord-wsl--details-function` | The function to get the Rich Presence details | `(concat "Editing " buf)`
`elcord-wsl--state-function` | The function to get the Rich Presence state | `(concat "Line " (format-mode-line "%l"))`
`elcord-wsl--large-image-text-function` | The function to get the Rich Presence large image text | `(concat "Emacs " emacs-version)`
---
`buf` refers to the name of the current buffer.

## Example
```elisp
(use-package elcord-wsl
  :load-path "/path/to/directory"
  :custom
  (elcord-wsl--load-path "/path/to/directory")
  (elcord-wsl--assets-alist
    '((".cpp" . "cpp")
      (".hpp" . "cpp")
      (".hs" . "haskell")
      ("*scratch*" . "emacs")
      ("_default" . "emacs")))
  (elcord-wsl--client-id "1234567890")
  :config
  (defun elcord-wsl--details-function (buf)
    (concat "I am editing " buf "!"))
  (defun elcord-wsl--state-function (buf)
    '"I am totally not procrastinating."))
```
---
The asset used will be the first key in `elcord-wsl--assets-alist` that the buffer name ends with. If you are editing `main.cpp`, the buffer name ends with `.cpp` and the `cpp` asset in the Discord application will be used. Similarly, if you are editing `*scratch*`, the asset used will be `emacs` because `*scratch*` ends with `*scratch*`. The asset with the key `_default` will be used if the buffer name does not end with any key in the alist.

## Default Client ID and Art Assets
#### Assets of the default client `(698809287564328991)`
![art-assets](https://cdn.discordapp.com/attachments/437471715975757834/748904075021647943/unknown.png)
