#!/bin/env python
import os, re, requests, argparse, time
import notify


def getArgs() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("-c", "--config", dest="config", help="set configuration FILE path", metavar="FILE")
    parser.add_argument("-n", "--nonstop", action="store_true", dest="nonstop", default=False, help="ask endlessly to select a wallpaper")
    parser.add_argument("-o", "--output", dest="output", help="set output FILE path", metavar="FILE")
    parser.add_argument("-p", "--program", dest="command", help="set wallpaper program CMD", metavar="CMD")
    parser.add_argument("-t", "--try-all", dest="delay", help="try all the wallpapers with TIME delay", metavar="TIME", type=int, default=None, const=2, nargs="?")
    parser.add_argument("-w", "--wallpaper", dest="number", help="set wallpaper ID immediately", metavar="ID", type=int)
    options = parser.parse_args()
    if options.config is None:
        options.config = os.path.dirname(os.path.abspath(__file__)) + "/../wallpapers.md"
    if options.output is None:
        options.output = os.path.expanduser("~") + "/Pictures/wallpaper.jpg"
    if options.command is None:
        options.command = "pkill hyprpaper; hyprpaper"
    return options

def dloadWallp(url, output, command):
    with open(output, "wb") as f:
        f.write(requests.get(url).content)
    os.system(command + " > /dev/null 2>&1&disown;exit")

def tryAll(wps, delay, command, output):
    try:
        for i in range(3):
            notify.notification('Starting in', f"{3 - i}...", 1000)
            time.sleep(1)
        for i, c in enumerate(wps):
            for j, w in enumerate(wps[c]):
                notify.notification(f"Trying [{j}] ({c})", f"{w[0]}", delay * 1000)
                dloadWallp(w[1], output, command)
                time.sleep(delay)
        notify.notification('Completed!', 'Wallpaper Tryall Completed!', 5000)
    except KeyboardInterrupt:
        print()
        exit(1)


def main():
    options = getArgs()
    fcontent = ""
    with open(options.config, "r") as f:
        fcontent = [[f.read()]]
    finds = re.findall(r'##.*', fcontent[0][0])
    for i in range(len(finds)):
        fcontent.append([re.sub("## ?", "", finds[i]), fcontent[0][0].split(finds[i])[1].split(finds[(i + 1) if len(finds) > i + 1 else i])[0].replace("\n", "")])
    fcontent.pop(0)

    wpre = re.compile(r'\[\!\[(?P<name>[^\]]+)\]\((?P<direct_link>[^\)]+)\)\]\((?P<page_link>[^\)]+)\)')
    wps = {c[0]: [w for w in re.findall(wpre, c[1])] for c in fcontent}
    catcnt = len(wps)
    wpcs = [len(wps[w]) for w in wps]
    if options.delay != None:
        tryAll(wps, options.delay, options.command, options.output)

    selected = None
    prt_cnt = 0
    wpcs.append(0)
    for c in wpcs[:catcnt]:
        wpcs[catcnt] += c
    errs = [False, False]
    while selected == None:
        print(f"\033[{prt_cnt}F\033[0J", end="")
        if errs[0]:
            errs[0] = False
            print(f"[\033[31mERROR\033[0m]: please input a number between 1 and {wpcs[catcnt]}!")
            prt_cnt += 1
        if errs[1]:
            errs[1] = True
            print("[\033[31mERROR\033[0m]: please input only numbers!")
            prt_cnt += 1

        for i, c in enumerate(wps):
            for j, w in enumerate(wps[c]):
                print(("\033[32m" if c == 'Current' else "") + f"[{j + (wpcs[i - 1] if i - 1 >= 0 else 0) + 1}] {w[0]}\033[0m")

        prt_cnt = wpcs[catcnt]

        try:
            if options.number != None:
                selected = options.number
            else:
                selected = input(f"Select a wallpaper [1-{wpcs[catcnt]}]: ")
                prt_cnt += 1
        except EOFError:
            print()
            exit(1)
        except KeyboardInterrupt:
            print()
            exit(1)

        try:
            selected = int(selected) - 1
            if selected < 0 or selected > wpcs[catcnt] - 1:
                errs[0] = True
                selected = None
        except ValueError:
            errs[1] = True
            selected = None

        if selected != None:
            cat = 0
            while selected >= wpcs[cat]:
                selected -= wpcs[cat]
                cat += 1
            dloadWallp(wps[list(wps)[cat]][selected][1], options.output, options.command)
        if options.nonstop == True:
            selected = None



if __name__ == '__main__':
    main()