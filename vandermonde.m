% Sursa de inspiratie: Tema2 MN Task2 Vandermonde Interpolation
function coef = vandermonde(x, y)

  % Extragem lungimea lui x
  lungime = length(x);
  % Initializam matricea A cu 1 si dimensiunea lui x coloane si linii
  A = ones(lungime, lungime)
  % Initializam indexul liniilor lui A cu 1
  index_linii_A = 1;

  % Luam fiecare element x
  for i = 1:lungime
    % Initializam indexul coloanelor lui A cu 2
    index_coloane_A = 2;
    % Facem un for pentru puterea elementelor
    for putere = 1:(lungime - 1)
      % Punem in pozitia corespunzatoare in A x(i) la puterea respectiva
      A(index_linii_A, index_coloane_A) = x(i) ^ putere;
      % Crestem cu 1 indexul coloanelor lui A
      index_coloane_A = index_coloane_A + 1;
    endfor

    % Crestem cu 1 indexul liniilor lui A
    index_linii_A = index_linii_A + 1;
  endfor

  % Pentru a afla coef inmultim inversa lui A cu vectorul y
  coef = inv(A) * y;

end
