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

## More Custom Symbols
Symbols | Description
-- | --
`elcord-wsl--assets-alist` | The art assets for `elcord-wsl` to load
`elcord-wsl--client-id` | The client ID of your Discord Application
`elcord-wsl--details-function` | The function to get the Rich Presence details
`elcord-wsl--state-function` | The function to get the Rich Presence state
