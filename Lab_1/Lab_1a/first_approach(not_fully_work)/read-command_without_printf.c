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
  command_t *sequence_commands;
  int commands_num;
  int command_index;
};

// Initialize the command_stream struct

token_list tk_list;
command_stream_t com_stream_t;

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


/*Description: Build simple command structure*/
command_t BuildSimple(token_list sublist_head)
{
  int line_num = 1;
  int is_first = 1; // 1 if we are analyzing the first token
  int index = 0;
  int is_LQUOTE = 0;  // flag to indicate '<'
  int is_RQUOTE = 0;  // flag to indicate '>'
  int has_LQUOTE = 0; // we can only have one '<' in a simple command
  int has_RQUOTE = 0; // we can only have one '>' in a simple command
  int is_NEWLINE = 0; // flag to indicate '\n'
  command_t simple_command;
  simple_command = (command_t)malloc(sizeof(struct command));
  token_t *search_token = sublist_head;
  //token_t *search_token_pre = sublist_head;
  int token_list_length = TokenListLength(sublist_head);
  char *token_words[token_list_length];
  int i;
  for (i=0; i<token_list_length; i++)
  {
    token_words[i] == (char *)malloc(MAX_CHAR_LIMIT*sizeof(char));
  }
  //printf("START SIMPLE\n");   //FOR TEST
  while (search_token->next != NULL)
  {
    //search_token_pre = search_token;
    search_token = search_token->next;
    if (is_LQUOTE)  // Input redirection
    {
      if (search_token->type == WORDS)
      {
        //printf("INPUT REDIRECTION\n");  // FOR TEST
        simple_command->input = search_token->token_value;
      }
      else if (search_token->type == NEWLINE)
      {
        line_num++;
        error(1,0,"line %d: no newline allowed after '<'", line_num);
      }
      else
      {
        error(1,0,"line %d: expect words after '<'", line_num);
      }     
      is_LQUOTE = 0;      
    }
    else if (is_RQUOTE)   // Output redirection
    {
      if (search_token->type == WORDS)
      {
        //printf("OUTPUT REDIRECTION\n");  // FOR TEST
        simple_command->output = search_token-> token_value;
      }
      else if (search_token->type == NEWLINE)
      {
        line_num++;
        error(1,0,"line %d: no newline allowed after '>'", line_num);         
      }
      else
      {
        error(1,0,"line %d: expect words after '>'", line_num);
      }     
      is_RQUOTE = 0;
    }
    else
    {
      if (search_token->type == WORDS)
      {
        is_first = 0;
        token_words[index] = search_token->token_value;
        //printf("WORDS: %s\n", token_words[index]);  // FOR TEST
        index++;
      }
      else if (search_token->type == LQUOTE)
      {
        if (is_first)  // First token of simple command could not be '<'
        {
          error(1,0,"line %d: unexpected '<' at the beginning of the line", line_num);
        }
        if (has_LQUOTE)  // no duplicate input redirection
        {
          error(1,0,"line %d: no duplicate input redirection allowed", line_num);
        }
        //printf("INPUT <\n");  // FOR TEST
        has_LQUOTE = 1;
        is_LQUOTE = 1;
      }
      else if (search_token->type == RQUOTE)
      {
        if (is_first) // First token of simple command could not be '>'
        {
          error(1,0,"line %d: unexpected '>' at the beginning of the line", line_num);
        }
        if (has_RQUOTE)  // no duplicate output redirection
        {
          error(1,0,"line %d: no duplicate output redirection allowed", line_num);
        }
        //printf("OUTPUT >\n"); // FOR TEST
        has_RQUOTE = 1;
        is_RQUOTE = 1;
      }
      else if (search_token->type == NEWLINE)
      {
        //printf("NEWLINE \n");  //FOR TEST
        is_first = 0;
        line_num++;
      }

    }
  }
  char **w = (char **)malloc(token_list_length*MAX_CHAR_LIMIT*sizeof(char));
  simple_command->u.word = w;
  for (i=0; i<index; i++)
  {
    *w++ = token_words[i];
  }
  //simple_command->u.word = token_words;
  simple_command->type = SIMPLE_COMMAND;
  //printf("FINISH SIMPLE\n");
  return simple_command;
}

command_t BuildPipe(command_t command_first, command_t command_second)
{
  int index = 0;
  command_t pipe_command = (command_t)malloc(sizeof(struct command));
  pipe_command->type = PIPE_COMMAND;
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


command_t BuildAnd(command_t command_first, command_t command_second)
{
  int index = 0;
  command_t pipe_command = (command_t)malloc(sizeof(struct command));
  pipe_command->type = AND_COMMAND;
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
  command_t pipe_command = (command_t)malloc(sizeof(struct command));
  pipe_command->type = OR_COMMAND;
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

command_t BuildSequence(command_t command_first, command_t command_second) {
  int index = 0;
  command_t sequence_command = (command_t)malloc(sizeof(struct command));
  sequence_command->type = SEQUENCE_COMMAND;
  if (command_first != NULL) {
    sequence_command->u.command[index] = command_first;
    index++;
  }
  if (command_second != NULL) {
    sequence_command->u.command[index] = command_second;
    index++;
  }
  return sequence_command;
}

int DeleteToken(token_list list, token_t *delete_node)
{
  token_t *node = list;
  token_t *pre_node = list;
  if (list == NULL)
    return -1;  
  while (node->next != NULL)
    {
      pre_node = node;
      node = node->next;
      if (node == delete_node)
	{
	  pre_node->next = node->next;
	  node->next = NULL;
	  free(node);
	  return 1;
	}
    }
  return 0;
}

command_t BuildTree(token_list sublist_head)
{
  int is_ANDOR = 0;
  int is_SEQUENCE = 0;
  int is_PIPE = 0;
  token_t *search_token = sublist_head;
  token_t *search_token_pre = sublist_head;
  token_t *pound_search;
  token_list head_first, head_second;
  command_t command; 
  command_t subcommand_first = NULL;
  command_t subcommand_second = NULL;
  
 //printf("START BUILD TREE\n");
 while (search_token->next != NULL) 
 {
   search_token_pre = search_token;
   search_token = search_token->next;
   if (search_token->type == SEMICOLON) 
   {
     //printf("FIND SEMI\n");
     is_SEQUENCE = 1;
     break;
   }
   else if (search_token->type == NEWLINE) 
   {
     token_t *delete_token = search_token->next;
     while (search_token->next->type == NEWLINE) {
       DeleteToken(sublist_head,delete_token);
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
	      search_token_pre->type != SEMICOLON) 
     {
       is_SEQUENCE = 1;
       break; 
     }
     else /*if (search_token_pre->type == VBAR &&
	 search_token_pre->type == AND &&
         search_token_pre->type == OR &&
         search_token_pre->type == LPAREN &&
         search_token_pre->type == RPAREN &&
         search_token_pre->type == SEMICOLON)*/ {

        delete_token = search_token;
        search_token_pre->next = search_token->next;
        search_token = search_token_pre;
     }     
   }
 }
 if (is_SEQUENCE) 
 {
   head_first = sublist_head;  // First token list: from begining to the token before '|'
   InitList(&head_second);      // Second token list: from the token after '|' to the end
   head_second->next = search_token->next;
   search_token_pre->next = NULL;  // Separate the two token list
   search_token->next = NULL;
   free(search_token);
   if (head_first->next != NULL)
   {
     subcommand_first = BuildTree(head_first);
   }
   if (head_second->next != NULL)
   {
     subcommand_second = BuildTree(head_second);
   }
   //printf("PRINTING COMMANDS\n");
   //print_command(subcommand_first);  //FOR TEST
   //print_command(subcommand_second);  //FOR TEST
   command = BuildSequence(subcommand_first, subcommand_second);
 }
 else
 {
  search_token_pre = sublist_head;
  search_token = sublist_head;
  while (search_token->next != NULL)
  {
    search_token_pre = search_token;
    search_token = search_token->next;
    if (search_token->type == OR || search_token->type == AND)
    {
      //printf("FIND ANDOR\n");
      is_ANDOR = 1;
      break;
    }
  }
  if (is_ANDOR)
  {
      head_first = sublist_head;  // First token list: from begining to the token before '|'
      InitList(&head_second);      // Second token list: from the token after '|' to the end
      head_second->next = search_token->next; 
      search_token_pre->next = NULL;  // Separate the two token list
      search_token->next = NULL;
      if (head_first->next != NULL)
      {
         subcommand_first = BuildTree(head_first);
      }
      if (head_second->next != NULL)
      {
         subcommand_second = BuildTree(head_second);
      }
      //print_command(subcommand_first);  //FOR TEST
      //print_command(subcommand_second);  //FOR TEST
      if (search_token->type == OR)
      {
        command = BuildOr(subcommand_first, subcommand_second);
      }
      else
      {
        command = BuildAnd(subcommand_first, subcommand_second);
      }
      free(search_token);
  }
  else  // Do not find AND OR, try to find PIPE
  {
    search_token = sublist_head;
    search_token_pre = sublist_head;
    while (search_token->next != NULL)
    {
      search_token_pre = search_token;
      search_token = search_token->next;
      if (search_token->type == VBAR)
      {
        //printf("FIND VBAR\n");
        is_PIPE = 1;
        break;
      }
    }
    if (is_PIPE)
    {
      head_first = sublist_head;  // First token list: from begining to the token before '|'
      InitList(&head_second);      // Second token list: from the token after '|' to the end
      head_second->next = search_token->next; 
      search_token_pre->next = NULL;  // Separate the two token list
      search_token->next = NULL;
      free(search_token);
      if (head_first->next != NULL)
      {
         subcommand_first = BuildTree(head_first);
      }
      if (head_second->next != NULL)
      {
         subcommand_second = BuildTree(head_second);
      }
      //print_command(subcommand_first);  //FOR TEST
      //print_command(subcommand_second);  //FOR TEST
      command = BuildPipe(subcommand_first, subcommand_second);
    }
    else
    {
	  //printf("FIND SIMPLE\n");
	  command = BuildSimple(sublist_head);
          //print_command(command);
    }
  }
 }
  //printf("FINISH BUILD TREE\n");
  return command;
}


void Parse(token_list t)
{
  int is_SEQUENCE = 0;
  command_t *current_sequence;
  command_t store_command;
  token_t *search_token_second = t->next;
  token_t *search_token_second_pre = t;
  token_t *search_token = t;
  token_t *search_token_pre = t;
  token_list sublist;

  InitList(&sublist);
  //Presearch to determine the number of sequence commands
  while (search_token->next != NULL) 
  {
    search_token_pre = search_token;
    search_token = search_token->next;
    if (search_token->type == SEMICOLON) 
    {
      //printf("FIND SEMI\n");
      is_SEQUENCE += 1;
    }
    else if (search_token->type == NEWLINE) 
    {
      token_t *delete_token = search_token->next;
      while (search_token->next->type == NEWLINE) 
      {
        DeleteToken(t,delete_token);
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
	      search_token_pre->type != SEMICOLON) 
      {
        is_SEQUENCE += 1;
      }
    }
  }

  if (is_SEQUENCE == 0 || is_SEQUENCE == 1)
  {
     com_stream_t->commands_num = 1;
     //printf("ONE SEQUENCE.\n");
     current_sequence = (command_t *)malloc (sizeof(struct command));
     com_stream_t->sequence_commands = current_sequence;
     store_command = BuildTree(t);
     *(current_sequence) = store_command;
     return;
  }
  else if (is_SEQUENCE%2 == 0)
  {
     //printf("ODD SEQUENCE.\n");
     //printf("is_SEQUENCE: %d\n", is_SEQUENCE);
     com_stream_t->commands_num = (is_SEQUENCE/2)+1;
     current_sequence = (command_t *)malloc (((is_SEQUENCE/2)+10)*sizeof(struct command));
  }
  else if (is_SEQUENCE%2 == 1)
  {
     //printf("EVEN SEQUENCE.\n"); 
     //printf("is_SEQUENCE: %d\n", is_SEQUENCE);
     com_stream_t->commands_num = (is_SEQUENCE/2)+1;
     current_sequence = (command_t *)malloc (((is_SEQUENCE/2)+10)*sizeof(struct command));
  }

  com_stream_t->sequence_commands = current_sequence;
  int count = 0; 
  is_SEQUENCE = 0;
  search_token = t;
  search_token_pre = t;
  //while (count < (com_stream_t->commands_num)) 
  while (1)
  {
    //printf("aab\n");
    search_token_pre = search_token;
    search_token = search_token->next;
    if (search_token->next == NULL)
    {
      //printf("FIND END\n");
      is_SEQUENCE = 3;
    }
    else if (search_token->type == SEMICOLON) 
    {
      //printf("FIND SEMI\n");
      is_SEQUENCE += 1;
    }
    else if (search_token->type == NEWLINE) 
    {
      token_t *delete_token = search_token->next;
      while (search_token->next->type == NEWLINE) 
      {
        DeleteToken(t,delete_token);
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
	      search_token_pre->type != SEMICOLON) 
      {
        is_SEQUENCE += 1;
      }
      else /*if (search_token_pre->type == VBAR &&
	 search_token_pre->type == AND &&
         search_token_pre->type == OR &&
         search_token_pre->type == LPAREN &&
         search_token_pre->type == RPAREN &&
         search_token_pre->type == SEMICOLON)*/ 
      {
        //printf("FIND nw\n");
        delete_token = search_token;
        search_token_pre->next = search_token->next;
        search_token = search_token_pre;
        //DeleteToken(t,delete_token);
      }     
    }

    if (is_SEQUENCE == 2) 
    {
      //printf("SEQUENCE 2\n");
      is_SEQUENCE = 0;
      search_token_pre->next = NULL;
      sublist->next = search_token_second;
      store_command = BuildTree(sublist);
      //print_command(store_command);
      if (search_token->next != NULL)
      {
        search_token_second = search_token->next;
      }
      //printf("aababc\n");
      //print_command(store_command);
      *(current_sequence) = store_command;
      //print_command(*(current_sequence));
      current_sequence++;
      count++;
    }
    
    else if (is_SEQUENCE == 3) 
    {
      //printf("SEQUENCE 3\n");
      sublist->next = search_token_second;
      //PrintTokens(sublist);
      store_command = BuildTree(sublist);
      //print_command(store_command);
      *(current_sequence) = store_command;
      //printf("ababab\n");
      //print_command(*(current_sequence));
      count++;
      break;
    }
  }
  return;
}

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

command_stream_t
make_command_stream (int (*get_next_byte) (void *),
		     void *get_next_byte_argument)
{
  /* FIXME: Replace this with your implementation.  You may need to
     add auxiliary functions and otherwise modify the source code.
     You can also use external functions defined in the GNU C Library.  */
  command_t test;
  com_stream_t = (command_stream_t)malloc(sizeof(struct command_stream));
  com_stream_t->command_index = 0;
  //printf("AAAAA:%d\n", 5/2);
  InitList(&tk_list);   // Initialize the linked list
  SeparateTokens(get_next_byte, get_next_byte_argument);  // Convert the input stream into tokens
  ProcessComment(tk_list);
  //PrintTokens(tk_list);
  Parse(tk_list);
  //test = BuildTree(tk_list);  //FOR TEST
  //com_stream_t-> parse_tree = test;
  //print_command(*(com_stream_t->sequence_commands));  //FOR TEST
  //(com_stream_t->commands)[com_stream_t->commands_num] = *(test);
  //(com_stream_t->commands_num)++;
  //printf("FINISH MAKE\n");
  return com_stream_t;

  
  //error (1, 0, "command creating not yet implemented");
  //return 0;
}

command_t
read_command_stream (command_stream_t s)
{
  command_t *command_index_t;
  command_t command;
 
  //while (s->command_index < s->commands_num)
  //{
  //  print_command(*(s->sequence_commands));
  //   s->sequence_commands++;
  //}
  
  if (s->command_index < s->commands_num)
  {
    //printf("Print Com\n");
    command = *((s->sequence_commands)+s->command_index);
    (s->command_index)++;
    return command;  
  }
  else
  {
    s->command_index = 0;
    return NULL;
  }
  /* FIXME: Replace this with your implementation too.  */
  //error (1, 0, "command reading not yet implemented");
  //return 0;
}
