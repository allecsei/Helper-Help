### Actualizare Majoră: Sistemul Complet de Gunoier (Skill 1 - 10)

Am reproiectat complet jobul de Gunoier pentru a oferi o experiență de joc progresivă, interactivă și orientată spre lucrul în echipă, eliminând vechiul sistem repetitiv.

---

#### 1. Progresia Contractelor și Vehiculelor
Jucătorii deblochează contracte, unelte și vehicule noi pe măsură ce avansează în nivel:
* **Skill 1-2 | Sweeper (Curățarea străzilor):** Curățare direct cu vehiculul pe petele de pe asfalt menținând o viteză maximă de 35 km/h. ($500 - $550)
* **Skill 3-4 | Walton (Deșeuri rezidențiale):** Colectarea și încărcarea sacilor de gunoi din cartiere folosind tasta `Y`. ($680 - $970)
* **Skill 5-6 | Yosemite (Deșeuri voluminoase):** Ridicarea obiectelor grele folosind cârlige animate operate de șofer sau partener. ($1.250 - $1.550)
* **Skill 7-8 | DFT-30 (Reciclare comercială):** Sortarea deșeurilor (reciclabile, metalice, generale) în compartimentele dedicate ale vehiculului. ($2.100 - $2.700)
* **Skill 9-10 | Trashmaster (Intervenție municipală):** Inspecția zonelor și remedierea problemelor (graffiti, pubele deteriorate, zone murdare, curățenie) cu unelte specifice. ($3.300 - $3.900)

---

####  2. Sistemul Co-Op Avansat (Începând cu Skill 3)
* **Mecanică:** Comanda `/work` permite lucrul individual sau invitarea unui partener eligibil (minim Skill 3, aflat la locația de start, fără contract activ).
* **Împărțirea veniturilor:** Baza salarială este împărțită **50/50** dacă partenerul efectuează cel puțin o acțiune validă în timpul rutei.
* **Bonusuri active:** Partenerii care contribuie primesc suplimentar 1 punct de skill, 1 punct Marathon și Clan XP.

---

####  3. Activitatea Pasivă de Scotocire (Skill 7+)
* **Comenzi:** `/rummage` (la tomberon) și `/rummagebins` (afișează lista cu cele mai apropiate locații și starea lor).
* **Recompense Standard:** Bani, materiale, droguri sau resurse de crafting (șansele cresc în funcție de skill).
* **Recompense Ultra-Rare (Șansă de 1 la 100.000):**
  * Cupoane Dealership Stock neutilizate
  * Tichete Diamond / Onyx
  * Artefacte rare
* **Reguli și Riscuri:** Cooldown personal de 45 de secunde, cooldown de 10 minute per tomberon, notificação vizuală pe o rază de 15 metri și risc de **wanted** din partea poliției dacă ești prins.

---

#### Actualizare Sistem Bunker (Tier-uri, Producție și Vânzare)

Sistemul de bunker a fost actualizat complet pentru a reflecta detaliile oficiale de progresie, producție și vânzare stoc:

* **Progresie Tiers (Tier 0 - Tier 10):**
  * **Tier 0:** Deblocat automat la achiziționare ($0 / $100 provizii / 100 stoc).
  * **Tier 1 - 5:** Praguri de la $20.000.000 până la $100.000.000 generate (capacitate crescută treptat până la 150 provizii / 100-150 stoc).
  * **Tier 6 - 10:** Praguri de la $150.000.000 până la $250.000.000 generate (capacitate maximă de 150 provizii / 110-150 stoc).
  * *Notă:* Comanda `/buybunker` este disponibilă de la Lvl 10, iar stocul se pierde la mutare!

* **Producție și Viteza de Generare:**
  * Condiție: Bunkerul necesită provizii, iar proprietarul trebuie să fie online.
  * Fără îmbunătățiri: 1 unitate / 20 minute.
  * Staff sau Echipament: 1 unitate / 15 minute.
  * Staff + Echipament (Maxim): 1 unitate / 10 minute.
  * Consum provizii (Maxim): 1 unitate / 300 secunde.

* **Vânzare și Livrare Stoc:**
  * Preț unitar: $1.000 (locație apropiată) / $2.000 (locație îndepărtată).
  * Vehicule: Se utilizează vehicule de tip Bandito în funcție de cantitate (se recomandă invitarea prietenilor pentru ajutor).
  * Timp alocat: 5 minute (aproape) / 10 minute (departe).
  * Bonus Ajutor (Supporters): Fiecare ajutor la misiune primește 10% din plata finală, fără a scădea din banii proprietarului.