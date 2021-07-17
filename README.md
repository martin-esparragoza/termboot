### Termboot

A bootloader which never jumps to hyperspace. It never becomes a kernel or an operating system. Its simply a terminal that utilizes the BIOS.

## What is this supposed to run on?
This is supposed to run on x86 processors (we dont like floppies here). Honestly not sure how itll run on different machines so set up a discussion please!

## How do I build and flash?
First build the binary:
```sh
make
```

After that its a simple matter of flashing it:
```sh
make flash DRIVE=MY_MOUNTED_DRIVE
```

# NOTES:
* If there is no drive specified `make flash` will create a virtual drive by the name of drive.img.

# Dependencies:
* nasm
* dd
* make

# Want to use this as a template?
I don't know why you would but theres a wiki page that goes over the standard libraries.
