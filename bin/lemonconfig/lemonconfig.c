#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include "config.h"

int main() {
	// kill all the lemonbar instances
	system("killall -q lemonbar");
	const char* base_cmd = "lemonbar -g %sx%s+%s+%s -d -f -o%s \"%s\" -f -o%s \"%s\" -p -u %s -B \"%s\" -F \"%s\"";
	// command length, uset to allocate the right amount of space
	int cmd_len = strlen(base_cmd) - (strlen("%s")*11);
	for (int i = 0;i<2;i++){
		cmd_len += strlen(FONT_FAMILY[i]);
		cmd_len += strlen(FONT_SZ[i]);
		cmd_len += strlen(FONT_OFS[i]);
		cmd_len += strlen(BAR_SZ[i]);
		cmd_len += strlen(BAR_OFS[i]);
	}
	cmd_len += strlen(FOREGROUND);
	cmd_len += strlen(BACKGROUND);
	cmd_len += strlen(UL_COLOR);
	cmd_len += strlen(UL_SZ);
	// generate the command to launch lemonbar
	char*command = malloc(cmd_len);
	sprintf(command, base_cmd, BAR_SZ[0],BAR_SZ[1],BAR_OFS[0],BAR_OFS[1],FONT_OFS[0],FONT_FAMILY[0],FONT_OFS[1],FONT_FAMILY[1],UL_SZ,BACKGROUND,FOREGROUND);
	// launch lemon bar in write mode
	FILE* plemonbar = popen(command, "w");
	free(command);
	// lemonbar must go under fullscreen windows
	system("sleep 1; xdo above -t $(xdo id -n root) $(xdo id -n lemonbar)");
	FILE* pws_names = popen("bspc query -D --names", "r");
	char ws_names[11][64] = {0};
	for (int i = 0; i < 11 && fgets(ws_names[i], 64, pws_names);i++);
	pclose(pws_names);
	char*buf = malloc(1024);
	while (1){
		sprintf(buf, "%%{l}");
		for (int i = 0;i<11;i++){
			sprintf(buf, "%s%s ", buf, ws_names[i]);
		}
		fputs(buf, plemonbar);
		fflush(plemonbar);
		sleep(1);
	}
	// this is not so useful as the loop never ends
	pclose(plemonbar);
	return 0;
}
