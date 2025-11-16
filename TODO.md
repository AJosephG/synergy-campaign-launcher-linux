# TODO
check here for current known bugs, stuff thats fixed, and other things we still gotta do.

## Project Status

this project moved from the old wine-based thing to a pre‑patched proton ge. the proton ge route is the main supported way now.

## High Priority

- [ ] Create GitHub Release v1.0 with `GE-Proton-PSS-Patched.tar.gz` archive
- [ ] Test installation process on multiple distributions (Debian, Fedora, Arch)
- [ ] Verify Lutris integration with patched Proton GE
- [ ] Document any edge cases or known compatibility issues

## Documentation

- [x] Update README.md with Proton GE instructions
- [x] Create DISTRIBUTION.md for maintainer release process
- [x] Update .gitignore to exclude large binary files
- [ ] Add screenshots or demo video to README
- [ ] Create troubleshooting guide for common issues

## Features / Improvements

- [ ] Add automated build script for creating patched Proton from source
- [ ] Consider creating a GUI installer for less technical users
- [ ] Add version checking/update mechanism
- [ ] Create desktop file for easier launching from application menu

## Legacy Wine Approach

- [ ] Archive old Wine-based scripts to separate branch
- [ ] Determine if Wine approach should be deprecated entirely
- [ ] Clean up `src/wine/` directories or mark as deprecated

## Testing

- [ ] Test on Ubuntu 22.04 LTS / 24.04 LTS
- [ ] Test on Fedora 39/40
- [ ] Test on Arch Linux
- [ ] Test on Steam Deck
- [ ] Verify all campaign maps load correctly
- [ ] Test with different StarCraft II installation methods

## Known Issues

- Downgrading to GE-Proton 9-20 may show "invalid version" warnings (harmless)
- Archive size is large (~430MB) - must be distributed via GitHub Releases, not git
- Requires Steam directory structure even if not using Steam

## Completed

- [x] Patch Proton GE 9-20 with PSS API stubs
- [x] Create installation script
- [x] Document installation and usage process
- [x] Test campaign launcher functionality
- [x] Test map loading via SC2Switcher