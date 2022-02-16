# ArtAutomatize
Starter.sh - Ezzel elindíthatunk két EC2 gépet, egyet a frontendnek, egyet a backendnek.
  Felmásolhatjuk vele a gépekre a szükséges fájlokat.
frontend.sh - Ez a script telepíti fel a dockert a gépekre, ha még nincs fent.
  A starter.sh használja ezt a scriptet, nem kell külön használni.
frontendstart.sh - Ezt használhatjuk a cron-al, hogy csekkolja a github repository-t.
  Ha még nincs a gépen a repo, akkor leklónozza és lebuildeli docker-compose-al.
  Ha ez már megvan, akkor azt csekkolja, hogy van e változás a repóban.
  Ha van, akkor pull-olja, leállítja a docker-compose-t, és újra megcsinálja.
Még nem jöttem rá, hogyan kell automatizálni egy crontab létrehozását, így addig
ezt manuálisan kell végrehajtani.
crontab -e a crontabunk megnyitása, ide lehet beírni, hogy milyen időközönként és
milyen scriptet indítson el a gép. 
Default beállításom az, hogy percenként indítja a /home/ubuntu/frontendstart.sh-t.
grep CRON /var/log/syslog - ezzel kiírathatjuk a cron logjait.
1-59/2 * * * * /home/ubuntu/teszt.sh - Minden második percben elindul a script, output
nincs, ha szeretnénk, akkor vagy telepítünk egy mail alkalmazást, vagy így írjuk be:
1-59/2 * * * * /home/ubuntu/teszt.sh >/dev/null 2>&1