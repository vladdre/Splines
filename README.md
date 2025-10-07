1. Functia parse_data
    Se deschide fisierul de citire si se citeste primul numar ce simbolizeaza lungimea fiecarui
vector din fisier. Numarul lor de elemente este lungime + 1 asa ca adaugam 1 la lungime si citim
pe rand in x abscisele punctelor interpolarii suport si in y ordonatele punctelor interpolarii
suport. La final, se inchide fisierul de citire.

2. Functia spline_c2
    Sursa de inspiratie o reprezinta informatiile oferite in Tema2 MN la Task2 capitolul
Cubic Spline Interpolation.
    Se extrage lungimea vectorului x, se calculeaza numarul de intervale si numarul de coeficienti.
Se initializeaza o matrice A cu 0 de dimensiune numar_coeficienti x numar_coeficienti, un vector
coloana b cu 0 de dimensiune numar_coeficienti,  vectorul coloana coef cu 0 de aceeasi dimensiune
ca b si variabila linie_A_b cu 1 pentru a construi matricea si vectorul. Construim matricea A si
vectorul coloana b dupa ecuatia si(xi) = yi, i = 0 : n - 1. Pentru fiecare interval, calculam
indexul din A care incepe de la 0 si punem in A pe linie_A_b si coloana 4 * index + 1 pentru ca
sunt 4 variabile (a, b, c, d) si + 1 pentru ca vrem sa punem pe pozitia lui a coeficientul lui
din dezvoltarea polinomului si(xi). Nu punem nimic pentru b, c, d pentru ca ele se vor anula din
cauza lui xi - xi.In b pe linia linie_A_b punem y(i) pentru ca asta se afla dupa egal in ecuatie.
Crestem linie_A_b cu 1 si iesim din for. Acum construim matricea A si vectorul b dupa ecuatia
s_n-1(xn) = yn. Calculam din nou index pentru ultimul interval dupa aceeasi formula si punem in
A pe pozitiile 4 * index + 1 pentru a / + 2 pentru b / + 3 pentru c / + 4 pentru d coeficientii
lor din dezvoltarea polinomului s_n-1(xn). In vectorul b punem ultimul y din vectorul y si
crestem cu 1 variabila linie_A_b. Din acest moment am terminat de construit vectorul coloana b
si continuam doar cu A. Construim matricea A dupa ecuatia si(x_i+1) = s_i+1(x_i+1), i = 0 : n - 1.
Luam toate intervalele pana la penultimul (pentru ca o sa avem x(i + 1) - x(i) si automat va lua
x si din ultimul interval) si punem pe pozitia corespunzatoare lui a, lui b, lui c si lui d
coeficientul corespunzator fiecaruia din dezvoltarea polinomului si(x_i+1). La final, punem
pe pozitia urmatorului a de dupa cel pe care l am completat, coeficientul lui cu minus (pentru
a fi satisfacuta egalitatea din ecuatie) a lui a (b, c, d se anuleaza din cauza x_i+1 - x_i+1)
din s_i+1(x_i+1) si crestem linie_A_b cu 1 si iesim din for. Construim matricea dupa ecuatia
si'(x_i+1) = s_i+1'(x_i+1), i = 0 : n - 1. Calculam la fel index si punem pe pozitiile a, b, c,
d coeficientii lor din dezvoltarea polinomului si'(x_i+1). La final, punem pe pozitia urmatorului
b de dupa cel pe care l am completat, coeficientul lui cu minus (pentru a fi satisfacuta egalitatea
din ecuatie) a lui b (c, d se anuleaza din cauza x_i+1 - x_i+1) din s_i+1'(x_i+1) si crestem
linie_A_b cu 1 si iesim din for. Construim matricea dupa ecuatia si''(x_i+1) = s_i+1''(x_i+1),
i = 0 : n - 1. Calculam index si punem pe pozitiile lui a, b, c, d coeficientii lor din dezvoltarea
polinomului si''(x_i+1). La final, punem pe pozitia urmatorului c de dupa cel pe care l am
completat, coeficientul lui cu minus (pentru a fi satisfacuta egalitatea din ecuatie) a lui c
din s_i+1''(x_i+1) (d se anuleaza din cauza x_i+1 - x_i+1) si crestem linie_A_b si iesim din for.
Construim matricea A dupa ecuatia s0''(x0) = 0. Punem in A pe pozitia corespunzatoare lui c,
coeficientul lui din dezvoltarea polinomului s0''(x0) si crestem linie_A_b cu 1. Construim
matricea A dupa ecuatia s_n-1''(x_n) = 0. Calculam indexul pentru ultimul interval si punem
pe pozitia lui c, d coeficientii lor din dezvoltarea polinomului s_n-1''(x_n). Punem in coef
solutia ecuatiei A * coef = b, calculata prin inv(A) * b.

3. Functia P_spline
    Sursa de inspiratie o reprezinta informatiile oferite in Tema2 MN la Task2 capitolul
Cubic Spline Interpolation.
    Extragem lungimea vectorului x si calculam numarul de intervale ca fiind lungimea lui x - 1.
Initializam y_interp ca fiind  un vector coloana de lungimea lui x_interp cu valori 0 si
luam fiecare element din x_interp. Luam fiecare interval si vedem daca x_interp(i) se afla
intre capete intervalului inchis, daca da salvam capatul din stanga si iesim din al doilea
for. Facem indexul coeficientilor si luam a, b, c, d din intervalul gasit. Calculam polinomul
si(capat_stanga) pentru a, b, c, d luate, iar rezultatul il punem in y(i).

4. Functia vandermonde
    Sursa de inspiratie o reprezinta informatiile oferite in Tema2 MN la Task2 capitolul
Vandermonde Interpolation.
    Extragem lungimea vectorului x si initializam matricea A de dimensiune lungime si lungime
cu valori de 1 si indexul_linii_A cu 1. Luam fiecare element din x si initializam la fiecare
iteratie index_coloane_A = 2. Facem un for pentru puterea elementelor si punem in pozitia
corespunzatoare din A, elementul x(i) la puterea putere si crestem indexul coloanelor din A
si iesim din al doilea for. Crestem si index_linii_A si iesim si din primul for. La final,
coef va fi solutia ecuatiei A * coef = y, care se calculeaza cu inv(A) * y.

5. Functia P_vandermonde
    Sursa de inspiratie o reprezinta informatiile oferite in Tema2 MN la Task2 capitolul
Vandermonde Interpolation.
    Extragem lungimea lui x_interp. Luam fiecare element din x_interp si initializam
x_Vandermonde ca fiind gol la fiecare iteratie, la fel si putere = 0. Facem un for pentru
a completa vectorul linie x_Vandermonde si punem pe fiecare pozitie x_interp(i) la puterea
putere si crestem putere cu 1. Iesim din al doilea for si y_interp(i) va fi inmultirea
vectorului linie creat si vectorul coloana coef (va rezulta numarul = cu rezultatul polinomului
Vandermonde pentru coeficientii oferiti).
