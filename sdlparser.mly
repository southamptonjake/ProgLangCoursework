%{
  open Path
%}

%token <string> IDENT KLEENE
%token <int> LANG SIZE LOOPTIMES
%token UNION JOIN PREF INTERSECTION
%token OVER LEFTCURLY RIGHTCURLY LEFTCOMMA RIGHTCOMMA
%token COMMENT
%token IN NEWEXPR LOOP
%token SEP
%token EOL
%left COMMENT    /* lowest precedence */
%left PREF UNION INTERSECTION JOIN  /* lowest precedence */
%left IN       /* medium precedence */
%left NEWEXPR
%left LOOP
%start main
%type <Path.pTerm> main
%%
main :
   |expr EOL    { $1 }
   |COMMENT EOL main { $3 }
;
expr :
  | set { Set($1) }
  | LEFTCOMMA expr RIGHTCOMMA IN LEFTCOMMA expr RIGHTCOMMA { In ($2, $6 )}
  | LEFTCOMMA expr RIGHTCOMMA NEWEXPR LEFTCOMMA expr RIGHTCOMMA { Newexpr($2, $6 ) }
  | LEFTCOMMA LOOP LOOPTIMES expr RIGHTCOMMA { Loop ($3, $4) }
;

set :
  | PREF word LANG { Pref ($2, $3) }
  | UNION LANG LANG { Union ($2, $3)}
  | INTERSECTION LANG LANG { Intersection ($2, $3)}
  | JOIN LANG language { Join ($2, $3 )}
;

word :
  | IDENT { Ident ($1) }
;
language :
  | KLEENE  { Kleen ($1) }
  | SIZE OVER LEFTCURLY inLanguage RIGHTCURLY { LanguageOver ($1, $4) }
;
inLanguage :
  | word { Singleton($1) }
  | inLanguage SEP word { Multiple ($1,$3) }
;
;;
