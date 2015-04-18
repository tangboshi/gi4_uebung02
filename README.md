# Übung 2: Makefiles, Datentypen, Speichermodell

**Hinweis:** Beachten Sie die Informationen über das Werkzeug `make` am Ende des Übungsblattes! Freitext-Aufgaben können als Text- oder [Markdown-Datei](http://markdown.de) eingereicht werden.

## 1 Makefiles

1. Im Anhang sind Ausschnitte aus C-Quelltexten des Programmpaketes *Editor* gegeben. Erstellen Sie dazu ein Makefile. Beachten Sie dabei die Abhängigkeiten der Quelltexte untereinander sowie die Abhängigkeiten der Header-Dateien.

2. Wie müssen die Header-Dateien des Betriebssystems berücksichtigt werden und warum?

3. In der Datei `main.c` wird eine Funktion aus der Datei `input.c` aufgerufen. Wie ist diese Abhängigkeit zu berücksichtigen?

4. Erweitern Sie das Makefile, so dass durch Eingabe von `make clean` die zu den Quell- dateien gehörigen Binärdateien und alle Objekt-Dateien gelöscht werden. Zusätzlich soll durch `make install` der Editor nach `/usr/bin/` kopiert werden und die Rechte `555` (`r-xr-xr-x`) erhalten.

5. Was passiert, wenn es zufällig eine Datei mit dem Namen `clean` oder `install` im Verzeichnis des Makefiles gibt?

6. Man kann die Abhängigkeiten zwischen Quelldateien auch automatisch ermittelnlassen. Schreiben Sie ein Makefile, das bei Aufruf von `make depend` die Abhängigkeiten ermittelt und einbindet.

### Anhang

`main.c`:

	#include <stdio.h>
	#include <string.h>
	#include <stdlib.h>
	#include "utils.h"

`input.c`:

	#include <stdio.h>
	#include <string.h>
	#include <stdlib.h>
	
`utils.h`:

	#include "types.h"
	#include "defs.h"
	
## Datentypen, Speichermodell

1. Ein Rechner speichert Zeichen, indem er einen zugehörigen Zeichencode speichert. Dieser Zeichencode ist der Index des Zeichens in der [ASCII-Tabelle]( http://en.wikipedia.org/wiki/ASCII), welche 256 verschiendene Zeichen enthält. Zeichenketten werden durch eine Folge von Zeichen (`char[]`) dargestellt, die mit dem ASCII-Code 0 beendet wird (nicht zu verwechseln mit den Zeichen `’0’` oder `’O’`). Geben Sie die Speicherdarstellung des Strings `char msg[] = "Hello World!";` an. Nutzen Sie die hexadezimale Darstellung. Wo liegen die hohen Speicheradressen?

2. Ganzzahlen werden direkt binär gespeichert. Je nach Typ und Architektur belegen sie ein oder mehrere Bytes. Geben Sie die Speicherdarstellung folgender Zahlen auf einer Big-Endian- (SPARC) und einer Little-Endian (Intel x86) Maschine an. Nutzen Sie die hexadezimale Darstellung. Wo liegen die hohen Speicheradressen?

	int i = 0xDEADBEEF;	/* Datentyp benoetigt 4 Byte */
	short s = 1025;		/* Datentyp benoetigt 2 Byte */
	char c = 7; 		/* Datentyp benoetigt 1 Byte */
	
3. Um auf Daten effizient zugreifen zu können, werden diese oft an bestimmte Stel- len im Speicher gelegt. Die Speicherausrichtung (engl.: alignment) wirkt sich auf die Geschwindigkeit, mit der auf sie vom Prozessor zugegriffen werden kann, aus. Zum Beispiel können x86-Prozessoren n Byte große Variablen schneller verarbeiten, wenn diese an durch n teilbaren Adressen (natural boundaries) im Speicher liegen. Dadurch können sich Lücken in Datenstrukturen ergeben.Wie wird ein Compiler die folgende Struktur in den Speicher eines x86-Rechners legen? Der Compiler soll hierbei keinerlei Optimierungen vornehmen (-O0)! Die C-Kommentare geben die Werte der einzelnen Elemente an. Verifizieren Sie Ihre Lösung mit Hilfes eines C-Programms, welches Sie zur Laufzeit mit dem Debugger untersuchen.

		struct bigone {
			char index;			/* =7 */
			int avalue;			/* = -512 */
			short shortvalue;	/* =127 */
			char space;			/* =32 */
			short sarray [2];	/* = {0x123, 0x456} */
			int anothervalue;	/* = 4096 */
		}
	
## Projektmanagement mit Make

### Compilieren und Linken von Programmen

Das Kommando cc ist ein Frontend zum C-Compiler und gestattet das Übersetzen von C-Sourcecode und das Binden zu ausführbaren Programmen, die aus mehreren Teilobjekten bestehen können, z.B.

	cc -o myprog main.c average.c
	
Damit nicht bei jedem Compilieren des Programms alle Quelltexte neu übersetzt wer- den müssen, führt man in der Regel Zwischenschritte ein:

* `cc -c main.c`: Compilieren des Hauptprogramms
* `cc -c average.c`: Compilieren einer weiteren C-Datei
* `cc -o myprog main.o average.o`: Binden der Objektdateien zum ausführbaren Programm

Wird das Programm mehrmals übersetzt, sind die ersten beiden Schritte natürlich nur dann notwendig, wenn die zugehörigen Dateien `main.c` und `average.c` in der Zwischenzeit verändert wurden. Um genau solche Abhängigkeiten automatisch überprüfen zu können, wurde das Werkzeug `make` entwickelt.

### Das Werkzeug `make`

`make` überprüft die Abhängigkeit von Programmteilen und übersetzt alle von Änderungen betroffenen Programmteile neu oder ruft sonstige Kommandos auf, die notwendig sind, um die Programme zu generieren. `make` erkennt von sich aus die Abhängigkeiten zwischen Dateien an ihrem Namen und der Namensendung (`.c`, `.o`, `.s`, `.f90`, `.a`, `.y`, `.l`, ...). Das Kommando `make newprog` ruft zum Beispiel für eine vorhandene Datei `newprog.c` automatisch den C-Compiler auf und erzeugt das Programm `newprog`, falls es die Datei `newprog` noch nicht gibt oder diese älteren Datums als `newprog.c` ist. newprog ist in diesem Fall das *Ziel (Target)*, das aktualisiert werden soll, sinnvollerweise sollte die Aktion, die dieses tut, die Datei `newprog` erzeugen oder ersetzen. Durch den Aufruf `make -p` kann man sich alle Standardregeln ausgeben lassen, aus denen man auch die Namen der Variablen ermitteln kann, die die Standardregeln beeinflussen. So legt `CC` z.B. den aufzuru- fenden C-Compiler fest, `CFLAGS` die Optionen beim Compileraufruf und `LDFLAGS` die beim Linkeraufruf. Komplexere Strukturen müssen in einem so genannten Makefile (das standardmäßig `Makefile`, `makefile` oder `MAKEFILE` heißt) als Regeln und Abhängigkeiten definiert werden, die von make beim Aufruf ausgewertet werden. Ein Beispiel für ein Makefile:

	CC = gcc				# GNU C-Compiler benutzen
	CFLAGS = -Wall -g	# Compilerflags
	LDFLAGS =				# keine Linkerflags
	# Auswahl des Kompressionsalgorithmus
	# COMPRESS = bzip2
	COMPRESS = gzip
	
	all: myprog
	
	myprog: main.o average.o
		$(CC) $(LDFLAGS) -o myprog main.o average.o
	
	archive:
		tar cvf myprog.tar *.c *.f makefile
		$(COMPRESS) myprog.tar
		
Werden zusätzlich noch Header-Dateien in die Programmteile eingebunden, so müssen diese Abhängigkeiten angegeben werden:

	main.o:defs.h
	average.o:defs.h
	
### Automatische Bestimmung von Abhängigkeiten

Da die Compiler ja eigentlich von den Quelldatei-Abhängigkeiten betroffen sind, kann man viele von ihnen gleich dazu benutzen, diese Abhängigkeiten zu ermitteln. Z.B. erzeugt der GNU C/C++-Compiler `gcc` durch den Aufruf

	gcc -MM main.c average.c
	
obige Abhängigkeiten automatisch und schreibt die entsprechenden Zeilen in die Standardausgabe. Mit dem >-Operator kann die Ausgabe wie gewohnt in eine Datei umgeleitet und später mittels des `make`-Kommandos

	include <Datei >
	
an eine beliebige Stelle im Makefile eingebunden werden. Weiterhin nützlich zur Lö- sung der Aufgabe ist die Möglichkeit, Suffixe in Variablen zu substituieren. Hat man z.B. in der Variable `DATEIEN` wie folgt

	${DATEIEN} = datei1.x datei2.x datei3.x
	
Dateinamen abgelegt und möchte eine Liste derselben Dateinamen mit dem Suffix `.y` anstatt `.x erhalten, so kann man dies per
	
	${DATEIEN:.x=.y}

erledigen. Manchmal ist es auch nötig, make rekursiv aufzurufen. Mit dem Target

	rebuildAll:
		touch ${OBJS:.o=.c} 	# alle .c-Files beruehren
		make 			# rekursiv aufrufen

kann man die Neuerstellung eines Projektes erzwingen.
