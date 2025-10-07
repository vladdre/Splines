% Sursa de inspiratie: Tema2 MN Task2 Cubic Spline Interpolation
function coef = spline_c2 (x, y)

	% si(x)   = ai + bi(x - xi) + ci(x - xi)^2 + di(x - xi)^3
	% si'(x)  =      bi         + 2ci(x - xi)  + 3di(x - xi)^2
	% si''(x) =                   2ci          + 6di(x - xi)

  % Extragem lungimea lui x
  lungime = length(x);
  % numar_intervale va fi lungimea lui x - 1
  numar_intervale = lungime - 1;
  % numar_coeficienti va fi 4 * numar_intervale
  numar_coeficienti = numar_intervale * 4;

  % Initializam cu 0 matricea A de dimensiune numar_coeficienti x numar_coeficienti
  A = zeros(numar_coeficienti, numar_coeficienti);
  % Initializam cu 0 vectorul coloana b de dimensiune numar_coeficienti x 1
  b = zeros(numar_coeficienti, 1);
  % Initializam cu 0 vectorul coloana coef de dimensiune numar_coeficienti x 1
  coef = zeros(numar_coeficienti, 1);
  % Initializam cu 1 linie_A_b
  linie_A_b = 1;

  % Construim matricea A si vectorul coloana b
  % dupa ecuatia: si(xi) = yi, i = 0 : n - 1

  for i = 1:numar_intervale
    % Calculam in index indexul din A care incepe de la 0
    index = i - 1;

    % Punem in A pe pozitia corespunzatoare lui a, coeficientul lui
    % din si(xi) (b, c, d se anuleaza din cauza xi - xi)
    A(linie_A_b, (4 * index + 1)) = 1;
    % Punem in b ce se afla dupa egalul ecuatiei
    b(linie_A_b, 1) = y(i);

    % Crestem linie_A_b cu 1
    linie_A_b = linie_A_b + 1;
  endfor

  % Construim matricea A si vectorul coloana b
  % dupa ecuatia: s_n-1(xn) = yn

  % Calculam in index indexul din A care incepe de la 0
  index = numar_intervale - 1;

  % Punem in A pe pozitia corespunzatoare lui a, coeficientul lui
  % din s_n-1(xn)
  A(linie_A_b, 4 * index + 1) = 1;
  % Punem in A pe pozitia corespunzatoare lui b, coeficientul lui
  % din s_n-1(xn)
  A(linie_A_b, 4 * index + 2) = x(numar_intervale + 1) - x(numar_intervale);
  % Punem in A pe pozitia corespunzatoare lui c, coeficientul lui
  % din s_n-1(xn)
  A(linie_A_b, 4 * index + 3) = (x(numar_intervale + 1) - x(numar_intervale)) ^ 2;
  % Punem in A pe pozitia corespunzatoare lui d, coeficientul lui
  % din s_n-1(xn)
  A(linie_A_b, 4 * index + 4) = (x(numar_intervale + 1) - x(numar_intervale)) ^ 3;

  % Punem in b ce se afla dupa egalul ecuatiei
  b(linie_A_b, 1) = y(numar_intervale + 1);

  % Crestem linie_A_b cu 1
  linie_A_b = linie_A_b + 1;

  % Construim matricea A
  % dupa ecuatia: si(x_i+1) = s_i+1(x_i+1), i = 0 : n - 1
  % Nu mai e nevoie sa construim vectorul coloana b
  % pentru ca l am terminat pe el

  for i = 1:(numar_intervale - 1)
    % Calculam in index indexul din A care incepe de la 0
    index = i - 1;

    % Punem in A pe pozitia corespunzatoare lui a, coeficientul lui
    % din si(x_i+1)
    A(linie_A_b, 4 * index + 1) = 1;
    % Punem in A pe pozitia corespunzatoare lui b, coeficientul lui
    % din si(x_i+1)
    A(linie_A_b, 4 * index + 2) = x(i + 1) - x(i);
    % Punem in A pe pozitia corespunzatoare lui c, coeficientul lui
    % din si(x_i+1)
    A(linie_A_b, 4 * index + 3) = (x(i + 1) - x(i)) ^ 2;
    % Punem in A pe pozitia corespunzatoare lui d, coeficientul lui
    % din si(x_i+1)
    A(linie_A_b, 4 * index + 4) = (x(i + 1) - x(i)) ^ 3;

    % Punem in A pe pozitia corespunzatoare lui a, coeficientul lui
    % din s_i+1(x_i+1) (b, c, d se anuleaza din cauza x_i+1 - x_i+1)
    A(linie_A_b, 4 * i + 1) = -1;

    % Crestem linie_A_b cu 1
    linie_A_b = linie_A_b + 1;
  endfor

  % Construim matricea A
  % dupa ecuatia: si'(x_i+1) = s_i+1'(x_i+1), i = 0 : n - 1

  for i = 1:(numar_intervale - 1)
    % Calculam in index indexul din A care incepe de la 0
    index = i - 1;

    % Punem in A pe pozitia corespunzatoare lui a, coeficientul lui
    % din si'(x_i+1)
    A(linie_A_b, 4 * index + 1) = 0;
    % Punem in A pe pozitia corespunzatoare lui b, coeficientul lui
    % din si'(x_i+1)
    A(linie_A_b, 4 * index + 2) = 1;
    % Punem in A pe pozitia corespunzatoare lui c, coeficientul lui
    % din si'(x_i+1)
    A(linie_A_b, 4 * index + 3) = 2 * (x(i + 1) - x(i));
    % Punem in A pe pozitia corespunzatoare lui d, coeficientul lui
    % din si'(x_i+1)
    A(linie_A_b, 4 * index + 4) = 3 * ((x(i + 1) - x(i)) ^ 2);

    % Punem in A pe pozitia corespunzatoare lui b, coeficientul lui
    % din s_i+1'(x_i+1) (c, d se anuleaza din cauza x_i+1 - x_i+1)
    A(linie_A_b, 4 * i + 2) = -1;

    % Crestem linie_A_b cu 1
    linie_A_b = linie_A_b + 1;
  endfor

  % Construim matricea A
  % dupa ecuatia: si''(x_i+1) = s_i+1''(x_i+1), i = 0 : n - 1

  for i = 1:(numar_intervale - 1)
    % Calculam in index indexul din A care incepe de la 0
    index = i - 1;

    % Punem in A pe pozitia corespunzatoare lui a, coeficientul lui
    % din si''(x_i+1)
    A(linie_A_b, 4 * index + 1) = 0;
    % Punem in A pe pozitia corespunzatoare lui b, coeficientul lui
    % din si''(x_i+1)
    A(linie_A_b, 4 * index + 2) = 0;
    % Punem in A pe pozitia corespunzatoare lui c, coeficientul lui
    % din si''(x_i+1)
    A(linie_A_b, 4 * index + 3) = 2;
    % Punem in A pe pozitia corespunzatoare lui d, coeficientul lui
    % din si''(x_i+1)
    A(linie_A_b, 4 * index + 4) = 6 * (x(i + 1) - x(i));

    % Punem in A pe pozitia corespunzatoare lui c, coeficientul lui
    % din s_i+1''(x_i+1) (d se anuleaza din cauza x_i+1 - x_i+1)
    A(linie_A_b, 4 * i + 3) = -2;

    % Crestem linie_A_b cu 1
    linie_A_b = linie_A_b + 1;
  endfor

  % Construim matricea A
  % dupa ecuatia: s0''(x0) = 0

  % Punem in A pe pozitia corespunzatoare lui c, coeficientul lui
  % din s0''(x0) = 0 (d se anuleaza din cauza x0 - x0)
  A(linie_A_b, 3) = 2;

  % Crestem linie_A_b cu 1
  linie_A_b = linie_A_b + 1;

  % Construim matricea A
  % dupa ecuatia: s_n-1''(x_n) = 0

  % Calculam in index indexul din A care incepe de la 0
  index = numar_intervale - 1;

  % Punem in A pe pozitia corespunzatoare lui c, coeficientul lui
  % din s_n-1''(x_n) = 0
  A(linie_A_b, 4 * index + 3) = 2;
  % Punem in A pe pozitia corespunzatoare lui d, coeficientul lui
  % din s_n-1''(x_n) = 0
  A(linie_A_b, 4 * index + 4) = 6 * (x(numar_intervale + 1) - x(numar_intervale));

  % coef va fi rezultatul ecuatiei A * coef = b
  coef = inv(A) * b;

end
