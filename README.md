### Termboot

A bootloader which never jumps to hyperspace and becomes a kernel or an operating system. Its simply a terminal that utilizes the BIOS.

## What is this supposed to run on?
This is supposed to run on x86 processors. Honestly not sure how itll run on different machines so set up a discussion please!

## How do I build and flash?
First build the binary:
```sh
make
```
will be fine.

After that its a simple matter of flashing it:
```sh
make flash DRIVE=MY_MOUNTED_DRIVE
```

# NOTE:
If there is no drive specified it will create a virtual drive by the name of drive.img.

# Dependencies:
NASM
LINUX (duh)
