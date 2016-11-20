/**
 * Name: modula_2
 * Description: modula_2 programming language
 * Author: Peter Funk <pf@artcom0.artcom-gmbh.de>
 */

state modula_2_comment extends Highlight
{
  /(\*\))/ {
    language_print ($0);
    return;
  }
}

state modula_2_string extends Highlight
{
  /[\'\"]/ {
    language_print ($0);
    return;
  }
}

state modula_2 extends HighlightEntry
{
  /* comments */
  /(\(\*)/ {
    comment_face (true);
    language_print ($0);
    call (modula_2_comment);
    comment_face (false);
  }
  /* strings */
  /[\'\"]/ {
    string_face (true);
    language_print ($0);
    call (modula_2_string);
    string_face (false);
  }
  /* Keywords.  */
  /\b(A(ND|RRAY)|B(EGIN|Y)|C(ASE|ONST)|D(EFINITION|IV|O)|ELS(E|IF)|END|EXIT\
|F(OR|ROM)|I(F|MPLEMENTATION|MPORT|N)|LOOP|MO(D|DULE)|NOT|OF|OR|POINTER\
|PROCEDURE|QUALIFIED|R(ECORD|EPEAT|ETURN)|SET|THEN|TO|TYPE|UNTIL|VAR\
|WHILE|WITH)\b/ {
  keyword_face (true);
  language_print ($0);
  keyword_face (false);
  }
}


/*
Local variables:
mode: c
End:
*/
