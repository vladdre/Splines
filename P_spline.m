% Sursa de inspiratie: Tema2 MN Task2 Cubic Spline Interpolation
function y_interp = P_spline (coef, x, x_interp)

  % Calulam lungimea lui x
  lungime = length(x);
  % numar_intervale va fi lungimea lui x - 1
  numar_intervale = lungime - 1;
  % Initializam y_interp cu 0 si dimensiunea
  % lui x_interp si o coloana (y_interp va fi vector coloana)
  y_interp = zeros(length(x_interp), 1);

  % Luam fiecare element din x_interp
  for i = 1:length(x_interp)
    % Luam fiecare interval din x
    for j = 1:numar_intervale
      % Daca x_interp(i) este intre capetele intervalului inchis luat
      if x_interp(i) >= x(j) && x_interp(i) <= x(j + 1)
        % Salvam capatul stang
        capat_stanga = x(j);
        break;
      endif

    endfor

    % Salvam coeficientii corespunzatori intervalului in care e x_interp(i)
    index_coef = j - 1;
    a = coef(4 * index_coef + 1);
    b = coef(4 * index_coef + 2);
    c = coef(4 * index_coef + 3);
    d = coef(4 * index_coef + 4);

    % Calculam dieferenta intre x_interp(i) si capat_stanga
    diferenta = x_interp(i) - capat_stanga;
    % Punem in y_interp rezultatul polinomului
    y_interp(i) = a + b * diferenta + c * (diferenta ^ 2) + d * (diferenta ^ 3);
  endfor

end
