# Hydra
### Praktyczny przewodnik użytkownika

![alt text](hydra.jpeg)

W niniejszym przewodniku opiszemy, jak korzystać z Hydry - superkomputera ICM UW.
Pokażemy przykład, jak uruchomić obliczenia z wykorzystaniem pakietu `R`.

## Co to jest Hydra i do czego jest przydatna
Hydra jest to jeden z kilku superkomputerów szeroko udostępnianych przez ICM UW.
Gdy zajmujemy się statystyką lub analizą danych, możliwość korzystania z superkomputera takiego jak Hydra może być nam niekiedy bardzo potrzebna. Hydra daje nam możliwość przeprowadzania ciężkich obliczeń w wygodny sposób i w wielu przypadkach znacząco ułatwia nam życie.
Często zdarza się, że musimy zbudować jakiś trudny obliczeniowo model statystyczny lub przetestować jakość modelu dla wielu różnych parametrów.
Uruchamianie takich wielogodzinnych obliczeń na komuterze osobistym jest bardzo niewygodne (nie możemy w tym samym czasie płynnie z niego korzystać), niepewne (co jeśli w nocy wyłączą prąd na chwilę?) i drogie (prąd kosztuje). A często czasowo niewykonalne.

Tak więc do dzieła - zobaczmy, jak uruchomić obliczenia na Hydrze.

## Jak korzystać z Hydry
Ponieważ człowiek najlepiej uczy się na przykładach, pokażemy na wszystko przykładzie.
Powiedzmy, że chcemy zbudować las losowy do przewidywania gatunku irysów.
Chcemy jednak, by to był las z *milionem* drzew - dlatego potrzebujemy Hydry.
Skrypt znajduje się w pliku `test.R`.

### Logowanie do ICM
Aby móc korzystać z Hydry, należy przede wszystkim posiadać grant obliczeniowy i wraz z nim
* login i hasło do infrastruktury obliczeniowej ICM,
* numer grantu obliczeniowego.

Jeśli ten warunek jest w naszym przypadku spełniony, to wpisujemy do terminala naszego komputera polecenie
```
ssh student@login.icm.edu.pl
```
gdzie `student` zastępujemy swoim loginem; następnie wpisujemy swoje hasło.
Teraz tworzymy katalog (tu: o nazwie *test*) do naszego zadania:
  ```
mkdir test
```

### Kopiowanie plików na Hydrę

Musimy skopiować nasz skrypt `test.R` na Hydrę, otwieramy więc drugi terminal i korzystamy z narzędzia `scp`:
  ```
scp ~/sciezka/do/pliku/test.R student@login.icm.edu.pl:~/test/
  ```
Wracamy do pierwszego terminala (*HYDRA*) i sprawdzamy, czy plik się skopiował, wyświetlając zawartość katalogu *test*:
  ```
ls test
```

### Tryb wsadowy i tryb interaktywny
Z Hydry można korzystać w dwojaki sposób:
  * w trybie interaktywnym: z dostępem do powłoki - możemy wówczas otworzyć `R`'a i wpisywać polecenia od razu widząc efekt ich wykonania.
* w trybie wsadowym: bez możliwości interakcji z wykonywanym programem - wysyłamy skrypt do wykonania i czekamy na wynik,

Zademonstrujemy obydwa tryby.
W trybie interaktywnym zainstalujemy w `R` pakiet `randomForest`, a w trybie wsadowym uruchomimy nasz skrypt `test.R`.

### Instalowanie pakietu w trybie interaktywnym

Tryb interaktywny uruchamiamy poleceniem
```
srun -p plgrid -A student2016a --pty bash -l
```
gdzie zamiast `student2016a` wpisujemy numer naszego grantu obliczeniowego.
Poleceniem ```module avail``` możemy wyświetlić dostępne moduły.

Aby uruchomić `R`'a, załadujmy moduł zawierający jego wersję `3.1.0`:
  ```
module load plgrid/apps/r/3.1.0
```
Teraz możemy normalnie uruchomić `R`'a:
```
R
```
Spradzamy, czy działa:
```
2 + 2
```
i instalujemy `randomForest` do późniejszego użycia:
```
install.packages('randomForest')
```
Ponieważ nie posiadamy praw dostępu do katalogu, gdzie `R` domyślnie instaluje pakiety, zostaniemy zapytani, czy stworzyć do tego celu katalog w naszym katalogu domowym - oczywiście się zgadzamy.

Kiedy pakiet jest już pomyślnie zainstalowany, wychodzimy z `R`'a poleceniem
```
quit()
```
i wylogowujemu się z trybu interaktywnego:
  ```
logout
```
### Uruchomienie skryptu w trybie wsadowym

A teraz wyjaśnijmy, jak uruchomić nasz skrypt `test.R` w trybie wsadowym.
Trybem wsadowym na Hydrze (tak jak na wielu innych superkomputerach) rozporządza system kolejkowy SLURM (*Simple Linux Utility for Resource Management*). Aby zlecić jakieś zadanie do policzenia, należy zadeklarować, jakie zasoby (moc obliczeniowa, pamięć, typ procesora) będą nam potrzebne. System kolejkowy wstawia nasze zadanie do kolejki wielu innych zadań zgłoszonych przez innych użytkowników, i kiedy zwolnią się zasoby, na które zgłosiliśmy zapotrzebowanie - rozpoczynają się obliczenia.

Informacje o zapotrzebowaniu na zasoby komputera zamieszcza się w odpowiednim pliku w odpowiednim formacie. Niech u nas ten plik nazywa się `test.batch` i ma natępującą zawartość:
  ```
#!/bin/bash -l
#SBATCH -J irysowy_las
#SBATCH -N 1
#SBATCH --ntasks-per-node 10
#SBATCH --mem 10000
#SBATCH --time=72:00:00
#SBATCH -A student2016a
#SBATCH -p plgrid-long
#SBATCH --output="test.out"
#SBATCH --mail-type=ALL
#SBATCH --mail-user=student@mini.pw.edu.pl

module load r/3.1.2
R CMD BATCH test.R
```
Omówmy  najważniejsze linie:
  * ``` #SBATCH -J irysowy_las ``` - nazwa, pod jaką będzie widoczne nasze zadanie w systemie kolejkowym,
* ``` #SBATCH -N 1 ``` - liczba potrzebnych nam węzłów (1),
* ``` #SBATCH --ntasks-per-node 10 ``` - liczba potrzebnych nam rdzeni w węźle (10),
* ``` #SBATCH --mem 2000 ``` - ilość potrzebnej nam pamięci (2 GB),
* ``` #SBATCH --time=72:00:00 ``` - maksymalny czas obliczeń (3 dni),
* ``` #SBATCH -A student2016a ``` - numer naszego grantu obliczeniowego (AAA-1),
* ``` #SBATCH --output="test.out" ``` - nazwa pliku, gdzie system kolejkowy zapisze swoje komunikaty,
* ``` #SBATCH --mail-user=student@mini.pw.edu.pl ``` - adres e-mail, na który przyjdzie informacja o rozpoczęciu/zakończeniu obliczeń,
* ```module load r/3.1.2``` - potrzebny moduł z oprogramowaniem (to `R` w wersji `3.1.2`)
* ```R CMD BATCH test.R``` - najistotniejsze - polecenie wykonania naszego skryptu `R`'owego.

W naszym przypadku plik `test.R` jest postaci:

```
library(randomForest)
irisRf <- randomForest(Species ~ ., data=iris, ntree=1000000)
saveRDS(irisRf, 'irisRf.rds')
```

Tak przygotowany skrypt `test.batch` musimy przesłać na Hydrę - tak samo, jak robiliśmy to wcześniej z plikiem `test.R`:
```
scp ~/sciezka/do/pliku/test.batch student@login.icm.edu.pl:~/test/
```

Następnie **wstawiamy nasze zadanie do kolejki** poleceniem:
```
sbatch test.batch
```
Nasze zadanie jest w kolejce. Polecenie
```
squeue -u student
```
pozwala to potwierdzić oraz dowiedzieć się, czy oczekuje lub ile czasu już jest wykonywane.
Kiedy zacznie się wykonywać, powinniśmy otrzymać informację drogą mailową na podany adres.
Całą kolejkę możemy obejrzeć wpisując:
```
squeue
```
Gdybyśmy chcieli anulować nasze zadanie, wpisujemy:
```
scancel -u student
```
Kiedy zadanie zostanie wykonane, dostaniemy informację mailem.
Wtedy poleceniem
```
scp student@login.icm.edu.pl:~/test/irisRf.rds ~/sciezka/do/katalogu/
```
kopiujemy plik z wynikiem (*irisRf.rds* to nazwa pliku wynikowego) na komputer osobisty i *voilà* - możemy się cieszyć naszym milionowym lasem!

## Suplement
### Przypomnienie podstawowych poleceń bash'owych

* ```cd sciezka/do/katalogu``` - zmienia katalog bieżący na `sciezka/do/katalogu`,
* ```cd ..``` - zmienia katalog bieżący na nadrzędny,
* ```ls ``` - wyświetla zawartość bieżącego katalogu,
* ```mkdir nazwa_katalogu``` - tworzy nowy katalog w wewnątrz bieżącego katalogu,
* ```cp plik sciezka/do/katalogu/``` - kopiuje `plik` do lokalizacji `sciezka/do/katalogu/`
* ```sl``` - rozwesela i pociesza.

### Przydatne linki
* [Strona centrum obliczeniowego ICM](https://www.icm.edu.pl/kdm/)
* [Informacje nt. Hydry na stronie ICM](https://www.icm.edu.pl/kdm/Hydra)
* [Informacje nt. systemu kolejkowego SLURM na stronie ICM](https://www.icm.edu.pl/kdm/Slurm)
* [Oficjalna strona systemu SLURM](http://slurm.schedmd.com/)
* [pakiet RandomForest](https://cran.r-project.org/web/packages/randomForest/index.html)
* [źródło ilustracji](http://www.hydravm.org/hydra)
