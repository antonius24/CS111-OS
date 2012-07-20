// UCLA CS 111 Lab 1 main program

#include <errno.h>
#include <error.h>
#include <getopt.h>
#include <stdio.h>
#include <stdlib.h>

#include "command.h"

static char const *program_name;
static char const *script_name;
static int PROCESS_LIMIT;

static void
usage (void)
{
  error (1, 0, "usage: %s [-pt] SCRIPT-FILE", program_name);
}

static int
get_next_byte (void *stream)
{
  return getc (stream);
}

int
main (int argc, char **argv)
{
  int opt;
  int command_number = 1;
  int print_tree = 0;
  int time_travel = 0;
  program_name = argv[0];

  for (;;)
    switch (getopt (argc, argv, "pt"))
      {
      case 'p': print_tree = 1; break;
      case 't': time_travel = 1; break;
      default: usage (); break;
      case -1: goto options_exhausted;
      }
 options_exhausted:;
  int index;
 // for (index = optind; index < argc; index++)
 // {
 //   printf("Non-option argument %s\n", argv[index]);
 // }
  if (print_tree != 1)
  {
    if ((optind == argc - 1) || time_travel != 1)
    {
      PROCESS_LIMIT = 15; //default value
    }
    else
    {
      PROCESS_LIMIT = atoi(argv[optind]);
      optind++;
    }
  }
  // There must be exactly one file argument.
  if (optind != argc - 1)
    usage ();

  script_name = argv[optind];
  FILE *script_stream = fopen (script_name, "r");
  if (! script_stream)
    error (1, errno, "%s: cannot open", script_name);
  command_stream_t command_stream =
    make_command_stream (get_next_byte, script_stream);

  command_t last_command = NULL;
  command_t command;
  while ((command = read_command_stream(command_stream, time_travel)))
    {
      if (print_tree)
	{
          //printf("IN MAIN\n");
	  printf ("# %d\n", command_number++);
	  print_command (command);
	}
      else
	{
	  last_command = command;
	  execute_command (command, time_travel, PROCESS_LIMIT);
	}
    }

  return print_tree || !last_command ? 0 : command_status (last_command);
}
