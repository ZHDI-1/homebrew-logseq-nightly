# Homebrew Logseq Nightly Tap

Personal Homebrew tap for Logseq's DB/nightly desktop build.

## Install

```sh
brew tap zhdi-1/logseq-nightly
brew install --cask logseq@nightly
```

This cask conflicts with Homebrew's stable `logseq` cask because both install
`Logseq.app`.

## Upgrade

The cask tracks Logseq's moving `nightly` release, so it uses
`version :latest`.

To include it in plain `brew upgrade`, add this to your zsh environment:

```sh
export HOMEBREW_UPGRADE_GREEDY_CASKS="logseq@nightly"
```

If `HOMEBREW_UPGRADE_GREEDY_CASKS` already contains other casks, keep it as a
space-separated list.
