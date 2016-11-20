/**
 * Name: nested
 * Description: Nested highlighting entries.
 * Author: Markku Rossi <mtr@iki.fi>
 */

state nested extends HighlightEntry
{
  nested_start_re {
    language_print($0);

    nested_end_re = nested_end_re_cached;

    if (strcmp($1, "") == 0)
      calln(nested_default);
    else
      calln($3);

    nested_end_re = 0;
  }
}

/*
Local variables:
mode: c
End:
*/
