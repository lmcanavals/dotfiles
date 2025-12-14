AddPackage 7zip                  # File archiver for extremely high compression
AddPackage bat                   # Cat clone with syntax highlighting and git integration
AddPackage btop                  # A monitor of system resources, bpytop ported to C++
AddPackage chafa                 # Image-to-text converter supporting a wide range of symbols and palettes, transparency, animations, etc.
AddPackage cups                  # OpenPrinting CUPS - daemon package
AddPackage dust                  # A more intuitive version of du in rust
AddPackage eza                   # A modern replacement for ls (community fork of exa)
AddPackage fd                    # Simple, fast and user-friendly alternative to find
AddPackage font-manager          # A simple font management application for GTK+ Desktop Environments
AddPackage fzf                   # Command-line fuzzy finder
AddPackage gphoto2               # A digital camera download and access program.
AddPackage gthumb                # Image browser and viewer for the GNOME Desktop
AddPackage gutenprint            # Top quality printer drivers for POSIX systems
AddPackage gvfs                  # Virtual filesystem implementation for GIO
AddPackage gvfs-gphoto2          # Virtual filesystem implementation for GIO - gphoto2 backend (PTP camera, MTP media player)
AddPackage imagemagick           # An image viewing/manipulation program
AddPackage jq                    # Command-line JSON processor
AddPackage less                  # A terminal based program for viewing text files
AddPackage libvips               # A fast image processing library with low memory needs
AddPackage lostfiles             # Find orphaned files not owned by any Arch packages
AddPackage mc                    # A file manager that emulates Norton Commander
AddPackage mosh                  # Mobile shell, surviving disconnects with local echo and line editing
AddPackage ntfs-3g               # NTFS filesystem driver and utilities
AddPackage procs                 # A modern replacement for ps written in Rust
AddPackage qalculate-qt          # Qt frontend for libqalculate
AddPackage ripgrep               # A search tool that combines the usability of ag with the raw speed of grep
AddPackage sd                    # Intuitive find & replace
AddPackage showmethekey          # A screenkey alternative that works under Wayland via libinput.
AddPackage speech-dispatcher     # High-level device independent layer for speech synthesis interface
AddPackage speedtest-cli         # Command line interface for testing internet bandwidth using speedtest.net
AddPackage spirv-tools           # API and commands for processing SPIR-V modules
AddPackage starship              # The cross-shell prompt for astronauts
AddPackage swappy                # A Wayland native snapshot editing tool
AddPackage system-config-printer # A CUPS printer configuration tool and status applet
AddPackage tectonic              # Modernized, complete, self-contained TeX/LaTeX engine, powered by XeTeX and TeXLive
AddPackage terminus-font         # Monospace bitmap font (for X11 and console)
AddPackage unarchiver            # unar and lsar: Objective-C tools for uncompressing archive files
AddPackage unrar                 # The RAR uncompression program
AddPackage v4l2loopback-dkms     # v4l2-loopback device – module sources
AddPackage zenity                # Display graphical dialog boxes from shell scripts

# This are needed for https://github.com/CyberShadow/aconfmgr
AddPackage expect   # A tool for automating interactive applications
AddPackage pacutils # Helper tools for libalpm

AddPackage --foreign hyprqt6engine        # QT6 Theme Provider for Hyprland
AddPackage --foreign maplemono-ttf        # Open source monospace font with round corner, ligatures and Nerd-Font for IDE and command line
AddPackage --foreign otf-font-awesome-5   # Iconic font designed for Bootstrap (version 5.x)
AddPackage --foreign psf-cozette          # A bitmap programming font optimized for coziness, console version (PSF format)
AddPackage --foreign rose-pine-hyprcursor # None
AddPackage --foreign yay                  # Yet another yogurt. Pacman wrapper and AUR helper written in go.

# packages we should ignore
IgnorePackage arch-install-scripts   # Scripts to aid in installing Arch Linux
IgnorePackage asciinema              # Record and share terminal sessions
IgnorePackage blender                # A fully integrated 3D graphics creation suite
IgnorePackage bottom                 # A graphical process/system monitor
IgnorePackage cheese                 # Take photos and videos with your webcam, with fun graphical effects
IgnorePackage fastfetch              # A feature-rich and performance oriented neofetch like system information tool
IgnorePackage gnuplot                # Plotting package which outputs to X11, PostScript, PNG, GIF, and others
IgnorePackage go                     # Core compiler tools for the Go programming language
IgnorePackage intel-ucode            # Microcode update image for Intel CPUs
IgnorePackage krita                  # Edit and paint images
IgnorePackage lld                    # Linker from the LLVM project
IgnorePackage lldb                   # Next generation, high-performance debugger
IgnorePackage llvm                   # Compiler infrastructure
IgnorePackage network-manager-applet # Applet for managing network connections
IgnorePackage obs-studio             # Free, open source software for live streaming and recording
IgnorePackage openmp                 # LLVM OpenMP Runtime Library
IgnorePackage qpwgraph               # PipeWire Graph Qt GUI Interface
IgnorePackage ruby-erb               # An easy to use but powerful templating system for Ruby
IgnorePackage thunderbird            # Standalone mail and news reader from mozilla.org
IgnorePackage xorg-server            # Xorg X server
IgnorePackage xournalpp              # Handwriting notetaking software with PDF annotation support

# here some packages that are optional form others but might not be that important?
# lvm2 ddcutil libopenraw glib2-devel foomatic-db-gutenprint-ppds meson btrfs-progs usbmuxd geoclue
