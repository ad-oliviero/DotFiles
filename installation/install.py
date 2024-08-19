#!/bin/env python

import subprocess, shutil, os, curses

DOTFILES_PATH = os.path.abspath(__file__).replace('/installation/install.py', '')
HOME_DIR = os.getenv('HOME')
class Configuration(object):
    def __init__(self, hostname) -> None:
        self.hostname = hostname

def selection_menu(opts) -> str:
    scr = curses.initscr()
    curses.noecho()
    curses.cbreak()
    curses.curs_set(0)
    scr.keypad(True)

    sel = 0
    while True:
        scr.clear()
        for i, o in enumerate(opts):
            if i == sel:
                scr.addstr(i, 0, f"> {o}")
            else:
                scr.addstr(i, 0, f"  {o}")
        scr.refresh()

        c = scr.getch()
        if c == curses.KEY_UP:
            sel = (sel - 1) % len(opts)
        elif c == curses.KEY_DOWN:
            sel = (sel + 1) % len(opts)
        elif c == ord('\n'):  # Enter key
            break

    scr.keypad(False)
    curses.curs_set(1)
    curses.nocbreak()
    curses.echo()
    curses.endwin()
    return opts[sel]

avail_confs = {
    "Laptop" : Configuration("adri-lap"),
    "Desktop" : Configuration("adri-desk"),
    "New": Configuration("new"),
}

selected_conf = selection_menu([k for k in avail_confs])

