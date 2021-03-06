��               )  �      �     �     �     �     �     �        &  5     \   	  c     m     y     �  #  �     �     �     �     �     �   $  �     �             �  0          $     2    >     
J  J  
M     �   #  �   6  �   #        5   !  V   2  x     �   	  �     �     �     �  T  �     /     4     8     @     H   n  \   
  �     �   "  �            	  !   
  +  �  6     �                	                                        
                                                                                %s \- manual page for %s %s %s: can't create %s (%s) %s: can't get `%s' info from %s %s: can't open `%s' (%s) %s: can't unlink %s (%s) %s: error writing to %s (%s) %s: no valid information found in `%s' AUTHOR COPYRIGHT DESCRIPTION EXAMPLES Examples GNU %s %s

Copyright (C) 1997, 1998, 1999, 2000, 2001, 2002, 2003 Free Software
Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

Written by Brendan O'Dea <bod@debian.org>
 Games NAME OPTIONS Options REPORTING BUGS Report +bugs|Email +bug +reports +to SEE ALSO SYNOPSIS System Administration Utilities The full documentation for
.B %s
is maintained as a Texinfo manual.  If the
.B info
and
.B %s
programs are properly installed at your site, the command
.IP
.B info %s
.PP
should give you access to the complete manual.
 This +is +free +software User Commands Written +by `%s' generates a man page out of `--help' and `--version' output.

Usage: %s [OPTION]... EXECUTABLE

 -n, --name=STRING       description for the NAME paragraph
 -s, --section=SECTION   section number for manual page (1, 6, 8)
 -m, --manual=TEXT       name of manual (User Commands, ...)
 -S, --source=TEXT       source of program (FSF, Debian, ...)
 -L, --locale=STRING     select locale (default "C")
 -i, --include=FILE      include material from `FILE'
 -I, --opt-include=FILE  include material from `FILE' if it exists
 -o, --output=FILE       send output to `FILE'
 -p, --info-page=TEXT    name of Texinfo manual
 -N, --no-info           suppress pointer to Texinfo manual
     --help              print this help, then exit
     --version           print version number, then exit

EXECUTABLE should accept `--help' and `--version' options although
alternatives may be specified using:

 -h, --help-option=STRING     help option string
 -v, --version-option=STRING  version option string

Report bugs to <bug-help2man@gnu.org>.
 or Project-Id-Version: help2man 1.31
POT-Creation-Date: 2003-07-09 20:33:36+1000
PO-Revision-Date: 2003-07-09 20:34:44+1000
Last-Translator: Denis Barbier <barbier@linuxfr.org>
Language-Team: French <debian-l10n-french@lists.debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
 %s \- page de manuel de %s %s %s: impossible de cr�er ��%s�� (%s) %s: impossible de r�cup�rer l'information ��%s�� de %s %s: impossible d'ouvrir ��%s�� (%s) %s: impossible d'effacer %s (%s) %s: erreur d'�criture sur %s (%s) %s: aucune information valable trouv�e dans ��%s�� AUTEUR COPYRIGHT DESCRIPTION EXEMPLES Exemples GNU %s %s

Copyright (C) 1997, 1998, 1999, 2000, 2001, 2002, 2003 Free Software
Foundation, Inc.
Ce logiciel est libre�; voir les sources pour les conditions de
reproduction. AUCUNE garantie n'est donn�e, pas m�me la garantie
implicite de COMMERCIALISATION ni l'ADAPTATION A UN BESOIN PARTICULIER.

�crit par Brendan O'Dea <bod@debian.org>
 Jeux NOM OPTIONS Options SIGNALER DES BOGUES Signaler +les +bogues|Rapporter +les +bogues|Rapporter +toutes +anomalies|Envoyer +les +rapports +de +bogue +� VOIR AUSSI SYNOPSIS Commandes d'administration syst�me La documentation compl�te pour
.B %s
est mise � jour dans un manuel Texinfo (en anglais).
Si les programmes
.B info
et
.B %s
sont correctement install�s sur votre syst�me, la commande
.IP
.B info %s
.PP
devrait vous donner acc�s au manuel complet (en anglais).
 Ce +logiciel +est +libre Commandes �crit +par ��%s�� g�n�re la page de manuel d'un programme � partir des
indications fournies par celui-ci lorsqu'il est lanc� avec les
options ��--help�� et ��--version��.

Usage: %s [OPTION]... PROGRAMME

 -n, --name=CHA�NE         description pour le paragraphe NOM
 -s, --section=SECTION     num�ro de section de la page de
                           manuel (1, 6, 8)
 -m, --manual=TEXTE        nom du manuel (Commandes, ...)
 -S, --source=TEXTE        source du programme (FSF, Debian, ...)
 -L, --locale=CHA�NE       changer les param�tres r�gionaux
                           (��C�� par d�faut)
 -i, --include=FICHIER     ajouter du texte depuis ��FICHIER��
 -I, --opt-include=FICHIER ajouter du texte depuis ��FICHIER��,
                           si ce fichier existe
 -o, --output=FICHIER      envoyer le r�sultat dans ��FICHIER��
 -p, --info-page=TEXTE     nom du manuel Texinfo
 -N, --no-info             supprimer le pointeur vers le manuel Texinfo
     --help                afficher cette aide, puis quitter
     --version             afficher le num�ro de version, puis quitter

PROGRAMME devrait accepter les options ��--help�� et ��--version��
mais des alternatives peuvent �tre sp�cifi�es en utilisant�:

 -h, --help-option=CHA�NE    cha�ne pour l'option �quivalente � ��--help��
 -v, --version-option=CHA�NE cha�ne pour l'option �quivalente � ��--version� �

Signaler les bogues � <bug-help2man@gnu.org>.
 ou 