# Praca domowa - debugowanie
Michał Stolarczyk  
24 kwietnia 2016  

Zadanie polega na poprawieniu działania następującego wywołania funkcji z 
pakietu eurostat. 

```r
library(eurostat)
blad <- try(cens_01rdh <- get_eurostat(id = "cens_01rdhh"))
```

Otrzymujemy następujący błąd.

```r
print(blad)
```

```
## [1] "Error in tidy_eurostat(y_raw, time_format, select_time, stringsAsFactors = stringsAsFactors,  : \n  Data includes several time frequencies. Select frequency with\n         select_time or use time_format = \"raw\".\n         Available frequencies: '''1''2''3''4''5''6''0''7''8''9''A''B''C''D''E''F'\n"
## attr(,"class")
## [1] "try-error"
## attr(,"condition")
## <simpleError in tidy_eurostat(y_raw, time_format, select_time, stringsAsFactors = stringsAsFactors,     keepFlags = keepFlags): Data includes several time frequencies. Select frequency with
##          select_time or use time_format = "raw".
##          Available frequencies: '''1''2''3''4''5''6''0''7''8''9''A''B''C''D''E''F'>
```

Problemem jest to, że dla danych w których istnieje tylko jedna unikalna wartość
kolumny `time`, funkcja `tidy_eurostat` nie potrafi rozpoznać daty. 
Naprawia to dodanie następującego kodu:


```r
trace("get_eurostat", 
      tracer = quote(
          trace("tidy_eurostat", at = 9, 
                tracer = quote(if(length(unique(dat2$time)) == 1) time_format = "raw"))))
```


Jest to dodanie linijki kodu do funkcji `tidy_eurostat`, która w przypadku gdy
istnieje tylko jedna unikalna wartość kolumny `time` w tabeli, zmienia parametr
`time_format` na wartość `'raw'`. Musimy użyć zagnieżdżonej funkcji trace, 
ponieważ funkcja `tidy_eurostat` nie jest dostępna poza pakietem.

Teraz otrzymujemy poprawną tabelę.

```r
cens_01rdh <- get_eurostat(id = "cens_01rdhh")
```

```r
head(cens_01rdh)
```

```
##   building housing unit time   geo values
## 1     NRES      DW   NR 2001 CH070  21059
## 2     NRES   DW_OC   NR 2001 CH070  17497
## 3     NRES  DW_OWN   NR 2001 CH070   2363
## 4     NRES  DW_SEC   NR 2001 CH070   2512
## 5     NRES  DW_VAC   NR 2001 CH070   1050
## 6     NRES   H_OTH   NR 2001 CH070    205
```

Funkcja nadal działa dla tabel, dla których działała przed zmianą.

```r
head(get_eurostat(id = 'agr_r_milkpr'))
```


```
##   milkitem prodmilk  geo       time values
## 1      PRO    MF001   AT 1995-01-01     NA
## 2      PRO    MF001  AT1 1995-01-01     NA
## 3      PRO    MF001 AT11 1995-01-01     NA
## 4      PRO    MF001 AT12 1995-01-01     NA
## 5      PRO    MF001 AT13 1995-01-01     NA
## 6      PRO    MF001  AT2 1995-01-01     NA
```


```r
untrace("get_eurostat")
```


