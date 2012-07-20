// UCLA CS 111 Lab 1 command execution

#include "command.h"
#include "command-internals.h"

#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <error.h>
#include <sys/wait.h>
#include <sys/types.h> //mode_t
#include <sys/stat.h>
#include <fcntl.h>

/* FIXME: You may need to add #include directives, macro definitions,
   static function definitions, etc.  */

void DoSequence(command_t);
//int dependency[][];  // Used to record the dependency between each command
//int execute_status[]; // Record the execution status of each command



int
command_status (command_t c)
{
  return c->status;
}

void DoCD(command_t command)     //cd is the internal command which could not be found in the PATH, we will implement it by ourselves
{
  char *argument;
  argument = *((command->u.word)+1);
  if (argument != NULL)
  {
    if (chdir(argument) < 0)
    {
      switch(errno)
      {
        case ENOENT:
        case ENOTDIR:
        case EACCES:
               error(1, 0, "%s", strerror(errno));
               exit(-1);
               break;
        default:
               error(1, 0, "some error happened in chdir");
               exit(-1);
      }
    }
  }
  else
  {
    error(1, 0, "some error happened in chdir");
  }
  return;
}


void DoSubshell(command_t command, int pipe_write, int pipe_read)
{
  mode_t fd_mode = S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH; // user: r/w, group: r, other: r
  pid_t pid;
  int status; // Return status of execute command
  int new_fd_input;  // input file descriptor
  int new_fd_output; // output file descriptor
  int fd_output = -1;
  int fd_input = -1;
  int is_fd_output = 0; // flag of fd_output
  int is_fd_input = 0; // flag of fd_input

  //printf("In Subshell\n");
  //printf("Type: %d\n", command->type);
  pid = fork();
  if (pid == 0)
  {
    //printf("IN CHILD\n");
    if (command->input != NULL)   // I/O redirection has higher priority than pipe   
    {
      fd_input = open(command->input, O_RDONLY, fd_mode);
      is_fd_input = 1; // flag of fd_input
      if (fd_input < 0)
      {
        switch (errno)
        {
          case ENOENT:
          case ENOTDIR:
          case EACCES:
                 error(1, 0, "%s", strerror(errno));
                 exit(-1);
                 break;
          default:
                 error(1, 0, "some error happened in chdir");
                 exit(-1);
        }
      }
      new_fd_input = dup2(fd_input, STDIN_FILENO); //STDIN_FILENO = 0;
      if (new_fd_input != 0)
      {
         exit(-1);
      }
      close(fd_input);
    }
    else  // No Input redirection, then check pipe input
    {
      if (pipe_read != -1)
      {
        new_fd_input = dup2(pipe_read, STDIN_FILENO); //STDIN_FILENO = 0;
        if (new_fd_input != 0)
        {
          exit(-1);
        }      
        close(pipe_read);  
      }
    }

    if (command->output != NULL) // I/O redirection has higher priority than pipe
    {
      fd_output = open(command->output, O_WRONLY|O_CREAT|O_TRUNC, fd_mode);  // r/w, create if not exist, trunc to zero before write
      is_fd_output = 1; // flag of fd_output
      if (fd_output < 0)
      {
        switch (errno)
        {
          case ENOENT:
          case ENOTDIR:
          case EACCES:
                 error(1, 0, "%s", strerror(errno));
                 exit(-1);
                 break;
          default:
                 error(1, 0, "some error happened in chdir");
                 exit(-1);
        }
      }
      new_fd_output = dup2(fd_output, STDOUT_FILENO);
      if (new_fd_output != 1)
      {
        exit(-1);
      }
      close(fd_output);
    }
    else  // No output redirection, then check pipe output
    {
      if (pipe_write != -1)   
      {
        new_fd_output = dup2(pipe_write, STDOUT_FILENO);
        if (new_fd_output != 1)
        {
          exit(-1);
        }
        close(pipe_write);
      }
    }
    DoSequence(command->u.subshell_command);
    exit(0);
  }
  else if (pid > 0)
  {
    //printf("IN FATHER\n");
    if (pipe_read != -1)
      close(pipe_read);  // Very important, must close the pipe fd!
    if (pipe_write != -1)
      close(pipe_write);
    if (is_fd_input)
      close(fd_input);
    if (is_fd_output)
      close(fd_output);
    wait(&status);
    command->status = status;
    //printf("OUT FATHER\n");
  }
  else
  {
    error(1, 0, "%s", strerror(errno));
  } 
  
}


/*
Command A, B
write w1, w2, w3, ..., wn,   -1
read  -1, r1, r2, ..., rn-1, rn
->     ->A->           ->PIPE->            ->B->       -> ...
-1  STDIN STDOUT  w1(fd[1]) r1(fd[0])    STDIN STDOUT   w2 ...
 |                |         |                           |
  ----------------           ---------------------------
           |                          |
    read[0], write[0]         read[1], write[1]  ...
    pipe_read, pipe_write   pipe_read, pipe_write  ...
*/

void DoSimple(command_t command, int pipe_write, int pipe_read)  
{
  mode_t fd_mode = S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH; // user: r/w, group: r, other: r
  int status; // Return status of execute command
  int new_fd_input;  // input file descriptor
  int new_fd_output; // output file descriptor
  int fd_output = -1;
  int fd_input = -1;
  int is_fd_output = 0; // flag of fd_output
  int is_fd_input = 0; // flag of fd_input
  pid_t pid;  // child's pid
  char **execute_arguments;
  char *execute_file;
  char **word_index = command->u.word;
  execute_file = *(word_index);
  execute_arguments = word_index;

  //printf("In Simple\n");
  //printf("Type: %d\n", command->type);
  //printf("EXECUTE_FILE: %s\n", execute_file);
 
  //while (*(execute_arguments) != NULL)
   // printf("EXECUTE_ARGUMENTS: %s\n", *(execute_arguments)++);

  if (strcmp(execute_file, "cd") == 0)
  {
    DoCD(command);
  }  
  else
  {
    pid = fork();
    if (pid == 0)
    {
      //printf("IN CHILD\n");
      if (command->input != NULL)   // I/O redirection has higher priority than pipe   
      {
        fd_input = open(command->input, O_RDONLY, fd_mode);
        is_fd_input = 1; // flag of fd_input
        if (fd_input < 0)
        {
          switch (errno)
          {
            case ENOENT:
            case ENOTDIR:
            case EACCES:
                   error(1, 0, "%s", strerror(errno));
                   exit(-1);
                   break;
            default:
                   error(1, 0, "some error happened in chdir");
                   exit(-1);
          }
        }
        new_fd_input = dup2(fd_input, STDIN_FILENO); //STDIN_FILENO = 0;
        if (new_fd_input != 0)
        {
           exit(-1);
        }
        close(fd_input);
      }
      else  // No Input redirection, then check pipe input
      {
        if (pipe_read != -1)
        {
          new_fd_input = dup2(pipe_read, STDIN_FILENO); //STDIN_FILENO = 0;
          if (new_fd_input != 0)
          {
            exit(-1);
          }      
          close(pipe_read);  
        }
      }

      if (command->output != NULL) // I/O redirection has higher priority than pipe
      {
        fd_output = open(command->output, O_WRONLY|O_CREAT|O_TRUNC, fd_mode);  // r/w, create if not exist, trunc to zero before write
        is_fd_output = 1; // flag of fd_output
        if (fd_output < 0)
        {
          switch (errno)
          {
            case ENOENT:
            case ENOTDIR:
            case EACCES:
                   error(1, 0, "%s", strerror(errno));
                   exit(-1);
                   break;
            default:
                   error(1, 0, "some error happened in chdir");
                   exit(-1);
          }
        }
        new_fd_output = dup2(fd_output, STDOUT_FILENO);
        if (new_fd_output != 1)
        {
          exit(-1);
        }
        close(fd_output);
      }
      else  // No output redirection, then check pipe output
      {
        if (pipe_write != -1)   
        {
          new_fd_output = dup2(pipe_write, STDOUT_FILENO);
          if (new_fd_output != 1)
          {
            exit(-1);
          }
          close(pipe_write);
        }
      }


      //print_command(command);
      //close(pipe_read);
      //close(pipe_write);
      if(execvp(execute_file, execute_arguments) < 0)
      {
        //printf("OUT CHILD 1\n");
        switch (errno)
        {
          case ENOENT:
          case EACCES:
                 error(1, 0, "%s", strerror(errno));
                 exit(-1);
                 break;
          default:
                 error(1, 0, "error happened in exec");
                 exit(-1);
        }
      }
      //printf("OUT CHILD\n");
    }
    else if (pid > 0)
    {
      //printf("IN FATHER\n");
      if (pipe_read != -1)
        close(pipe_read);  // Very important, must close the pipe fd!
      if (pipe_write != -1)
      close(pipe_write);
      if (is_fd_input)
        close(fd_input);
      if (is_fd_output)
        close(fd_output);
      wait(&status);
      command->status = status;
      //printf("OUT FATHER\n");
    }
    else
    {
      error(1, 0, "%s", strerror(errno));
    }  
  }
  return;
}



void DoPipe(command_t command)  //
{
  int fd[2];
  int PIPE_LEVEL = 0;
  //int status_single;
  //printf("In Pipe\n");
  //printf("Type: %d\n", command->type);
  command_t command_index = command;
  if (command_index->u.command[1] == NULL) // No pipeline
  {
    //printf("Command type: %d\n", command_index->u.command[0]->type);
    if (command_index->u.command[0]->type == SIMPLE_COMMAND)
    {
      DoSimple(command_index->u.command[0], -1, -1);
      if (WIFEXITED(command_index->u.command[0]->status))
      {
        command->status = command_index->u.command[0]->status;
       // printf("PIPE status: %d\n", WEXITSTATUS(command->status));
      }
    }
    else
    {
      //printf("DO SUBSHELL 1\n");
      DoSubshell(command_index->u.command[0], -1, -1);
      if (WIFEXITED(command_index->u.command[0]->status))
      {
        command->status = command_index->u.command[0]->status;
     //   printf("PIPE status: %d\n", WEXITSTATUS(command->status));
      }
    }   
  }
  else // pipeline
  {
    while (command_index->u.command[1] != NULL)
    {
      PIPE_LEVEL++;
      command_index = command_index->u.command[1];
    }
    PIPE_LEVEL++;

    int write[PIPE_LEVEL];
    int read[PIPE_LEVEL];
    int status[PIPE_LEVEL];
    int i;

    for (i=0; i< PIPE_LEVEL; i++)
    { 
      write[i] = -1;
      read[i] = -1;
    }

    for (i=0; i<(PIPE_LEVEL-1); i++)
    {
       if (pipe(fd) == -1)
         error(1, 0, "cannot create a pipe");
       write[i] = fd[1];
       read[i+1] = fd[0];
    }

    command_index = command;
    i=0;
    while (1)
    {
      if (command_index->u.command[0]->type == SIMPLE_COMMAND)
      {
        //printf("SIMPLE COMMAND\n");
        //print_command(command_index->u.command[0]);
        DoSimple(command_index->u.command[0], write[i], read[i]);
        if (WIFEXITED(command_index->u.command[0]->status))
        {
          command->status = command_index->u.command[0]->status;
         // printf("PIPE status: %d\n", WEXITSTATUS(command->status));
        }
      }
      else
      {
       // printf("DO SUBSHELL 2\n");
        DoSubshell(command_index->u.command[0], write[i], read[i]);
        if (WIFEXITED(command_index->u.command[0]->status))
        {
          command->status = command_index->u.command[0]->status;
       //   printf("PIPE status: %d\n", WEXITSTATUS(command->status));
        }
      }
      //printf("DO PIPE END\n");
      if (i == PIPE_LEVEL-1)
        break;
      command_index = command_index->u.command[1];
      i++;
    }
  }
  return;
}


/*
AndOr command follow the circuit logic
Example:
1. true && a && b && c
This will execute command a, b, c, return the status of command c as the AND command status
2. false && a && b && c
This will not execute any command, return the status of false as the AND command status (the last fail status)
3. true && a && b || c && d
This will execute command a, b, return the status of command b as the AND command status
4. false && a && b || c && d
This will execute command c, d, return the status of command d as the AND command status
4. true || a && b
This will not execute any command, return the status of true as the AND command status

Based on this logic, we build a simple state machine here

*/
void DoAndOr(command_t command)
{
  command_t command_index = command;
  int ANDOR_LEVEL = 0;
  int state = 0; // switch state
  int is_exit = 0; // used in the state machine

  //printf("In AndOr\n");
  //printf("Type: %d\n", command->type);
  if (command_index->u.command[1] == NULL) // No AND or OR
  {
    DoPipe(command_index->u.command[0]);
    command->status = command_index->u.command[0]->status;   
    //printf("AND_OR status: %d\n", WEXITSTATUS(command->status));
    
  }
  else
  {
    DoPipe(command_index->u.command[0]);
    command->status = command_index->u.command[0]->status;
    if (command_index->u.command[0]->status == 0) // True
    {
      while (1) // State Machine
      {
        if ((command_index->u.command[1] == NULL) || is_exit == 1)
          break;
        switch(state)
        {
          case 0:  // Initial state
            if (command_index->type == AND_COMMAND)
              state = 1;
            else
              state = 2;
            break;
          case 1:  // Excute state
            command_index = command_index->u.command[1];
            DoPipe(command_index->u.command[0]);
            command->status = command_index->u.command[0]->status;
            if (command_index->type == AND_COMMAND)
              state = 1;
            else
              state = 2;
            break;
          case 2:  // Break state
            is_exit = 1;
            break;
        } 
      }
    }
    else // False
    {
      while (1) // State Machine
      {
        if ((command_index->u.command[1] == NULL) || is_exit == 1)
          break;
        switch(state)
        {
          case 0:  // Initial state
            if (command_index->type == AND_COMMAND)
              state = 1;
            else
              state = 2;
            break;
          case 1:  // Skip current command state
            command_index = command_index->u.command[1];
            if (command_index->type == AND_COMMAND)
              state = 1; 
            else
              state = 2;
            break;
          case 2:  // Excute state
            command_index = command_index->u.command[1];
            DoPipe(command_index->u.command[0]);
            command->status = command_index->u.command[0]->status;
            if (command_index->type == AND_COMMAND)
              state = 2;
            else
              state = 3;
            break;
          case 3:  // Break state
            is_exit = 1;
            break;
        } 
      }

    }
     //printf("AND_OR status: %d\n", WEXITSTATUS(command->status));
  }
}


void DoSequence(command_t command)
{
  command_t command_index = command;

  //printf("In Sequence\n");
  //printf("Type: %d\n", command->type);
  DoAndOr(command_index->u.command[0]);
  command->status = command_index->u.command[0]->status;
  while (command_index->u.command[1] != NULL)
  {
     command_index = command_index->u.command[1];
     DoAndOr(command_index->u.command[0]);
     command->status = command_index->u.command[0]->status;
  }
  
}



//////////////////Begin: Functions for time travel//////////////////////

void CheckDependency(command_t command)
{
  

}








//////////////////End: Functions for time travel////////////////////////



void
execute_command (command_t c, int time_travel)
{
  if (time_travel == 0)  // No time travel
  {
    DoAndOr(c);  // In our read_command implementation, the top level sequence node is eliminated. So now the top node return to execute is AND or OR node
  }
  else
  {
    print_command(c);
    error(1, 0, "NOT IMPLEMENT");
  }

  /* FIXME: Replace this with your implementation.  You may need to
     add auxiliary functions and otherwise modify the source code.
     You can also use external functions defined in the GNU C Library.  */
}
