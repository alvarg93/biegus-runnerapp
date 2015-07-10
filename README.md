# Bieguś

###Członkowie zespołu

* Łukasz Janyga, 109761, janygalukasz@gmail.com
* Roman Kaczorowski, 109729, romekkaczorowski@gmail.com
* Krystian Paszek, 109724, krystianpaszek93@gmail.com

###Krótki opis projektu

Bieguś to aplikacja mobilna na telefony z systemem iOS do rejestrowania trasy podczas aktywności fizycznych, takich jak bieganie czy jazda na rowerze. Dzięki wbudowanym w urządzenia modułom GPS możliwe jest dokładne określanie pozycji użytownika w czasie i tym samym nagranie przebytej trasy, a także zmierzenie szeregu statystyk takich jak prędkość, wysokość, czasy poszczególnych odcinków. Dzięki takim danym można poddać swój trening analizie i śledzić swoje postępy oraz wydajność. Aplikacja będzie umożliwiać wysłanie danych treningu na stronę internetową, na której wygodnie będzie można prześledzić trasę na interaktywnej mapie i zobaczyć statystyki w przyjemnej dla oka formie wykresów.

###Zakładana funkcjonalność po pierwszym etapie

#####Aplikacja mobilna powinna być w stanie pobrać dane przebytej trasy i wyświetlić opisujące ją statystyki (prędkość, czas itd.):
* zakładanie kont użytkowników, logowanie (także za pomocą Facebooka czy Twittera)
* rejestrowanie przebytej trasy i wyświetlanie jej na ekranie urządzenia
* wyświetlanie statystyk pojedynczego treningu (przebyta odległość, minimalna/maksymalna/średnia prędkość, suma zmian wysokości)
* zapisywanie danych treningu w bazie danych
* wyświetlanie historii treningów

#####Strona internetowa:
* rejestracja i logowanie użytkowników (także przez Facebooka/Twittera)
* wyświetlanie i edycja konta użytkownika

###Zakładana funkcjonalność wersji końcowej

#####Aplikacja mobilna spełnia wymagania pierwszego etapu oraz:
* pozwala na wybór rodzaju treningu (np. bieganie, rower) i oblicza dodatkowe statystyki z uwzględnieniem dyscypliny
* wyświetla zbiorcze statystyki dla okresu w historii, np. zeszły tydzień, miesiąc
* pozwala na planowanie treningów w przyszłości i przypomina o tym użytkownikowi
* pozwala dzielić się ze znajomymi swoimi treningami
* ~~wyświetla aktywności innych znajomych i pozwala na polubienie/skomentowanie ich treningów~~
* posiada przyjemny dla oka interfejs

#####Strona internetowa spełnia wymagania pierwszego etapu oraz:
* pozwala na wyświetlenie szczegółów treningów użytkownika (trasa na mapie, statystyki pojedynczego treningu i zbiorcze)
* ~~daje możliwość przeglądania/komentowania/lubienia treningów swoich znajomych~~
* pozwala na planowanie treningów i przypominanie o nich mailowo

###Opis architektury

System składa się z bazy danych umieszczonej na serwerze oraz 2 aplikacji klienckich: mobilnej oraz internetowej. Użytkownicy aplikacji posiadają swoje konta, a odbyte treningi są przypisywane do konta. Użytkownik loguje się za pomocą tych samych danych do aplikacji mobilnej i internetowej. Dane treningu są zbierane za pomocą aplikacji mobilnej za pomocą systemów lokalizacji i zapisywane w bazie danych. Obie aplikacje klienckie komunikują się z bazą danych w celu pobrania danych i prezentacji ich użytkownikowi.

###Podział zadań w zespole


Członkowie         | Rola
-------------------|-------
Roman Kaczorowski i Krystian Paszek    | Stworzenie aplikacji na telefony z systemem iOS
Łukasz Janyga | Stworzenie serwisu webowego

###Przewidywane środowisko realizacji projektu

Aplikacja mobilna
* platforma: iOS8, urządzenia: iPhone
* język programowania: Objective-C
* środowisko programistyczne: XCode

Więszkość naszego zespołu posiada na swoim wyposażeniu sprzęt pozwalający na pisanie aplikacji dla iOS, tak jak i same urządzenia z tymże systemem. Posiadamy też pewne doświadczenie w tworzeniu na tą platformę. Stąd z trzech dostępnych systemów mobilnych wybór padł na ekosystem Apple.

Strona internetowa
* platforma: Web
* języki programowania: HTML, CSS, Javascript, PHP
* środowisko programistyczne: Komodo

Serwis internetowy ma umożliwiać zalogowanie na konto użytkownika i obejrzenie swoich treningów. Ograniczona liczba funkcji powoduje, że nie jest konieczne angażowanie zaawansowanej logiki po stronie serwera. Dodatkowo tracą onę swoją zaletę w postaci integracji z bazą danych, ponieważ dane będą pobierane z bazy znajdującej się w serwisie Parse.

Dodatkowe serwisy i biblioteki, z których zamierzamy korzystać:
* parse.com (do przechowywania danych użytkowników, API pozwalające na rejestrowanie i logowanie użytkowników oraz zarządzanie danymi)

###Przewidywane trudności i problemy

* opanowanie GPS i działania aplikacji w tle na iOS
* stworzenie mechanizmów społecznościowych
* nauka i efektywne wykorzystanie PHP
