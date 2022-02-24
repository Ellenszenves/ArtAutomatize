# ArtAutomatize
Nem automata script amilyennek indult, mert átköltöztem Google Cloud-ra.

Minden szolgáltatás dockerrel futtatható, de nem univerzálisak a kódok,
pár dolgot specifikusan át kell írni valószínűleg, de indulásnak jó.

Az sh fájlokat a jenkins-be adtam meg, de ezeket akár crontab-ba is
meg lehet adni, viszont vannak webhook-os verziók is, azokat nem
rakom ide külön, úgy még ennyi kód sem kell.
Nem tökéletes még mert ha valaki merge-el a giten több branch-et
azzal nem tud mit kezdeni a docker pull néha és megmakkan rajta.
Erre lehet megoldás, hogy legyaluljuk a repó mappáját és
újra leklónozzuk a repository-t.