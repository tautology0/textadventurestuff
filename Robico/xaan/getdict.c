#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define VERB_PTR 0x6473
#define NOUN_PTR 0x65A9
#define OBJLOC_PTR 0x62f5
#define VERB_NUM 56
#define NOUN_NUM 48
#define VERB_OFFL 0x6400
#define VERB_OFFH 0x6438

typedef struct
{
   char verb[64];
   int  address;
} verb_struct;

typedef struct
{
   char noun[64];
   int location;
} noun_struct;

char directions[10][20]={
   "north",     "south",     "east",      "west",
   "northeast", "northwest", "southeast", "southwest",
   "up",        "down"
};

typedef struct
{
   int direction;
   int destination;
   int blocked:1;
} exit_struct;

typedef struct
{
   int         description;
   exit_struct exits[10];
} room_struct;

verb_struct verbs[255];
noun_struct nouns[255];
char intro[15][255];

int main (void)
{
   FILE *infile;
   char tokens[512][30], temp[30];
   char messages[512][512];
   room_struct rooms[512];
   
   unsigned char byte, byte2;
   int i=0,size=0,ptr=0,lower=0,bracket;
   int endtok=0,lowtok=0,token=0,j=0;
   int msgcount=0, roomcount=0, introcount=0;
   int curexit=0;

   infile = fopen("XAAN","rb");
   if (infile == NULL)
   {
      printf("Failed to open file\n");
      exit(1);
   }
   fseek(infile,0x66e5,SEEK_SET);

   do
   {
      byte=fgetc(infile);
      if ( (byte != 0x40) && !feof(infile) )
      {
         tokens[i][ptr++]=byte;
      }
      else if (!feof(infile))
      {
         tokens[i][ptr++]='\0';
         ptr=0;
         ++i;
      }
   } while (!feof(infile));
   size=i;

   printf("Reading Intro\n");
   
   fseek(infile,0x3100,SEEK_SET);
   endtok=0x0d;
   do
   {
      byte=fgetc(infile);
      
      if (byte == endtok)
      {
         introcount++;
         bracket=0;
         lower=0;
      }
      else if (byte < 0x20 || byte > 0x5a)
      {
         if (byte < 0x0e) token = byte + 0xa5;
         else if (byte < 0x20) token = byte + 0xa4;
         else token = byte - 0x5b;
         /* look up in dictionary */
         if (lower==1)
         {
            sprintf(intro[introcount],"%s%c",intro[introcount],tokens[token][0]);
         }
         for (i=lower;i<strlen(tokens[token]);i++)
         {
            sprintf(intro[introcount],"%s%c",intro[introcount],tolower(tokens[token][i]));
         }
         lower=0;
      }
      else if (byte == 0x2e || byte == 0x3f || byte == 0x21 || byte == 0x2c ||
               byte == 0x3b || byte == 0x3a)
      {
         sprintf(intro[introcount],"%s%c ",intro[introcount],byte);
         if (byte == 0x2e || byte == 0x3f || byte == 0x21) lower=1;
      }
      else if (byte > 0x40 && byte < 0x5b)
      {
         if (lower == 1)
         {
            token=byte;
            lower=0;
         }
         else
         {
            token=tolower(byte);
         }
         sprintf(intro[introcount],"%s%c",intro[introcount],token);
      }
      else if (byte == 0x23)
      {
         lower=1;
      }
      else if (byte == 0x2b)
      {
         sprintf(intro[introcount],"%s\\n",intro[introcount]);
      }
      else
      {
         sprintf(intro[introcount],"%s%c",intro[introcount],byte);
      }
   } while (ftell(infile) < 0x3249);

   printf("Reading Messages\n");
   
   fseek(infile,0x3300,SEEK_SET);
   endtok=0x0d;
   msgcount=0;
   do
   {
      byte=fgetc(infile);
      
      if (byte == endtok)
      {
         msgcount++;
         bracket=0;
         lower=0;
      }
      else if (byte < 0x20 || byte > 0x5a)
      {
         if (byte < 0x0e) token = byte + 0xa5;
         else if (byte < 0x20) token = byte + 0xa4;
         else token = byte - 0x5b;
         /* look up in dictionary */
         if (lower==1)
         {
            sprintf(messages[msgcount],"%s%c",messages[msgcount],tokens[token][0]);
         }
         for (i=lower;i<strlen(tokens[token]);i++)
         {
            sprintf(messages[msgcount],"%s%c",messages[msgcount],tolower(tokens[token][i]));
         }
         lower=0;
      }
      else if (byte == 0x2e || byte == 0x3f || byte == 0x21 || byte == 0x2c ||
               byte == 0x3b || byte == 0x3a)
      {
         sprintf(messages[msgcount],"%s%c ",messages[msgcount],byte);
         if (byte == 0x2e || byte == 0x3f || byte == 0x21) lower=1;
      }
      else if (byte > 0x40 && byte < 0x5b)
      {
         if (lower == 1)
         {
            token=byte;
            lower=0;
         }
         else
         {
            token=tolower(byte);
         }
         sprintf(messages[msgcount],"%s%c",messages[msgcount],token);
      }
      else if (byte == 0x23)
      {
         lower=1;
      }
      else if (byte == 0x2b)
      {
         sprintf(messages[msgcount],"%s\\n",messages[msgcount]);
      }
      else
      {
         sprintf(messages[msgcount],"%s%c",messages[msgcount],byte);
      }
   } while (ftell(infile) < 0x5c57);

   printf("Enumerating rooms\n");
   fseek(infile,0x6354,SEEK_SET);
   roomcount=0x34;
   do
   {
      byte = fgetc(infile);
      token = byte + 162;
      rooms[roomcount].description=token;
      roomcount++;
   } while (ftell(infile) < 0x6400);
   roomcount--;
  
   printf("Gathering exits\n");
   fseek(infile, 0x5c5c, SEEK_SET);
   i=0x34;
   curexit=0;
   for (j=0;j<10;j++) rooms[i].exits[j].destination=0xff;   
   do
   {
      unsigned char byte2;
      byte=fgetc(infile);
      byte2=fgetc(infile);

      rooms[i].exits[curexit].direction=byte & 0xf;
      rooms[i].exits[curexit].destination=byte2;
      if (byte & 0x40)
      {
         rooms[i].exits[curexit].blocked=1;
      }
      curexit++;
      
      if (byte & 0x80)
      {
         i++;
         for (j=0;j<10;j++) rooms[i].exits[j].destination=0xff;
         curexit=0;
      }
      
   } while (i < roomcount);
   printf("%lx\n",ftell(infile));
   
   printf("Gathering Verbs\n");
   fseek(infile,VERB_PTR,SEEK_SET);
   for (i=0; i<VERB_NUM; i++)
   {
      int ptr=0, j=0;
      do
      {
         j=fgetc(infile);
         if (j != '@') verbs[i].verb[ptr++]=j;
      } while (j != '@');
      verbs[i].verb[ptr]='\0';
   }

   // addresses
   fseek(infile, VERB_OFFL, SEEK_SET);
   for (i=1; i<VERB_NUM; i++)
   {
      verbs[i].address=fgetc(infile);
   }
   fseek(infile, VERB_OFFH, SEEK_SET);
   for (i=1; i<VERB_NUM; i++)
   {
      verbs[i].address+=(fgetc(infile)<<8);
   }
   verbs[0].address=0; 

   printf("Gathering Nouns\n");
   fseek(infile,NOUN_PTR+1,SEEK_SET);
   for (i=0; i<NOUN_NUM; i++)
   {
      int ptr=0, j=0;
      do
      {
         j=fgetc(infile);
         if (j != '@') nouns[i].noun[ptr++]=j;
      } while (j != '@');
      nouns[i].noun[ptr]='\0';
   }
   
   printf("Object Locations\n");
   fseek(infile,OBJLOC_PTR+1,SEEK_SET);  
   for (i=0; i<NOUN_NUM; i++)
   {
      int ptr=0, j=0;
      j=fgetc(infile);
      nouns[i].location=j;
   }
   
   printf("\n\nDumping it all:\n");
   printf("Intro:\n");
   for (i=0; i<=introcount; i++)
   {
      printf("%s\n", intro[i]);
   }
   // Display messages
   for (i=0; i<=msgcount; i++)
   {
      printf("Message %d: %s\n", i, messages[i]);
   }
   
   // Display rooms
   for (i=0x34; i<=roomcount; i++)
   {
      printf("\nRoom %d: %s\n", i, messages[rooms[i].description]);
      printf("Exits:\n");
      for (j=0; j < 10; j++)
      {
         if (rooms[i].exits[j].destination != 0xff)
         {
            printf(" %s to %d (%s)", directions[rooms[i].exits[j].direction],
                                     rooms[i].exits[j].destination,
                                     messages[rooms[rooms[i].exits[j].destination].description]);
            if (rooms[i].exits[j].blocked)
            {
               printf("(blocked)");
            }
            printf("\n");
         }
      }
   }
   
   // Display Verbs
   for (i=0; i<VERB_NUM; i++)
   {
      printf("Verb %d: %s\n address &%04x\n", i, verbs[i].verb, verbs[i].address);
   }
   for (i=2; i<NOUN_NUM; i++)
   {
      printf("Noun %d: %s\n Starts in: %d (%s)\n", 
               i, nouns[i].noun, nouns[i].location,
               (nouns[i].location==0)?"inventory":
               (nouns[i].location==1)?"worn":
               (nouns[i].location<0x34)?nouns[nouns[i].location].noun:
               (nouns[i].location>223)?"nowhere":
               messages[rooms[nouns[i].location].description]);
   }
         
   fclose(infile);
   return 0;
}
