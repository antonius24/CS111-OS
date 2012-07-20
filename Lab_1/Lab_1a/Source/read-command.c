// UCLA CS 111 Lab 1 command reading
#define MAX_CHAR_LIMIT 200

#include "command.h"
#include "command-internals.h"

#include <error.h>
#include <stdio.h>
#include <malloc.h>
#include <stdlib.h>

/* FIXME: You may need to add #include directives, macro definitions,
   static function definitions, etc.  */

/* FIXME: Define the type 'struct command_stream' here.  This should
   complete the incomplete type declaration in command.h.  */

char token_type_map[11][10] = {"WORDS", "VBAR", "AND", "OR", "LPAREN", "RPAREN", "LQUOTE", "RQUOTE", "POUND", "SEMICOLON", "NEWLINE"};	//enum int mapping to string

enum token_type
  {
    WORDS,		// [a-zA-Z0-9!%+-,./:@^_]
    //LETTERS,		// [a-zA-Z]
    //DIGITS,		// [0-9]
    //EXCLAMATION,	// !
    //PERCENT,		// %
    //ADD,		// +
    //SUB,		// -
    //COMMA,		// ,
    //DOT,		// .
    //BSLASH,		// /
    //COLON,		// :
    //AT,		// @
    //CARET,		// ^
    //USCORE,		// _
    VBAR,		// |
    AND,		// &&
    OR,			// ||
    LPAREN,		// (
    RPAREN,		// )
    LQUOTE,		// <
    RQUOTE,		// >
    POUND,              // #
    SEMICOLON,          // ;
    NEWLINE,		// \n
  };

// token node in the linked list
typedef struct token		// Structure for each token, also define the head of token linked list
{
  enum token_type type;
  char* token_value;		// For letters and digits, limit size: MAX_CHAR_LIMIT
  struct token *next;
}token_t,*token_list;



struct command_stream
{
  command_t complete_command;
  command_t last_command;
  int commands_num;
  int command_index;
};

// Initialize the command_stream struct

token_list tk_list;
command_stream_t com_stream_t;
int line_number = 1;



command_t ParseSequence(token_list);
command_t ParseAndOr(token_list);
command_t ParsePipe(token_list);
command_t ParseSimple(token_list);
command_t ParseSubshell(token_list);

command_t BuildSequence(command_t, command_t);
command_t BuildAnd(command_t, command_t);
command_t BuildOr(command_t, command_t);
command_t BuildPipe(command_t, command_t);
command_t BuildSimple(token_list);
command_t BuildSubshell(command_t);

void InitList(token_list *head)
{
  if((*head=(token_list)malloc(sizeof(token_t))) == NULL)
    exit(-1);
  (*head)->next = NULL; 
}

/*Description: Print the token linked list 
  Arguments: token_list --- head of the token linked list*/
void PrintTokens(token_list head)	//Print the token linked list
{
  int d=0;
  token_t *t;
  t = head;
  while (t->next != NULL)
  {
    t = t->next;
    d++;
    if (t->type == WORDS)
    {
    	printf("Token %d - type: %s, value: %s\n", d, token_type_map[t->type], t->token_value);
    }
    else
    {
    	printf("Token %d - type: %s\n", d, token_type_map[t->type]);

    }
  }
}

int TokenListLength(token_list head)
{
  int length=0;
  token_t *token_index = head;
  while (token_index->next != NULL)
  {
    token_index = token_index->next;
    length++;
  }
  return length;
}


/*Description: Convert input stream into token linked list 
  Arguments: get_next_byte --- function to get next byte
	     get_next_byte_argument --- FILE pointer*/
void SeparateTokens(int (*get_next_byte) (void *),
		     void *get_next_byte_argument)
{
  char next_char;	// The next character from input stream 
  token_t *current_token_t;
  token_t *next_token_t;	//current_token_t is the last token in the linked list, next_token_t is the new added one in state 0;  
  current_token_t = tk_list; // Initialize the current token to the head of linked list
  int state=0;
  int token_value_index = 0; // Record the last recorded position in token value character array 
  int line_num = 1;	// Record line num for error information
  int read_next = 1;	// 0 not read this round, 1 read next byte
  //int error_lines[MAX_ERROR];	// Record the error lines 

  while(1)
  {
    if (read_next)
    {
	if((next_char=get_next_byte ((FILE *)get_next_byte_argument)) == EOF)
          break;
        read_next = 0;	//reset
    }
    switch (state)
    {
      case 0: 	// state 0: Identify the character to determine which token type it belongs. Create token struct, jump to other state if necessary
          //if ((next_char >= 'a' && next_char <= 'z') || (next_char>= 'A' && next_char <= 'Z'))
	  //{
	  //  if((next_token_t=(token_t*) malloc(sizeof(token_t))) == NULL)
          //    exit(-1);
          //  next_token_t->type = LETTERS;
          //  next_token_t->token_value = (char *)malloc(MAX_CHAR_LIMIT*sizeof(char));
	  //  *(next_token_t->token_value + token_value_index) = next_char;
          //  token_value_index++; 
	  //  current_token_t->next = next_token_t;
          //  current_token_t = next_token_t;              
          //  state = 1;	//letters token
          //  printf("%c\n", next_char);		//FOR TEST
          //}
          //else if (next_char >= '0' && next_char <= '9')
          //{
	  //  if((next_token_t=(token_t*) malloc(sizeof(token_t))) == NULL)
          //    exit(-1);
          //  next_token_t->type = DIGITS;
	  //  next_token_t->token_value = (char *)malloc(MAX_CHAR_LIMIT*sizeof(char));
	  //  *(next_token_t->token_value + token_value_index) = next_char;
          //  token_value_index++; 
	  //  current_token_t->next = next_token_t;
          //  current_token_t = next_token_t;              
          //  state = 2;	//digits token
          //  printf("%c\n", next_char);		//FOR TEST
          //}
          if ((next_char >= 'a' && next_char <= 'z') || (next_char>= 'A' && next_char <= 'Z') || (next_char >= '0' && next_char <= '9') || (next_char == '!') || (next_char == '%') || (next_char == '+') || (next_char == '-') || (next_char == ',') || (next_char == '.') || (next_char == '/') || (next_char == ':') || (next_char == '@') || (next_char == '^') || (next_char == '_'))
	  {
	    if((next_token_t=(token_t*) malloc(sizeof(token_t))) == NULL)
              exit(-1);
            next_token_t->type = WORDS;
            next_token_t->token_value = (char *)malloc(MAX_CHAR_LIMIT*sizeof(char));
	    *(next_token_t->token_value + token_value_index) = next_char;
            token_value_index++; 
	    current_token_t->next = next_token_t;
            current_token_t = next_token_t;              
            state = 1;	//words token
            //printf("%c\n", next_char);		//FOR TEST
          }
	  else if (next_char == '|')
	  {
	    if((next_token_t=(token_t*) malloc(sizeof(token_t))) == NULL)
              exit(-1);
            next_token_t->type = VBAR;
	    current_token_t->next = next_token_t;
            current_token_t = next_token_t;              
            state = 2;	//vbar or OR token, jump to vbar token first
            //printf("%c\n", next_char);		//FOR TEST
	  }
	  else if (next_char == '&')
	  {
            state = 3;	//AND token
            //printf("%c\n", next_char);		//FOR TEST
	  }
          else if (next_char == '(')
          {
	    if((next_token_t=(token_t*) malloc(sizeof(token_t))) == NULL)
              exit(-1);
            next_token_t->type = LPAREN; // left parenthesis, do not need to jump to other state
	    current_token_t->next = next_token_t;
            current_token_t = next_token_t;              
            //printf("%c\n", next_char);		//FOR TEST
          }
          else if (next_char == ')')
          {
	    if((next_token_t=(token_t*) malloc(sizeof(token_t))) == NULL)
              exit(-1);
            next_token_t->type = RPAREN; // left parenthesis, do not need to jump to other state
	    current_token_t->next = next_token_t;
            current_token_t = next_token_t;              
            //printf("%c\n", next_char);		//FOR TEST
          }
          else if (next_char == '<')
          {
	    if((next_token_t=(token_t*) malloc(sizeof(token_t))) == NULL)
              exit(-1);
            next_token_t->type = LQUOTE; // left parenthesis, do not need to jump to other state
	    current_token_t->next = next_token_t;
            current_token_t = next_token_t;              
            //printf("%c\n", next_char);		//FOR TEST
          }
          else if (next_char == '>')
          {
	    if((next_token_t=(token_t*) malloc(sizeof(token_t))) == NULL)
              exit(-1);
            next_token_t->type = RQUOTE; // left parenthesis, do not need to jump to other state
	    current_token_t->next = next_token_t;
            current_token_t = next_token_t;              
            //printf("%c\n", next_char);		//FOR TEST
          }
          else if (next_char == '#')
          {
	    if((next_token_t=(token_t*) malloc(sizeof(token_t))) == NULL)
              exit(-1);
            next_token_t->type = POUND; // left parenthesis, do not need to jump to other state
	    current_token_t->next = next_token_t;
            current_token_t = next_token_t;              
            //printf("%c\n", next_char);		//FOR TEST
          }
          else if (next_char == ';')
          {
	    if((next_token_t=(token_t*) malloc(sizeof(token_t))) == NULL)
              exit(-1);
            next_token_t->type = SEMICOLON; // left parenthesis, do not need to jump to other state
	    current_token_t->next = next_token_t;
            current_token_t = next_token_t;              
            //printf("%c\n", next_char);		//FOR TEST
          }
          else if ((next_char == ' ') || (next_char == '\t'))
          {
	    state = 4;	//SPACE       
            //printf("%c\n", next_char);		//FOR TEST
          }
          else if (next_char == '\n')
          {
            line_num++;
	    if((next_token_t=(token_t*) malloc(sizeof(token_t))) == NULL)
              exit(-1);
            next_token_t->type = NEWLINE; // left parenthesis, do not need to jump to other state
	    current_token_t->next = next_token_t;
            current_token_t = next_token_t;              
            //printf("%c\n", next_char);		//FOR TEST
          }
	  else
          {
            error(1,0,"line %d: syntax error", line_num);
            exit(-1);
          }
	  
	  read_next = 1; //Read next byte
          break;
          
       case 1:		// state 1: token type: WORDS 
          if ((next_char >= 'a' && next_char <= 'z') || (next_char>= 'A' && next_char <= 'Z') || (next_char >= '0' && next_char <= '9') || (next_char == '!') || (next_char == '%') || (next_char == '+') || (next_char == '-') || (next_char == ',') || (next_char == '.') || (next_char == '/') || (next_char == ':') || (next_char == '@') || (next_char == '^') || (next_char == '_'))
          {
	    *(next_token_t->token_value + token_value_index) = next_char;
            token_value_index++;
            read_next = 1; //Read next byte
	    //printf("%c\n", next_char);		//FOR TEST
	  }
          else
          {
	    token_value_index = 0;	//Index reset
	    state = 0;			//Back to initial state
            read_next = 0; //Not the character we want, do not read next byte, go back to state 0 to process it
	  }
          break;

       case 2:		// state 2: token type: VBAR
          if (next_char == '|')
          {
	    current_token_t->type = OR;
	    state = 0;
	    read_next = 1; //Read next byte
	    //printf("%c\n", next_char);		//FOR TEST
	  }
          else
          {
	    token_value_index = 0;	//Index reset
	    state = 0;			//Back to initial state
            read_next = 0; //Not the character we want, do not read next byte, go back to state 0 to process it
	  }
          //printf();
          break;

       case 3:	// state 3: token type: AND
	  if (next_char == '&')
          {
	    if((next_token_t=(token_t*) malloc(sizeof(token_t))) == NULL)	// Give && and set the new token
              exit(-1);
            next_token_t->type = AND;
	    current_token_t->next = next_token_t;
            current_token_t = next_token_t;
	    state = 0;
	    read_next = 1; //Read next byte
	    //printf("%c\n", next_char);		//FOR TEST              
          }
          else
          {
	    token_value_index = 0;	//Index reset
	    state = 0;			//Back to initial state
            read_next = 0; //Not the character we want, do not read next byte, go back to state 0 to process it
	  }
	  break;

       case 4:		//state 4: process space
          if ((next_char == ' ') || (next_char == '\t'))
          {
	    read_next = 1; //Read next byte
	    //printf("%c\n", next_char);		//FOR TEST
	  }
          else
          {
	    token_value_index = 0;	//Index reset
	    state = 0;			//Back to initial state
            read_next = 0; //Not the character we want, do not read next byte, go back to state 0 to process it
	  }
          break;
       default:
          break;
    }
  }


  // Deal with strange problem. The last token of the command is always NEWLINE, delete it
  current_token_t = tk_list;
  next_token_t = tk_list;
  while (next_token_t->next != NULL)
  {
    current_token_t = next_token_t;
    next_token_t = next_token_t->next;
  }
  current_token_t->next = NULL;
  free(next_token_t);
  return;
}



/*Method 2 --- Based on grammer --- start*/
command_t BuildSimple(token_list list) {
  command_t simple_command = (command_t)malloc(sizeof(struct command));
  int token_list_length = 0;
  token_t *token_index = list;
  int i;
  while (token_index->next != NULL)
  {
    token_index = token_index->next;
    token_list_length++;
  }

  char **w = (char **)malloc(token_list_length*MAX_CHAR_LIMIT*sizeof(char));
  simple_command->u.word = w;
  simple_command->type = SIMPLE_COMMAND;
  //printf("Build Simple Start\n");
  token_index = list->next;
  for (i=0; i<token_list_length; i++)
  {
    *w = token_index->token_value;
    //printf("%s\n", *w);
    w++;
    token_index = token_index->next;
  }
  //printf("Build Simple End\n");
  //printf("Print Simple:\n");
  //print_command(simple_command);
  //printf("PRINT SIMPLE COMMAND:\n");
  //print_command(simple_command);
  return simple_command;
}



command_t BuildSubshell(command_t command) {
  command_t subshell_command = (command_t)malloc(sizeof(struct command));
  subshell_command->type = SUBSHELL_COMMAND;
  subshell_command->u.subshell_command = NULL;
  if (command != NULL) 
  {
    subshell_command->u.subshell_command = command;
  }
  return subshell_command;
}



command_t BuildPipe(command_t command_first, command_t command_second)
{
  int index = 0;
  command_t pipe_command = (command_t)malloc(sizeof(struct command));
  pipe_command->type = PIPE_COMMAND;
  pipe_command->u.command[0] = NULL;
  pipe_command->u.command[1] = NULL;
  if (command_first != NULL)
  {
    pipe_command->u.command[index] = command_first;
    index++;
  }
  if (command_second != NULL)
  {
    pipe_command->u.command[index] = command_second;
    index++;
  }
  return pipe_command;
}



command_t BuildOr(command_t command_first, command_t command_second)
{
  int index = 0;
  command_t or_command = (command_t)malloc(sizeof(struct command));
  or_command->type = OR_COMMAND;
  or_command->u.command[0] = NULL;
  or_command->u.command[1] = NULL;
  if (command_first != NULL)
  {
    or_command->u.command[index] = command_first;
    index++;
  }
  if (command_second != NULL)
  {
    or_command->u.command[index] = command_second;
    index++;
  }
  return or_command;
}


command_t BuildAnd(command_t command_first, command_t command_second)
{
  int index = 0;
  command_t and_command = (command_t)malloc(sizeof(struct command));
  and_command->type = AND_COMMAND;
  and_command->u.command[0] = NULL;
  and_command->u.command[1] = NULL;
  if (command_first != NULL)
  {
    and_command->u.command[index] = command_first;
    index++;
  }
  if (command_second != NULL)
  {
    and_command->u.command[index] = command_second;
    index++;
  }
  return and_command;
}


command_t BuildSequence(command_t command_first, command_t command_second) {
  int index = 0;
  command_t sequence_command = (command_t)malloc(sizeof(struct command));
  sequence_command->type = SEQUENCE_COMMAND;
  sequence_command->u.command[0] = NULL;
  sequence_command->u.command[1] = NULL;
  if (command_first != NULL) {
    sequence_command->u.command[index] = command_first;
    index++;
  }
  if (command_second != NULL) {
    sequence_command->u.command[index] = command_second;
    index++;
  }
  //printf("PRINT SEQUENCE COMMAND:\n");
  //print_command(sequence_command);
  return sequence_command;
}



command_t ParseSimple(token_list list_head)
{
  token_list sublist_first;
  token_list sublist_second;
  token_t *search_token = list_head;
  token_t *search_token_pre = list_head;
  token_t *simple_end;
  command_t subcommand = NULL;
  command_t command = NULL;
  int is_LQUOTE = 0;
  int has_LQUOTE = 0;
  int is_RQUOTE = 0;
  int has_RQUOTE = 0;

  InitList(&sublist_first);
  InitList(&sublist_second);
  //printf("In Simple 1\n");
  while (search_token->next != NULL)
  {
    search_token_pre = search_token;
    search_token = search_token->next;

    if (search_token->type == WORDS)
    {
      simple_end = search_token;
    }
    else if (search_token->type == NEWLINE)
    {
      token_t *delete_token = search_token;
      search_token_pre->next = delete_token->next;
      delete_token->next = NULL;
      free(delete_token);
      search_token = search_token_pre;
      line_number++;
    }
    else
    {
      sublist_second->next = search_token;
      search_token = sublist_second;
      search_token_pre = sublist_second;
      break;
    }
  }
  sublist_first = list_head;
  simple_end->next = NULL;
  command = BuildSimple(sublist_first);


  while (search_token->next != NULL)
  {
    search_token_pre = search_token;
    search_token = search_token->next;

    if (is_LQUOTE)  // Input redirection
    {
      if (search_token->type == WORDS)
      {
        command->input = search_token-> token_value;
      }
      else if (search_token->type == NEWLINE)
      {
        line_number++;
        error(1,0,"line %d: no newline allowed after '<'", line_number);
      }
      else
      {
        error(1,0,"Line %d: expect words after '<'", line_number);
      }     
      is_LQUOTE = 0;      
    }
    else if (is_RQUOTE)   // Output redirection
    {
      if (search_token->type == WORDS)
      {
         command->output = search_token-> token_value;
      }
      else if (search_token->type == NEWLINE)
      {
        line_number++;
        error(1,0,"Line %d: no newline allowed after '>'", line_number);         
      }
      else
      {
        error(1,0,"Line %d: expect words after '>'", line_number);
      }     
      is_RQUOTE = 0;
    }
    else
    {
      if (search_token->type == LQUOTE)
      {
        if (has_LQUOTE)  // no duplicate input redirection
        {
          error(1,0,"Line %d: no duplicate input redirection allowed", line_number);
        }
        //printf("INPUT <\n");  // FOR TEST
        has_LQUOTE = 1;
        is_LQUOTE = 1;
      }
      else if (search_token->type == RQUOTE)
      {
        if (has_RQUOTE)  // no duplicate output redirection
        {
          error(1,0,"Line %d: no duplicate output redirection allowed", line_number);
        }
        has_RQUOTE = 1;
        is_RQUOTE = 1;
      }
      else if (search_token->type == NEWLINE)
      {
        token_t *delete_token = search_token;
        search_token_pre->next = delete_token->next;
        delete_token->next = NULL;
        free(delete_token);
        search_token = search_token_pre;
        line_number++;
      }
    }
  }
  return command;
}



command_t ParseSubshell(token_list list_head)
{
  token_list sublist;
  token_t *search_token = list_head->next;
  token_t *search_token_pre = list_head;
  token_t *paren_start;
  token_t *paren_end;
  command_t subcommand = NULL;
  command_t command = NULL;
  
  int paren_match = 0; // When this value != 0, the parens are not matched, so the ';' and '\n' should not be used to identify sequence command

  InitList(&sublist);
  //PrintTokens(list_head);
  //printf("In Subshell\n");
  if (search_token->type != LPAREN)
  {
    error(1,0,"Line %d: Unexpected Character", line_number);
  }
  paren_match++;
  paren_start = search_token->next;
  
      // '('<sequence_command>')'
      //    ^                ^     
      //    |                |     
 //      sublist        sublist_end
  while (search_token->next != NULL)
  {
    search_token_pre = search_token;
    search_token = search_token->next;

    if (search_token->type == LPAREN)
    {
      paren_match++;
    }
    if (search_token->type == RPAREN)
    {
      paren_match--;
    }
    if (paren_match == 0)
    {
      break;
    }
  }
  
  if (paren_match != 0)
  {
     error(1,0,"Line %d: Parenthesis not match", line_number);
  }
  paren_end = search_token_pre;
  sublist->next = paren_start;
  paren_end->next = NULL;
  subcommand = ParseSequence(sublist);
  command = BuildSubshell(subcommand);

  int is_LQUOTE = 0;
  int has_LQUOTE = 0;
  int is_RQUOTE = 0;
  int has_RQUOTE = 0;

  while (search_token->next != NULL)
  {
    search_token_pre = search_token;
    search_token = search_token->next;
    if (is_LQUOTE)  // Input redirection
    {
      if (search_token->type == WORDS)
      {
        command->input = search_token-> token_value;
      }
      else if (search_token->type == NEWLINE)
      {
        line_number++;
        error(1,0,"line %d: no newline allowed after '<'", line_number);
      }
      else
      {
        error(1,0,"Line %d: expect words after '<'", line_number);
      }     
      is_LQUOTE = 0;      
    }
    else if (is_RQUOTE)   // Output redirection
    {
      if (search_token->type == WORDS)
      {
         command->output = search_token-> token_value;
      }
      else if (search_token->type == NEWLINE)
      {
        line_number++;
        error(1,0,"Line %d: no newline allowed after '>'", line_number);         
      }
      else
      {
        error(1,0,"Line %d: expect words after '>'", line_number);
      }     
      is_RQUOTE = 0;
    }
    else
    {
      if (search_token->type == LQUOTE)
      {
        if (has_LQUOTE)  // no duplicate input redirection
        {
          error(1,0,"Line %d: no duplicate input redirection allowed", line_number);
        }
        //printf("INPUT <\n");  // FOR TEST
        has_LQUOTE = 1;
        is_LQUOTE = 1;
      }
      else if (search_token->type == RQUOTE)
      {
        if (has_RQUOTE)  // no duplicate output redirection
        {
          error(1,0,"Line %d: no duplicate output redirection allowed", line_number);
        }
        has_RQUOTE = 1;
        is_RQUOTE = 1;
      }
      else if (search_token->type == NEWLINE)
      {
        token_t *delete_token = search_token;
        search_token_pre->next = delete_token->next;
        delete_token->next = NULL;
        free(delete_token);
        search_token = search_token_pre;
        line_number++;
      }
    }
  }
  return command;
}



command_t ParsePipe(token_list list_head)
{
  token_list sublist_first;
  token_list sublist_second;
  token_t *search_token = list_head;
  token_t *search_token_pre = list_head;
  command_t subcommand_first = NULL;
  command_t subcommand_second = NULL;
  command_t command = NULL;
  
  int paren_match = 0; // When this value != 0, the parens are not matched, so the ';' and '\n' should not be used to identify sequence command
  int has_paren = 0;

  InitList(&sublist_first);
  InitList(&sublist_second);
  //printf("In Pipe\n");
  while (search_token->next != NULL)
  {
    search_token_pre = search_token;
    search_token = search_token->next;

    if (search_token->type == LPAREN)   
    {
      has_paren = 1; //Used to identify simple_command and subshell_command
      paren_match++;
      continue;
    }
    else if (search_token->type == RPAREN)
    {
      paren_match--;
      continue;
    }

    if (paren_match == 0)
    {

      if (search_token->type == NEWLINE)
      {
        line_number++;
        token_t *delete_token = search_token;
        search_token_pre->next = delete_token->next;
        delete_token->next = NULL;
        free(delete_token);
        search_token = search_token_pre;
        continue;
      }
      if (search_token->type == VBAR)   
      {
      // <subshell_command> '|' <pipe_command>
      // ^                ^     ^            ^
      // |                |     |            |
 //  sublist_first first_end sublist_second second_end
        if (has_paren == 1)
        {
          sublist_first->next = list_head->next;
          search_token_pre->next = NULL;
          sublist_second->next = search_token->next;
          subcommand_first = ParseSubshell(sublist_first);  //<subshell_command>
          subcommand_second = ParsePipe(sublist_second);  //<pipe_command>
          command = BuildPipe(subcommand_first, subcommand_second);
          return command;         
        }
      // <simple_command> '|' <pipe_command>
      // ^              ^     ^            ^
      // |              |     |            |
 //  sublist_first first_end sublist_second second_end
        else
        {
          sublist_first->next = list_head->next;
          search_token_pre->next = NULL;
          sublist_second->next = search_token->next;
          subcommand_first = ParseSimple(sublist_first);  //<simple_command>
          subcommand_second = ParsePipe(sublist_second);  //<pipe_command>
          command = BuildPipe(subcommand_first, subcommand_second);
          return command;    
        }
      }
    }
  }

  if (paren_match != 0)
  {
    error(1,0,"Line %d: Parenthesis not match", line_number);
  }
  //printf("IN PIPE 2\n");
  search_token = list_head;
  search_token_pre = list_head;
  while (search_token->next != NULL)
  {
    search_token_pre = search_token;
    search_token = search_token->next;
      // <subshell_command> NULL         NULL
      // ^            ^     ^            ^
      // |            |     |            |
 //  sublist_first first_end sublist_second second_end
    if (search_token->type == LPAREN)
    {
      sublist_first->next = list_head->next;
      subcommand_first = ParseSubshell(sublist_first);  //<pipe_command>
      subcommand_second = NULL;
      command = BuildPipe(subcommand_first, subcommand_second);
      return command;      
    }
      // <simple_command>    NULL         NULL
      // ^            ^     ^            ^
      // |            |     |            |
 //  sublist_first first_end sublist_second second_end
    else
    {
      //printf("IN PIPE 3\n");
      sublist_first->next = list_head->next;
      subcommand_first = ParseSimple(sublist_first);  //<pipe_command>
      subcommand_second = NULL;
      command = BuildPipe(subcommand_first, subcommand_second);
      return command;      
    }
  }
  return command;
} 



command_t ParseAndOr(token_list list_head)
{
  token_list sublist_first;
  token_list sublist_second;
  token_t *search_token = list_head;
  token_t *search_token_pre = list_head;
  command_t subcommand_first = NULL;
  command_t subcommand_second = NULL;
  command_t command = NULL;
  
  int paren_match = 0; // When this value != 0, the parens are not matched, so the ';' and '\n' should not be used to identify sequence command

  InitList(&sublist_first);
  InitList(&sublist_second);
  //printf("In AndOr\n");
  while (search_token->next != NULL)
  {
    search_token_pre = search_token;
    search_token = search_token->next;

    if (search_token->type == LPAREN)   
    {
      paren_match++;
      continue;
    }
    else if (search_token->type == RPAREN)
    {
      paren_match--;
      continue;
    }

    if (paren_match == 0)
    {
      // <pipe_command> '&&' <and_or_command>
      // ^            ^      ^              ^
      // |            |      |              |
 //  sublist_first first_end sublist_second second_end
      if (search_token->type == NEWLINE)
      {
        line_number++;
        token_t *delete_token = search_token;
        search_token_pre->next = delete_token->next;
        delete_token->next = NULL;
        free(delete_token);
        search_token = search_token_pre;
        continue;
      }
      else if (search_token->type == AND)   
      {
        sublist_first->next = list_head->next;
        search_token_pre->next = NULL;
        sublist_second->next = search_token->next;
        subcommand_first = ParsePipe(sublist_first);  //<pipe_command>
        subcommand_second = ParseAndOr(sublist_second);  //<and_or_command>
        command = BuildAnd(subcommand_first, subcommand_second);
        return command;
      }

      // <pipe_command> '||' <and_or_command>
      // ^            ^      ^              ^
      // |            |      |              |
 //  sublist_first first_end sublist_second second_end
      else if (search_token->type == OR)  
      {
        sublist_first->next = list_head->next;
        search_token_pre->next = NULL;
        sublist_second->next = search_token->next;
        subcommand_first = ParsePipe(sublist_first);  //<pipe_command>
        subcommand_second = ParseAndOr(sublist_second);  //<and_or_command>
        command = BuildOr(subcommand_first, subcommand_second);
        return command;
      }
    }
  }
  if (paren_match != 0)
  {
    error(1,0,"Line %d: Parenthesis not match", line_number);
  }
    // <pipe_command>    NULL         NULL
    // ^            ^     ^            ^
    // |            |     |            |
//  sublist_first first_end sublist_second second_end
  sublist_first->next = list_head->next;
  subcommand_first = ParsePipe(sublist_first);  //<pipe_command>
  subcommand_second = NULL;
  command = BuildAnd(subcommand_first, subcommand_second);
  return command;
}



command_t ParseSequence(token_list list_head)
{
  token_list sublist_first;
  token_list sublist_second;
  token_t *search_token = list_head;
  token_t *search_token_pre = list_head;
  command_t subcommand_first = NULL;
  command_t subcommand_second = NULL;
  command_t command = NULL;
  
  int paren_match = 0; // When this value != 0, the parens are not matched, so the ';' and '\n' should not be used to identify sequence command

  InitList(&sublist_first);
  InitList(&sublist_second);  
  //printf("In Sequence\n");
  while (search_token->next != NULL) 
  {
    search_token_pre = search_token;
    search_token = search_token->next;

    if (search_token->type == LPAREN)   
    {
      paren_match++;
      continue;
    }
    else if (search_token->type == RPAREN)
    {
      paren_match--;
      continue;
    }

    if (paren_match == 0)
    {
      // <and_or_command> ';' <sequence_command>
      // ^              ^     ^                ^
      // |              |     |                |
 //  sublist_first first_end sublist_second   second_end
      if (search_token->type == SEMICOLON)   
      {
        sublist_first->next = list_head->next;
        search_token_pre->next = NULL;
        sublist_second->next = search_token->next;
        subcommand_first = ParseAndOr(sublist_first);  //<and_or_command>
        subcommand_second = ParseSequence(sublist_second);  //<sequence_command>
        command = BuildSequence(subcommand_first, subcommand_second);
        return command;
      }
      else if (search_token->type == NEWLINE)  
      {
        line_number++;
        token_t *delete_token = search_token->next;
        while (search_token->next->type == NEWLINE) 
        {
          line_number++;
          search_token->next = delete_token->next;
          delete_token->next = NULL;
          free(delete_token);
          delete_token = search_token->next;
        }
      // <and_or_command> '\n' <sequence_command>
      // ^              ^     ^                ^
      // |              |     |                |
  //  sublist_first first_end sublist_second   second_end
        if ((search_token->next->type == WORDS || search_token->next->type == LQUOTE)&&
	      search_token_pre->type != VBAR &&
	      search_token_pre->type != AND &&
	      search_token_pre->type != OR &&
	      search_token_pre->type != LPAREN &&
	      search_token_pre->type != RPAREN &&
	      search_token_pre->type != LQUOTE &&
	      search_token_pre->type != RQUOTE &&
	      search_token_pre->type != SEMICOLON)
        {
          //printf("TEST\n");
          sublist_first->next = list_head->next;
          search_token_pre->next = NULL;
          sublist_second->next = search_token->next;
          subcommand_first = ParseAndOr(sublist_first);  //<and_or_command>
          subcommand_second = ParseSequence(sublist_second);  //<sequence_command>
          command = BuildSequence(subcommand_first, subcommand_second);
          //printf("TEST 2\n");
          return command;
        }
        else  // The new line is useless, delete it
        {
          delete_token = search_token;
          search_token_pre->next = delete_token->next;
          delete_token->next = NULL;
          search_token = search_token_pre;
          free(delete_token);
        }
      }
    }
  }
  if (paren_match != 0)
  {
    error(1,0,"Line %d: Parenthesis not match", line_number);
  }
      // <and_or_command>   NULL         NULL
      // ^            ^     ^            ^
      // |            |     |            |
 //  sublist_first first_end sublist_second second_end
  sublist_first->next = list_head->next;
  subcommand_first = ParseAndOr(sublist_first);  //<and_or_command>
  subcommand_second = NULL;
  command = BuildSequence(subcommand_first, subcommand_second);
  return command;
}


/*
ProcessNewLine(token_list list)
{
  token_t *search_token = list;
  token_t *search_token_pre = list;
  while (search_token->next != NULL) 
  {
    search_token_pre = search_token;
    search_token = search_token->next;
    if (search_token->type == NEWLINE)  
    {
      token_t *delete_token = search_token->next;
      while (search_token->next->type == NEWLINE) 
      {
        search_token->next = delete_token->next;
        delete_token->next = NULL;
        free(delete_token);
        delete_token = search_token->next;
    }
    if (search_token->next->type == WORDS &&
	      search_token_pre->type != VBAR &&
	      search_token_pre->type != AND &&
	      search_token_pre->type != OR &&
	      search_token_pre->type != LPAREN &&
	      search_token_pre->type != RPAREN &&
	      search_token_pre->type != LQUOTE &&
	      search_token_pre->type != RQUOTE &&
	      search_token_pre->type != SEMICOLON);   
    else  // The new line is useless, delete it
    {
      delete_token = search_token;
      search_token_pre->next = delete_token->next;
      delete_token->next = NULL;
      search_token = search_token_pre;
      free(delete_token);
    }
  }
}
*/

/*Method 2 --- Based on grammer --- end*/


//Process the comment in the token list
void ProcessComment(token_list list)
{
  token_t *search_token = list;
  token_t *search_token_pre = list;
  token_t *pound_search;
  //Process the comment
  while (search_token->next != NULL)
  {
    search_token_pre = search_token;
    search_token = search_token->next;
    if (search_token->type == POUND)
    {
      //printf("FIND POUND\n");
      pound_search = search_token;
      while ((pound_search->next != NULL))
      {
        if (pound_search->next->type != NEWLINE)
        {
           pound_search = pound_search->next;
        }
        else
        { 
           break;
        }
      }
      if (pound_search->next == NULL) 
      {
        search_token_pre->next = NULL;
        search_token = list;
        search_token_pre = list;
        // Deal with the newline left at the end of the command
        while (1)
        {
          while (search_token->next != NULL)
          {
            search_token_pre = search_token;
            search_token = search_token->next;
          }
          if (search_token->type == NEWLINE)
          {
            search_token_pre->next = NULL;
            free(search_token);
          }
          else
          {
            break;
          }
        }
        break;
      }
      else if (pound_search->next->type == NEWLINE)
      {
        search_token_pre->next = pound_search->next->next;
        pound_search->next->next = NULL;
        search_token = search_token_pre->next;
      }
    }
  }
}

int CommandsNum(command_t a)
{
  int commands_number = 0;
  command_t temp = a;
  while (temp->u.command[1] != NULL)
  {
    temp = temp->u.command[1];
    commands_number++;
  }
  commands_number++;
  return commands_number;
}


void Parse(token_list t)
{
  com_stream_t = (command_stream_t)malloc(sizeof(struct command_stream));
  com_stream_t->complete_command = ParseSequence(t);
  com_stream_t->commands_num = CommandsNum(com_stream_t->complete_command);
  com_stream_t->command_index = 0;
  com_stream_t->last_command = com_stream_t->complete_command;
  //printf("Parse End 1\n");
  //print_command(com_stream_t->complete_command->);
  //printf("Parse End 2\n");
}

command_stream_t
make_command_stream (int (*get_next_byte) (void *),
		     void *get_next_byte_argument)
{
  /* FIXME: Replace this with your implementation.  You may need to
     add auxiliary functions and otherwise modify the source code.
     You can also use external functions defined in the GNU C Library.  */
  InitList(&tk_list);   // Initialize the linked list
  SeparateTokens(get_next_byte, get_next_byte_argument);  // Convert the input stream into tokens
  ProcessComment(tk_list);
  //PrintTokens(tk_list);
  Parse(tk_list);  //Parse the token list
  return com_stream_t;
}

command_t
read_command_stream (command_stream_t s)
{
  command_t temp;
  //printf("IN READ\n");
  if ((s->command_index) < (s->commands_num))
  {
     temp = s->last_command->u.command[0];
     s->command_index++;
     //printf("IN READ 2\n");
     s->last_command = s->last_command->u.command[1];
     //printf("IN READ 3\n");
     return temp;
  }
  else
  {
    s->command_index = 0;
    s->last_command = s->complete_command;
    return NULL;
  }
}

