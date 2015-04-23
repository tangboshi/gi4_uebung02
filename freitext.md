# Lösung Freitextaufgaben

## Aufgabenteil 1.2
Die Header-Dateien des Betriebssystems befinden sich an dem Compiler bekannten Stellen
und müssen im make-File nicht berücksichtigt werden. Vielmehr werden diese bei Bedarf
geladen.

## Aufgabenteil 1.3
siehe makefile

## Aufgabenteil 1.5
Nichts, da im Makefile make keine dependencies für install bzw. clean festgelegt sind
Ausgabe: "make "(...)" ist bereits aktualisiert.".
Dies führt dazu, dass install und clean für aktuell gehalten werden und dementsprechend
nicht geändert werden! Also: ganz schlechte Idee seine files install, clean oder all
zu nennen.




