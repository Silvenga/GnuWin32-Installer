��    6      �  I   |      �  �  �  O  �  q   �	  "   `
  -   �
     �
     �
     �
     �
     �
       &         G     X  !   m     �     �  %   �     �     �       &        >  )   K     u     �     �     �  I   �          3     B  2   O  
   �     �     �     �     �  "   �  )   �  &   !     H     ]      |  ,   �  ,   �     �       
   
               #     2  Z  7  �  �    9  m   P  *   �  8   �     "     @     Z      r     �  !   �  *   �        +     3   G  "   {  *   �  0   �     �          '  *   C     n  >     1   �     �  )   
     4  y   F  +   �     �       L        a     x     �     �     �  #   �  ?   �  )   <     f  5   �  (   �  ;   �  @        `     w          �  
   �     �     �           1                '      +   5   0   $   "             /                   %      &       2       	   3       #      (                 .   *      !                        4               )             6   ,      
                    -                      
Controlling the shar headers:
  -n, --archive-name=NAME   use NAME to document the archive
  -s, --submitter=ADDRESS   override the submitter name
  -a, --net-headers         output Submitted-by: & Archive-name: headers
  -c, --cut-mark            start the shar with a cut line

Selecting how files are stocked:
  -M, --mixed-uuencode         dynamically decide uuencoding (default)
  -T, --text-files             treat all files as text
  -B, --uuencode               treat all files as binary, use uuencode
  -z, --gzip                   gzip and uuencode all files
  -g, --level-for-gzip=LEVEL   pass -LEVEL (default 9) to gzip
  -Z, --compress               compress and uuencode all files
  -b, --bits-per-code=BITS     pass -bBITS (default 12) to compress
 
Giving feedback:
      --help              display this help and exit
      --version           output version information and exit
  -q, --quiet, --silent   do not output verbose messages locally

Selecting files:
  -p, --intermix-type     allow -[BTzZ] in file lists to change mode
  -S, --stdin-file-list   read file list from standard input

Splitting output:
  -o, --output-prefix=PREFIX    output to file PREFIX.01 through PREFIX.NN
  -l, --whole-size-limit=SIZE   split archive, not files, to SIZE kilobytes
  -L, --split-size-limit=SIZE   split archive, or files, to SIZE kilobytes
 
Option -o is required with -l or -L, option -n is required with -a.
Option -g implies -z, option -b implies -Z.
 %s is probably not a shell archive %s looks like raw C code, not a shell archive %s: Illegal ~user %s: No `begin' line %s: No `end' line %s: No user `%s' %s: Not a regular file %s: Short file -C is being deprecated, use -Z instead Cannot access %s Cannot chdir to `%s' Cannot get current directory name Cannot open file %s Cannot use -a option without -n Cannot use -l or -L option without -o Closing `%s' Could not fork Created %d files
 DEBUG was not selected at compile time File %s (%s) Found no shell commands after `cut' in %s Found no shell commands in %s Hard limit %dk
 In shar: remaining size %ld
 Limit still %d
 Mandatory arguments to long options are mandatory for short options too.
 Newfile, remaining %ld,  No input files Opening `%s' PLEASE avoid -X shars on Usenet or public networks Read error Saving %s (%s) Soft limit %dk
 Starting `sh' process Starting file %s
 The `cut' line was followed by: %s Too many directories for mkdir generation Try `%s --help' for more information.
 Usage: %s [FILE]...
 Usage: %s [INFILE] REMOTEFILE
 Usage: %s [OPTION]... [FILE]...
 WARNING: No user interaction in vanilla mode WARNING: Non-text storage options overridden Write error binary compressed empty gzipped standard input text Date: 1995-08-02 02:00:57+0200
From: Ulrich Drepper <drepper@myware>
Xgettext-Options: --default-domain=sharutils --output-dir=. --add-comments --keyword=_
Files: ../../po/../lib/error.c ../../po/../lib/getopt.c
	 ../../po/../lib/xmalloc.c ../../po/../src/shar.c
	 ../../po/../src/unshar.c ../../po/../src/uudecode.c
	 ../../po/../src/uuencode.c
 
Controlo dos cabe�alhos de `shar':
  -n, --archive-name=NOME   atribui ao arquivo o nome NOME
  -s, --submitter=ENDERECO  altera o nome original
  -a, --net-headers         produz os cabe�alhos Submitted-by: e Archive-name:
  -c, --cut-mark            coloca uma linha de demarca��o no in�cio de `shar'

Metodos de armazenamento:
  -M, --mixed-uuencode         faz `uuencode' dinamicamente (por defeito)
  -T, --text-files             considera todos os ficheiros de texto
  -B, --uuencode               considera todos os ficheiros bin�rios,
                               usa `uuencode'
  -z, --gzip                   aplica `gzip' e `uuencode' a todos os ficheiros
  -g, --level-for-gzip=NIVEL   fornece -NIVEL (valor defeito 9) a `gzip'
  -Z, --compress               aplica `compress' e `uuencode' a todos os
                               ficheiros
  -b, --bits-per-code=BITS     fornece -bBITS (valor defeito 12) a `compress'
 
Mensagens informativas:
      --help               apresenta esta mensagem de apoio e termina
      --version            identifica o programa e termina
  -q, --quiet, --silent    n�o apresenta mensagens pormenorizadas localmente

Escolha dos ficheiros:
  -p, --intermix-type      permite -[BTzZ] na lista de ficheiros para
                           mudar de modo
  -S, --stdin-file-list    ler a lista de ficheiros da entrada standard

Delimitar os resultados:
  -o, --output-prefix=PREFIXO      gera os ficheiros PREFIXO.01 a PREFIXO.NN
  -l, --whole-size-limit=TAMANHO   limita os arquivos, n�o os ficheiros,
                                   a TAMANHO kbytes
  -L, --split-size-limit=TAMANHO   limita os arquivos, ou os ficheiros,
                                   a TAMANHO kbytes
 
Exige-se a op��o -o com -l ou -L, exige-se a op��o -n com -a.
A op��o -g implica -z, a op��o -b implica -Z.
 %s provavelmente nao � um arquivo de shell %s parece ser c�digo C em bruto, n�o um arquivo de shell %s: ~utilizador n�o permitido %s: Falta a linha `begin' %s: Falta a linha `end' %s: N�o existe o utilizador `%s' %s: N�o � um ficheiro ordin�rio %s: Ficheiro de dimens�o reduzida -C est� a cair em desuso, utilize antes -Z N�o � poss�vel aceder a %s N�o � poss�vel mudar para a directoria `%s' N�o se consegue obter o nome da directoria corrente N�o � poss�vel abrir o ficheiro %s N�o se pode usar a op��o -a sem a op��o -n N�o se pode usar a op��o -l ou -L sem a op��o -o Fechando `%s' N�o � poss�vel fazer um `fork' Foram criados %d ficheiros
 N�o se escolheu DEBUG durante a compila��o Ficheiro %s (%s) N�o foi encontrado nenhum comando de shell ap�s o `cut', em %s N�o foi encontrado nenhum comando de shell, em %s Limite tipo `hard' de %dk Em shar: o espa�o ainda dispon�vel � %ld
 O limite dura %d
 Os argumentos obrigat�rios para as op��es na forma longa s�o tamb�m
obrigat�rios para a forma curta que lhe corresponde.
 Ficheiro novo, espa�o ainda dispon�vel %ld, Nenhum ficheiro de entrada Abrindo `%s' Por favor, evite -X em arquivos de shell com grande difus�o (redes p�blicas) Erro durante a leitura Gravando %s (%s) Limite tipo `soft' de %dk Arrancando o processo `sh' Arrancando o ficheiro %s
 � linha de demarca��o seguiu-se: %s Demasiados nomes de directorias para poder criar uma directoria Para mais informa��o, tente `%s --help'.
 Utiliza��o: %s [FICHEIRO]...
 Utiliza��o: %s [FICHEIRO_DE_ENTRADA] FICHEIRO_REMOTO
 Utiliza��o: %s [OP��O]... [FICHEIRO]...
 ATEN��O: N�o h� interven��o do utilizador no modo `vanilla' ATEN��O: As op��es para armazenamento n�o-textual foram anuladas Erro durante a escrita bin�rio via `compress' vazio via `gzip' entrada standard texto 