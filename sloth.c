/*
 *  sloth v1.0.0
 *  Copyright (C) 2002  Nick Jennings
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; version 2 of the License. 
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
 *
 *  This program is developed and maintained by Nick Jennings.
 * Contact Information:
 *
 *    Nick Jennings                 nick@namodn.com
 *    PMB 338                       http://nick.namodn.com
 *    4096 Piedmont Ave.
 *    Oakland, CA 94611
 */

#include <stdio.h>
#include <wait.h>
#include <signal.h>
#include <sys/types.h>
#include <sys/time.h>

// Constants
#define VERSION "1.0.1"
#define DEFAULT_SPEED 0
#define POS_SPEED 1
#define POS_PROG 2
#define TOTAL_ARGS 3

// Prototypes
void usage();

/*****************************************************************************
 * int main(int argc, char *argv[]);
 *
 * sloth <0-99999> <progname>
 *
 */
int main(int argc, char *argv[]) {
	pid_t chpid;
	int status, exit_code = 0;
	long dspeed = DEFAULT_SPEED;  // delay speed
	long wspeed = DEFAULT_SPEED; // wait speed
	struct timeval timeout;

	if (argc < TOTAL_ARGS) {
		usage();
		exit_code = 1;
	} else if ((long)atoi(argv[POS_SPEED]) < 0) {
		usage();
		exit_code = 1;
	} else {
		wspeed = (long)atoi(argv[POS_SPEED]); 
	}

	dspeed = wspeed * 10;

	if (!exit_code) {
		printf("sloth: wait %ldms, delay %ldms\n", wspeed, dspeed);
 
		chpid = fork();
		if (chpid != 0) {
			while(!waitpid(chpid, &status, WNOHANG)) {
				// wait
				timeout.tv_sec = 0;
				timeout.tv_usec = wspeed;
				select(0, (fd_set *)0, (fd_set *)0, (fd_set *)0, &timeout);
				// stop
				kill(chpid, SIGSTOP);
				// delay
				timeout.tv_sec = 0;
				timeout.tv_usec = dspeed;
				select(0, (fd_set *)0, (fd_set *)0, (fd_set *)0, &timeout);
				// continue
				kill(chpid, SIGCONT);
			}
		}
		else {
			// child execution begins 
			execvp(argv[POS_PROG], &argv[POS_PROG]);
			return(0);
		}
	}
	exit(exit_code);
}


/*****************************************************************************
 * void usage();
 *
 * displays usage text
 *
 */
void usage() {
	printf("sloth version %s\n", VERSION);
	printf("usage: sloth <0-99999> <progname>\n");
}


