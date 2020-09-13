To set up this project run
```
brew install cabal-install
cabal init # intiiate probect
cabal v1-sandbox init # build project
cabal install -j
.cabal-sandbox/bin/pdfsearch me
```
https://wiki.haskell.org/How_to_write_a_Haskell_program

Alternatively, we run
```
brew cask install ghc
cd ~/scripts/pdfsearches/pdfsearch.hs/
ghc -o pdfsearch pdfsearch.hs
./pdfsearch
```
http://learnyouahaskell.com/starting-out#ready-set-go
